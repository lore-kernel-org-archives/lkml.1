Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZCJWZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZCJWZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZCJWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:25:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZCJWZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:25:07 -0400
Message-ID: <49B6E7EB.2040009@zytor.com>
Date: Tue, 10 Mar 2009 15:21:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] paravirt/xen: add pvop for page_is_ram
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <1235786365-17744-10-git-send-email-jeremy@goop.org> <49B5BD63.1090909@zytor.com> <49B6D94F.9070902@goop.org>
In-Reply-To: <49B6D94F.9070902@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> Why are these pages mapped as RAM in the memory map?  That is the right
>> way to handle that, not by adding yet another bloody hook...
>>   
> Granted pages can turn up anywhere dynamically, since they're pages
> borrowed from other domains for the purposes of IO.  They're not static
> regions of non-RAM like the other cases page_is_ram() tests for,
> 
> They can't be mapped via normal pte operations (because they have
> additional state associated with them, like the grant handle), so
> /dev/mem can't just create an aliased mapping by copying the pte.
> 
> page_is_ram is used to:
> 
>   1. prevent /dev/mem from mapping non-RAM pages
>   2. prevent ioremap from mapping any RAM pages
>   3. testing for RAMness in PAT
> 
> 3) isn't yet relevant to Xen; ioremap can't map granted pages either, so
> 2) isn't terribly relevent, so the main motivation for this patch is
> 1).  This allows us to reject usermode attempts to map granted pages,
> rather than oopsing (as a failed set_pte will raise a page fault).
> 
> So, more cosmetic than essential, but I don't see a better way to
> implement this functionality if its to be there at all.
> 

OK, that is a valid usage case and I agree about repurposing the
existing interface.  However, it is also a definition change in the
interface, so it really should be renamed first.

Would you be willing to break this patch up into one which renames the
interface and then a second which adds the pv hook?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

