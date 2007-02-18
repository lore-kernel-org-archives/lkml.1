Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbXBRSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbXBRSU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 13:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXBRSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 13:20:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:56257 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXBRSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 13:20:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=rpBdPuhMdIsf1IKm5YyL07Ly0hZQfFVyU7UHuwHAYLgEw3h9067bqhbRzedn2J30g13ZnQbR9CNAN0F7VBduvwowLSgSOcoD/gvUhCKcjFJoNo2gy2+IBKQ/nUYndoaBybNNnq9ZbW/TQ9a+BsdVbv9gQLPcsbc1HtS/Ewy8+aQ=
Message-ID: <45D898E8.3040807@googlemail.com>
Date: Sun, 18 Feb 2007 19:20:24 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-mm2
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> 

Slab corruption + oops yablb (yet another block layer bug)

Slab corruption: start=f3b8f654, len=176
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c0160f39>](mempool_free_slab+0xe/0x10)
060: 6b 6b 6b 6b 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Prev obj: start=f3b8f598, len=176
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c0160f39>](mempool_free_slab+0xe/0x10)
000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Next obj: start=f3b8f710, len=176
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c0160f39>](mempool_free_slab+0xe/0x10)
000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b


0xc0160f39 is in mempool_free_slab (/mnt/md0/devel/linux-mm/mm/mempool.c:295).
290
291     void mempool_free_slab(void *element, void *pool_data)
292     {
293             struct kmem_cache *mem = pool_data;
294             kmem_cache_free(mem, element);
295     }
296     EXPORT_SYMBOL(mempool_free_slab);
297
298     /*
299      * A commonly used alloc and free fn that kmalloc/kfrees the amount of memory

quilt patches mm/mempool.c
patches/origin.patch

It's time to test 2.6.20-git14 with LTP.

BUG: unable to handle kernel paging request at virtual address 6b6b6b8f
 printing eip:
c01f4618
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
last sysfs file: /devices/platform/i2c-9191/9191-0290/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram evdev snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer intel_agp 8139too agpgart skge snd i2c_i801 mii soundcore sk98lin snd_page_alloc ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c01f4618>]    Not tainted VLI
EFLAGS: 00010292   (2.6.20-mm2 #18)
EIP is at ll_back_merge_fn+0x9d/0x1ba
eax: 6b6b6b6b   ebx: f5e6a2a8   ecx: 00001000   edx: 00000001
esi: f7cc1a14   edi: f5e6a2a8   ebp: ee7ebb34   esp: ee7ebb18
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process doio (pid: 11602, ti=ee7ea000 task=f339a070 task.ti=ee7ea000)
Stack: f306d394 00001000 f7cb2e54 ee7ebb34 f5e6a2a8 f306d394 f7cc1a14 ee7ebb5c
       c01f622f c020fad7 f5e6a2a8 f306d394 f306d394 ee7ebb5c f5e6a2a8 f7cc1a14
       f306d394 ee7ebb94 c01f7a74 ee7ebb8c c013ea3c f339a5e8 00000002 f339a070
Call Trace:
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011a8e1>] do_page_fault+0x47c/0x55b
 [<c0336d54>] error_code+0x7c/0x84
 [<c01f622f>] bio_attempt_back_merge+0x40/0xe3
 [<c01f7a74>] __make_request+0xe1/0x32e
 [<c01f5128>] generic_make_request+0x2e1/0x30f
 [<c01f7614>] submit_bio+0x132/0x13a
 [<c019e063>] submit_bh+0xf6/0x113
 [<c019f659>] __block_write_full_page+0x242/0x35c
 [<c019fbcc>] block_write_full_page+0xc9/0xd1
 [<c01c0788>] ext3_ordered_writepage+0x100/0x1b1
 [<c01637db>] __writepage+0xb/0x25
 [<c0163c6c>] write_cache_pages+0x19d/0x2b4
 [<c0163da5>] generic_writepages+0x22/0x2a
 [<c0163de3>] do_writepages+0x36/0x48
 [<c015f176>] __filemap_fdatawrite_range+0x5b/0x67
 [<c015f22b>] filemap_fdatawrite_range+0x22/0x29
 [<c015f392>] sync_page_range+0x8c/0x107
 [<c0160347>] generic_file_aio_write+0xbf/0xdb
 [<c01bc94b>] ext3_file_write+0x27/0x99
 [<c017f1ec>] do_sync_write+0xd7/0x114
 [<c017fad2>] vfs_write+0xd1/0x15a
 [<c0180102>] sys_write+0x3d/0x72
 [<c010432c>] syscall_call+0x7/0xb
 =======================
Code: ff 8b 45 e4 8b 50 0c 83 f2 08 c1 ea 03 83 e2 01 b8 20 e1 43 c0 e8 e5 bb 01 00 85 c0 74 0a 8b 55 e4 89 f0 e8 63 f4 ff ff 8b 47 38 <8b> 50 24 89 55 e8 8b 4d e4 8b 49 20 89 4d ec 0f b7 48 14 6b c9
EIP: [<c01f4618>] ll_back_merge_fn+0x9d/0x1ba SS:ESP 0068:ee7ebb18

0xc01f4618 is in ll_back_merge_fn (/mnt/md0/devel/linux-mm/block/ll_rw_blk.c:1421).
1416            }
1417            if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
1418                    blk_recount_segments(q, req->biotail);
1419            if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
1420                    blk_recount_segments(q, bio);
1421            len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
1422            if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio)) &&
1423                !BIOVEC_VIRT_OVERSIZE(len)) {
1424                    int mergeable =  ll_new_mergeable(q, req, bio);
1425

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20-mm2/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
