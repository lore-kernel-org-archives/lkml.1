Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYADLrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYADLrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYADLrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:47:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:56885 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751407AbYADLrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:47:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+2PN0DMHq2UHWSc8sHgpeC4gFaI7wWxje7CCNXag
	cAOktwtutUlotL
Subject: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory pressure:
	box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-/sjjcPgvjnY7h/vZ7i8p"
Date: Fri, 04 Jan 2008 12:46:51 +0100
Message-Id: <1199447212.4529.13.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/sjjcPgvjnY7h/vZ7i8p
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings,

I discovered that I can easily turn my P4/HT 2.6.24.git box into a
doorstop by simply copying a checked-out [~500MB] git repository to a
DVD+RW.  This isn't a 2.6.24.git regression, the stock openSuSE 10.3
kernel (2.6.22) does the same.  A modest write with no memory pressure
works fine, but add pressure, and box chokes to death every time.

recipe:
dvd+rw-format
mkudffs
mount
/dev/sr0 on /media/LinuxUDF type udf (rw,nosuid,nodev,noatime,uid=0)
cp -av linux-2.6 /media/LinuxUDF/.

Give cp a good head start, and then start a couple parallel kbuilds.
After a while, box slogs to a halt, or perhaps it's just a very VERY
slow crawl.  Box is not oom, but it may as well be.

Snippet of serial console output while box is impersonating doorstop:
(264k boot->SysRq-B log available, config.gz attached)

Anybody unfortunate enough to enter shrink_slab() reclaim  path (Xorg
did below) ends up sleeping on iprune_mutex, if not forever, for long
enough that I give up and forcibly reboot.  I've waited for up to an
hour to see if it would eventually recover, but it never has before I
became impatient.  The iprune_mutex appears to be held my kswapd, which
is asleep after having also gone down the shrink_slab() reclaim path.

homer:/root # vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  4     44   8196  70276 609588    0    0   205   229   38  862 70 10  7 13
 0  4     44   8196  70276 609588    0    0     0     0   14   37  0  0 32 68
 0  4     44   8196  70276 609588    0    0     0     0    7   35  0  0 51 49
 0  4     44   8200  70276 609588    0    0     0     0    5   37  0  0 50 50
 0  4     44   8200  70276 609588    0    0     0     0    6   41  0  0 35 65
 0  4     44   8200  70276 609588    0    0     0     0    6   35  0  0 48 52
 0  4     44   8200  70276 609588    0    0     0     0    5   36  0  0 50 50
 0  4     44   8200  70276 609588    0    0     0     0    6   33  0  0 52 48
 0  4     44   8200  70276 609588    0    0     0     0    5   41  0  0 50 50
 0  4     44   8200  70276 609588    0    0     0     0    5   33  0  0 48 52

