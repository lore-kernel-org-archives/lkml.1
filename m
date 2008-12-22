Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbYLVWLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbYLVWLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbYLVWAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:00:37 -0500
Received: from aun.it.uu.se ([130.238.12.36]:65224 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951AbYLVWAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:00:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18768.3580.529348.865055@harpo.it.uu.se>
Date: Mon, 22 Dec 2008 23:00:28 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: Multiple math errors and SIGFPE
In-Reply-To: <494FC03A.3090208@zytor.com>
References: <494FC03A.3090208@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > I have received a bug report related to the si_code field of siginfo for
 > SIGFPE.  The FPE_ values are (unfortunately) an enumeration rather than
 > a bitmask, so we can't just OR them together.  Unfortunately when we get
 > multiple unmasked exceptions at least on x86 we leave info.si_code to
 > __SI_FAULT, which means it is returned to userspace as zero.  This
 > violates POSIX, which states that an si_code <= 0 is a user-generated
 > signal.
 > 
 > Looking at the code in other architectures, it looks like most of them
 > prioritize the faults, but still end up with __SI_FAULT|0 if none of the
 > expected conditions are found (which may not be possible, of course.)
 > Prioritizing the faults seem like the reasonable thing to do in terms of
 >  dealing with the multiple unmasked errors problem.
 > 
 > I am wondering if it would make sense to notice the combination
 > __SI_FAULT|0 or __SI_FAULT and (short)si_code < 0 and force SI_KERNEL
 > into the user-space code field in the generic code.  I am also wondering
 > if there is any possibility that there is code out there which relies on
 > the current, buggy behaviour.

The SIGFPE handlers I've written for the Erlang VM (several CPU/OS
combinations and FPU variations where applicable) do not rely on
si_code. If they need to do autopsy they look at the fault-time FPU
status word in the ucontext.

So at least Erlang won't break if you change SIGFPE's si_code :-)
