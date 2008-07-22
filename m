Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYGVQaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYGVQaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGVQaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:30:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:9786 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYGVQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ljMRbffq2v0aPSXGtjxAYlFHR+rSUk0OPwL2Hia8ompIbZVwPV7IX5HlToKiUSCoXP
         CJudKiPsWLqI8iVHZmysA2Mmh7bIHT0KV2h5VePA8XQNZ5qhAAC/IzmLOoA88JnTHyDy
         c6ANvlf9rDrwiBwS5mHk3lVh8+bFegoo2JjAU=
Message-ID: <19f34abd0807220930q36694d7bwfac2095dfba52d2a@mail.gmail.com>
Date: Tue, 22 Jul 2008 18:30:00 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
Cc: jfs-discussion@lists.sourceforge.net,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1216418302.30152.6.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
	 <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
	 <1216402157.11215.21.camel@norville.austin.ibm.com>
	 <19f34abd0807181108r53ea74adsd471e49f87d77024@mail.gmail.com>
	 <1216418302.30152.6.camel@norville.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 11:58 PM, Dave Kleikamp
<shaggy@linux.vnet.ibm.com> wrote:
>> You can also have a copy of my scripts if you want to try to reproduce
>> it locally. But I don't mind testing either :-)
>
> Can you please send me a copy.  For some of these, I'd like to get a
> repeatable test case, so I'm not debugging several problems at once.

Hi,

I've updated my scripts to save the bad disk images too, and now I've
hit a repeatable case:

    mount -o loop disk.1 /mnt
    rm -rf /mnt/*

BUG: unable to handle kernel paging request at f4568036
IP: [<c03048e2>] dbAdjTree+0x62/0xd0
*pde = 36b9a163 *pte = 34568160
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 396, comm: jfsCommit Not tainted (2.6.26-05752-g93ded9b #93)
EIP: 0060:[<c03048e2>] EFLAGS: 00010246 CPU: 1
EIP is at dbAdjTree+0x62/0xd0
EAX: 00000000 EBX: 00020015 ECX: 00000004 EDX: 00080054
ESI: f4548010 EDI: 00000000 EBP: f7a37c58 ESP: f7a37c48
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process jfsCommit (pid: 396, ti=f7a36000 task=f78a9fe0 task.ti=f7a36000)
Stack: 00020015 f4548804 00000001 00000004 f7a37c78 c0304a0d 00000001 f4548010
       f7a37c88 f4548804 00000001 00000022 f7a37cc0 c03065c1 00000246 f569893c
       c1c44ce0 f7a37c98 c017c77e f4548000 f639b950 f4548800 00000000 00000022
Call Trace:
 [<c0304a0d>] ? dbJoin+0xbd/0xe0
 [<c03065c1>] ? dbFreeBits+0xc1/0x320
 [<c017c77e>] ? unlock_page+0x4e/0x60
 [<c03071ad>] ? dbFreeDmap+0x3d/0xd0
 [<c0307c63>] ? dbFree+0x153/0x270
 [<c0315b01>] ? txFreeMap+0x1d1/0x3e0
 [<c01c65ec>] ? __mark_inode_dirty+0x2c/0x180
 [<c02fcf5b>] ? xtTruncate+0xe7b/0x1030
 [<c015c678>] ? __lock_acquire+0x2c8/0x1140
 [<c015c678>] ? __lock_acquire+0x2c8/0x1140
 [<c03b0c18>] ? _raw_spin_unlock+0x68/0x80
 [<c01c6662>] ? __mark_inode_dirty+0xa2/0x180
 [<c02f9c58>] ? jfs_free_zero_link+0x98/0x1b0
 [<c0159fdd>] ? put_lock_stats+0xd/0x30
 [<c02f6f57>] ? jfs_delete_inode+0x77/0x90
 [<c02f6ee0>] ? jfs_delete_inode+0x0/0x90
 [<c01bc1e2>] ? generic_delete_inode+0x62/0xe0
 [<c01bc37d>] ? generic_drop_inode+0x11d/0x170
 [<c01bb297>] ? iput+0x47/0x50
 [<c0315ee5>] ? txUpdateMap+0x1d5/0x2a0
 [<c015a083>] ? lock_release_holdtime+0x83/0x120
 [<c015bd2b>] ? trace_hardirqs_on+0xb/0x10
 [<c0318921>] ? jfs_lazycommit+0xd1/0x2e0
 [<c012f970>] ? default_wake_function+0x0/0x10
 [<c0318850>] ? jfs_lazycommit+0x0/0x2e0
 [<c014bebc>] ? kthread+0x3c/0x70
 [<c014be80>] ? kthread+0x0/0x70
 [<c0104d8b>] ? kernel_thread_helper+0x7/0x1c
 =======================
Code: f0 8d 44 16 12 8b 5d f0 0f b6 48 02 0f b6 78 03 38 48 03 0f b6
40 01 0f 4d cf 38 c1 0f 4c c8 0f b6 44 16 12 38 c1 0f 4c c8 31 ff <38>
4c 1e 11 75 47 eb 54 8d b6 00 00 00 00 8b 55 f0 83 ea 01 83
EIP: [<c03048e2>] dbAdjTree+0x62/0xd0 SS:ESP 0068:f7a37c48
---[ end trace 2d3ec5b787d965f7 ]---

This decodes to fs/jfs/jfs_dmap.c:2831:

                if (tp->dmt_stree[pp] == max)

or

   0:   38 4c 1e 11             cmp    %cl,0x11(%esi,%ebx,1)

It looks like %esi is the "tp" and %ebx is "pp", which would make pp
== 0x00020015.

Earlier, I got a crash in the same function, but a bit higher (with
the same disk image, and with the same commands):

BUG: unable to handle kernel paging request at daf76077
IP: [<c030488e>] dbAdjTree+0xe/0xd0
*pde = 34e11163 *pte = 1af76160
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC

Pid: 396, comm: jfsCommit Not tainted (2.6.26-05752-g93ded9b #93)
EIP: 0060:[<c030488e>] EFLAGS: 00010206 CPU: 1
EIP is at dbAdjTree+0xe/0xd0
EAX: daef6010 EBX: daef6804 ECX: 00000004 EDX: 00080056
ESI: daef6010 EDI: 00000004 EBP: f79dfc58 ESP: f79dfc48
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process jfsCommit (pid: 396, ti=f79de000 task=f7336f90 task.ti=f79de000)
Stack: c0185b72 daef6804 00000001 00000004 f79dfc78 c0304a0d 00000001 daef6010
       f79dfc88 daef6804 00000001 00000022 f79dfcc0 c03065c1 00000246 d7731e5c
       c16511a8 f79dfc98 c017c77e daef6000 f386c180 daef6800 00000000 00000022
Call Trace:
 [<c0185b72>] ? activate_page+0x42/0xb0
 [<c0304a0d>] ? dbJoin+0xbd/0xe0

This corresponds to fs/jfs/jfs_dmap.c:2805:

        if (tp->dmt_stree[lp] == newval)

or

   0:   0f be 44 10 11          movsbl 0x11(%eax,%edx,1),%eax

..and here it looks like %eax is the base pointer and %edx the index,
which would make lp == 0x00080056.

The bad disk image can be found at
http://userweb.kernel.org/~vegard/20080722-jfs/ (no private/sensitive
data)

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
