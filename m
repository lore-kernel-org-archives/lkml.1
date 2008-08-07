Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbYHGHu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbYHGHu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYHGHut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:50:49 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57245 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbYHGHus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:50:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18586.43322.249846.130170@harpo.it.uu.se>
Date: Thu, 7 Aug 2008 09:50:18 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: md@google.com (Michael Davidson)
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent binaries from making system calls using the wrong syscall interface
In-Reply-To: <20080807003459.37CC629624@localhost>
References: <20080807003459.37CC629624@localhost>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Davidson writes:
 > Prevent binaries from making system calls using other than one
 > of the "normal" system call interfaces for that binary type.
 > 
 > Currently there is nothing to prevent 64 bit binaries from
 > attempting to make system calls using the 32 bit system call
 > interfaces and vice versa.
 > 
 > Since the 32 bit and 64 bit system call numbers are different
 > this means that a binary could attempt to obfuscate which system
 > calls it was actually making by using the "wrong" system call
 > interface. In particular, the call to audit_syscall_entry()
 > relies on checking the TIF_IA32 flag to determine whether it is
 > dealing with a 32 or 64 bit system call without regard to the
 > actual type of system call that was made.While this specific issue
 > could be addressed by checking the TS_COMPAT flag in threadinfo_status
 > it seems preferable to simply disallow this situation altogether.

I asked Andi whether 64-bit processes are allowed to make 32-bit
syscalls on May 4 2007, and he stated that yes it's both allowed
and supposed to work. (The thread was cc:d to discuss@x86-64.org.)

 > --- linux-2.6.26.2.orig/arch/x86/ia32/ia32entry.S	2008-08-06 09:19:01.000000000 -0700
 > +++ linux-2.6.26.2/arch/x86/ia32/ia32entry.S	2008-08-06 13:34:54.566992000 -0700
 > @@ -123,6 +123,8 @@
 >   	.quad 1b,ia32_badarg
 >   	.previous	
 >  	GET_THREAD_INFO(%r10)
 > +	testl  $_TIF_IA32,threadinfo_flags(%r10)
 > +	jz     ia32_bad_abi
 >  	orl    $TS_COMPAT,threadinfo_status(%r10)
 >  	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 >  	CFI_REMEMBER_STATE
 > @@ -230,6 +232,8 @@
 >  	.quad 1b,ia32_badarg
 >  	.previous	
 >  	GET_THREAD_INFO(%r10)
 > +	testl $_TIF_IA32,threadinfo_flags(%r10)
 > +	jz    ia32_bad_abi
 >  	orl   $TS_COMPAT,threadinfo_status(%r10)
 >  	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 >  	CFI_REMEMBER_STATE
 > @@ -324,6 +328,8 @@
 >  	   this could be a problem. */
 >  	SAVE_ARGS 0,0,1
 >  	GET_THREAD_INFO(%r10)
 > +	testl $_TIF_IA32,threadinfo_flags(%r10)
 > +	jz    ia32_bad_abi
 >  	orl   $TS_COMPAT,threadinfo_status(%r10)
 >  	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
 >  	jnz ia32_tracesys

Your patch slows down all compat-mode syscalls.

/Mikael
