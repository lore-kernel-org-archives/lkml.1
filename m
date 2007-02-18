Return-Path: <linux-kernel-owner+w=401wt.eu-S1751254AbXBROzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbXBROzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 09:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXBROzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 09:55:36 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:56171 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbXBROzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 09:55:35 -0500
Subject: Re: Which architectures need to sync vmalloc mappings between
	processes?
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45D7E438.4020902@goop.org>
References: <45D7E438.4020902@goop.org>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 08:55:31 -0600
Message-Id: <1171810531.3423.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 21:29 -0800, Jeremy Fitzhardinge wrote:
> I'm looking at making all architectures export a vmalloc_sync_all()
> function, so that generic code can be sure that a particular vmalloc
> mapping is present in all address spaces.   I need this to implement a
> function to reserve a chunk of vmalloc address space complete with
> constructed pagetables, but without allocating any actual data pages.
> 
> On i386 with PAE, this is not necessary because the kernel's mappings
> are shared between all processes anyway, so it would be a no-op.  
> However, non-PAE i386 has a separate kernel mapping for each process,
> and so needs to sync them - typically lazily on faults, but
> vmalloc_sync_all exists to allow mass syncing when required.
> 
> What other architectures would require syncing of vmalloc mappings, and
> what architectures would implement it as a no-op?

Er, but there are fundamental assumptions that vmalloc_sync_all() makes
that simply aren't true on other architectures.  Really, it's an
artifact of the Intel x86 processor's inability to flush by %cr3, so we
try to keep the kernel mappings alive in a process so that a sys call
and return doesn't do a full TLB flush ... and thus, because we have a
hidden piece of kernel in userspace, we get the HIGHMEM issues.

A substantial number of other architectures do have a selective TLB
flush, so a lot operate with a fully separated kernel and user space,
and thus vmalloc mappings appear only in the single kernel address space
and nowhere else.

Could you elaborate on exactly what you think you need
vmalloc_sync_all() exported for ... your explanation of a reserved
vmalloc range sounds reasonable, but should in no way depend on
vmalloc_sync_all().  It really sounds like this should be an arch
specific function so the architectures can decide the implementation
details.

James


