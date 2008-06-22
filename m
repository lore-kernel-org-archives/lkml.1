Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYFVVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYFVVWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYFVVWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:22:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbYFVVWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:22:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: Oops when using growisofs
Date: Sun, 22 Jun 2008 23:22:04 +0200
User-Agent: KMail/1.9.9
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de>
In-Reply-To: <200806221818.24372.mb@bu3sch.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806222322.05706.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18vsbSEtJi2p0+U2ldPhZNVPM0vwJiJ64J3E79
 dUwfa536I7E09nHMqmqTI1gV9VNQr0w5T94raqVNTrLJZHEGf9
 zlHiGiQF2zSUeof27eojw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008, Michael Buesch wrote:
> [28375.893176] Unable to handle kernel paging request for data at address 0x00000008

access at offset 8 of a NULL pointer, maybe bh->b_this_page?

> [28375.893181] Faulting instruction address: 0xc00000000012df84
> [28375.893186] Oops: Kernel access of bad area, sig: 11 [#1]
> [28375.893189] PREEMPT SMP NR_CPUS=4 NUMA PowerMac

Ok, important information: ppc64 architecture. It would be nice to mention
in the bug report, but here we can see it as well.

> [28375.893320] TASK = c00000011636db00[4667] 'kded' THREAD: c000000116ae8000 CPU: 2

task was kded, i.e. not growisofs itself, thouh growisofs is probably the one
that has caused this problem (by exausting memory).

> [28375.893327] GPR00: c00000000012df70 c000000116aeb580 c00000000090ff20 0000000000000000 
> [28375.893340] GPR04: 0000000000010000 0000000000000001 c00000011bfe37a0 0000000000000010 
> [28375.893352] GPR08: f00000000694d280 0000000000000000 c0000000008c0be0 0000000000000000 
> [28375.893364] GPR12: 0000000028004842 c000000000941700 0000000000000004 c000000116aeb840 
> [28375.893377] GPR16: c0000001195d8f78 c0000000008c0cb8 c0000000000bd064 0000000000000003 
> [28375.893389] GPR20: 0000000000000000 c0000001195d8d68 0000000000000004 c0000001195d8f80 
> [28375.893402] GPR24: c00000000082c700 0000000000010000 f00000000694d280 0000000000000000 
> [28375.893415] GPR28: 0000000000000000 f00000000694d280 c00000000088e640 c000000116aeb580 

Note: r9 and r3 are both NULL pointers. r3 is the value returned from alloc_page_buffers.
R9 is a copy of that, which gets accessed.

> [28375.893428] NIP [c00000000012df84] .create_empty_buffers+0x44/0x180
> [28375.893439] LR [c00000000012df70] .create_empty_buffers+0x30/0x180
> [28375.893446] Call Trace:
> [28375.893451] [c000000116aeb580] [c00000000012df70] .create_empty_buffers+0x30/0x180 (unreliable)
> [28375.893463] [c000000116aeb620] [c0000000001331a4] .block_read_full_page+0x464/0x480
> [28375.893473] [c000000116aeb750] [c000000000137b28] .blkdev_readpage+0x28/0x50
> [28375.893483] [c000000116aeb7d0] [c0000000000bd2c8] .__do_page_cache_readahead+0x368/0x390
> [28375.893496] [c000000116aeb8e0] [c0000000000bd698] .ondemand_readahead+0x158/0x270
> [28375.893505] [c000000116aeb9a0] [c0000000000bd8fc] .page_cache_sync_readahead+0x3c/0x50
> [28375.893513] [c000000116aeba20] [c0000000000b2994] .generic_file_aio_read+0x4f4/0x630
> [28375.893523] [c000000116aebb50] [c0000000000f6fa4] .do_sync_read+0xe4/0x180
> [28375.893534] [c000000116aebcf0] [c0000000000f79c4] .vfs_read+0xf4/0x1c0
> [28375.893542] [c000000116aebd90] [c0000000000f8234] .sys_read+0x54/0xa0
> [28375.893550] [c000000116aebe30] [c0000000000076d4] syscall_exit+0x0/0x40

a simple file read, from a random process.

> [28375.893560] Instruction dump:
> [28375.893566] f8010010 f821ff61 7cbb2b78 38a00001 7c7d1b78 7c3f0b78 4bfffe65 7c7c1b78 
> [28375.893586] 7c691b78 4800000c 60000000 7d695b78 <e9690008> e8090000 2fab0000 7c00db78 
> [28375.893607] ---[ end trace d2a7775e4472c36e ]---
> 

4800000c is the branch to alloc_page_buffers
7d695b78 copies the return value of that to r9
e9690008 dereferences r9

Evidently, alloc_page_buffers got an out of memory condition, which was not caught
by create_empty_buffers. No idea how it should be handled, but the fact that it's
not looks like a bug to me ;-).

	Arnd <><
