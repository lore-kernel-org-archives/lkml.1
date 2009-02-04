Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZBDXCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZBDXCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZBDXCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:02:44 -0500
Received: from outbound-mail-318.bluehost.com ([67.222.54.250]:46906 "HELO
	outbound-mail-318.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751501AbZBDXCn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:02:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Pp5NA/bv6PRJHHaHsEQJNJkp506IxOaBmOV9V2qI1ICkogLD/svy/U7C2t0yYhysNsCYGc380Ka/k6srnnkhwRTdwA3UrfPozIyV2hWvtzFsH/roCf3ibcgh4I3p0ykV;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas =?iso-8859-1?q?Hellstr=F6m?= <thomas@shipmail.org>
Subject: Re: Gem GTT mmaps..
Date: Wed, 4 Feb 2009 15:02:41 -0800
User-Agent: KMail/1.9.10
Cc: DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <498A1760.7010108@shipmail.org>
In-Reply-To: <498A1760.7010108@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902041502.41524.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 4, 2009 2:32 pm Thomas Hellström wrote:
> Jesse,
>
> I have some concerns about the GEM GTT mmap functionality.

Thanks for looking it over again; you would know since some of this code came 
from you in the first place. :)

> First, a gem object pointer is copied to map->offset and then to the
> vma->vm_private_data without proper reference counting. This pointer is
> used in i915_gem_fault() to access the gem object. However if the gem
> object is destroyed and a process then tries to access data in a vma
> mapping the (now destroyed) object, it would dereference a stale pointer
> into kernel space? Shouldn't those pointers be reference counted, and to
> account for fork(), a vm open and close would be needed to  reference
> count corresponding pointers of newly created and destroyed vmas?

Yeah looks like we don't protect against vm_private_data pointing at a freed 
or other object.  But rather than refcounting the pointers I wonder if we 
could make the private data use the GEM object name instead, then do the 
lookup in the fault handler?

> Second, the i915_gem_fault method  returns VM_FAULT_SIGBUS if
> vm_insert_pfn() fails with an -EBUSY. I think that's an error, since
> that would indicate that the pte was already populated by a racing thread.

Ah ok that's easy enough to fix up; I didn't see that EBUSY meant "pte already 
valid".

-- 
Jesse Barnes, Intel Open Source Technology Center
