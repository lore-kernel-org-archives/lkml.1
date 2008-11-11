Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYKKNga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYKKNga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbYKKNgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:36:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:53374 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbYKKNgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:36:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W4I2H3LRFJflzCjaBV5qwOdrkzBzm72GxCH0RCsiRg1PwcfkRfcbbcUPXcj7fInF8/
         UwdATjb8+SQrsVQDoE86lS5teaOcmiv07evdM1alYewpAkTTattRciys9KnxClhfVdtT
         KNscNmsj2nq1Q20MK8N8AUpf5g9ntK65qg1dk=
Message-ID: <19f34abd0811110536i71994436q4aa78a99d201c478@mail.gmail.com>
Date: Tue, 11 Nov 2008 14:36:19 +0100
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
In-Reply-To: <20081111105214.GA15645@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
	 <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl>
	 <20081111105214.GA15645@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 11:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
> [ Cc:-ed workqueue/locking/suspend-race-condition experts. ]

Heh. I am not expert, but I looked at the code. The obvious suspicious
thing to see is the use of unpaired barriers? Maybe like this:

 47 static void set_state(enum stopmachine_state newstate)
48 {
49         /* Reset ack counter. */
50         atomic_set(&thread_ack, num_threads);
51         smp_wmb();

+ /* force ordering between thread_ack/state */

52         state = newstate;
53 }
54
55 /* Last one to ack a state moves to the next state. */
56 static void ack_state(void)
57 {
58         if (atomic_dec_and_test(&thread_ack))

Maybe
+ /* force ordering between thread_ack/state */
+ smp_rmb();
here?

59                 set_state(state + 1);
60 }
61

Or maybe I am wrong. But Documentation/memory-barriers.txt is rather
explicit on this point.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
