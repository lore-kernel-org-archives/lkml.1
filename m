Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXFDUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXFDUmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbXFDUmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:42:05 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49213 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbXFDUmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:42:03 -0400
Message-ID: <4664785C.4090205@gmail.com>
Date: Mon, 04 Jun 2007 22:38:52 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Q] Bio traversal trouble?
References: <4663DE68.5030200@gmail.com> <84144f020706041141q26d0cba2u352c294d1ec90daf@mail.gmail.com>
In-Reply-To: <84144f020706041141q26d0cba2u352c294d1ec90daf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2007 08:41 PM, Pekka Enberg wrote:

[ Jens' email address updated to his oracle address ]

> We can see that we're reading 2048 bytes from port 0x300 and storing
> the data in memory location 0x8c1d2071 which causes the OOPS. What's
> surprising is that EBP is set to 0x8c1d2071 too which suggests stack
> corruption (note that ioread8_rep() is a fastcall so it does not
> create a stack frame of its own). What you could do here is add some
> printks and watch how dst changes over time to see if you can figure
> out a pattern.

Mmm, I do always run with 4K stacks, I guess I'll try that next. I did follow 
things a bit with printk. The normal and expected scenario is an N-frame request 
consisting of N bio's, each consisting of 1 segment, each consisting of 1 frame.

That is, with this as mitsumi_read:

static unsigned int mitsumi_read(struct mitsumi_cdrom *mcd, struct bio *bio)
{
         sector_t frame = sector_to_frame(bio->bi_sector);
         unsigned int bytes = 0;
         struct bio_vec *bvec;
         int segno;

         printk("%s: enter\n", __func__);

         bio_for_each_segment(bvec, bio, segno) {
                 unsigned char *dst;
                 unsigned int len;

                 dst = page_address(bvec->bv_page) + bvec->bv_offset;

                 printk("%s: dst = %p, len = %#x\n", __func__, dst,
                        bvec->bv_len);

                 for (len = bvec->bv_len; len; len -= CD_FRAMESIZE) {
                         if (mitsumi_get_frame(mcd, frame++, dst))
                                 goto out;

                         bytes += CD_FRAMESIZE;
                         dst += CD_FRAMESIZE;
                 }
         }
   out:
         return bytes;
}

I get a long uninterrupted string of:

[  903.130588] mitsumi_read: enter
[  903.130630] mitsumi_read: dst = c2cd1000, len = 0x800
[  903.143644] mitsumi_read: enter
[  903.143686] mitsumi_read: dst = c2cd1800, len = 0x800
[  903.156949] mitsumi_read: enter
[  903.156992] mitsumi_read: dst = c3353000, len = 0x800
[  903.170325] mitsumi_read: enter
[  903.170367] mitsumi_read: dst = c3353800, len = 0x800

until it oopses:

[  903.184750] mitsumi_read: enter
[  903.184795] mitsumi_read: dst = c3a7f000, len = 0x800
[  903.299315] mitsumi_read: dst = 8c1d2071, len = 0xc1033bda
[  903.311457] BUG: unable to handle kernel paging request at virtual address 
8c1d2071

And yes, it's the ioread8_rep that's trying to address the wrong dst. This 
particular OOPS by the way while very similar doesn't have cfq in the backtrace 
so here it is complete again:

===
BUG: unable to handle kernel paging request at virtual address 8c1d2071
  printing eip:
c10a6d6f
*pde = 00000000
Oops: 0002 [#1]
Modules linked in: mitsumi nfsd exportfs lockd sunrpc nls_cp437 msdos fat nls_base
CPU:    0
EIP:    0060:[<c10a6d6f>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21.3 #1)
EIP is at ioread8_rep+0x20/0x31
eax: 00010000   ebx: 00010300   ecx: 00000800   edx: 00000300
esi: c2e26b20   edi: 8c1d2071   ebp: 8c1d2071   esp: c2e26adc
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process dd (pid: 1437, ti=c2e26000 task=c1632050 task.ti=c2e26000)
Stack: 00000000 c3c55098 c486504d c4865ab7 00000006 50e20034 c11a5edc 00000034
        00000000 00520300 50d50100 11d73140 00000034 00340300 5b3e343c 30392020
        39322e33 00000000 00000001 00000000 00000000 00000000 dead4ead ffffffff
Call Trace:
  [<c486504d>] __mitsumi_get_frame+0xc/0x16 [mitsumi]
  [<c4865ab7>] mitsumi_get_frame+0x120/0x134 [mitsumi]
  [<c1033bda>] mempool_free+0x5f/0x64
  [<c4865b66>] mitsumi_read+0x9b/0xce [mitsumi]
  [<c1033bda>] mempool_free+0x5f/0x64
  [<c4865be2>] mitsumi_request+0x49/0xb5 [mitsumi]
  [<c1099aae>] blk_start_queueing+0x14/0x1c
  [<c10971c2>] elv_insert+0xa3/0x13f
  [<c114fbc5>] _spin_lock_irq+0x2f/0x3a
  [<c109a577>] __make_request+0x29f/0x2d3
  [<c109a75b>] generic_make_request+0x136/0x146
  [<c1048433>] kmem_cache_alloc+0x93/0x9e
  [<c1033ae0>] mempool_alloc+0x32/0xcd
  [<c1033ae0>] mempool_alloc+0x32/0xcd
  [<c109a80f>] submit_bio+0xa4/0xaa
  [<c106736b>] bio_alloc_bioset+0xb2/0x112
  [<c1066dd1>] submit_bh+0xc2/0xdb
  [<c1065fc4>] block_read_full_page+0x245/0x252
  [<c1068346>] blkdev_get_block+0x0/0x36
  [<c114ffff>] _write_unlock_irq+0x20/0x23
  [<c103134f>] add_to_page_cache+0x71/0x78
  [<c10368f3>] read_pages+0x7c/0xc1
  [<c114ff7e>] _read_unlock_irq+0x20/0x23
  [<c114ff7e>] _read_unlock_irq+0x20/0x23
  [<c1025de0>] trace_hardirqs_on+0x11b/0x13e
  [<c1036a25>] __do_page_cache_readahead+0xed/0x107
  [<c1036b43>] blockable_page_cache_readahead+0x4d/0x9d
  [<c1036c17>] make_ahead_window+0x84/0xa5
  [<c1036d74>] page_cache_readahead+0x13c/0x15b
  [<c1031cbc>] file_read_actor+0x7f/0x102
  [<c1031953>] do_generic_mapping_read+0x110/0x3fa
  [<c1031ec6>] generic_file_aio_read+0x187/0x1b0
  [<c1031c3d>] file_read_actor+0x0/0x102
  [<c104abc3>] do_sync_read+0xbf/0xfc
  [<c101f2b8>] autoremove_wake_function+0x0/0x33
  [<c1070fe1>] dnotify_parent+0x1b/0x66
  [<c104aec2>] vfs_write+0xc9/0xff
  [<c1027210>] __lock_release+0x2d/0x3f
  [<c104ac87>] vfs_read+0x87/0xfd
  [<c104af39>] sys_read+0x41/0x67
  [<c1002490>] syscall_call+0x7/0xb
  =======================
Code: 00 00 89 c8 ef c3 0f c9 89 0a c3 57 3d ff ff 03 00 53 89 d7 89 c3 89 ca 77 
15 66 31 c0 3d 00 00 01 00 74 04 0f 0b eb fe 0f b7 d3 <f3> 6c eb 0a 4a 78 07 8a 
03 88 07 47 eb f6 5b 5f c3 57 3d ff ff
EIP: [<c10a6d6f>] ioread8_rep+0x20/0x31 SS:ESP 0068:c2e26adc
===

> Also, assuming CFQ fiddles with the request after we've done
> elv_next_request() and dropped the lock, one thing worth trying is to
> do blk_stop_queue() before we drop it and blk_start_queue after we
> reacquire it so that we don't actually get any new I/O while we wait
> for mitsumi_get_frame() to finish.

That sounded like it might work (even if it might not be a proper solution) so I 
added:

	block_stop_queue(q);

immediately before the spin_unlock_irq(q->queue_lock) and a

	block_start_queue(q);

immediately after the spin_lock_irq(q->queue_lock) in mitsumi_request. This 
seems to be an immediate deadlock of sorts though. Box dead. :-\

Rene.

