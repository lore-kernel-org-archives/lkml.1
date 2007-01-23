Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXAWFiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXAWFiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbXAWFiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:38:19 -0500
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:61958 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbXAWFiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:38:18 -0500
Subject: Re: sigaction's ucontext_t with incorrect stack reference when
	SA_SIGINFO is being used ?
From: Nicholas Miell <nmiell@comcast.net>
To: Xavier Roche <roche+kml2@exalead.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45B47C68.2000903@exalead.com>
References: <45B47C68.2000903@exalead.com>
Content-Type: text/plain
Date: Mon, 22 Jan 2007 21:37:57 -0800
Message-Id: <1169530677.2995.8.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-22 at 09:57 +0100, Xavier Roche wrote:
> Hi folks,
> 
> I have a probably louzy question regarding sigaction() behaviour when an
> alternate signal stack is used: it seems that I can not get the user
> stack reference in the ucontext_t stack context ; ie. the uc_stack
> member contains reference of the alternate signal stack, not the stack
> that was used before the crash.
> 
> Is this is a normal behaviour ? Is there a way to retrieve the original
> user's stack inside the signal callback ?
> 
> The example given below demonstrates the issue:
> top of stack==0x7fffff3d7000, alternative_stack==0x501010
> SEGV==0x7fffff3d6ff8; sp==0x501010; current stack is the alternate stack
> 
> It is obvious that the SEGV was a stack overflow: the si_addr address is
> just on the page below the stack limit.

POSIX says:
"the third argument can be cast to a pointer to an object of type
ucontext_t to refer to the receiving thread's context that was
interrupted when the signal was delivered."

so if uc_stack doesn't point to the stack in use immediately prior to
signal generation, this is a bug.

(In theory I should be able to pass the ucontext_t supplied to the
signal handler to setcontext() and resume execution exactly where I left
off -- glibc's refusal to support kernel-generated ucontexts gets in the
way of this, but the point still stands.)

I have no idea who to bother about i386 signal delivery, though. (And I
suspect this bug has probably been copied to other architectures as
well.)

-- 
Nicholas Miell <nmiell@comcast.net>

