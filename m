Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbZCHGtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbZCHGtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 01:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZCHGtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 01:49:42 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:19364 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZCHGtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 01:49:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r0Xh937kybyGx2c6qttaK3Fd5l/yAboaB9dnoaRLGIHMuJRZ97imv3r3d5hin0f7sC
         9ezZ09mtzLLdvr1gxgA7AnIhT9xbgnVhT8tsGqIu33tNj/TBuxzjcByXCxes+cUVn5/x
         MnX84c39jPyMSSN6Hv4knL5aPzAlNLsw7aJbk=
Date: Sun, 8 Mar 2009 14:49:52 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] UML on UML fixed: it did not start
Message-ID: <20090308064952.GA30016@hack.private>
References: <20090306194921.GA2881@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306194921.GA2881@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 08:49:22PM +0100, Renzo Davoli wrote:
>It is currently impossible to run a user-mode linux machine inside another user-mode 
>linux (UML on UML). It breaks after a few instructions. When it tries to check
>whether SYSEMU is installed (the inner) UML receives an inconsistent result 
>(from the outer UML).
>
>This is the output of a broken attempt:
>$ ./linux mem=256m ubd0=cow
>Locating the bottom of the address space ... 0x0
>Locating the top of the address space ... 0xc0000000
>Core dump limits :
>        soft - 0
>        hard - NONE
>Checking that ptrace can change system call numbers...OK
>Checking ptrace new tags for syscall emulation...unsupported
>Checking syscall emulation patch for ptrace...check_sysemu : expected SIGTRAP, got status = 256
>$
>
>The problem is the following:
>PTRACE_SYSCALL/SINGLESTEP is currently managed inside arch_ptrace for ARCH=um.
>
>PTRACE_SYSEMU/SUSEMU_SINGLESTEP is not captured in arch_ptrace's switch, therefore
>it is erroneously passed back to ptrace_request (in kernel/ptrace).
>
>This simple patch simply forces ptrace to return an error on PTRACE_SYSEMU/SUSEMU_SINGLESTEP
>as it is unsupported on ARCH=um, and fixes the problem.
>
>I posted the same patch one month ago. I just tested it again against the latest kernel.
>
>	renzo

Thanks, renzo! Good work!

>
>Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
>---
>diff -Naur linux-2.6.29-rc7/arch/um/kernel/ptrace.c linux-2.6.29-rc7-umluml/arch/um/kernel/ptrace.c
>--- linux-2.6.29-rc7/arch/um/kernel/ptrace.c	2008-12-25 00:26:37.000000000 +0100
>+++ linux-2.6.29-rc7-umluml/arch/um/kernel/ptrace.c	2009-03-06 20:27:51.000000000 +0100
>@@ -64,6 +64,11 @@
> 		ret = poke_user(child, addr, data);
> 		break;
> 
>+	case PTRACE_SYSEMU:
>+	case PTRACE_SYSEMU_SINGLESTEP:
>+		ret=-EIO;
>+		break;
>+

I think this is OK. Please feel free to add my reviewed-by:

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Jeff, what do you think?

-- 
Do what you love, f**k the rest! F**k the regulations!
 
