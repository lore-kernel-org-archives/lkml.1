Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbYCNAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbYCNAD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYCNADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:03:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:47113 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYCNADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZX6MZBY93x6BSQBRAH08mItJE187RzIeKCWyPBOo3zcNACVCMeanJUZ67Jzv6naro0oTsDS+QiSkfQCu3QM1iAAlco7ieFpnvWsHxWJehFgPbpizgsGGPjhHfuIl06DYAx7QWFc5jUT+MPXg1b7YY6EuhzK5ZIf22D9H8j6FstU=
Message-ID: <9810cff90803131703t3626d83fq727b04242f407c13@mail.gmail.com>
Date: Thu, 13 Mar 2008 17:03:15 -0700
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>, mingo@elte.hu
Subject: [PATCH RT 0/6] lockstat measurement extensions
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net, ak@suse.de,
       pavel@ucw.cz, acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to announce extensions to the lockstat/lockdep framework to
measure the possibility of whether or not adaptive spins and/or lock
steals can happen within the rtmutex implementation's slow path. This
extends the common rtmutex functions to pass the depmap and friends so
that the lock_note_contention function can determine whether a
rtmutex->owner is live on another run queue. If so, then it logs it in
per cpu storage with the peterz's lockstat framework.

I had to extend a lot of function headers using some preprocessor
definitions to minimize the ifdef complexity, but it's still rather
complex even with some of the reductions. With that said and done, I'd
like suggest that a better method would be to add fields in the struct
rtmutex to pass values down to the lock_note_contention() function and
to contain state/events that can be post processed by
LOCK_CONTENDED*() macros instead. This was originally proposed by
Peter Zijlstra, but I had already decided to complete this track just
to see where it would take me.

This is a reimplementation of my own lockstat work into Peter's stuff.
I hope to pass it over to the Novell folks so that they can maintain
and take over development of this feature which will shine a light on
whether adaptive locks and lateral steals are useful in -rt.

Some results here:
----

lock_stat version 0.2
spinnables_total = 320571
contentions_total = 1670097
stolen_total = 1161888
cpu range error = 0
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces contentions
[adapt,steals]   waittime-min   waittime-max waittime-total
acq-bounces   acquisitions   holdtime-min   holdtime-max
holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                &type->i_mutex_dir_key#2:        273392         659581
[172517, 658744] 18446744073709      580800.58   524881532.33
315374        1050378 18446744073709      605616.37   107058004.06
                ------------------------
                &type->i_mutex_dir_key#2         659581
[<ffffffff802a785b>] vfs_readdir+0x52/0xaf
                &type->i_mutex_dir_key#2              0
[<ffffffff802a2917>] do_lookup+0x84/0x1b4

...............................................................................................................................................................................................

                              irq_desc#1:        305009         305009
[1, 0]           0.51          13.55     1120626.91         620872
   1783324           0.23          36.62     8316839.04
                              ----------
                              irq_desc#1         304949
[<ffffffff8026c3bf>] do_irqd+0x86/0x2c7
                              irq_desc#1             39
[<ffffffff8026cfc8>] handle_fasteoi_irq+0x2a/0x10a

...............................................................................................................................................................................................

    (raw_spinlock_t *)(&lock->wait_lock):         77005          77561
[623, 0]           0.32          44.14       93979.97         743444
    10998216           0.24          53.89     4278155.20
    ------------------------------------
    (raw_spinlock_t *)(&lock->wait_lock)          14706
[<ffffffff804ff9bd>] rt_spin_lock_slowunlock+0xf/0x5c
    (raw_spinlock_t *)(&lock->wait_lock)          15631
[<ffffffff804ffa19>] rt_mutex_slowunlock+0xf/0x59
    (raw_spinlock_t *)(&lock->wait_lock)             61
[<ffffffff804ffe8e>] rt_mutex_slowlock+0x1f7/0x2d5
    (raw_spinlock_t *)(&lock->wait_lock)              9
[<ffffffff804ffbf0>] rt_spin_lock_slowlock+0x128/0x1cf

...............................................................................................................................................................................................

                   dcache_lock.wait_lock:         69559          72424
[34806, 0]           0.36          13.90       87260.09         379404
       1234745           0.29          27.01     1749680.84
                   ---------------------
                   dcache_lock.wait_lock          12618
[<ffffffff804ff9bd>] rt_spin_lock_slowunlock+0xf/0x5c
                   dcache_lock.wait_lock          51591
[<ffffffff804ffbf0>] rt_spin_lock_slowlock+0x128/0x1cf
                   dcache_lock.wait_lock           8072
[<ffffffff804ffb02>] rt_spin_lock_slowlock+0x3a/0x1cf
                   dcache_lock.wait_lock            143
[<ffffffff802623b7>] task_blocks_on_rt_mutex+0x1aa/0x1bf

----

I measure the total number of contention events printed out at the
very top of the listing and spin/steals within "[]" to the right of
the contention number for that lock. It's interesting how many steals
actually happen in that the percentage is quite substantial. This was
against a load of "find /" commands which hit inode locks pretty
heavily. irq_desc is interesting as well.

Patches can be found here:
http://mmlinux.sourceforge.net/public/lockstat/patch?.diff

More of the output can be found here
http://mmlinux.sourceforge.net/public/lockstat/output

bill
