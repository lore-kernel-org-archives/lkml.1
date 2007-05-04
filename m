Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbXEDLqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbXEDLqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXEDLqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:46:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53033 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbXEDLqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:46:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>
Date: Fri, 04 May 2007 05:46:01 -0600
In-Reply-To: <463AED07.1000505@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 04 May 2007 01:21:27 -0700")
Message-ID: <m1r6pwu806.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> When the paravirt dispatcher gets run immediately on entry to
> startup_32, the bss isn't cleared.  This happens to work if the
> hypervisor's domain builder loaded the complete kernel image and
> cleared the bss for us, but this may not always be true (for example,
> if we're running out of a decompressed bzImage).
>
> Change head.S so that it unconditionally clears the bss before doing
> the paravirt dispatch or continuing on to normal native boot.
>
> There are a couple of points to note:
>  - We can't, in general, load the segment registers before paravirt
>    dispatch, because we could be running with a non-standard gdt and
>    segment selectors.  In practice though, all code which ends up
>    jumping into startup_32 will have already set the segment registers
>    up to sane values, so we don't need to do it again.
>  - Paging may or may not be enabled, and if enabled we may or may not
>    be mapped to the proper kernel virtual address.  To deal with this,
>    we compare the kernel's linked address with where we're actually
>    running, and use that to offset the bss pointer.

NAK.  

Skipping the segment register load is likely fine.
Supporting V!=P at startup_32 is not.
Assuming that we have a stack at startup_32 is not.

If you want to figure out where the kernel is loaded you can do
(from arch/i386/boot/head.S)
> 
> /* Calculate the delta between where we were compiled to run
>  * at and where we were actually loaded at.  This can only be done
>  * with a short local call on x86.  Nothing  else will tell us what
>  * address we are running at.  The reserved chunk of the real-mode
>  * data at 0x34-0x3f are used as the stack for this calculation.
>  * Only 4 bytes are needed.
>  */
> 	leal 0x40(%esi), %esp
> 	call 1f
> 1:	popl %ebp
> 	subl $1b, %ebp
> 

Eric