homer:/root # [ 2188.489078] SysRq : Show Blocked State
[ 2188.492870]   task                PC stack   pid father
[ 2188.498113] pdflush       D ef863d7c     0   155      2
[ 2188.503400]        ef863d90 00000046 00000002 ef863d7c ef863d74 00000000 00000000 00000960 
[ 2188.511783]        00000000 b0406240 b0408f80 ef898e70 ef8990a0 b180bf80 ef863000 00000000 
[ 2188.520305]        ee2cf5d0 ef86a908 0019c2c6 b01dd062 b014214d 00000000 00000003 00000000 
[ 2188.527995] Call Trace:
[ 2188.531469]  [<b01dd062>] generic_unplug_device+0x15/0x21
[ 2188.534022]  [<b014214d>] getnstimeofday+0x2f/0xd7
[ 2188.539493]  [<b02e2689>] io_schedule+0x4f/0x89
[ 2188.539505]  [<b01a252d>] sync_buffer+0x30/0x34
[ 2188.539511]  [<b02e28a8>] __wait_on_bit+0x42/0x5e
[ 2188.539515]  [<b01a24fd>] sync_buffer+0x0/0x34
[ 2188.539525]  [<b02e292b>] out_of_line_wait_on_bit+0x67/0x6f
[ 2188.539533]  [<b01a24fd>] sync_buffer+0x0/0x34
[ 2188.539543]  [<b013ccbd>] wake_bit_function+0x0/0x3c
[ 2188.539558]  [<b01a24c4>] __wait_on_buffer+0x24/0x29
[ 2188.539565]  [<b01a3ed5>] __bread+0x55/0x8a
[ 2188.539572]  [<f0d70e53>] udf_tread+0x3c/0x41 [udf]
[ 2188.539585]  [<f0d66add>] udf_update_inode+0x43/0xb8d [udf]
[ 2188.539597]  [<b01692fd>] pagevec_lookup_tag+0x24/0x2c
[ 2188.539612]  [<b01676bc>] __writepage+0x0/0x25
[ 2188.539661]  [<f0d68ca4>] udf_write_inode+0x14/0x20 [udf]
[ 2188.539671]  [<b019d9cc>] __writeback_single_inode+0x228/0x306
[ 2188.539689]  [<b015fd15>] delayacct_end+0x71/0x79
[ 2188.539699]  [<b01e6795>] _atomic_dec_and_lock+0x31/0x5c
[ 2188.539713]  [<b019de52>] sync_sb_inodes+0x1c3/0x295
[ 2188.539730]  [<b019e100>] writeback_inodes+0x7d/0xac
[ 2188.539739]  [<b01685df>] background_writeout+0x98/0xb7
[ 2188.539765]  [<b0168abc>] pdflush+0x0/0x1d4
[ 2188.539770]  [<b0168bc3>] pdflush+0x107/0x1d4
[ 2188.539777]  [<b0168547>] background_writeout+0x0/0xb7
[ 2188.539789]  [<b013ca06>] kthread+0x34/0x56
[ 2188.539793]  [<b013c9d2>] kthread+0x0/0x56
[ 2188.539800]  [<b0104d8b>] kernel_thread_helper+0x7/0x1c
[ 2188.539814]  =======================
[ 2188.539818] pdflush       D b1811b40     0   156      2
[ 2188.539822]        ef864ef4 00000046 00000818 b1811b40 00000002 ef864edc 00000001 db6b063e 
[ 2188.539829]        0000019a b0406240 b0408f80 ef8987d0 ef898a00 b1814f80 ef864000 00000202 
[ 2188.539836]        ef84e000 ee1f7588 b0133013 00000002 00000000 ef864f04 00000202 b013312e 
[ 2188.539843] Call Trace:
[ 2188.539870]  [<b0133013>] lock_timer_base+0x19/0x35
[ 2188.539881]  [<b013312e>] __mod_timer+0x9d/0xac
[ 2188.539894]  [<b02e2717>] schedule_timeout+0x44/0xa1
[ 2188.539906]  [<b0132cb1>] process_timeout+0x0/0x5
[ 2188.539913]  [<b02e2712>] schedule_timeout+0x3f/0xa1
[ 2188.539927]  [<b02e255a>] io_schedule_timeout+0x54/0x93
[ 2188.539938]  [<b016d3af>] congestion_wait+0x4d/0x61
[ 2188.539946]  [<b013cc88>] autoremove_wake_function+0x0/0x35
[ 2188.539958]  [<b01686c4>] wb_kupdate+0x9c/0xe2
[ 2188.539980]  [<b0168abc>] pdflush+0x0/0x1d4
[ 2188.539984]  [<b0168bc3>] pdflush+0x107/0x1d4
[ 2188.539990]  [<b0168628>] wb_kupdate+0x0/0xe2
[ 2188.540001]  [<b013ca06>] kthread+0x34/0x56
[ 2188.540005]  [<b013c9d2>] kthread+0x0/0x56
[ 2188.540012]  [<b0104d8b>] kernel_thread_helper+0x7/0x1c
[ 2188.540025]  =======================
[ 2188.540027] kswapd0       D 00000004     0   157      2
[ 2188.540031]        ef8aacd4 00000046 d8fdb0e8 00000004 00000000 ee2cf5d0 00000000 dec5cace 
[ 2188.540037]        00000197 b0406240 b0408f80 ef89b550 ef89b780 b180bf80 ef8aa000 00000000 
[ 2188.540044]        ee2cf5d0 ee310208 ee2cf5d0 00000000 00000000 ef814914 0039768c 01403000 
[ 2188.540051] Call Trace:
[ 2188.540094]  [<b02e2689>] io_schedule+0x4f/0x89
[ 2188.540103]  [<b01a252d>] sync_buffer+0x30/0x34
[ 2188.540107]  [<b02e28a8>] __wait_on_bit+0x42/0x5e
[ 2188.540111]  [<b01a24fd>] sync_buffer+0x0/0x34
[ 2188.540120]  [<b02e292b>] out_of_line_wait_on_bit+0x67/0x6f
[ 2188.540128]  [<b01a24fd>] sync_buffer+0x0/0x34
[ 2188.540138]  [<b013ccbd>] wake_bit_function+0x0/0x3c
[ 2188.540150]  [<b01a24c4>] __wait_on_buffer+0x24/0x29
[ 2188.540158]  [<b01a348a>] sync_dirty_buffer+0x7e/0xc4
[ 2188.540171]  [<f0d67400>] udf_update_inode+0x966/0xb8d [udf]
[ 2188.540223]  [<f0d6fafc>] extent_trunc+0xac/0x16e [udf]
[ 2188.540244]  [<f0d68ca4>] udf_write_inode+0x14/0x20 [udf]
[ 2188.540253]  [<b019d9cc>] __writeback_single_inode+0x228/0x306
[ 2188.540284]  [<b019db3a>] write_inode_now+0x66/0xb3
[ 2188.540310]  [<f0d691f3>] udf_clear_inode+0x33/0x47 [udf]
[ 2188.540318]  [<b019549a>] clear_inode+0x62/0x136
[ 2188.540327]  [<b0195a79>] dispose_list+0x1a/0xd6
[ 2188.540337]  [<b0195caf>] shrink_icache_memory+0x17a/0x233
[ 2188.540352]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.540375]  [<b016bcaa>] kswapd+0x314/0x4a6
[ 2188.540411]  [<b013cc88>] autoremove_wake_function+0x0/0x35
[ 2188.540422]  [<b012099a>] complete+0x3a/0x4a
[ 2188.540433]  [<b016b996>] kswapd+0x0/0x4a6
[ 2188.540438]  [<b013ca06>] kthread+0x34/0x56
[ 2188.540442]  [<b013c9d2>] kthread+0x0/0x56
[ 2188.540449]  [<b0104d8b>] kernel_thread_helper+0x7/0x1c
[ 2188.540463]  =======================
[ 2188.540485] hald-addon-st D ede4bb5c     0  2308   2202
[ 2188.540489]        ede4bb70 00000082 00000002 ede4bb5c ede4bb54 00000000 00000000 ee2cf5d0 
[ 2188.540496]        ee2cf5d0 b0406240 b0408f80 ee3204b0 ee3206e0 b180bf80 ede4b000 e82600b0 
[ 2188.540503]        00000001 ef86a908 0019c2c6 00000002 ef3c3ec8 00000000 00000003 00000000 
[ 2188.540509] Call Trace:
[ 2188.540553]  [<b02e273c>] schedule_timeout+0x69/0xa1
[ 2188.540560]  [<b01d8e70>] elv_drain_elevator+0x15/0x5d
[ 2188.540570]  [<b01d9912>] elv_insert+0x107/0x220
[ 2188.540574]  [<b01dd0ad>] blk_plug_device+0x3f/0xb1
[ 2188.540590]  [<b02e1b97>] wait_for_common+0x6a/0x101
[ 2188.540599]  [<b01228e7>] default_wake_function+0x0/0xc
[ 2188.540612]  [<b01dcda1>] blk_execute_rq+0x72/0xb3
[ 2188.540618]  [<b01dbbb9>] blk_end_sync_rq+0x0/0x23
[ 2188.540635]  [<b01a53b2>] bio_add_pc_page+0x23/0x28
[ 2188.540650]  [<b01dbd5f>] blk_rq_bio_prep+0x9a/0xae
[ 2188.540658]  [<b01dc01b>] blk_rq_append_bio+0x14/0x44
[ 2188.540666]  [<b01dc1c4>] blk_rq_map_user+0x11d/0x199
[ 2188.540684]  [<b01e03ec>] sg_io+0x196/0x2f3
[ 2188.540737]  [<b01e081e>] scsi_cmd_ioctl+0x2d5/0x417
[ 2188.540754]  [<f084be00>] scsi_test_unit_ready+0x56/0x95 [scsi_mod]
[ 2188.540819]  [<f0aab3a8>] cdrom_ioctl+0x2b/0xdca [cdrom]
[ 2188.540832]  [<b018c1c8>] __link_path_walk+0x9eb/0xd0f
[ 2188.540841]  [<b017ed94>] cache_free_debugcheck+0xf8/0x240
[ 2188.540852]  [<f0aa8074>] media_changed+0x47/0x7e [cdrom]
[ 2188.540868]  [<f0ac1068>] sr_block_ioctl+0x47/0x7f [sr_mod]
[ 2188.540886]  [<b01de50f>] blkdev_driver_ioctl+0x55/0x5e
[ 2188.540898]  [<b01de72f>] blkdev_ioctl+0x217/0x7c8
[ 2188.540913]  [<b0181ae1>] get_unused_fd_flags+0xb5/0xce
[ 2188.540925]  [<b01e7502>] kobject_get+0xf/0x13
[ 2188.540932]  [<b01df0fd>] get_disk+0x1b/0x80
[ 2188.540940]  [<b01df169>] exact_lock+0x7/0xd
[ 2188.540944]  [<b0252fff>] kobj_lookup+0x157/0x172
[ 2188.540952]  [<b01e7502>] kobject_get+0xf/0x13
[ 2188.540964]  [<f0ac03a1>] sr_block_open+0x70/0x81 [sr_mod]
[ 2188.540975]  [<b01a68e4>] do_open+0xb5/0x28b
[ 2188.540992]  [<b01a6c84>] blkdev_open+0x25/0x53
[ 2188.541002]  [<b0181c80>] __dentry_open+0x17f/0x1d9
[ 2188.541014]  [<b0181d67>] nameidata_to_filp+0x31/0x3a
[ 2188.541020]  [<b01a6c5f>] blkdev_open+0x0/0x53
[ 2188.541024]  [<b017eadc>] poison_obj+0x1c/0x33
[ 2188.541027]  [<b0181da9>] do_filp_open+0x39/0x40
[ 2188.541038]  [<b017ed94>] cache_free_debugcheck+0xf8/0x240
[ 2188.541054]  [<b01a60c4>] block_ioctl+0x18/0x1d
[ 2188.541060]  [<b01a60ac>] block_ioctl+0x0/0x1d
[ 2188.541064]  [<b018e68f>] do_ioctl+0x1f/0x6d
[ 2188.541075]  [<b018e8e0>] vfs_ioctl+0x203/0x27f
[ 2188.541081]  [<b0181e5b>] do_sys_open+0xab/0xc0
[ 2188.541091]  [<b018e9b2>] sys_ioctl+0x56/0x68
[ 2188.541101]  [<b010413a>] sysenter_past_esp+0x5f/0x85
[ 2188.541118]  [<b02e0000>] netlbl_cipsov4_genl_init+0x40/0x57
[ 2188.541135]  =======================
[ 2188.541137] Xorg          D ede7bd38     0  2340   2318
[ 2188.541141]        ede7bd4c 00203082 00000002 ede7bd38 ede7bd30 00000000 00000001 ede7bd94 
[ 2188.541147]        00000020 b0406240 b0408f80 ee26e9d0 ee26ec00 b1814f80 ede7b000 b016998a 
[ 2188.541154]        00000020 edee0ac8 001a5d24 00000000 00000000 00000000 00000003 00000000 
[ 2188.541161] Call Trace:
[ 2188.541184]  [<b016998a>] __pagevec_release+0x15/0x1d
[ 2188.541208]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.541222]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.541226]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.541233]  [<f083a45c>] mb_cache_shrink_fn+0xde/0xe0 [mbcache]
[ 2188.541250]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.541273]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.541304]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.541331]  [<b017c382>] shmem_getpage+0x144/0x68b
[ 2188.541351]  [<b0143084>] clocksource_get_next+0x3a/0x40
[ 2188.541355]  [<b0141be1>] update_wall_time+0x3f0/0x865
[ 2188.541367]  [<b017c9a3>] shmem_fault+0x68/0x97
[ 2188.541382]  [<b01cc2fc>] shm_fault+0xc/0xd
[ 2188.541387]  [<b016e4ba>] __do_fault+0x55/0x376
[ 2188.541415]  [<b01cc2f0>] shm_fault+0x0/0xd
[ 2188.541419]  [<b016fb79>] handle_mm_fault+0x11d/0x634
[ 2188.541449]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[ 2188.541470]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[ 2188.541478]  [<b011c99c>] do_page_fault+0x0/0x5d4
[ 2188.541483]  [<b02e3d9a>] error_code+0x72/0x78
[ 2188.541500]  [<b02e0000>] netlbl_cipsov4_genl_init+0x40/0x57
[ 2188.541516]  =======================
[ 2188.541538] vmstat        D e0b1bdec     0  4690   3811
[ 2188.541542]        e0b1be00 00200082 00000002 e0b1bdec e0b1bde4 00000000 00000001 ee2291a0 
[ 2188.541549]        b01bb098 b0406240 b0408f80 ee19c2b0 ee19c4e0 b1814f80 e0b1b000 00000001 
[ 2188.541555]        00000004 e0836908 001af82e 00000000 00005c5e 00000000 00000003 00000000 
[ 2188.541562] Call Trace:
[ 2188.541576]  [<b01bb098>] show_stat+0x791/0x87f
[ 2188.541609]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.541624]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.541628]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.541631]  [<b0192fcb>] prune_dcache+0x145/0x189
[ 2188.541647]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.541669]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.541701]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.541728]  [<b0167016>] __get_free_pages+0x39/0x47
[ 2188.541734]  [<b01b8783>] proc_file_read+0x6d/0x27c
[ 2188.541755]  [<b01b8716>] proc_file_read+0x0/0x27c
[ 2188.541761]  [<b01b47f6>] proc_reg_read+0x58/0x79
[ 2188.541775]  [<b01b479e>] proc_reg_read+0x0/0x79
[ 2188.541781]  [<b0183bc6>] vfs_read+0xa1/0x147
[ 2188.541788]  [<b0182ea1>] vfs_llseek+0x36/0x3c
[ 2188.541798]  [<b018403c>] sys_read+0x41/0x6a
[ 2188.541810]  [<b010413a>] sysenter_past_esp+0x5f/0x85
[ 2188.541839]  =======================
[ 2188.541841] cp            D 00000004     0  4911   3894
[ 2188.541844]        e0b38b14 00200082 0000024e 00000004 00000000 ee2cf5d0 00000000 96ccdff3 
[ 2188.541851]        00000199 b0406240 b0408f80 e0845710 e0845940 b180bf80 e0b38000 00000000 
[ 2188.541858]        ee2cf5d0 e09c5208 ee2cf5d0 00000002 00000000 edeb8914 0039f4ce 01403000 
[ 2188.541865] Call Trace:
[ 2188.541909]  [<b02e2689>] io_schedule+0x4f/0x89
[ 2188.541918]  [<b01a252d>] sync_buffer+0x30/0x34
[ 2188.541921]  [<b02e28a8>] __wait_on_bit+0x42/0x5e
[ 2188.541925]  [<b01a24fd>] sync_buffer+0x0/0x34
[ 2188.541935]  [<b02e292b>] out_of_line_wait_on_bit+0x67/0x6f
[ 2188.541943]  [<b01a24fd>] sync_buffer+0x0/0x34
[ 2188.541953]  [<b013ccbd>] wake_bit_function+0x0/0x3c
[ 2188.541966]  [<b01a24c4>] __wait_on_buffer+0x24/0x29
[ 2188.541974]  [<b01a3ed5>] __bread+0x55/0x8a
[ 2188.541981]  [<f0d70e53>] udf_tread+0x3c/0x41 [udf]
[ 2188.541991]  [<f0d66add>] udf_update_inode+0x43/0xb8d [udf]
[ 2188.542003]  [<b01692fd>] pagevec_lookup_tag+0x24/0x2c
[ 2188.542017]  [<b01676bc>] __writepage+0x0/0x25
[ 2188.542050]  [<b017e56a>] dbg_redzone1+0xe/0x19
[ 2188.542056]  [<b017eb68>] cache_alloc_debugcheck_after+0x75/0x1a9
[ 2188.542073]  [<f0d68ca4>] udf_write_inode+0x14/0x20 [udf]
[ 2188.542083]  [<b019d9cc>] __writeback_single_inode+0x228/0x306
[ 2188.542106]  [<b01e6795>] _atomic_dec_and_lock+0x31/0x5c
[ 2188.542118]  [<b019de52>] sync_sb_inodes+0x1c3/0x295
[ 2188.542135]  [<b019e100>] writeback_inodes+0x7d/0xac
[ 2188.542143]  [<b01682fd>] balance_dirty_pages_ratelimited_nr+0x21f/0x33c
[ 2188.542188]  [<b0162c9f>] generic_file_buffered_write+0x1c7/0x65f
[ 2188.542217]  [<b013ff2d>] ktime_get_ts+0x16/0x44
[ 2188.542226]  [<b015fd15>] delayacct_end+0x71/0x79
[ 2188.542250]  [<b01633e4>] __generic_file_aio_write_nolock+0x2ad/0x50d
[ 2188.542266]  [<b0161859>] file_read_actor+0xcf/0xd9
[ 2188.542289]  [<b016178a>] file_read_actor+0x0/0xd9
[ 2188.542303]  [<b01636a9>] generic_file_aio_write+0x65/0xd3
[ 2188.542311]  [<b012e8e7>] current_fs_time+0x13/0x15
[ 2188.542328]  [<f0d6442c>] udf_file_aio_write+0x4e/0xfc [udf]
[ 2188.542348]  [<b018323f>] do_sync_write+0xd2/0x10e
[ 2188.542377]  [<b013cc88>] autoremove_wake_function+0x0/0x35
[ 2188.542396]  [<b0145517>] tick_program_event+0x38/0x58
[ 2188.542417]  [<b018316d>] do_sync_write+0x0/0x10e
[ 2188.542423]  [<b0183a7f>] vfs_write+0xa4/0x14a
[ 2188.542436]  [<b01840a6>] sys_write+0x41/0x6a
[ 2188.542448]  [<b010413a>] sysenter_past_esp+0x5f/0x85
[ 2188.542478]  =======================
[ 2188.542483] cc1           D b1808b40     0 14511  14510
[ 2188.542486]        d6f87e04 00200082 00000400 b1808b40 00000002 d6f87dec 00000000 93edb8a2 
[ 2188.542493]        00000198 b0406240 b0408f80 d70ac3f0 d70ac620 b180bf80 d6f87000 00000000 
[ 2188.542500]        00000020 ee3103c8 001902d9 b8accb99 ffffffff 00000001 00000003 00000000 
[ 2188.542506] Call Trace:
[ 2188.542551]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.542566]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.542570]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.542586]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.542609]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.542640]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.542667]  [<b016fc89>] handle_mm_fault+0x22d/0x634
[ 2188.542678]  [<b0104c08>] apic_timer_interrupt+0x28/0x30
[ 2188.542701]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[ 2188.542723]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[ 2188.542730]  [<b011c99c>] do_page_fault+0x0/0x5d4
[ 2188.542736]  [<b02e3d9a>] error_code+0x72/0x78
[ 2188.542752]  [<b02e0000>] netlbl_cipsov4_genl_init+0x40/0x57
[ 2188.542768]  =======================
[ 2188.542771] cc1           D b03ac500     0 14878  14876
[ 2188.542775]        cc474e04 00200086 b11d35a0 b03ac500 b016a58c 00000001 00000001 2eedb85d 
[ 2188.542782]        00000198 b0406240 b0408f80 e0845070 e08452a0 b1814f80 cc474000 00000000 
[ 2188.542789]        00000020 e35ca048 cc474e54 00000000 00000000 b0406560 b0406560 b03ac880 
[ 2188.542795] Call Trace:
[ 2188.542803]  [<b016a58c>] isolate_lru_pages+0x5f/0x1bb
[ 2188.542842]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.542857]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.542861]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.542865]  [<b0192fcb>] prune_dcache+0x145/0x189
[ 2188.542879]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.542903]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.542934]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.542961]  [<b016fc89>] handle_mm_fault+0x22d/0x634
[ 2188.542991]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[ 2188.543013]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[ 2188.543020]  [<b011c99c>] do_page_fault+0x0/0x5d4
[ 2188.543026]  [<b02e3d9a>] error_code+0x72/0x78
[ 2188.543042]  [<b02e0000>] netlbl_cipsov4_genl_init+0x40/0x57
[ 2188.543058]  =======================
[ 2188.543061] cc1           D b03ac080     0 14953  14952
[ 2188.543064]        e3480e04 00200086 b100a340 b03ac080 b016a58c 00000001 00000001 2f20bdcf 
[ 2188.543071]        00000198 b0406240 b0408f80 e0880950 e0880b80 b1814f80 e3480000 00000000 
[ 2188.543078]        b03ac080 c65f6588 e3480e54 00000000 00000000 b0406560 b0406560 b03ac400 
[ 2188.543085] Call Trace:
[ 2188.543093]  [<b016a58c>] isolate_lru_pages+0x5f/0x1bb
[ 2188.543133]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.543147]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.543151]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.543155]  [<b0192f7b>] prune_dcache+0xf5/0x189
[ 2188.543170]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.543192]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.543223]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.543250]  [<b016fc89>] handle_mm_fault+0x22d/0x634
[ 2188.543281]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[ 2188.543302]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[ 2188.543310]  [<b011c99c>] do_page_fault+0x0/0x5d4
[ 2188.543315]  [<b02e3d9a>] error_code+0x72/0x78
[ 2188.543344]  =======================
[ 2188.543346] cc1           D d717de4c     0 15009  15008
[ 2188.543350]        d717de04 00200082 b12d9720 d717de4c 00000001 00000001 00000000 ebc981b4 
[ 2188.543357]        00000197 b0406240 b0408f80 cc6de2f0 cc6de520 b180bf80 d717d000 00000000 
[ 2188.543364]        00000001 ee310208 d717de44 00000000 00000000 b03ac400 00000017 d717dea8 
[ 2188.543370] Call Trace:
[ 2188.543414]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.543429]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.543433]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.543436]  [<b0192fcb>] prune_dcache+0x145/0x189
[ 2188.543451]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.543473]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.543504]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.543530]  [<b016fc89>] handle_mm_fault+0x22d/0x634
[ 2188.543561]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[ 2188.543581]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[ 2188.543589]  [<b011c99c>] do_page_fault+0x0/0x5d4
[ 2188.543594]  [<b02e3d9a>] error_code+0x72/0x78
[ 2188.543611]  [<b02e0000>] netlbl_cipsov4_genl_init+0x40/0x57
[ 2188.543627]  =======================
[ 2188.543630] cc1           D e371adf0     0 15093  15092
[ 2188.543633]        e371ae04 00200086 00000002 e371adf0 e371ade8 00000000 00000001 e371ae4c 
[ 2188.543640]        00000020 b0406240 b0408f80 eded50b0 eded52e0 b1814f80 e371a000 b016998a 
[ 2188.543647]        00000020 c65f6748 0019034d 00000000 00000000 00000000 00000003 00000000 
[ 2188.543653] Call Trace:
[ 2188.543677]  [<b016998a>] __pagevec_release+0x15/0x1d
[ 2188.543701]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.543716]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.543720]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.543724]  [<b0192f7b>] prune_dcache+0xf5/0x189
[ 2188.543738]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.543761]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.543792]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.543819]  [<b016fc89>] handle_mm_fault+0x22d/0x634
[ 2188.543849]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[ 2188.543870]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[ 2188.543877]  [<b011c99c>] do_page_fault+0x0/0x5d4
[ 2188.543883]  [<b02e3d9a>] error_code+0x72/0x78
[ 2188.543899]  [<b02e0000>] netlbl_cipsov4_genl_init+0x40/0x57
[ 2188.543915]  =======================
[ 2188.543918] cc1           D d6d33df0     0 15147  15146
[ 2188.543921]        d6d33e04 00200086 00000002 d6d33df0 d6d33de8 00000000 00000000 b013ff2d 
[ 2188.543928]        03312780 b0406240 b0408f80 cc7dcfb0 cc7dd1e0 b180bf80 d6d33000 db730a00 
[ 2188.543935]        000001c3 d7015588 001908bd 000001c3 b18093a0 00000000 00000003 00000000 
[ 2188.543941] Call Trace:
[ 2188.543953]  [<b013ff2d>] ktime_get_ts+0x16/0x44
[ 2188.543987]  [<b02e2abe>] __mutex_lock_slowpath+0x57/0x90
[ 2188.544002]  [<b02e293d>] mutex_lock+0xa/0xb
[ 2188.544006]  [<b0195b8d>] shrink_icache_memory+0x58/0x233
[ 2188.544010]  [<b0192f7b>] prune_dcache+0xf5/0x189
[ 2188.544024]  [<b016b8c3>] shrink_slab+0x12e/0x197
[ 2188.544046]  [<b016c2b7>] try_to_free_pages+0x182/0x267
[ 2188.544077]  [<b0166dd9>] __alloc_pages+0x146/0x34a
[ 2188.544104]  [<b016fc89>] handle_mm_fault+0x22d/0x634
[ 2188.544134]  [<b011ca6c>] do_page_fault+0xd0/0x5d4
[ 2188.544155]  [<b0117f47>] smp_apic_timer_interrupt+0x59/0x84
[ 2188.544162]  [<b011c99c>] do_page_fault+0x0/0x5d4
[ 2188.544168]  [<b02e3d9a>] error_code+0x72/0x78
[ 2188.544197]  =======================


