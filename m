Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYKKNqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYKKNqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYKKNqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:46:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:47177 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbYKKNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I9r7ZljeTjnWlcaVWFxbSno+oMTS91y8yZAcv2kaDrgmD6xlqzmvh280EQR+TPJn4J
         O7sCm0TzT8irXqRQF7aJglIbQFC6AK9EttjxqicjpGGUcINWCSmuXWF1vuisUENB64bE
         3Jh311fG2Elemjvqp3QwyAodsYMVOlnXNZL00=
Message-ID: <19f34abd0811110546s39b39b96ka41b7d0d24eaec03@mail.gmail.com>
Date: Tue, 11 Nov 2008 14:46:38 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <19f34abd0811110536i71994436q4aa78a99d201c478@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
	 <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl>
	 <20081111105214.GA15645@elte.hu>
	 <19f34abd0811110536i71994436q4aa78a99d201c478@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 2:36 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Tue, Nov 11, 2008 at 11:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> [ Cc:-ed workqueue/locking/suspend-race-condition experts. ]
>
> Heh. I am not expert, but I looked at the code. The obvious suspicious
> thing to see is the use of unpaired barriers? Maybe like this:

...

> 55 /* Last one to ack a state moves to the next state. */
> 56 static void ack_state(void)
> 57 {
> 58         if (atomic_dec_and_test(&thread_ack))
>
> Maybe
> + /* force ordering between thread_ack/state */
> + smp_rmb();
> here?

Oops, I am wrong (after a small investigation).

"1490 Any atomic operation that modifies some state in memory and
returns information
1491 about the state (old or new) implies an SMP-conditional general
memory barrier
1492 (smp_mb()) on each side of the actual operation (with the exception of
1493 explicit lock operations, described later).  These include:
1494
...
1503         atomic_dec_and_test();"

Won't fix the problem at hand, but maybe something like this would be
nice for future generations :-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 0e688c6..6796bb1 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -55,6 +55,7 @@ static void set_state(enum stopmachine_state newstate)
 /* Last one to ack a state moves to the next state. */
 static void ack_state(void)
 {
+       /* Implicit memory barrier; no smp_rmb() needed */
        if (atomic_dec_and_test(&thread_ack))
                set_state(state + 1);
 }


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
