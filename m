Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXD0H7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXD0H7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbXD0H7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:59:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:59983 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755474AbXD0H7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:59:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+9EPEbhli98DE1qnCIH7F7YmaGLLUwFRv/qncYbz
	z6DboTUlrcddbK
Subject: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is
	under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: multipart/mixed; boundary="=-5xzHrAax+VUHPPAQSHJd"
Date: Fri, 27 Apr 2007 09:59:27 +0200
Message-Id: <1177660767.6567.41.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5xzHrAax+VUHPPAQSHJd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings,

As subject states, my GUI is going away for extended periods of time
when my very full and likely highly fragmented (how to find out)
filesystem is under heavy write load.  While write is under way, if
amarok (mp3 player) is running, no song change will occur until write is
finished, and the GUI can go _entirely_ comatose for very long periods.
Usually, it will come back to life after write is finished, but
occasionally, a complete GUI restart is necessary.

The longest comatose period to date was ~20 minutes with 2.6.20.7 a few
days ago.  I was letting SuSE's software update programs update my SuSE
10.2 system, and started a bonnie while it was running (because I had
been seeing this on recent kernels, and wanted to see if it was in
stable as well), WHAM, instant dead GUI.  When this happens, kbd and
mouse events work fine, so I hot-keyed to a VT via CTRL+ALT+F1, and
killed the bonnie.  No joy, GUI stayed utterly comatose until the
updater finished roughly 20 minutes later, at which time the shells I'd
tried to start popped up, and all worked as if nothing bad had ever
happened.  During the time in between, no window could be brought into
focus, nada.

While a bonnie is writing, if I poke KDE's menu button, that will
instantly trigger nastiness, and a trace (this one was with a cfs
kernel, but I just did same with virgin 2.6.21) shows that "kicker",
KDE's launcher proggy does an fdatasync for some reason, and that's the
end of it's world for ages.  When clicking on amarok's icon, it does an
fsync, and that's the last thing that will happen in it's world until
write is done as well.  I've repeated this with CFQ and AS IO
schedulers.

I have a couple of old kernels lying around that I can test with, but I
think it's going to be the same.  Seems to be ext3's journal that is
causing my woes.  Below this trace of kicker is one of amarok during
it's dead to the world time.

Box is 3GHz P4 intel ICH5, SMP/UP doesn't matter.  .config is latest
kernel tested attached.  Mount options are
noatime,nodiratime,acl,user_xattr.