--=-/sjjcPgvjnY7h/vZ7i8p
Content-Disposition: attachment; filename=config.gz
Content-Type: application/x-gzip; name=config.gz
Content-Transfer-Encoding: base64

H4sIAIbpfUcCA4xcW3PbtrZ+76/QuGfm7P1waluyFaczfgBBUERFEjAA6pIXjmMrqaa25W3J3em/
PwsgKQEkQKfTNuH6Fu4L6wZAv/7y6wi9H3bP94ftw/3T0z+j75uXzdv9YfM4er7/azN62L18237/
ffS4e/nfw2jzuD1AiWz78v5j9Nfm7WXzNPp787bf7l5+H41/m/42vgI4eduO/rh/GY2uRheff7+4
+X1yMxpfXNz88iuAmBUJnVXTq4iq0XY/etkdRvvN4ZeGvrqZVpPx7T8nTk2ZXvlZga/5mJGCCIor
RXPSp+KcyarkMVIWiDOG55KVApNqiRROYzbzFNVcZEEKJQfBKhIMxRhJdWLTaEx4JUvOmbAAqRCe
K4Gg5T5GcsRTJgDKCOFEWO3meXn6+MIKUsU5OlHuSornGbW70PaUSuTyHgEGzfXJUemZi3RJ6Cy1
akcCp1WO1lWKFqTiuEpifELjnNoLKZYwtGNdktNCz49nYWvGFU5nKI4rlM2YoCrN7bpMwymSFc3Y
bFyVk7FdT5DNK0fHxUQZjQSISBWTDK3t5mzpqhZyLYE381Rl2mtWVFaMC5bQjNg1tYvmdtguzhkv
M+iFrAoWk6pendOIypgqwzgwkhSJmIo7j8ACtYJeRZ49wkkR02KmWU6g3nwy5y7BlgD9HVHYXYJE
jHUAkPCcs4wWVnNzM4d6ApGwRIUk7Z7R4nt2/rT9ev68e3x/2uzP/6csEJQRJCNIkvPfap109ovR
JzOjr570NLy/AqWphqxg50BLhUKZuyGrOREFsYi0gBklxQJmVTefU3U7GVslULaATUhZcXv2f/vn
1zMfBOuimLWHl/aeAnlZUI57BP0nVlZPOJN0VeV3JSmtGYtkrNcMEykrhLEKI9VicgIVknPQM7ba
0qRauDsVGWDloVGmOVlZKBANWw5LSURVSO+u4zTuQLbwWtpDfzabqUMF0SHWFNB5/Zc+xYzfXmCY
lTKpZEoTdXv56dQpPBOs5L5eJYiKyqAglimJT7UZxIy0BY7VGQhbpbwzAYNLJMw4FwTDlo59yq7R
Ne2SZnqFFkYoRewKKewmqK22WLdnZ9bYMOga2Ff0C6kSBr2Fv3ia6oobySMSx/aASxpfTh05hQJV
b4nm8CXXuexTqprv2LMjnayg+xVH0rcCKVM8sw0OF7RQc2tWbJBkSYXBPlowqIUqKe0uJqUiK0uo
CtijVCtUq9MEdJNVRNJZgbLEmg5j2W2CTHOSnz4Xec1SmR3iWGqZocieCJmVkV9EMhb5xEJVuR6C
6e+RGXbhuu6Ep4iZBZnrFbg4OgwsLjN7zDWhKsH2orhHBuHBXrBRc/2KpMBHFeiICOC2v8M4WDKc
OqYg0urY2rtR7NkHrDJ+ksUmkz5bJLWAGINA2Ug+/LnRpuNtfzIIYKP0NgWjyizV3FKR7NNigmLX
drUITu7sVQHjhcoMrLJfHbZwW59n6VqWQMW6zwOlmm7dnj18+09jFfnb7mGz3+/eRod/Xjej+5fH
0bfN/eH9bWNNiQJvsQJ/RKa24S5YlX45fabg8YGSksb3ER/5wCXN7GXveg7GCDqePWi/wjtrGlyw
NZoREcSLMkd3QVSWee7GGA4c0Rn0L9w2lUsZRJvBd/0wd2jy08XFRbiBUOutnOp/GYygSoR2fzij
Wsf4LS4SaEFBZ8xKIv1Dzic3Uz9wFQKuBwAlcRDL85Ufm4YqBN9T0TKn9AN4GPcpxRa7sgUvnwf6
Mf8UoN/46ViUkhE/RpKEYsL80p0vaQHakOPpIDweRCd+pyOfEbBzs9XlAFplgSXCa0FXwYleUIQn
1TgMBuaPh6RF23F/dUf1wsuPdmEgjYBzrmNIVwNllxDnwQZrPMRPNraCcNPlXvJqycQcQrm5C9Bi
kfFO1ZHr9Rt9xziKe4VnjIHF4RR361QkM+4mZnztYkCtOLi6FXQdz0GzdQIt2akL52zhUnLwIPMy
1/MJzmtOs/Xt1VHHc6Jq/W6ZAaFZ5e0xEqrVksztVIUh5Y5SB1eX5FzbrMK/MVqGBcvAaUJi7Vm+
hsd2COtC0TzrrKcOwnyTyTzE3PYjGoLuaIKcKLFF+JVKichtaJGbpNPJIWMgRxHyDpTezIOSW0fL
CV35Q5KcYghrYJ/ePvdIFctiIysiQb3xSHEqYeSAg0sPpGPjBdMG3e9ANsiVE+g1xOnVzDuYRS55
BjZqMvNUeAJ1fGLX2iLj4VrHpuAgy6WvYQ5uQ8WSRBJ1e/Ejuqj/6Yyzk8ZKMqSAWpECRRnpgBIs
rCRhmGQEwm/AmVhr19jOLwyCbas5KkrkhE4xlfA3RWcn2O8uHLvWZ3IbcVtt0kumnJ2sOFankwfU
2dsnbAH/g2LNbPhiTbM4XJmMi1EkV6eItw5hZZ0E7ic0dfdmt5dHHx+CK1vQQTOZROeJw7g+ioH7
Kbuiy1XAPCOVQgCsM23UtdEtgxLCrowkfptIxV2EwInF3lkgGLPcSeClX6rLgFcI0Pg6CE3cUk51
F5a//uX20pL1OYSQlhbEAsm0ikvbMefpWlKtRWHBhd4vl85uEUTrWOVK/bEMyiBq7pVpAnq98Fbb
MBMgdotYss72qaWo3SGnbEAdyuz+u3kbPd+/3H/fPG9eDqPd62G7e7HiGG5JNs+rjMwQdtK3QIxJ
VHo1RV6n2d1YpaVa26KUOkGq2XSaTlJnOhrUjpoiIgojW4EiFofbroq1O6+oQc7OHzd/n+8fv46P
aUeEObXmD766fTU0nRdLpJcIvVnapv4I1dmMDoDwyaQYQoQUGJ91l1oqBR12iQsaE9ahJajLFes0
QLeNbv1NnpOJDt0ragZpjbdl/eoBwWr5TwtMqQGLbhhwKRUDgZKx7/yq7n2G6nOYak2QuB1fXFx2
KgmJowHtDVuP3bNeci0V6biBID4dL67uMZgRRMFV7kydjKQzOdxxCurTOvC+k7fNf943Lw//jPYP
90/bl++nnWecSUGsA4OWUrUK45SkbJHQ2I8M2vB4atRkKAxDyaQHbrMhM7aoODhHDBa/thu+Lpx4
tcMNhg377YS3CCtiApXHP18CMGhmAdt9QYaG3u+8l0PLg0SLEH4cUgBv+x+A7c62WhgYtByMXo+J
pce37d91hs3xbGuJA26oLej+mgEUbFkFAnGX59NP8NyEg8SVUc/gd4UzRZyQGLYTrzDoP0EL9hOs
dCD1c+KSOQ2Ep/yqTp3ViVKneDN9VWHyseNgMxkrZqIsBvEUZDCcojqJkujt/f2f92+bx765dQeY
0cgVIxpnpE8xgpVBgG1rJwfMSVG20ha979t2R//imI42h4ff/m1ZfOycLMMnVKGPIf0Rp4HzvP4c
YImpAE/d5yUYGBVWVK5JukWXUtfg0tqGO5wsB50sO8Mg+uQ4KuWHZ8u5pJ1WugSPG4TDhidV7sFv
c19AB9F2FUAOJHJQIJf5YxzwdjnGSPj3ZGvT9cp3pZL82Dy8H+6/Pm1G37b6f7u35/vDfnQ+Is/v
T/cdWY1okeRKHxnZo2ioiJX+2LLBc+qmrUz7xebw393bX44ZLIhqJfcEe/xU8AqA89n9rnIn/ioL
ap1brRKRu19GuVtBvibJMqr0OTted3hzOhPOnRfoKYQElm/VEPqctB5U+8UriJUgHHTutwAVxQtt
qOJKwGQ6noc+PeZVQiN9ASN1hKgmg6L12UK3UKd9DsrCeBbSwUzjDQcEdh4MFFzEJOl0gxe+cxU9
J5RT7s4S5TNBPCTfxR/dXdOuQ+I0lxA6X/qIYzsk4vYZyroAg8zm1Bmybh2lp94YApG8Q6HchJ8u
0UiGKgt9CcJFvMRakHSuQAlUSHNZKcgxXEFESLdsJliHElMI/jv9wrxD1hT46+wof9a9hRaKKPYU
wKWfviRSLRmLPVAKf/ORZYC+Bv/fQ1+AQpYeurkLo53lPpRxbz0F85Ah1Eg9ZJpl4M9Qx9NvPdOI
4sETSzNXgxx6agYZzKAHOdqJHzjgFHrE/3Sp7RBvz942L7sze+R5fC2d2yK8WjgzYAhBY1ijoGdg
hpS8vRw3J8t8IUeHt/uX/evu7aBd4cPuYfc0etrdP46+3j/dvzxovb9/f9W4dfRsqoMAVjHdu063
GqCMA4De1V4Apccjb92xfXvo3W1YWOaipiz7pAz3mPqkLPLTerXFaZci+xQSd0nFHVBOI7p/fX3a
PhiTPvpz8/TaH1qibOXGF1P3S98jWSDbKhpqbar0mULiQ0DnJKwD1NdrJBjAKkaxq4inPU087avi
aV8X63pzyqddxqB+ngaoH2ro6Qcqejqoo23UTFBz16jOXbnjkVR1KL32zLDDtlxXUkb6+pd03BZQ
kXbeHCj6ZE5nWHMk5g6Q0Kx2RU6nHi0xuOUjQeMZcUrXke3ubaOdOvA1D5s3+NRXD9/fjFA6DmBT
v+4pLeaOn+BCVX29b4AhY5alK/Rlp6LQl2DmTaI09qMuVXWu+Dn1dKbMhvoT6nSgcxG6bqnWR657
ZAES29vURkDpZVSRwGiRzlGgAJh06zwi6WQ8CUBU4AACc2+usRYywMB5sEGJitAQJA0VUkl/UgaE
Z9XsFC8E20jMwE/CGZKSJusPuKAPZokHuWKJ+TDHx3UUSVDWbSZX3n0srCvgHqb6mtggSyvbH07P
TzGCKc9laEVy/aBAH3noK8gf8BRFtFZEfshV303+iGug4yemofmsuWIcXP+GQX7A4NhAD56SjNuh
rIclI8VMpcMsH05Kbp9gePEPJqwJrQfrMAbNMby+itK1jMlimGeu1JqTQZ67kik0yCEIyvJBjo5S
9jAopMiHHMYn+oBL6LvjQyw/sZPMu54hhnIyHpY2JNNWVhoX8/efMOyO9eCLK+cuhWMf9PlZfcTp
jyiAu6MNayLlXdVe0+tuUw4u3Yz4QcUCpQTBjtqxMYILP4DSQCsq8wNs6ZwpOXXFsXDFuEYb56pD
bRSqIH/o5KkfdIyEg5Rdf6lAqvsNEkGcm+5ODTmSsDQCxSTYsyax64dB3HQOzw9KlJNed2SRc31h
m+Ie5HemNNL1GDSt69FomvIxepwp0xr38PY8KNNlyvtrXcyy0Jx5hLNBPBLYlumL2tG1KSVITr8P
Ai27JCQCWwoAvwACcBpMox3+ngb1w+hf9vOif4fVhROPTr0qYBrSAVNrO6sAAJFYqEwinDSaDaVZ
qLruhp7aimgxTQmKgwyu+rCAPASQkk6velh/haZhNTAdVB9Tv5DahTxzUUtUfQ71tn38vvkJO9GG
j0lFou5SNhgAOlVc2kbVglRv4A7o6DQLubkYVxMvgnJmm10bEdxLp35yx8OyENdzsoCeE2NhUvmb
WWT2xRC3u4LwbO0F49DE6L5Vfqivze3uhSp0JM+il13L5HrOdU4b9zLYDSNE6fOFufBhBE6TRhjT
eP+TGqetRpcZdzKcJ2Ao03nkmvQ7pxKBzQlvoOLJz1UMCozpW2nWGOf14/H0/qE5SuvVP1Bz47ta
p4wK+KNZlctZ4BiyYWDRH7hQYZ4UgoXw1eUTi0zRpe++35Ehj6+tIwn9+vPZ/vKdW2iyvgIpbycO
rTF98nTf0ZDrx2zj62uHKjP9ErvGLhzEnBvf3lx+dqvR0nthvzADWvB2krJiCviArtk6o6XohysU
2/fpNJI5WRJNyTlDLiUS4+nNlY8Gy35MzDl78MSsFYjWh5d37lkHhh3oGUxm57Lho7N7/O8j9EXx
wK3u8bWXniHuf/hH4E/iF8UlDKROUgdOJ9vnqGbf3L1v3jewic6bZ2/do2nNXeHozj271MRURR5i
InGf6ix9S+SCsj5VCA/NSVo2RJl4+qTIXeahRkmfOPPWGsteQG/o8CfxjAFiU0FM8Fkroaf7/X77
rTl2cOcRZ25KWhN6TnxDVpgWMVn1AbOuVwF6v/pk2Wd1Qt2GYG6N2b9tUVN7ufG6Lbngnh4AdeqS
iXHU3ArIMfjHc+uhvAXhnPuqqUyay4t0g/eWnpNOnqMFFFmp/giQk/DWR+Q606yzN51mNX2GbA9g
huqkdNSvIKeiJ2iaDk57n+jGnm0XSEw9ZElzx4y1w6h7HNj6moHaV/daQU6oObWyb6GMDpv9oWNe
NTu4ZzPivzaWohziYMoCd91j/zWfyHsVFlzplTCW76Q/G1rQxIjVHFlzrW+CiOYFsxnFcvu2edrs
nWuHOJlpte9/77ak+ncjpHmBHngJgMOlKSEkjIpkTjP/7To9zZ957/ZQvPl7+7AZxce7k6ffsNg+
NOQR614cKutX5nXCtDI3XM7O91+3L+d/7g6vT+/frd8CgH0JcX7GvO+MwZE2NSVU5Euk7664D3aT
ZaWffpsoxLKgsFRVLOgi8Pq0YSALUKShn0GoUogHxIJK5rNpOmgGh5wJ+8VXex/duSOXq9j73ke4
ydeGUNl+V0uT4EejzMfb7qE+IEvtfTPnNl2DzgJvG1scrW5uPn2ehntdXY5vrvqtFkxV9o+G8MJ5
RwKf/U3Uvv029xLsm2cFd58NNO/mnUtxzVP6JA4Nh8Z+t1iXxPyuCimHBsYUduEAj248Rvjz9GKQ
pew8XusxYLY0By/eZz0tU6Z/BuC5S8VizRVrsF7FRRQPNixXN8M9jwZhgXyP8nAsWK41No4XlmJ0
yPonTxIdIdz44aV58ur8jJBCFYP9XBGVet8fSq2iF2CGnN1Ho7xC0j/9PEWFYn6MEK7783mCV/4L
33JGK8qw7+eZFE3y+vc+nh3Sp9Xq0jEtspTa21bMfyMpKf+gSpZDLLmkQ7BkxXoIVykt5vrBr95r
vsjVyS+b33ZaVemSJtbjuOPvXsTHVCR/2tzvN1AR2I3dw7t+A2Wc0/Pt4+a3w4+DvgJr7secb1++
7Ua7l5HeqOZ6vmMmraorCQIwKIxpXHW2e7+WmMq5MyBNqI/CzG0Rz695QDQW97cd1a86nHTRCUgy
xvnaC0ksqRdodN1JbPW9l/rnjLDK/CtTG5zk6Gjo0T/8uX0FrvZG1/nX9+/ftj/sn9DQBZtX6D6N
wTOk9FuOgXnEeTy9uuhPVU2vSJF28gTWOGuTUAsJpnaX9/1baHY5bJmC+ltnNMAfqO+A2xOnMfgv
gs3FROyNSNuaWZJEDAlPX09T1C3CFZ2OL/uA+GKeNfpWV19Ld0bQYojg6Xi16hdCGb28Xk3sFVrG
uCUPjAjl8acrb42K0pXPgOhV8/ArQZOMeAC8vhnj6eeJB5HX1+MLP30Sol/36SlXE7tL9bf5wTLn
BwFt/um0X88f5gV60Qckvhz7lorDFHkWUN2MLycBuoe/kP/P2JU1uY0j6b+it5mO6JkRqYvajX6A
SEpCi5cJUodfGNUutV3bdTiqyrvtf7+ZACkBJBKqBx/KLwGCII5EIo9gMfUs71VEoT+Gz43+8Jow
11FXdalbZA9KZfHB8ir7w05YyJynbBPbAOh029uIJFyOY1s3VmXqLy29tecMRsJRDrbBOlKFwTwc
j4kzCqxBzLnGqEljTHnlTpKvRJ7E0uSRVzZhcBsNxEtcdUf36hwzWGRKxmH7q6pS60VzmcZfZiRK
Sak2VY+nM4Yy+XqrtGxM2woV6uif9w9vf/06er/7fv51FEb/Arnjl+EiKHRRalsqWjWk5UKnXkqX
NhoaZkf6EeZS8cbysHDb7e/i5ems9+rb6J/nf3/9NzR+9D8//jr/8fL3L5dXfPrx+P7w/fE8SupM
24Zk16iNF4Bel6E7HxwKdbM9SU/yzUZF9dOpImQZyFKnLOwBB8YriV7ajU2uOnPofmsEetoOB0Kz
Di9kTa+uABgECrSq1oGHy79t1QomSHrCV4LZC/SH4ZVdHa76cFkQrUfkZvOT/JDAkTYxPark8CfM
6LvRNTk0sDQc5fwiriagFuBaAhfNwEiXKwWz0P0AxsOF+wGKAddkN9PyRi3LqYshKqqG+7mjBrxe
ESfh4CjDVJRE6KYNkwsZ7BGUnuzCo9zs3DyCORoC+y2nDhyIg+QFM5Xww2hX0+PEW3oRNexipmtR
LyQQiTebOGp64UavOC6/GO0OztIsi4SNBU8wUI34zZv3p3Nd1SBQKjdHuu2bqNrSKC8cHYd7Fs+d
OKNCbai9pGCO0mlKg6KKHaNTnNLZJAxgGviuVytp8JP84qgYGruYGCyablyuLjRLUrgqiMLJcva3
Gx9XNJ6JwhrmWBWWy+tTf3nV7/6YcbyH0ZapnSzqLWIaR//kJyRxGxJ9gCjIfERlrQBrsqd7uqrM
jhV41gCRhy74SVR5ScOoPOEidrzDceoAeeIEfWdZQYN14uhWkGddYBUL1wvB3A09OMxZtabdd37S
tZNIJNqjwDRygCWl01GwPO3ReHtWL0J+g+fowOVxz41PbuGzG/jcgZ8KvAelGeI1K4mJYtGAyCLq
KElXifji6MaPfnaDYULj6lB5A3eUb8+8NEN7rqcZUlaCwJdQ4zg1D8mSBrJTf+WRdDgQhTFx3aQY
5FF5fIvBMUhQHeNGqWVMMuBCR0l+kgGvFimpTDFItQ+NK12DA4+hu0sZs9HZTH/suwYerIrzwPUY
7qieWvkkeODZKs8cXeRQGaYWzVqqHWTTCEU2jDikk1ACHQ8o3pAyZJrO5gPaDOO3bVFb+1NDrq73
2qgFuvTUPTlUE1FqXDXSgboAkrcz1wYBRWSskNGLdSLe1+thooD0OdbdzJFHa6+F2sRpSCBlxMJe
k6/gtrC3XCWU0Cusu1Bb2v2E6EWiU3roOI5H3mQ5Hf1z/fB6xvvvXzS9y7U4L2O86yavsWUdFtW3
rzvg+3mThPLuka9PTZ414RbdD3QPTWCJj3DQjVhR6ZGqEGgDnTwNaSpqZW7En0cUQ/YZ7CoouEEy
FUhIkUH/n4w7fJ5h5K72mlrYjSeuN1oDmvqIvaMQX2v2UVGdpvo9RC7TZWjzg4WmCWv8qQaJ5LNu
0lvVGr6PzekiDTlW5PrHCxKCs6zdxq3YnpT1phwpGF8ZKJ3y7hrA6fIGcq/CUtprM+gfvEvUiZ9E
nHKTlMCYMAghD2GMmLRW7jOJIhWhSVERNfoP5WGR1MKkrfkRTqgWErxr442bdaQFU9ERF0RiLIUp
612XPZ5jgIAV67k34aUq5hjR1M9QWv/UsH4WpzSmInrWMOXsp88QHTwzTpqcKBVkMwmJi1gV5SPh
dmF2W1DnZbz4zeIDml+FzWcqULfBVW4+xFax7W0m/GtKGEQNYkEBkUoHlEaB53n9S+8rrtY0GQhz
Ta2lq6n9vCRjdUVU1fIGnOrdmALWMEQyu5ySsQonIfGV/R15GglgIyC0jQhVOaFS4WJJNb+Awxql
aKnhuJ4RwfWqXvD/yyoBgqBMFfE0IDVpyjUTnSs960WqEuHSH088chYUmLWgomAUTcjlVsPtDNUw
mFpntzaCV9a37QMaLcPJy2HA1pk1e4NKa7G6mPqx+7vv7714fIDDilHZVTwI7tiBGrAIFxi8hQiW
iXhZJYFHRKxFHP44TJwJA+vUtodfZ0QU2Yf1lhcFcXahlruiINSuVAEcN5TCDEViwlwbL2DyxDRB
bWlNdMpYqscpB8xMS9MS0L+9MK0+JRmDe5bwHzPgBRcRcWrd9iwDlZD5/P3HO3mpx7Oi1oNb4c9m
vcZ4vUms++0qBJulvJzVIH07vz5iApKHZxiff959MewnZIk0r0WszNGs9KYQrD6SqAjLOM6a42/e
2J+6eU6/LeaB1k2S6ff8BCw22VjC8b5nKdeRbcZ3qicHZp5GyV186tlJdBQY/ruVEQ7ygsBCuiPs
zy48ya7H0mc4yuqfLEVhq60IRce1CVV+YAd2IntK9raeIkimLRC+hdSwpBA2Omq+4d+isIECZktR
8dBekq8xqv7OhkmPTJlBxTAmveJ5HW531oyUiqlvNKqoIMYlsSxrnEYkthfH45ERqQG6cYfe8zsH
i/QlrFwM+HA1uB1c1kiG27vX+/+7ez2P+H/yUf8Kt7V21X82PBhP/T4R/jZNbxU5rAI/XOg6BUUv
WKmGoEkN8Zv3qXB0MQaPoir3zGueEJbKoJnD0MXf7l7vvqDPZnutfn27vbaa7WXED7k+X2NzH4Y0
4LuSMUJkZN6dy/Gh31AYgYfzFD4D5VZWSlGk/xLXwqcwYRFhWh3xDY8LIvpmmh+ZSiuSEBdlkgMd
ZqoPMOAiYR9k1B3TKQvxEtEJUlmQWrjZ2CZl1myjxFABiCIO4Qtw4l7OTi7Nt76a0CdRub/YmJxf
H+4eh8fl9pMH/mw8GAdIHI4hOEk2MSuTE/xujIQMejHDts0AssIOZGVTM+ndZ0NLzN6Yxi3L1MYS
Hys4OOpWhjqasuzUug9acavpoM4ApyLMgAEc1hwJWlMFu7iwvDz/C2nAKrtfmr8MRJO2sJkOUCNq
36Dfst+FTceK4VeXQVNUJ+1l1R0/SVTp/36bT430haYTRVJ0TbGpaQojKgwvUt5sYRVJTD94VLmw
jA/C9GtIG2zFhJSKS8sZY9ZpKNeQcEmG3Hs2horO15ojHiyIJTQzT42lU5HUumMoPS4QdRd35ZBJ
qm7w9PTs3cqwL5mhUy6J888GxEEKKyfLuf2Ujzs+p7QraCBOHELSA9sT+ZDCYDGZ/91sCmIJzkRI
g+raj8Zht7S47mh5n4zcJJgHCvqEmKkSNqMVo3ZYpqRqEw9o/V6F8KewdxSMjJBI/gyD1cyHzX09
5qQfNlIY7cVoBHKIWY+vxw4gjdjj15fXh/dvT7oI7ocypfTKiFTYEotwbSMyvdKL2IRByi2KeFWM
e9Rt7AWfT9z40YGn0WI2d8Go57Jq+0MU4zzzLXmgC2pIwQtII9YREl3h6BHPccUVJNw6Nt3CQezb
bB1cZS7Ynm1ikkPBUxrnKWxHjnDlDQtXjtIw45YzFz4n7ulbeDk/knDFcgHLe0qXr2q6bTI9LCqF
KAbqarLFoG9pOM+jPJ8MxOz04e3L+REO+OcXmA84QcJvD99tE0PEsP+VoomEN5nYczroLAv7FwRo
HvjO0srbyMkCEz2YEU+48rDlbLK8Xc/Sc/Kk7DgPFjMnTyUSfzajh41yscT5dYMFF6wbLKta3HrO
lg9dV0XBLfKX7lQousQ2JillQguoitWkd29tLJ3315fHR/jvQFOCBa93K5qUrzINgSCTnIh0aLxJ
0sW4SRL7O3TukW0res9kla/5GiAF/qhtxXhElcRz/2j/YAfbyiulJ5m/QUayuW7/Gn14+a3ZkDHF
ar+TUCmZYHL4i7k1Tdgh1V035E/MzmS8VjsWGfR7vanL2jliL1wTN1u0mHrBDZbUG/veB3hmH+CZ
f4BneZtncrM9S386vsFTLaYLN88uqGLqANxVI++E3SzVsfBuLahz3xqxpmXgM4y3u9JVMApYL7xg
PFvbgcBfb2zIbLKYCdvYWmPkktLZVGApiEQuei3EEaJj2SQzLxDpLR5/fIMHl9ybn4iv0oIyCO5Y
qmDh6P4knU+GHYnrmJU6s1IXVmpgowbWegNrGwLr0wLr05bWepe+lWp5GuyV3txbWoH5fGapXR2f
CGDqL2yj0CXDXWZMGnuLG2IKWi5MF6n3Iaal/wG21WTpfmS1TcOZezUAQW4ezJmbp/Ko+8YrS+Df
WAUPwWQReNFNnuVHePwP8ExusSSLYFaJW1xzf7Fdf4ApvsG1jVjhfpi8IBBpSKgycBe2i1zaRalS
xgxlmZfnhy9vI/Hw+PDl5Xm0uvvy13cUwzV5Bq9wr4knr40zTwhKjEfHsj9/PH+R0eYGFkJXPcYa
c2DOxp69hqfz/cOdpnC/puvFTJBN75rtKtTvV7RwG7Fhczevd9+/4esPJFK2MWI3wM++XbiOVHzA
TGwsLTafElUN1F1IzOC1iSMXwpQZqcRoI1aE945qbZnnu74sTXtLzDQRre1bF4Kl5wf2atCWN5Yy
pVEAVQlkbTyYjIna+FL6+Brs6YaRVVFdhxjVN7LcQHfQDdAN60W8VkM2ryu8QWuv2TUzs5Wu12/D
6cQR16PprJooCvUiTQh/1jxJzCxxLYBp36EWNgCk9/EqMV10W6yUntbHWIaFajDClt1uYiWj8HTP
dvF0zXDxXFrkfFhuTW6O3RKvYwyq1ZghdbAcfIeEr6hqUxZiZAmi2pVMu7rZml0rE5eo2EnCACqe
yHeolMpcLizr17un8+iPH3/+CafSb52qz7IQYvfzsiTO0oAWqU9B4WkVlz5lPQQMrAxJSPCEs4zs
eJ6KqrJ3D3StNzeGY72PBTMokqB3UrzmvU+0jcN6RY6O7YYeOF7kTSj3UcAdqyUOdL4nMXLVASyJ
4fyyCOxdMli1Oxpph35hQL30z97ghCXiaC9zWS37pLaeAVkfy0Y3KJjWFOAYqU69dbuHkl9oQiK0
zhVRTk6DLM5hreDkeN6dCKUjYBNqa8KBKvWRHglXwdyfOCZgQg6mCgNd0ROMlTt6ypNPpC+0sLG8
rGpmcxK6jIImCaMu+6d2BwlEmfSlveMzbhwBS6r9ZDb+tHfWbFSgx4C4cuTlhjvrKMp8oxxPVJi7
hzeQRX+SFmURF0XCTpcX6hWzrLttMqbnt5dHIHfVq3h5g+phobMYcGwYXruLfI1hDNBkDpt/C4eh
/TnWrnaVUCDixNjApW+A5b6/ZGmsYnN9COwuyosS9tfy5OYt86rLHq/ZIGeVdW8EehP8HWg1Kgrs
B9fBlG9y8xe6E9VH2EAzO6A2FBsSJnXl+9OL0vflx/O9djDJ6yzqPjq7/9+75y/n+1Hy8Pzjb8U6
Yq9fvj28n7+8/3jVDzSZbjmURZdLR41UhKlJ2B6iuDBJJTuksNWYRBF/quMs7NcnMJO36fqBZDhW
xWmtmWkiMQU5rERo0CSS2GCiW5UH2NYWWc6AWoNReFaWl/1iajpJXxtmaOYBbDOgSt+ZtaAw2Nt2
vQe2Gv3r8bEjtsPVfgBuX/FY1hkRp7CLejkwz5JdWdTTsSdtVsx+Y+FyAXMgikOTbvlGsKwOP3Na
FWzfJwk9D4H6ANJGpPbmM0PpdGlZ72NCr6cs8+Wd6SUel+UYLN8g8oJgSfYaS8SE0vcqeDp24nw2
nXk0TvsyX2EpM6c0Ux1QAlcH+2544oA/V5MJIb0gvqoCwnUT0ZCNvfGchlNO+UVIWEz9wHPB86Pj
2bSL9gWesZqKritHMSsT5ug7WCpcMOypzuKq+qm7+umN6mkcNgpGg5zG4nCbTzYkjMaWm/wGzG8x
RL/Tz09rb7zzbuH0p48zvLEe38AdDxDechI44TkNr9NgbL3cwe0vYpdTTo+sdsaffbJcXGUGsSre
UTDLGGYOIFDBN3AYihMK33NGVlzxbZRyCsag+UemW7/18DSO6MoFn4xn0yHaBTDo7XLb7tIVjz8x
2f3bSBROkF5JQeT2Fp7vxv0p8W3ldw2OvQ2qoxqaPgR2IMZ7vuNpKYsFHGEnjjl8ZCW94WepP5s7
xIHjtiTRkmN0AbqTyzSe+C50OXejM7q0yDMe7vmKCl+NkqbjUKhkDRb4jr2hxW9srPuj79PNPKVr
1+YlJSP7cL0YP1xFkosDGSGloP+We69SHl5H/+TkCBlnn4Zt+fn2fn7CWLXSWujux/3Di9VmSH6d
0HL5EY6YXkgGwRU/vp9ft93L5d/Pz+1xQj3OqBiPIPKgZVMGy640XNO33HL83poGFMhD62UAhXOH
1YdPdxrSw75D96lHmITOzeqAUrvu74INWK/N34WukUbnGhDZtwZXAcvpNi6TvDRLV9uyFpWy3jEA
jKYgXbF1Yts25Sp1eTOgjFYv8L4XqxuLKlV6IhK+TYhJfxqbrTZgg28ix22pEj422zAikHyrW9kb
UNyH9G+MnPbjjGkIhy//MojjLwujnmVthNW+0pUyhuwJ8/BHsolaFHEWOfw6S8FFReJ5tbGO0+3L
27vTagsLY/fJjn8aUAVme264yM2el1iZ51WzrVdNVVnQCpMsHrq0NxrKReF58+Pwgfm1Gea7IX2F
XssgFDI8mwraP7bPjM7HxECUrHiZkMQtt9nQmmhP7U18pFPjOwk8z1auDNh8PoNlqlf28rFaH0SZ
0GbovCJHvK4qkePi4regXDDyKv6vkWxFlZeo/j0/3/3xeH6ToT9/HaFT5z9U4NKHt7+6lfgf3fr7
dPdzdPf49jL64zx6Pp/vz/f/LYOY6xVuz4/f5dL9hHnWMX7561Mv847G3u+Dlkzq6g0eVrE1W5kf
pQPXZRyHuhuDDnIRYXxjKxahusmKwP9ZZYdEFJXjJY3NZnbs9zpV0W6sKEtgu2Z2bMdKGXHX6L0E
g3r31M7XLenp7uvD89ehckYuyFEY6BGfJQ0jZeGBwaRK/eSlVrlTW8diLcRCRru+8LZuV7DcAPe7
Tc0r37Dnl3mlaUL9EGO8DNG10loQQCkY2MFyN/H0azQNW8XJjmeDUdq6I20nU48apIrlsIXdeRvr
KYQ0FF39YM6GcRKbHpf6Qwrf05VTOqQCvDVpYIXjtIg3VmRdRegklNvBOkONuRWT2V6sCC/YJztg
54+jDf3OHdhU3D4OYPDzjGjHwUrfxSdRYGAGPWPuEHeWTYvSOvQ6vBbMD25zHD/Awj7As7rF4y1v
ctxujLc83Gb59BEefotnevtRwJLY5/8uEfbBsstXPME8jlY0Daum9vVkZTqYi8XCH5NYMLVjGdun
xFgqEn8ynhALSl7xeTAL3EvKttBj/2uAYOuYBOBMEEV9UavDeVzCQaZNq2WtgpiI0uzhdxburOgR
luQ8tUIYeDC391CeZphh1b5gmiFmpTD5GeV5bUcypXbr1hSnfN774kDye1sAi+qq7nU1q0HQPrCk
J5qWPJ/1t88k3uQVnuh65L5YCz1YnqSv2ybu19Bj7Rb88LQIdetiheGRry/+bTGhZmUl7ridnkKr
y4FxlMaAERl7WwePVKAIgyh3mTjpTwRpQNleF/c+Modjzmq/YQQZVYXmAO5/h6rEyER7vipZ1d+o
eH5gJXyosj/5qlhUdnlbJCDF3p+f7IKKkUBTNrSI46iLHaF/miMLy9qk1THbJPGgiqMUMlNdatrc
3X89v6MmpK9KwQIbhp/EFuQiNePppaFDk4EobPu4TsAAq9Ohqgk4/iOiUXj3ej88JGLxXpS/C6lZ
5XVmmiEIDLNWM0uEh/YpN0+lWLuI8FRvPBBkw3zbvrlGPqz05BBIkemmhJEB8oDTzXAGj4Q6u3cf
Ayh98wUkVa8PX78arZNFq5JvNoZ9mk7u33MbGCbzkJmY7EVBnCyrlZIptagga57xFSN0BHHEQltu
xqpLBq0RjJeW/tSWMD/Spzir1mgW+P+NXVmP2zgM/iuDvi/aOJfzsA+yLScan7XkJO2LMW2nbbDT
mWIOLPrvl5TtWGeyD0Hgj7Tug6ZEUj17PuPSoaMNaz6BVLRrGe30A3gkJ81eTlDVXhfLZK3rIzMa
Gn5Y6zUa8fXCia/WgY2jecJGXdNHQsOX8dz1BuP5LPgQ2oQjwEsblpaG6jKuEUIHoVjMhLTzUE3h
FUp3SIRTSXyxxWSFFqGvCYIpatndK37NX04tBsHIVUJo5+XSfQ4xsnCRzdaChBeZIJ31IrjIUixC
Ea6usiw3F1n28w/6uatshKfHv+K6dTdBUpDJH2l//akgthJ4uGxYEYFBcxQXsqSj5Rad5Clvxw+n
+0fVj48MPq8G20li3at+exw2V2fthotp7LO8aWRvey9Qo98w1dGFkLLdad+K6AyIpeOwSE/Pv+TV
LmuVpkmiRx3N866J3EaISZxEhDt97TJ2Doydnh7ub16k6l/N5ygCjCD0ywC6I8ZumVpqhOuKsyN8
d+c2idO4bZj4pG5X59SYyxcwUOdm5nN35nN/5nMj84mykBE89fQHzJHFSHHnMlLtjG5VD07wYFr9
AhRoDIHJAckWUR+VUp39lIG4mKKBn7Pbby3SlJxahykouz+tbcoDHw0vSHmJBeycRx+xqQpfGVnv
VFn1Ytd7WQZRWOmWj22lRiWSj2MsLMWFi+rxFLW2AyMIrfA95NKFfkwL0e0V1VAPKP0kU9AcNCdm
kTFonKyfEqZDQgsNS9H/mQoMqrihe3qpVIbmep/sEzlPrWnKeLVZrT50qrhwW+VM9ar7GZhUepuk
Wrb4XObT+lrx9ykR70vhzhJo2usFhzc0ZG+y4HNCpZdzecWgRi31Yr520VmFn20cKvDu9PIUhsvN
X7N354VajO06+X1ByKfalsTmcA7/+HL/9u3p5rurWlPINBXIdJ9JEtsXDhBENm1QGCKcKGrr0bWg
7Fr48sgjlXeAOtlof5RY0PA3tobjaE2vpOK81z/ZSeqnUelW3kfd+V8EUn8K6iZH1P9qdKE4flLc
kMJD2l9Y6Xa1n/axPC78VOjqvY/W+tY5WKvQdA1NjSgkIGihOlw3Vg983s91+n6ujxyJLfTnhKEV
k+qiENBESzeBxc1KKDFzS1zZJWZ+CQZoU4/R40zJTD5qr9AjKqTNikI2yo13hdBHq1amWFs2auTy
/rnbct2mvkfRFeHcdUMIiLB141td1kTqJ8VE4HVWaPpFXkTubo2ZWh18Qj95qku4CQsM8EBJ1tUH
PF3fGSRDKJGYXD0094lsXAkDT8mwxSme2ZSC5EZybR2TXBMLyrj2zrEqIf5VxBzy/dp79/x6kmaz
4s9vVXSv0WsiCs59OLo+iu+UGqy15cTjFkR4eoWDFGxLrvEI0rArPOhl3cmh7YVnDs1OBKYHKiBy
EtH8gsjE2+hyGXiVQ0FhTISrK6VFL33S4NKZ7zgtk8Jd4NwVZkQLRX4l91w0UJ8rlWmvda48lL3C
Q9NrhcE1ehVe7LteBJoeRonk73dvr9/DdypllGE6kGGUNUqlrP0U1S+FRgnVS/QGJfBS/Kn5ShCu
vPmsZl6KtwSqusWgLLwUb6nVaMAGZeOhbOa+dzbeFt3MffXZLHz5hGujPiBYo4DahZ4XZoE3fyAZ
TU14zJg7/ZkbDtzw3A17yr50wys3vHbDG0+5PUWZecoyMwqTVSzsGgfW6lgrUqULkly33s/94ZJY
yUXTyv1wWP4mmR4kM81JaNVj2kdlBpjvPmxBmszwzy83wuz++fH+4ebn3dd/To8/pn0QnW9L/7Bp
TrbcvrLXWx1JJbemSSnxhob8pIVq1iDwEUE9CuuetWg5fIahO0rXDoZWqLhc6n5q2xI9xGPMzqjK
nSolaeqkX9jbUZJQ9A7kyat/J8MgMJrg0eN8Z/jXVOjS/g9vVKBQ2dbO6Jk7mtjRiQE05DF5aGAK
aUMJcvUm1IR1OUhqdoGh7WlRC0+RkaMR0PiCHj0jZiRL5bzH/9NQipqVpmdQg+VSRj2HPEkCma9y
3+yDob2nkslQlUwSAiaALfc/SgoNR2l9pTSQEVrkoeFoim1wqfRZFd36zOp6jh3b7gpaeAce/AaL
PrOTB7epRnoef5ND8X03RYdm8Fiho8VqJz3ue/q7j5cDJYLFyNcPEV4KHZYHGUPNPbrithOwomC8
YfN4dsqu18GUt/K70SNLkQLd9bj0tui1ezKPNNtAkDiDMdWkeXW41FbIhxdTttTxFfHj/ubu4eEJ
DSK/vP1AhtPj16dfv+9eT18e7m/+Pb3+vOFP31+l+py/vfy+f/yGN+hP83ClHCv087FKtODmi0zm
rSwEKGSnDK/XF/UYt00jFnWN2iplBFUtLLK95Hh2jf717fn0+se+6oy3cLT4Fvy8lqDySaPaCuYR
GZUJuvtundYd08bnw23gjElNItj0BPNZeIycMD/RftkxAo5V0x9Rq7pPdFLfOx83MJidcf3JRI/q
LQOpdlIUGP0zOvDUTHdHOMqzmNU7aqXQEdiMLNDPbnyE92BBShiUjYXv4LvQAo9xFFvJlm2eW2CR
LBzY0kqR78jMYgQwUANQTvByFljwoXahYtvMNja8TWdBiKfHJoHGkYW5alu7wLw5WNhRcDtB/LO7
LKE2a2rEvDz3bnVIGdeijow1PlRIcelJNIZR6fTLQ16GjqanTY2e5+0RyF2YM42YcLF0ojavoMRO
t4ntMZXtyGfHJCBlGzHuqAZ1tT5Ip6r7p3G4snhHaI7/jo6M54EDhq0vzxlx1Ic7Gq8VO1raqewO
1jSRoZBIot+dsWnO/lDpMIWcdOmk5HyB5fTl+e75z83z09vr6VHVa0VMNBQjdKla+wYWwpgJrX7x
TOvTuGMCdmoNmgeaoq+JXV4ycxaZTY2macK+4v0ZWFHIkV2po1YHgxQpOEWzH0VmPmNdVtQu3i4q
nHDKFbxGoUn1kg9fgpUW8KOHDHMywofD+v8AVE20V5fbAAA=


--=-/sjjcPgvjnY7h/vZ7i8p--

