Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYF1S0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYF1S0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 14:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYF1S0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 14:26:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbYF1S0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 14:26:32 -0400
Date: Sat, 28 Jun 2008 11:26:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Fix copy_user on x86_64
In-Reply-To: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Jun 2008, Vitaly Mayatskikh wrote:
>
> Added copy_user_64.c instead of copy_user_64.S and
> copy_user_nocache_64.S

Grr, your patches are as attachements, which means that answering to 
themmakes quoting them much harder. Oh well. Anyway, a few more comments:

 - I don't think it's worth it to move what is effectively 100% asm code 
   into a C function is really worth it. It doesn't make things easier to 
   read (often quite the reverse), nor to maintain.

   Using inline asm from C is great if you can actually make the compiler 
   do a noticeable part of the job, like register allocation and a fair 
   amount of setup, but here there is really room for neither.

   The part I wanted to be in C was the copy_user_handle_tail() thing 
   (which you did), nothing more.

   That said - you seem to have done this C conversion correctly, and if 
   you have some inherent reason why you want to use the "asm within C" 
   model, then I don't think this is _fundamentally_ bad. Moving it to 
   within C *can* have advantages (for doing things like adding debugging 
   hooks etc). So if you can explain the thinking a bit more...

 - You've introduced a new pessimization: the original asm code did the 
   jump to the "rep string" vs "the hand-unrolled" loop with

	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string

   which while a nasty and fairly complex macro was actually more clever 
   than the code you replaced it with:

	if (cpu_has(&boot_cpu_data, X86_FEATURE_REP_GOOD))
		return copy_user_generic_string(to, from, len);
	else
		return copy_user_generic_unrolled(to, from, len);

   because the "altinstruction" thing actually does a one-time (boot-time) 
   choice of the code sequence to run, so it _never_ does any conditional 
   jumps at run-time.

   From C code you can use the altinstruction infrastructure to do this, 
   but in fact it would probably be best to keep it in asm (again, the 
   only thing that C function would contain would be the jump one way or 
   the other - there's nothing really helping it being in C, although the 
   same thing can really be done with the C macro

	alternative(non-rep-version, rep-version, X86_FEATURE_REP_GOOD);

   but since you cannot do jumps out of inline asm (because the compiler 
   may have set up a stackframe that needs to be undone etc), you cannot 
   actually do as well in C code as in asm.

Hmm? Sorry for being such a stickler. This code does end up being fairly 
critical, both for correctness and for performance. A lot of user copies 
are actually short (smallish structures, or just small reads and writes), 
and I'd like to make sure that really basic infrastructure like this is 
just basically "known to be optimal", so that we can totally forget about 
it for a few more years.

		Linus