[  308.046646] kicker        D 00000044     0  5897      1 (NOTLB)
[  308.052611]        f32abe4c 00200082 83398b5a 00000044 c01c251e f32ab000 f32ab000 c01169b6 
[  308.060926]        f772fbcc cdc7e694 00000039 8339857a 00000044 83398b5a 00000044 00000000 
[  308.069422]        c1b5ab00 c1b5aac0 00353928 f32abe80 c01c7ab8 00000000 f32ab000 c1b5ab10 
[  308.077927] Call Trace:
[  308.080568]  [<c01c7ab8>] log_wait_commit+0x9d/0x11f
[  308.085549]  [<c01c250f>] journal_stop+0x1a1/0x22a
[  308.090364]  [<c01c2fce>] journal_force_commit+0x1d/0x20
[  308.095699]  [<c01bac1e>] ext3_force_commit+0x24/0x26
[  308.100774]  [<c01b50ea>] ext3_write_inode+0x2d/0x3b
[  308.105771]  [<c0186cf0>] __writeback_single_inode+0x2df/0x3a9
[  308.111633]  [<c0187641>] sync_inode+0x15/0x38
[  308.116093]  [<c01b1695>] ext3_sync_file+0xbd/0xc8
[  308.120900]  [<c0189a09>] do_fsync+0x58/0x8b
[  308.125188]  [<c0189a5c>] __do_fsync+0x20/0x2f
[  308.129656]  [<c0189a7b>] sys_fdatasync+0x10/0x12
[  308.134384]  [<c0103eec>] sysenter_past_esp+0x5d/0x81
[  308.139441]  =======================
[  311.755953] bonnie        D 00000046     0  6146   5929 (NOTLB)
[  311.761929]        e7622a60 00200082 04d7e5fe 00000046 03332bd5 00000000 e7622000 c02c0c54 
[  311.770244]        d8eaabcc e7622a64 f7d0c3ec 04d7e521 00000046 04d7e5fe 00000046 00000000 
[  311.778758]        e7622aa4 f4f94400 e7622aac e7622a68 c04a2f06 e7622a70 c018b105 e7622a8c 
[  311.787261] Call Trace:
[  311.789904]  [<c04a2f06>] io_schedule+0xe/0x16
[  311.794373]  [<c018b105>] sync_buffer+0x2e/0x32
[  311.798927]  [<c04a3756>] __wait_on_bit_lock+0x3f/0x62
[  311.804089]  [<c04a37d8>] out_of_line_wait_on_bit_lock+0x5f/0x67
[  311.810115]  [<c018b248>] __lock_buffer+0x2b/0x31
[  311.814846]  [<c018bb56>] sync_dirty_buffer+0x88/0xc3
[  311.819921]  [<c01c3ce4>] journal_dirty_data+0x1dd/0x205
[  311.825256]  [<c01b3300>] ext3_journal_dirty_data+0x12/0x37
[  311.830858]  [<c01b333a>] journal_dirty_data_fn+0x15/0x1c
[  311.836280]  [<c01b277d>] walk_page_buffers+0x36/0x68
[  311.841347]  [<c01b552f>] ext3_ordered_writepage+0x11a/0x191
[  311.847027]  [<c0152133>] generic_writepages+0x1f3/0x305
[  311.852344]  [<c015227c>] do_writepages+0x37/0x39
[  311.857064]  [<c0186aa7>] __writeback_single_inode+0x96/0x3a9
[  311.862842]  [<c0187037>] sync_sb_inodes+0x1bc/0x27f
[  311.867830]  [<c01875e3>] writeback_inodes+0x98/0xe1
[  311.872819]  [<c015240a>] balance_dirty_pages_ratelimited_nr+0xc4/0x1bf
[  311.879461]  [<c014df55>] generic_file_buffered_write+0x32e/0x677
[  311.885576]  [<c014e580>] __generic_file_aio_write_nolock+0x2e2/0x57f
[  311.892044]  [<c014e87d>] generic_file_aio_write+0x60/0xd4
[  311.897553]  [<c01b14f7>] ext3_file_write+0x27/0xa5
[  311.902455]  [<c016ab7b>] do_sync_write+0xcd/0x103
[  311.907270]  [<c016b37a>] vfs_write+0xa8/0x128
[  311.911738]  [<c016b873>] sys_write+0x3d/0x64
[  311.916111]  [<c0103eec>] sysenter_past_esp+0x5d/0x81
[  311.921185]  =======================
[  311.924763] pdflush       D 00000046     0  6147      5 (L-TLB)
[  311.930739]        ec7e2ef0 00000046 03f2b0ea 00000046 ec7e2f0c c0186b45 ec7e2000 c01169b6 
[  311.939052]        ea14069c ec7e2f00 ec7e2f00 03f2afc9 00000046 03f2b0ea 00000046 00000282 
[  311.947557]        ec7e2f00 ffffab4c ec7e2f30 ec7e2f20 c04a3689 00000400 00000840 c0681648 
[  311.956062] Call Trace:
[  311.958703]  [<c04a3689>] schedule_timeout+0x44/0xa4
[  311.963683]  [<c04a2eda>] io_schedule_timeout+0xe/0x16
[  311.968827]  [<c01568c7>] congestion_wait+0x4c/0x61
[  311.973721]  [<c0152603>] background_writeout+0x2f/0x8f
[  311.978969]  [<c0152b68>] pdflush+0xe7/0x1d6
[  311.983255]  [<c012e8fb>] kthread+0xc5/0xc9
[  311.987465]  [<c0104aab>] kernel_thread_helper+0x7/0x1c

[ 1421.790647] amarokapp     D 00000148     0  6428      1 (NOTLB)
[ 1421.796620]        e303ce4c 00000082 823c9fd2 00000148 00000148 ee1a3030 e303c000 00000001 
[ 1421.804944]        ee1a316c dfef91d0 00000000 823c9f15 00000148 823c9fd2 00000148 00000246 
[ 1421.813447]        dfef91c0 dfef9180 0035465c e303ce80 c01c7ab8 00000000 e303c000 dfef91d0 
[ 1421.821962] Call Trace:
[ 1421.824603]  [<c01c7ab8>] log_wait_commit+0x9d/0x11f
[ 1421.829582]  [<c01c250f>] journal_stop+0x1a1/0x22a
[ 1421.834397]  [<c01c2fce>] journal_force_commit+0x1d/0x20
[ 1421.839732]  [<c01bac1e>] ext3_force_commit+0x24/0x26
[ 1421.844790]  [<c01b50ea>] ext3_write_inode+0x2d/0x3b
[ 1421.849771]  [<c0186cf0>] __writeback_single_inode+0x2df/0x3a9
[ 1421.855633]  [<c0187641>] sync_inode+0x15/0x38
[ 1421.860103]  [<c01b1695>] ext3_sync_file+0xbd/0xc8
[ 1421.864918]  [<c0189a09>] do_fsync+0x58/0x8b
[ 1421.869213]  [<c0189a5c>] __do_fsync+0x20/0x2f
[ 1421.873673]  [<c0189a8a>] sys_fsync+0xd/0xf
[ 1421.877874]  [<c0103eec>] sysenter_past_esp+0x5d/0x81


--=-5xzHrAax+VUHPPAQSHJd
Content-Disposition: attachment; filename=config.gz
Content-Type: application/x-gzip; name=config.gz
Content-Transfer-Encoding: base64

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
FGiGxV1N29VVKO06ZClDUfk/1Ef+ExLUAAA=


--=-5xzHrAax+VUHPPAQSHJd--

