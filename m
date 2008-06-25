Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYFYWMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYFYWMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYFYWMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:12:30 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:25035 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYFYWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j8zBUYx74BolZ8M0u2twvczNn/CphfhsyZaLiwGVJY1cHoZoii0jimZ11SwzHkCwk6
         DcMIeygrA/W8D43MLuSGT8O22BOcqUpMmIVO7GmWCljvtku5Y9CulygmL5OGQw0B3XCh
         U5ul82UwsVLnMV49IeSiG/Yte2xa9M5f/+yBQ=
Message-ID: <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com>
Date: Thu, 26 Jun 2008 00:12:28 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] CFS vs cpu hotplug
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Avi Kivity" <avi@qumranet.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080619161949.GA11062@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080619161949.GA11062@osiris.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/19 Heiko Carstens <heiko.carstens@de.ibm.com>:
> Hi Ingo, Peter,
>
> I'm still seeing kernel crashes on cpu hotplug with Linus' current git tree.
> All I have to do is to make all cpus busy (make -j4 of the kernel source is
> sufficient) and then start cpu hotplug stress.
> It usually takes below a minute to crash the system like this:
>
> Unable to handle kernel pointer dereference at virtual kernel address 005a800000031000
> Oops: 0038 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 1 Not tainted 2.6.26-rc6-00232-g9bedbcb #356
> Process swapper (pid: 0, task: 000000002fe7ccf8, ksp: 000000002fe93d78)
> Krnl PSW : 0400e00180000000 0000000000032c6c (pick_next_task_fair+0x34/0xb0)
>           R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:3 CC:2 PM:0 EA:3
> Krnl GPRS: 00000000001ff000 0000000000030bd8 000000000075a380 000000002fe7ccf8
>           0000000000386690 0000000000000008 0000000000000000 000000002fe7cf58
>           0000000000000001 000000000075a300 0000000000000000 000000002fe93d40
>           005a800000031201 0000000000386010 000000002fe93d78 000000002fe93d40
> Krnl Code: 0000000000032c5c: e3e0f0980024       stg     %r14,152(%r15)
>           0000000000032c62: d507d000c010       clc     0(8,%r13),16(%r12)
>           0000000000032c68: a784003c           brc     8,32ce0
>          >0000000000032c6c: d507d000c030       clc     0(8,%r13),48(%r12)
>           0000000000032c72: b904002c           lgr     %r2,%r12
>           0000000000032c76: a7a90000           lghi    %r10,0
>           0000000000032c7a: a7840021           brc     8,32cbc
>           0000000000032c7e: c0e5ffffefe3       brasl   %r14,30c44
> Call Trace:
> ([<000000000075a300>] 0x75a300)
>  [<000000000037195a>] schedule+0x162/0x7f4
>  [<000000000001a2be>] cpu_idle+0x1ca/0x25c
>  [<000000000036f368>] start_secondary+0xac/0xb8
>  [<0000000000000000>] 0x0
>  [<0000000000000000>] 0x0
> Last Breaking-Event-Address:
>  [<0000000000032cc6>] pick_next_task_fair+0x8e/0xb0
>  <4>---[ end trace 9bb55df196feedcc ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
>
> Please note that the above call trace is from s390, however Avi reported the
> same bug on x86_64.

FYI, I've managed to reproduce it 3 times (took 10 to 45 minutes) on
my dual-core Thinkpad R60.

(1) make -j3 of the kernel source

(2) a loop with : offline cpu_1 ; sleep 1 ; online cpu_1 ; sleep 1

2 times in the GUI environment so I couldn't see an oops (although, I
could here it as the very first time my laptop was constantly
beeeeeeeep-ing :-)

Strangely enough, an oops didn't appear in the plain console mode
(well, at least not on the active terminal). Although, my additional
debugging message from pick_next_task_fair() did appear on the screen
right before the system froze..

It's in the loop of pick_next_task_fair():

        do {
                se = pick_next_entity(cfs_rq);

                if (unlikely(!se))
                        printk(KERN_ERR "BUG: se == NULL but
nr_running (%ld), load (%ld),
                                        " rq-nr_running (%ld), rq-load (%ld)\n",
                                cfs_rq->nr_running,
cfs_rq->load.weight, rq->nr_running, r

                cfs_rq = group_cfs_rq(se);
        } while (cfs_rq);


BUG: se == NULL but nr_running (1), load (1024), rq-nr_running (1),
rq-load (1024)

so there is a crouching gremlin somewhere in the code :-/


-- 
Best regards,
Dmitry Adamushko
