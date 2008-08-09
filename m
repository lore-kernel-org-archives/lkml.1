Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbYHIKu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbYHIKu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 06:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYHIKur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 06:50:47 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:53810 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYHIKuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 06:50:46 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Sat, 9 Aug 2008 12:50:42 +0200
User-Agent: KMail/1.9.9
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, viro@zeniv.linux.org.uk,
       vegard.nossum@gmail.com
References: <200807171653.59177.wolfgang.walter@stwm.de> <200808090443.00597.wolfgang.walter@stwm.de> <489D0F69.9050307@zytor.com>
In-Reply-To: <489D0F69.9050307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808091250.43184.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, H. Peter Anvin wrote:
> Wolfgang Walter wrote:
> > 
> > These FPU changes are already in 2.6.26. Undoing them, would that be 
accepted 
> > for 2.6.26 stable?
> > 
> > Maybe the following solution would be possible: if a processor with 
padlock is 
> > detected the memory for xstate is always allocated when the thread is 
created 
> > instead "lazy"?
> > 
> 
> That will effectively happen, so it doesn't really matter.

With the patch? I don't think so:

With the patch the following changes compared with 2.6.25:

* processes which do not use FPU/SSE will not start saving and loading there 
xstate any more (and will not allocate xstate memory) if kernel is using 
padlock with the crypto-framework. Its similar to other places where the 
kernel uses MMX/SSE and protects them with kernel_fpu_begin(); 
kernel_fpu_end(); isn't it?

* if user space uses FPU/SSE its xstate will be saved though it is not really 
necessary.

* the crypto-framework using padlock can not be preempted any more while 
executing padlock-opcodes.

This is what Hebert fears.



What I'm not really understand - and Suresh probably could tell us - if with 
2.6.25 and earlier the following could happen:

1) a process is using FPU/SSE so it has a saved xstate BUT its not loaded 
because of lazy loading of FPU state (didn't use FPU/SSE for some time).

2) padlock usage by kernel without kernel_fpu_begin() kernel_fpu_end() sets 
TS_USEDFPU of this task but its not loaded

3) in __switch_to() the process then saves its FPU/SSE state overwriting its 
real xstate.

If I understand Suresh explanations correctly this could not happen.

The problem only exists at task creation time: a race between initialising 
TS_USEDFPU, used_math()) and setting the xstate pointer to NULL.

So wouldn't this help:

* a flag TS_INITIALISING is set for this task bevor used_math and TS_USEDFPU 
is set
* then math-state of the new task is initialisied including setting xstate to 
NULL
* then the flag is cleared
* math_state_restore() in trap_32.c does nothing if this flag is set.

Another possibility would be to use xstate for tracking if math has ever be 
used by this task and made TS_USEDFPU only valid if xtate != NULL

Both would only reestablish 2.6.25 behaviour.


But even if one or both would work its no solution for 2.6.26 (and probably 
2.6.27). My trust in 2.6.26 increased enough to use it on desktops and I 
would be a little bit nervous with such changes :-).

> 
> The true optimization would be to recognize that the state doesn't have 
> to be saved, and track when we did so, and so on and so forth.

Yes that would be perfect. But fixing the race between math-state 
initialisation and setting xtsate to NULL would be good enough. With ipsec 
traffic some tasks would save and restore unecessarily its xstate (as it is 
the case with 2.6.25 and earlier).

There is no way to know if it was the kernel who caused a math fault?

> 
> VIA really did their customers a disservice tying this to CR0.TS.
> 
> 	-hpa
> 
> 


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
