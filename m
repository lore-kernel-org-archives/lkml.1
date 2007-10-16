Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbXJPFuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbXJPFuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763361AbXJPFt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:49:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32856 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761638AbXJPFt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:49:56 -0400
Date: Tue, 16 Oct 2007 11:19:56 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [patch 0/2] Protect crashkernel against BSS overlap
Message-ID: <20071016054956.GA4659@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20071015115042.391348549@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015115042.391348549@strauss.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 01:50:42PM +0200, Bernhard Walle wrote:
> I observed the problem that even when you choose the default 16M as
> crashkernel base address and the kernel is very big, the reserved area may
> overlap with the kernel BSS. Currently, this is not checked at runtime, so the
> kernel just crashes when you load the panic kernel in the sys_kexec call.
> 
> This two patches check this at runtime. The patches are against current git,
> but with the patches
> 
>     extended-crashkernel-command-line.patch
>     extended-crashkernel-command-line-update.patch
>     extended-crashkernel-command-line-comment-fix.patch
>     extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
>     use-extended-crashkernel-command-line-on-i386.patch
>     use-extended-crashkernel-command-line-on-i386-update.patch
>     use-extended-crashkernel-command-line-on-x86_64.patch
>     use-extended-crashkernel-command-line-on-x86_64-update.patch
>     use-extended-crashkernel-command-line-on-ia64.patch
>     use-extended-crashkernel-command-line-on-ia64-fix.patch
>     use-extended-crashkernel-command-line-on-ia64-update.patch
>     use-extended-crashkernel-command-line-on-ppc64.patch
>     use-extended-crashkernel-command-line-on-ppc64-update.patch
>     use-extended-crashkernel-command-line-on-sh.patch
>     use-extended-crashkernel-command-line-on-sh-update.patch
> 
> from -mm tree applied since they are marked to be merged in 2.6.24.
> 
> I know that the implementation of both patches is only x86 (i386 and x86-64),
> but if you agree that it's the way to go, I can add the BSS resource
> and the check for all other architectures that apply.
> 

Hi Bernhard,

Shouldn't bootmem allocator have the functionality to flag an error if
we try to reserve a memory which is already reserved? I see that bootmem
allocator is currently printing a warning under CONFIG_DEBUG_BOOTMEM.

Wouldn't it be better if we reserve the code, data and bss memory also
using bootmem allocator and when somebody tries to reserve craskernel memory
and if there is an overlap, boot memory allocator should scream?

In second patch, you are checking for crash kernel reserved memory being
beyond _end. That will make sure that there is no overlap with kernel
text, data or bss. I am wondering then why do we need first patch and
why should we register bss memory in the resources list. Second patch 
would make sure that there is no overlap with crash kernel memory and kexec
will not place any segment outside crashkernel memory.

Thanks
Vivek
