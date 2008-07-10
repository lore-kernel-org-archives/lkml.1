Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYGJOQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYGJOQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYGJOQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:16:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:20938 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbYGJOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mmB0wMJyr36guxYKTrpcvNb3uV6JMrNQrOXLg2xaqf5y+00PLmqdrAMRCxeUaIU/i5
         CxmIKil5iV8Qzn7ud/UQ2n6KRjdRcaNHUmMyg8UPK97GAoCJpjrXfnBhtMOK6Z1UfQPk
         LKSBIvg9N3tvj44yqj0dk1KeMJsHeLfmiDkIQ=
Message-ID: <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
Date: Thu, 10 Jul 2008 16:16:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 4:03 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> Miao Xie's patch addresses a problem by fixing its consequence. In
> general, an 'offline' cpu must not be visible for any kind of
> load-balancing at this point. So I'd rather like to understand and
> address the root cause of this mis-behavior.
>

Oh, right. I fully agree.

> Regarding new crashes. Do you get them
>
> (1) after a few cpu offline / onlines ?
> (2) on a freshly booted system?
> (3) (1) or (2) but only with Miao Xie's patch (should not be (2) then)
> (4) something else?

Without Miao Xie's patch, I regularly get a crash on the first cpu-up.
So I am using it all the time. With this patch applied, the new
crashes can happen from anywhere between 2 minutes to 20 while running
a few different looping scripts simultaneously:

1. cpu up/down
2. grep -r . /sys
3. swapon/swapoff
4. cat /dev/cpu/*/msr

I also just got a bootup which had some more info just after a
kmem_cache_alloc failure:

BUG: unable to handle kernel paging request at da87d000
IP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0
*pde = 28180163 *pte = 1a87d160
Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 3850, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
EIP is at kmem_cache_alloc+0xc7/0xe0
EAX: 00000000 EBX: da87c100 ECX: 1adad71a EDX: 6b6b6b6b
ESI: 00200282 EDI: da87d000 EBP: f60bfe74 ESP: f60bfe54
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process grep (pid: 3850, ti=f60be000 task=e8318ff0 task.ti=f60be000)
Stack: c019fa36 f739ff20 c019fa36 000080d0 f7811c30 00000001 f60bff04 ffffffe9
       f60bfe8c c019fa36 c09382b0 000001f7 00000001 f60bff04 f60bfeac c01a8e44
       00001000 da9a0000 ffffff9c f60bff04 00008001 00000004 f60bfec4 c01a8f31
Call Trace:
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c01a8e44>] ? __path_lookup_intent_open+0x24/0x90
 [<c01a8f31>] ? path_lookup_open+0x21/0x30
 [<c01a8fd3>] ? do_filp_open+0x93/0x710
 [<c019cc48>] ? get_unused_fd_flags+0xc8/0xf0
 [<c05849b7>] ? _spin_unlock+0x27/0x50
 [<c019cc48>] ? get_unused_fd_flags+0xc8/0xf0
 [<c019ccb9>] ? do_sys_open+0x49/0xe0
 [<c019cdb9>] ? sys_open+0x29/0x40
 [<c0104ceb>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: b9 ff ff ff ff 8b 55 ec 89 7c 24 04 89 04 24 8b 45 f0 e8 4d f6
ff ff 89 c3 eb a0 85 db 74 bc 8b 57 10 31 c0 89 df 89 d1 c1 e9 02
<f3> ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa eb 9f 90 8d b4 26
EIP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0 SS:ESP 0068:f60bfe54
---[ end trace 0647416e896c69d3 ]---
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.
Priority:-10871 extents:1 across:2031608k
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
=============================================================================
BUG filp: Redzone overwritten
-----------------------------------------------------------------------------
INFO: 0xda87ceb8-0xda87cebb. First byte 0x0 instead of 0xbb
INFO: Slab 0xc1639d10 objects=16 used=6 fp=0xda87ce00 flags=0x400000c3
INFO: Object 0xda87ce00 @offset=3584 fp=0x00000000
Bytes b4 0xda87cdf0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce00:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce10:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce20:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce30:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce40:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce50:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce60:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  Object 0xda87ce70:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
 Redzone 0xda87ceb8:  00 00 00 00
....
 Padding 0xda87cee0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
 Padding 0xda87cef0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
Pid: 18498, comm: swapon Tainted: G      D   2.6.26-rc9-00059-gb190333 #5
 [<c0197bca>] print_trailer+0xaa/0xe0
 [<c0197c9b>] check_bytes_and_report+0x9b/0xc0
 [<c0197f43>] check_object+0x53/0x1f0
 [<c0198c4b>] __slab_alloc+0x44b/0x5d0
 [<c01991b3>] kmem_cache_alloc+0xb3/0xe0
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c019fa36>] ? get_empty_filp+0x36/0x140
 [<c019fa36>] get_empty_filp+0x36/0x140
 [<c01a8e44>] __path_lookup_intent_open+0x24/0x90
 [<c01a8f31>] path_lookup_open+0x21/0x30
 [<c01a8fd3>] do_filp_open+0x93/0x710
 [<c0197fcf>] ? check_object+0xdf/0x1f0
 [<c01a7055>] ? getname+0x25/0xe0
 [<c019cba6>] ? get_unused_fd_flags+0x26/0xf0
 [<c019cc48>] ? get_unused_fd_flags+0xc8/0xf0
 [<c05849b7>] ? _spin_unlock+0x27/0x50
 [<c019cc48>] ? get_unused_fd_flags+0xc8/0xf0
 [<c019ccb9>] do_sys_open+0x49/0xe0
 [<c019cdb9>] sys_open+0x29/0x40
 [<c0104ceb>] sysenter_past_esp+0x78/0xd1
 =======================
FIX filp: Restoring 0xda87ceb8-0xda87cebb=0xbb
FIX filp: Marking all objects used

..and then we had another NULL ptr in the rcu callbacks. Looks like
something is putting zeroes all over the place where it shouldn't be
allowed to?

I'll try stopping the cpu up/down script and see if it makes a difference.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
