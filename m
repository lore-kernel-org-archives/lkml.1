Return-Path: <linux-kernel-owner+w=401wt.eu-S1762528AbXKIMRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528AbXKIMRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbXKIMRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:17:01 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:6610 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbXKIMQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:16:57 -0500
Subject: Re: Module init call vs symbols exporting race?
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <1194608640.9377.104.camel@perihelion>
References: <473031FA.2060707@openvz.org>
	 <200711062341.34566.rusty@rustcorp.com.au>
	 <1194429690.6874.7.camel@localhost.localdomain>
	 <200711081310.07697.rusty@rustcorp.com.au>
	 <1194608640.9377.104.camel@perihelion>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 12:16:47 +0000
Message-Id: <1194610607.5000.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-09 at 06:44 -0500, Jon Masters wrote:
> On Thu, 2007-11-08 at 13:10 +1100, Rusty Russell wrote:
> > On Wednesday 07 November 2007 21:01:30 Jan Glauber wrote:
> > > Hi Rusty,
> > >
> > > I've seen a symbol-resolving race on s390. The qeth module uses symbols
> > > from qdio and although the loading order seems correct and the qdio
> > > symbols should be available the following error appears:
> > >
> > > qdio: loading QDIO base support version 2
> > > qeth: Unknown symbol qdio_synchronize
> > 
> > Looks like qdio does something which triggers qeth to load, but of course qdio 
> > isn't finished initializing yet so its symbols aren't available.
> > 
> > It's not obvious what's triggering the load, but you could probably find it by 
> > using printk's through qdio.c's init_QDIO().
> 
> Jan - did you get anything?

I still think this is a bug in the module loader since qdio does not
depent on qeth, qdio can be modprobe'd without automatically loading
qeth. Adding a printk to the end of init_QDIO() inidicates that
qeth_init() runs _after_ init_QDIO() is finished.

Here is the debug output if DEBUGP is enabled in module.c:

d to find symbol journal_get_write_access
Failed to find symbol journal_unlock_updates
Failed to find symbol journal_lock_updates
Failed to find symbol journal_stop
Failed to find symbol journal_extend
Failed to find symbol journal_restart
Failed to find symbol journal_start
load_module: umod=0000020000000010, len=265456, uargs=00000000800905a0
Core section allocation order:
	.text
	.fixup
	.exit.text
	.rodata
	.rodata.str1.2
	__ex_table
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel.ro
	.data.rel
	.data.rel.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x208953a8 .text
	0x208ae0a8 .fixup
	0x208ae0f0 .exit.text
	0x20815000 .init.text
	0x208ae130 .rodata
	0x208af2e8 .rodata.str1.2
	0x208b1ed0 __ex_table
	0x208b1f40 __versions
	0x208b57c0 .eh_frame
	0x208c00cc .data
	0x208c00d0 .data.rel.ro
	0x208c0428 .data.rel
	0x208c0970 .data.rel.local
	0x208c0e00 .gnu.linkonce.this_module
	0x208c5100 .bss
	0x208b7bd0 .symtab
	0x208bd558 .strtab
ext3 does not use jbd!
Allocating new usage for ext3.
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
Absolute symbol: 0x00000000
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
ext3 uses jbd!
load_module: umod=0000020000000010, len=148432, uargs=00000000800905a0
Core section allocation order:
	.text
	.fixup
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__ex_table
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	__ksymtab_gpl
	__kcrctab_gpl
	__ksymtab
	__kcrctab
	.data.rel.local
	__param
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20857bf8 .text
	0x20834000 .init.text
	0x20861674 .fixup
	0x20861688 .rodata
	0x20861aa8 .rodata.str1.2
	0x208632d4 __ksymtab_strings
	0x208635a0 __ex_table
	0x208635c0 __versions
	0x20865400 .eh_frame
	0x2086c880 .data
	0x2086c898 .data.rel
	0x2086cc50 __ksymtab_gpl
	0x2086ccd0 __kcrctab_gpl
	0x2086cd10 __ksymtab
	0x2086ced0 __kcrctab
	0x2086cfb0 .data.rel.local
	0x2086d0c8 __param
	0x2086d200 .gnu.linkonce.this_module
	0x20871500 .bss
	0x20866520 .symtab
	0x2086a3c0 .strtab
Absolute symbol: 0xa41f2c85
Absolute symbol: 0xe017e932
Absolute symbol: 0x4d39fcd0
Absolute symbol: 0x465cbbc1
Absolute symbol: 0xac264695
Absolute symbol: 0x562104ab
Absolute symbol: 0x7e2b2dab
Absolute symbol: 0x7650a5e7
Absolute symbol: 0x0302fb41
Absolute symbol: 0x183b6fd5
Absolute symbol: 0x14b3253d
Absolute symbol: 0x65b24f18
Absolute symbol: 0x19227556
Absolute symbol: 0xbaf2ec41
Absolute symbol: 0xa23b78d5
Absolute symbol: 0x35d71fbb
Absolute symbol: 0x473db3fe
Absolute symbol: 0x6f6178e2
Absolute symbol: 0xcda6f922
Absolute symbol: 0x4f84f57b
Absolute symbol: 0xc9cb549d
Absolute symbol: 0xc7bdf715
Absolute symbol: 0x6d249c2b
Absolute symbol: 0x1d8a733c
Absolute symbol: 0xe0e87cbe
Absolute symbol: 0xd95a68c0
Absolute symbol: 0x12d2595d
Absolute symbol: 0x0066eddc
Absolute symbol: 0x55f1b0de
Absolute symbol: 0xd3c8352f
Absolute symbol: 0x00000000
Absolute symbol: 0x4d8b1094
Absolute symbol: 0xe1be85a3
Absolute symbol: 0x2bf1fdb5
Absolute symbol: 0x9cbe3009
Absolute symbol: 0x10966c62
Absolute symbol: 0xed1cf670
Failed to find symbol dasd_term_IO
Failed to find symbol dasd_start_IO
Failed to find symbol dasd_smalloc_request
Failed to find symbol dasd_sleep_on_interruptible
Failed to find symbol dasd_sleep_on_immediatly
Failed to find symbol dasd_sleep_on
Failed to find symbol dasd_sfree_request
Failed to find symbol dasd_set_timer
Failed to find symbol dasd_set_target_state
Failed to find symbol dasd_schedule_bh
Failed to find symbol dasd_kmalloc_request
Failed to find symbol dasd_kick_device
Failed to find symbol dasd_kfree_request
Failed to find symbol dasd_int_handler
Failed to find symbol dasd_enable_device
Failed to find symbol dasd_clear_timer
Failed to find symbol dasd_cancel_req
Failed to find symbol dasd_add_request_tail
Failed to find symbol dasd_add_request_head
Failed to find symbol dasd_diag_discipline_pointer
Failed to find symbol dasd_debug_area
Failed to find symbol dasd_log_ccw
Failed to find symbol dasd_log_sense
Failed to find symbol dasd_free_erp_request
Failed to find symbol dasd_alloc_erp_request
Failed to find symbol dasd_default_erp_postaction
Failed to find symbol dasd_default_erp_action
Failed to find symbol dasd_eer_write
Failed to find symbol dasd_generic_set_offline
Failed to find symbol dasd_generic_set_online
Failed to find symbol dasd_generic_notify
Failed to find symbol dasd_generic_remove
Failed to find symbol dasd_generic_probe
Failed to find symbol dasd_set_uid
Failed to find symbol dasd_nopav
Failed to find symbol dasd_page_cache
load_module: umod=00000000800905c0, len=124264, uargs=00000000800905a0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20876378 .text
	0x2087e6bc .exit.text
	0x20832000 .init.text
	0x2087e6c8 .rodata
	0x2087ed98 .rodata.str1.2
	0x20881b78 __versions
	0x208828b8 .eh_frame
	0x208863a8 .data
	0x20886458 .data.rel
	0x20886700 .gnu.linkonce.this_module
	0x2088aa00 .bss
	0x20882fd8 .symtab
	0x20885588 .strtab
dasd_eckd_mod does not use dasd_mod!
Allocating new usage for dasd_eckd_mod.
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
Absolute symbol: 0x00000000
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd_eckd_mod uses dasd_mod!
dasd(eckd): 0.0.4e21: 3390/0C(CU:3990/01) Cyl:6678 Head:15 Sec:224
dasd(eckd): 0.0.4e21: (4kB blks): 4808160kB at 48kB/trk compatible disk
layout
 dasdb:VOL1/  0X4E21: dasdb1
dasd(eckd): 0.0.4e20: 3390/0C(CU:3990/01) Cyl:6678 Head:15 Sec:224
dasd(eckd): 0.0.4e20: (4kB blks): 4808160kB at 48kB/trk compatible disk
layout
 dasda:VOL1/  0X4E20: dasda1
dasd(eckd): 0.0.4e22: 3390/0C(CU:3990/01) Cyl:6678 Head:15 Sec:224
dasd(eckd): 0.0.4e22: (4kB blks): 4808160kB at 48kB/trk compatible disk
layout
 dasdc:VOL1/  0X4E22: dasdc1
dasd(eckd): 0.0.4e23: 3390/0C(CU:3990/01) Cyl:6678 Head:15 Sec:224
dasd(eckd): 0.0.4e23: (4kB blks): 4808160kB at 48kB/trk compatible disk
layout
 dasdd:VOL1/  0X4E23: dasdd1
load_module: umod=00000000800905c0, len=35144, uargs=00000000800905a0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x2081a184 .text
	0x2081b3a8 .exit.text
	0x20823000 .init.text
	0x2081b3b8 .rodata
	0x2081b428 .rodata.str1.2
	0x2081b770 __versions
	0x2081be30 .eh_frame
	0x2081ce48 .data
	0x2081ce78 .data.rel
	0x2081d100 .gnu.linkonce.this_module
	0x20821400 .bss
	0x2081c070 .symtab
	0x2081c9b8 .strtab
dasd_fba_mod does not use dasd_mod!
Allocating new usage for dasd_fba_mod.
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
Absolute symbol: 0x00000000
dasd_fba_mod uses dasd_mod!
dasd_fba_mod uses dasd_mod!
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
load_module: umod=0000020000016010, len=201941, uargs=000000008001c4c0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab
	__kcrctab
	.data.rel.local
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x208231e0 .text
	0x20823c1c .exit.text
	0x20836000 .init.text
	0x20823c28 .rodata
	0x20823c48 .rodata.str1.2
	0x20823c84 __ksymtab_strings
	0x20823cf8 __versions
	0x20824338 .eh_frame
	0x20830980 .data
	0x20830980 __ksymtab
	0x208309d0 __kcrctab
	0x208309f8 .data.rel.local
	0x20830c88 .data.rel
	0x20830d00 .gnu.linkonce.this_module
	0x20835000 .bss
	0x20824560 .symtab
	0x2082e478 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x5efbdd8e
Absolute symbol: 0xf864163e
Absolute symbol: 0xb7d84212
Absolute symbol: 0xbdcadd64
Absolute symbol: 0x4628590c
Failed to find symbol ccwgroup_remove_ccwdev
Failed to find symbol ccwgroup_probe_ccwdev
Failed to find symbol ccwgroup_create
Failed to find symbol ccwgroup_driver_unregister
Failed to find symbol ccwgroup_driver_register
load_module: umod=0000020000016010, len=201941, uargs=000000008001c4c0
load_module: umod=0000020000016010, len=201941, uargs=000000008001c4c0
load_module: umod=0000020000057010, len=9253606, uargs=000000008001c4a0
Core section allocation order:
	.text
	.exit.text
	.fixup
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__ex_table
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel.ro
	__ksymtab_gpl
	__kcrctab_gpl
	.data.rel
	.data.rel.local
	.data.rel.ro.local
	.data.read_mostly
	__ksymtab
	__kcrctab
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x21369538 .text
	0x2139d2b4 .exit.text
	0x20817000 .init.text
	0x2139d548 .fixup
	0x2139d648 .rodata
	0x2139ef00 .rodata.str1.2
	0x213a12f6 __ksymtab_strings
	0x213a1650 __ex_table
	0x213a17e0 __versions
	0x213a71a0 .eh_frame
	0x215828d0 .data
	0x21582af0 .data.rel.ro
	0x21582ce8 __ksymtab_gpl
	0x21582dd8 __kcrctab_gpl
	0x21582e50 .data.rel
	0x21591860 .data.rel.local
	0x21592930 .data.rel.ro.local
	0x21592950 .data.read_mostly
	0x215929d0 __ksymtab
	0x21592bc0 __kcrctab
	0x21592d00 .gnu.linkonce.this_module
	0x21597000 .bss
	0x213ac448 .symtab
	0x21575a20 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x606e7780
Absolute symbol: 0xc26f1bde
Absolute symbol: 0x733dab50
Absolute symbol: 0xaade0bbb
Absolute symbol: 0x4ca76feb
Absolute symbol: 0xad105483
Absolute symbol: 0x5f765105
Absolute symbol: 0x5b71a202
Absolute symbol: 0x4dc1bb67
Absolute symbol: 0x626855f9
Absolute symbol: 0x538383c0
Absolute symbol: 0x8f88226f
Absolute symbol: 0x56a8cd4a
Absolute symbol: 0x8870a7ee
Absolute symbol: 0xc5a3ee51
Absolute symbol: 0xe1aeecd1
Absolute symbol: 0x8613551c
Absolute symbol: 0x15792c26
Absolute symbol: 0x0ac987d5
Absolute symbol: 0xb905ad82
Absolute symbol: 0xba4fa05e
Absolute symbol: 0xd858b9ff
Absolute symbol: 0x4b7e94a8
Absolute symbol: 0xc861b09f
Absolute symbol: 0xa4ce6359
Absolute symbol: 0x79dbda6b
Absolute symbol: 0x177859cd
Absolute symbol: 0x2af9f57d
Absolute symbol: 0x5d444536
Absolute symbol: 0xd1a5972c
Absolute symbol: 0x43f5aebd
Absolute symbol: 0x34289890
Absolute symbol: 0x8f02d1cb
Absolute symbol: 0x04e387a8
Absolute symbol: 0xbc3363a4
Absolute symbol: 0xce19bac5
Absolute symbol: 0x00000000
Absolute symbol: 0x594db68d
Absolute symbol: 0xfa6b7108
Absolute symbol: 0x076dd597
Absolute symbol: 0x48283ce6
Absolute symbol: 0x67c1fca6
Absolute symbol: 0x39d97b88
Absolute symbol: 0x30123eb5
Absolute symbol: 0xd0706751
Absolute symbol: 0xd039ba12
Absolute symbol: 0x8da2b2bb
Failed to find symbol compat_ipv6_getsockopt
Failed to find symbol compat_ipv6_setsockopt
Failed to find symbol ipv6_push_nfrag_opts
Failed to find symbol rt6_lookup
Failed to find symbol xfrm6_rcv
Failed to find symbol in6_dev_finish_destroy
Failed to find symbol ipv6_chk_addr
Failed to find symbol ipv6_get_saddr
Failed to find symbol inet6_ioctl
Failed to find symbol inet6_getname
Failed to find symbol inet6_bind
Failed to find symbol inet6_release
Failed to find symbol ip6_xmit
Failed to find symbol inet6_del_protocol
Failed to find symbol inet6_add_protocol
Failed to find symbol inet6_unregister_protosw
Failed to find symbol inet6_register_protosw
Failed to find symbol ipv6_getsockopt
Failed to find symbol ipv6_setsockopt
Failed to find symbol addrconf_lock
Failed to find symbol ip6_route_output
Failed to find symbol unregister_inet6addr_notifier
Failed to find symbol register_inet6addr_notifier
Failed to find symbol ndisc_mc_map
Failed to find symbol icmpv6_err_convert
Failed to find symbol icmpv6_statistics
Failed to find symbol icmpv6_send
Failed to find symbol __ipv6_addr_type
Failed to find symbol xfrm6_rcv_spi
Failed to find symbol nf_ip6_checksum
Failed to find symbol ip6_route_me_harder
Failed to find symbol ipv6_opt_accepted
Failed to find symbol inet6_sk_rebuild_header
Failed to find symbol inet6_destroy_sock
Failed to find symbol ip6_sk_dst_lookup
Failed to find symbol ip6_dst_lookup
Failed to find symbol ip6_find_1stfragopt
Failed to find symbol ip6_dst_blackhole
Failed to find symbol ipv6_dup_options
Failed to find symbol ipv6_invert_rthdr
Failed to find symbol fl6_sock_lookup
Failed to find symbol inet6_csk_xmit
Failed to find symbol inet6_csk_addr2sockaddr
Failed to find symbol inet6_csk_reqsk_queue_hash_add
Failed to find symbol inet6_csk_search_req
Failed to find symbol inet6_csk_bind_conflict
load_module: umod=0000020000016010, len=9253606, uargs=000000008001c4a0
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
load_module: umod=0000020000057010, len=9253606, uargs=000000008001c4a0
load_module: umod=0000020001017010, len=1377314, uargs=000000008001c480
Core section allocation order:
	.text
	.fixup
	.exit.text
	.rodata
	__ex_table
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab
	__kcrctab
	.data.rel
	.data.rel.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20a2c4cc .text
	0x20a3f018 .fixup
	0x20a3f024 .exit.text
	0x2080e000 .init.text
	0x20a3f0d8 .rodata
	0x20a3f378 __ex_table
	0x20a3f388 .rodata.str1.2
	0x20a3fe14 __ksymtab_strings
	0x20a3fe90 __versions
	0x20a40e50 .eh_frame
	0x20a5789c .data
	0x20a578a0 __ksymtab
	0x20a57930 __kcrctab
	0x20a57978 .data.rel
	0x20a579a0 .data.rel.local
	0x20a57a00 .gnu.linkonce.this_module
	0x20a5bd00 .bss
	0x20a41398 .symtab
	0x20a523d8 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x18af6900
Absolute symbol: 0xb9a46d60
Absolute symbol: 0x37c9fef3
Absolute symbol: 0x8031f97f
Absolute symbol: 0x23af6f03
Absolute symbol: 0xfcae9195
Absolute symbol: 0x038cd578
Absolute symbol: 0x4b63b5ca
Absolute symbol: 0x00000000
Absolute symbol: 0xbb7d06e0
Failed to find symbol qdio_synchronize
Failed to find symbol qdio_cleanup
Failed to find symbol qdio_free
Failed to find symbol qdio_shutdown
Failed to find symbol do_QDIO
Failed to find symbol qdio_activate
Failed to find symbol qdio_initialize
Failed to find symbol qdio_establish
Failed to find symbol qdio_allocate
load_module: umod=0000000080032160, len=1377314, uargs=000000008001c480
qdio: start loading QDIO base support version 2
qdio: before bus_create_file
qdio: before add_procfs_entry
qdio: before mempool create
qdio: before tiqdio_check_chsc...
qdio: tiqdio_register_thinints...
load_module: umod=0000020001058010, len=1377314, uargs=000000008001c480
load_module: umod=0000020001259010, len=2464551, uargs=000000008001c460
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	__ksymtab
	__kcrctab
	.data.rel.local
	.data.rel.ro.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20917c78 .text
	0x20937628 .exit.text
	0x20817000 .init.text
	0x209377a8 .rodata
	0x20938358 .rodata.str1.2
	0x2093c012 __ksymtab_strings
	0x2093c048 __versions
	0x2093e308 .eh_frame
	0x2099a8d8 .data
	0x2099aba8 .data.rel
	0x2099b6d0 __ksymtab
	0x2099b700 __kcrctab
	0x2099b718 .data.rel.local
	0x2099bac8 .data.rel.ro.local
	0x2099bb00 .gnu.linkonce.this_module
	0x2099fe00 .bss
	0x209407c0 .symtab
	0x2098ebc8 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0xb10486ec
qeth does not use qdio!
qeth: Unknown symbol qdio_synchronize
qeth does not use ipv6!
Allocating new usage for qeth.
qdio: finished loading
Absolute symbol: 0x53f3c3bc
qeth does not use qdio!
qeth: Unknown symbol do_QDIO
qeth does not use ccwgroup!
Allocating new usage for qeth.
qeth uses ccwgroup!
qeth uses ipv6!
qeth uses ipv6!
qeth uses ccwgroup!
qeth uses ccwgroup!
qeth does not use qdio!
qeth: Unknown symbol qdio_initialize
qeth uses ccwgroup!
qeth uses ipv6!
qeth uses ipv6!
Absolute symbol: 0x00000000
Absolute symbol: 0x2bd588f5
qeth does not use qdio!
qeth: Unknown symbol qdio_cleanup
qeth does not use qdio!
qeth: Unknown symbol qdio_activate
qeth unusing ipv6
qeth unusing ccwgroup
load_module: umod=00000000802386e0, len=2464551, uargs=000000008001c460
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	__ksymtab
	__kcrctab
	.data.rel.local
	.data.rel.ro.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20967c78 .text
	0x20987628 .exit.text
	0x20817000 .init.text
	0x209877a8 .rodata
	0x20988358 .rodata.str1.2
	0x2098c012 __ksymtab_strings
	0x2098c048 __versions
	0x2098e308 .eh_frame
	0x209ea8d8 .data
	0x209eaba8 .data.rel
	0x209eb6d0 __ksymtab
	0x209eb700 __kcrctab
	0x209eb718 .data.rel.local
	0x209ebac8 .data.rel.ro.local
	0x209ebb00 .gnu.linkonce.this_module
	0x209efe00 .bss
	0x209907c0 .symtab
	0x209debc8 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0xb10486ec
qeth does not use qdio!
qeth: Unknown symbol qdio_synchronize
qeth does not use ipv6!
Allocating new usage for qeth.
Absolute symbol: 0x53f3c3bc
qeth does not use qdio!
qeth: Unknown symbol do_QDIO
qeth does not use ccwgroup!
Allocating new usage for qeth.
qeth uses ccwgroup!
qeth uses ipv6!
qeth uses ipv6!
qeth uses ccwgroup!
qeth uses ccwgroup!
qeth does not use qdio!
qeth: Unknown symbol qdio_initialize
qeth uses ccwgroup!
qeth uses ipv6!
qeth uses ipv6!
Absolute symbol: 0x00000000
Absolute symbol: 0x2bd588f5
qeth does not use qdio!
qeth: Unknown symbol qdio_cleanup
qeth does not use qdio!
qeth: Unknown symbol qdio_activate
qeth unusing ipv6
qeth unusing ccwgroup
load_module: umod=0000020001017010, len=2464551, uargs=000000008001c460
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	__ksymtab
	__kcrctab
	.data.rel.local
	.data.rel.ro.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20cb8c78 .text
	0x20cd8628 .exit.text
	0x20811000 .init.text
	0x20cd87a8 .rodata
	0x20cd9358 .rodata.str1.2
	0x20cdd012 __ksymtab_strings
	0x20cdd048 __versions
	0x20cdf308 .eh_frame
	0x20d3b8d8 .data
	0x20d3bba8 .data.rel
	0x20d3c6d0 __ksymtab
	0x20d3c700 __kcrctab
	0x20d3c718 .data.rel.local
	0x20d3cac8 .data.rel.ro.local
	0x20d3cb00 .gnu.linkonce.this_module
	0x20d40e00 .bss
	0x20ce17c0 .symtab
	0x20d2fbc8 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0xb10486ec
qeth does not use qdio!
Allocating new usage for qeth.
qeth does not use ipv6!
Allocating new usage for qeth.
Absolute symbol: 0x53f3c3bc
qeth uses qdio!
qeth does not use ccwgroup!
Allocating new usage for qeth.
qeth uses ccwgroup!
qeth uses ipv6!
qeth uses ipv6!
qeth uses ccwgroup!
qeth uses ccwgroup!
qeth uses qdio!
qeth uses ccwgroup!
qeth uses ipv6!
qeth uses ipv6!
Absolute symbol: 0x00000000
Absolute symbol: 0x2bd588f5
qeth uses qdio!
qeth uses qdio!
Failed to find symbol qeth_osn_assist
Failed to find symbol qeth_osn_deregister
Failed to find symbol qeth_osn_register
qeth: loading qeth S/390 OSA-Express driver
qeth: Device 0.0.f5f0/0.0.f5f1/0.0.f5f2 is a OSD Express card (level:
087a)
with link type OSD_1000 (portname: OSAPORT)
qeth: Hardware IP fragmentation not supported on eth0
qeth: VLAN enabled 
qeth: Multicast enabled
qeth: IPV6 enabled 
qeth: Broadcast enabled 
qeth: Using SW checksumming on eth0.
qeth: Outbound TSO enabled
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
load_module: umod=0000020000016010, len=1634917, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	__param
	__ksymtab
	__kcrctab
	__ksymtab_gpl
	__kcrctab_gpl
	.data.rel.ro.local
	.data.rel.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
	.init.data
final section addresses:
	0x20beed20 .text
	0x2080e000 .init.text
	0x20bf74fc .exit.text
	0x20bf7558 .rodata
	0x20bf7808 .rodata.str1.2
	0x20bf8624 __ksymtab_strings
	0x20bf8838 __versions
	0x20bfa778 .eh_frame
	0x20c58118 .data
	0x2080e2d8 .init.data
	0x20c58120 .data.rel
	0x20c58380 __param
	0x20c583a8 __ksymtab
	0x20c58578 __kcrctab
	0x20c58660 __ksymtab_gpl
	0x20c58690 __kcrctab_gpl
	0x20c586a8 .data.rel.ro.local
	0x20c587b8 .data.rel.local
	0x20c58a00 .gnu.linkonce.this_module
	0x20c5cd00 .bss
	0x20bfc1d8 .symtab
	0x20c51df8 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x9e93b09c
Absolute symbol: 0x8c627381
Absolute symbol: 0x2a1a9256
Absolute symbol: 0xb3576650
Absolute symbol: 0xde575915
Absolute symbol: 0xdfc692eb
Absolute symbol: 0x222f5faf
Absolute symbol: 0xae0c540e
Absolute symbol: 0x8473f43e
Absolute symbol: 0x35c98845
Absolute symbol: 0x8eac284e
Absolute symbol: 0x65c12376
Absolute symbol: 0xa1b49e1b
Absolute symbol: 0x5f95698d
Absolute symbol: 0x0756b8a1
Absolute symbol: 0xf06afb09
Absolute symbol: 0x2c330f23
Absolute symbol: 0xa278e47a
Absolute symbol: 0xc23c7ac7
Absolute symbol: 0x0feae9a7
Absolute symbol: 0xc79bcd36
Absolute symbol: 0x951c717d
Absolute symbol: 0x48507076
Absolute symbol: 0x50782174
Absolute symbol: 0x959c3b1a
Absolute symbol: 0x00000000
Absolute symbol: 0x5691b115
Absolute symbol: 0x0938e07a
Absolute symbol: 0x080b1d9a
Absolute symbol: 0xc65f2f3f
Absolute symbol: 0x2ff2bf6b
Absolute symbol: 0x9d3d2576
Absolute symbol: 0xd41f57eb
Failed to find symbol dm_get_mapinfo
Failed to find symbol dm_table_flush_all
Failed to find symbol dm_table_unplug_all
Failed to find symbol dm_table_get
Failed to find symbol dm_table_put
Failed to find symbol dm_table_get_md
Failed to find symbol dm_table_get_mode
Failed to find symbol dm_table_get_size
Failed to find symbol dm_table_event
Failed to find symbol dm_put_device
Failed to find symbol dm_get_device
Failed to find symbol dm_vcalloc
Failed to find symbol dm_unregister_target
Failed to find symbol dm_register_target
Failed to find symbol dm_io_async_vm
Failed to find symbol dm_io_sync_vm
Failed to find symbol dm_io_async_bvec
Failed to find symbol dm_io_sync_bvec
Failed to find symbol dm_io_async
Failed to find symbol dm_io_sync
Failed to find symbol dm_io_put
Failed to find symbol dm_io_get
Failed to find symbol dm_io
Failed to find symbol dm_io_client_destroy
Failed to find symbol dm_io_client_resize
Failed to find symbol dm_io_client_create
Failed to find symbol kcopyd_copy
Failed to find symbol kcopyd_client_destroy
Failed to find symbol kcopyd_client_create
Failed to find symbol dm_noflush_suspending
Failed to find symbol dm_device_name
Failed to find symbol dm_create_error_table
device-mapper: ioctl: 4.11.0-ioctl (2006-09-14) initialised:
dm-devel@redhat.com
load_module: umod=0000020000016010, len=634984, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab_gpl
	__kcrctab_gpl
	.data.rel.local
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20a5d37c .text
	0x20a5fcf4 .exit.text
	0x2080e000 .init.text
	0x20a5fd70 .rodata
	0x20a5fde8 .rodata.str1.2
	0x20a60414 __ksymtab_strings
	0x20a604a8 __versions
	0x20a60f68 .eh_frame
	0x20a87bf0 .data
	0x20a87bf0 __ksymtab_gpl
	0x20a87c50 __kcrctab_gpl
	0x20a87c80 .data.rel.local
	0x20a87d50 .data.rel
	0x20a87e00 .gnu.linkonce.this_module
	0x20a8c100 .bss
	0x20a61598 .symtab
	0x20a83300 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
dm_multipath does not use dm_mod!
Allocating new usage for dm_multipath.
Absolute symbol: 0x69def27a
dm_multipath uses dm_mod!
dm_multipath uses dm_mod!
Absolute symbol: 0x91722573
Absolute symbol: 0xf0205b64
Absolute symbol: 0x5de49118
dm_multipath uses dm_mod!
Absolute symbol: 0x29078b67
dm_multipath uses dm_mod!
dm_multipath uses dm_mod!
Absolute symbol: 0x00000000
dm_multipath uses dm_mod!
Absolute symbol: 0xbb728762
dm_multipath uses dm_mod!
Failed to find symbol dm_scsi_err_handler
Failed to find symbol dm_unregister_hw_handler
Failed to find symbol dm_register_hw_handler
Failed to find symbol dm_unregister_path_selector
Failed to find symbol dm_register_path_selector
Failed to find symbol dm_pg_init_complete
device-mapper: multipath: version 1.0.5 loaded
load_module: umod=0000020000016010, len=631127, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab
	__kcrctab
	.data.rel
	.data.rel.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20a8e4c8 .text
	0x2080e000 .init.text
	0x20a929a4 .exit.text
	0x20a92a00 .rodata
	0x20a92b80 .rodata.str1.2
	0x20a9362e __ksymtab_strings
	0x20a93698 __versions
	0x20a94598 .eh_frame
	0x20ab3bc0 .data
	0x20ab3bc0 __ksymtab
	0x20ab3c00 __kcrctab
	0x20ab3c20 .data.rel
	0x20ab3e78 .data.rel.local
	0x20ab3f00 .gnu.linkonce.this_module
	0x20ab8200 .bss
	0x20a94e30 .symtab
	0x20aaef60 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
dm_mirror does not use dm_mod!
Allocating new usage for dm_mirror.
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
Absolute symbol: 0x15eac5ba
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
Absolute symbol: 0xe9d084dd
Absolute symbol: 0x8cdb3f4d
dm_mirror uses dm_mod!
Absolute symbol: 0x00000000
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
dm_mirror uses dm_mod!
Absolute symbol: 0x5f67320d
Failed to find symbol dm_destroy_dirty_log
Failed to find symbol dm_create_dirty_log
Failed to find symbol dm_unregister_dirty_log_type
Failed to find symbol dm_register_dirty_log_type
EXT3 FS on dasda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dasdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is
recommended
EXT3 FS on dasdd1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
load_module: umod=0000020000016010, len=344770, uargs=000000008001c270
Core section allocation order:
	.text
	.exit.text
	.fixup
	.rodata
	.rodata.str1.2
	__ex_table
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab_gpl
	__kcrctab_gpl
	__ksymtab
	__kcrctab
	.data.rel.ro.local
	.data.rel
	.data.rel.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x209cf250 .text
	0x209d0848 .exit.text
	0x209d085c .fixup
	0x2080e000 .init.text
	0x209d0870 .rodata
	0x209d08d8 .rodata.str1.2
	0x209d0ac0 __ex_table
	0x209d0ae0 __ksymtab_strings
	0x209d0c80 __versions
	0x209d14c0 .eh_frame
	0x209e6fbc .data
	0x209e6fc0 __ksymtab_gpl
	0x209e70b0 __kcrctab_gpl
	0x209e7128 __ksymtab
	0x209e71a8 __kcrctab
	0x209e71e8 .data.rel.ro.local
	0x209e73e8 .data.rel
	0x209e74d0 .data.rel.local
	0x209e7500 .gnu.linkonce.this_module
	0x209eb800 .bss
	0x209d1978 .symtab
	0x209e1d40 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x4ae7af33
Absolute symbol: 0x4583d2e7
Absolute symbol: 0xe00b18f3
Absolute symbol: 0xd16cae93
Absolute symbol: 0x63f05053
Absolute symbol: 0xd264c4b6
Absolute symbol: 0xe968f34d
Absolute symbol: 0x2567d2f3
Absolute symbol: 0x2b3dbc9b
Absolute symbol: 0x4cb439c6
Absolute symbol: 0x0c0a8be7
Absolute symbol: 0x59abb651
Absolute symbol: 0xc6b44189
Absolute symbol: 0xce2c2512
Absolute symbol: 0xa916d305
Absolute symbol: 0xe53911a2
Absolute symbol: 0x2f32d4da
Absolute symbol: 0x00000000
Absolute symbol: 0x44aa2672
Absolute symbol: 0x5a5a3376
Absolute symbol: 0x5a89ff5c
Absolute symbol: 0x06d0052f
Absolute symbol: 0x2400f3c1
Absolute symbol: 0x7910e82e
Failed to find symbol xt_free_table_info
Failed to find symbol xt_alloc_table_info
Failed to find symbol xt_find_target
Failed to find symbol xt_find_match
Failed to find symbol xt_unregister_match
Failed to find symbol xt_register_match
Failed to find symbol xt_unregister_target
Failed to find symbol xt_register_target
Failed to find symbol xt_proto_fini
Failed to find symbol xt_proto_init
Failed to find symbol xt_unregister_table
Failed to find symbol xt_register_table
Failed to find symbol xt_replace_table
Failed to find symbol xt_compat_unlock
Failed to find symbol xt_compat_lock
Failed to find symbol xt_table_unlock
Failed to find symbol xt_find_table_lock
Failed to find symbol xt_compat_target
Failed to find symbol xt_check_target
Failed to find symbol xt_compat_match
Failed to find symbol xt_check_match
Failed to find symbol xt_find_revision
Failed to find symbol xt_request_find_target
load_module: umod=000000008002bbf0, len=445615, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab
	__kcrctab
	.data.rel.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x2097b300 .text
	0x2097d700 .exit.text
	0x2080e000 .init.text
	0x2097d760 .rodata
	0x2097d800 .rodata.str1.2
	0x2097d884 __ksymtab_strings
	0x2097d8d8 __versions
	0x2097e298 .eh_frame
	0x209974d8 .data
	0x20997548 __ksymtab
	0x20997598 __kcrctab
	0x209975c0 .data.rel.local
	0x20997700 .gnu.linkonce.this_module
	0x2099ba00 .bss
	0x2097e4d8 .symtab
	0x20991438 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
ip6_tables does not use x_tables!
Allocating new usage for ip6_tables.
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
Absolute symbol: 0x7baddd10
Absolute symbol: 0x1bf4da04
ip6_tables uses x_tables!
Absolute symbol: 0x2885c449
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
Absolute symbol: 0xb8bddf33
ip6_tables uses x_tables!
ip6_tables uses x_tables!
Absolute symbol: 0x00000000
Absolute symbol: 0xe14f133c
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
ip6_tables uses x_tables!
Failed to find symbol ipv6_find_hdr
Failed to find symbol ip6t_ext_hdr
Failed to find symbol ip6t_do_table
Failed to find symbol ip6t_unregister_table
Failed to find symbol ip6t_register_table
ip6_tables: (C) 2000-2006 Netfilter Core Team
load_module: umod=0000020000016010, len=313012, uargs=000000008001f130
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__param
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
	.init.data
final section addresses:
	0x2099d078 .text
	0x2099d118 .exit.text
	0x2080e000 .init.text
	0x2099d158 .rodata
	0x2099d160 .rodata.str1.2
	0x2099d188 __versions
	0x2099d3c8 .eh_frame
	0x209b4424 .data
	0x209b4430 __param
	0x209b4458 .data.rel
	0x2080e0a8 .init.data
	0x209b4600 .gnu.linkonce.this_module
	0x209b8900 .bss
	0x2099d480 .symtab
	0x209aee68 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
ip6table_filter does not use ip6_tables!
Allocating new usage for ip6table_filter.
ip6table_filter uses ip6_tables!
ip6table_filter uses ip6_tables!
load_module: umod=0000020000016010, len=326449, uargs=000000008001c330
Core section allocation order:
	.text
	.exit.text
	.rodata
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x209ed03c .text
	0x209ed404 .exit.text
	0x20855000 .init.text
	0x209ed458 .rodata
	0x209ed478 __versions
	0x209ed578 .eh_frame
	0x20a04a6c .data
	0x20a04a70 .data.rel
	0x20a04d00 .gnu.linkonce.this_module
	0x20a09000 .bss
	0x209ed650 .symtab
	0x209ff368 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
xt_tcpudp does not use x_tables!
Allocating new usage for xt_tcpudp.
xt_tcpudp uses x_tables!
load_module: umod=0000020000016010, len=348496, uargs=000000008001f130
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20a0a16c .text
	0x20a0a92c .exit.text
	0x20855000 .init.text
	0x20a0a938 .rodata
	0x20a0a9b8 .rodata.str1.2
	0x20a0aad0 __versions
	0x20a0b010 .eh_frame
	0x20a23b18 .data
	0x20a23b18 .data.rel
	0x20a23c00 .gnu.linkonce.this_module
	0x20a27f00 .bss
	0x20a0b0c8 .symtab
	0x20a1dda0 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
ip6t_REJECT does not use ipv6!
Allocating new usage for ip6t_REJECT.
ip6t_REJECT does not use x_tables!
Allocating new usage for ip6t_REJECT.
ip6t_REJECT uses ipv6!
Absolute symbol: 0x00000000
ip6t_REJECT uses ipv6!
ip6t_REJECT uses x_tables!
load_module: umod=0000020000016010, len=514091, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.fixup
	.rodata
	.rodata.str1.2
	__ex_table
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab
	__kcrctab
	.data.rel.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20b3936c .text
	0x20b3cd94 .exit.text
	0x20b3cdf0 .fixup
	0x20836000 .init.text
	0x20b3ce08 .rodata
	0x20b3cf30 .rodata.str1.2
	0x20b3cfb0 __ex_table
	0x20b3cfd0 __ksymtab_strings
	0x20b3d008 __versions
	0x20b3db88 .eh_frame
	0x20b573a4 .data
	0x20b573a8 __ksymtab
	0x20b573d8 __kcrctab
	0x20b573f0 .data.rel.local
	0x20b57600 .gnu.linkonce.this_module
	0x20b5b900 .bss
	0x20b3df60 .symtab
	0x20b511d8 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
ip_tables does not use x_tables!
Allocating new usage for ip_tables.
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
Absolute symbol: 0x7e68088a
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
Absolute symbol: 0x5e24eca9
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
Absolute symbol: 0xee612a28
Absolute symbol: 0x00000000
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
ip_tables uses x_tables!
Failed to find symbol ipt_do_table
Failed to find symbol ipt_unregister_table
Failed to find symbol ipt_register_table
ip_tables: (C) 2000-2006 Netfilter Core Team
load_module: umod=0000020000016010, len=254455, uargs=000000008001f130
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__param
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
	.init.data
final section addresses:
	0x20afa08c .text
	0x20afa17c .exit.text
	0x20836000 .init.text
	0x20afa1c0 .rodata
	0x20afa1d0 .rodata.str1.2
	0x20afa210 __versions
	0x20afa490 .eh_frame
	0x20b0cbf8 .data
	0x20b0cc08 __param
	0x20b0cc30 .data.rel
	0x208360a8 .init.data
	0x20b0ce00 .gnu.linkonce.this_module
	0x20b11100 .bss
	0x20afa548 .symtab
	0x20b08bb8 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
iptable_filter does not use ip_tables!
Allocating new usage for iptable_filter.
iptable_filter uses ip_tables!
iptable_filter uses ip_tables!
load_module: umod=0000020000016010, len=337296, uargs=000000008001c540
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	__ksymtab_gpl
	__kcrctab_gpl
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
	.init.data
final section addresses:
	0x20aba158 .text
	0x20abaacc .exit.text
	0x20836000 .init.text
	0x20abab18 .rodata
	0x20abab50 .rodata.str1.2
	0x20ababfe __ksymtab_strings
	0x20abac88 __versions
	0x20abb088 .eh_frame
	0x20ad2b00 .data
	0x20ad2b00 .data.rel
	0x20ad2b20 __ksymtab_gpl
	0x20ad2b90 __kcrctab_gpl
	0x2083608c .init.data
	0x20ad2c00 .gnu.linkonce.this_module
	0x20ad6f00 .bss
	0x20abb278 .symtab
	0x20acd158 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0xf6c9b5a6
Absolute symbol: 0x3f27e37f
Absolute symbol: 0x191212d2
Absolute symbol: 0xd7382804
Absolute symbol: 0xef509d51
Absolute symbol: 0x00000000
Absolute symbol: 0x86de9c48
Absolute symbol: 0xeca95329
Failed to find symbol __nfa_fill
Failed to find symbol nfattr_parse
Failed to find symbol nfnetlink_unicast
Failed to find symbol nfnetlink_send
Failed to find symbol nfnetlink_subsys_unregister
Failed to find symbol nfnetlink_subsys_register
Failed to find symbol nfnetlink_has_listeners
Netfilter messages via NETLINK v0.30.
load_module: umod=0000020000016010, len=1659169, uargs=000000008001c520
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab_gpl
	__kcrctab_gpl
	__ksymtab
	__kcrctab
	.data.rel
	.data.rel.local
	__param
	.data.read_mostly
	.data.rel.ro
	.data.rel.ro.local
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20ed9718 .text
	0x20edf6a8 .exit.text
	0x20836000 .init.text
	0x20edf740 .rodata
	0x20edfbb0 .rodata.str1.2
	0x20ee062c __ksymtab_strings
	0x20ee0af0 __versions
	0x20ee1cf0 .eh_frame
	0x20f45cc4 .data
	0x20f45d18 __ksymtab_gpl
	0x20f45eb8 __kcrctab_gpl
	0x20f45f88 __ksymtab
	0x20f460f8 __kcrctab
	0x20f461b0 .data.rel
	0x20f46eb8 .data.rel.local
	0x20f471c0 __param
	0x20f471e8 .data.read_mostly
	0x20f471f8 .data.rel.ro
	0x20f47248 .data.rel.ro.local
	0x20f47300 .gnu.linkonce.this_module
	0x20f4b600 .bss
	0x20ee2cd0 .symtab
	0x20f3cb50 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x23388f70
Absolute symbol: 0xcdb1850a
Absolute symbol: 0x92cb1f94
Absolute symbol: 0x2ccbfb46
Absolute symbol: 0xb3cd8f0f
Absolute symbol: 0xb3182355
Absolute symbol: 0xdf0513cd
ip_conntrack does not use nfnetlink!
Allocating new usage for ip_conntrack.
Absolute symbol: 0xb02071c4
Absolute symbol: 0x386855a5
ip_conntrack uses nfnetlink!
Absolute symbol: 0x74ad6de3
Absolute symbol: 0x3e6b4276
Absolute symbol: 0x07c5eb48
Absolute symbol: 0x9f443da1
Absolute symbol: 0x301be3db
Absolute symbol: 0x88bf1b45
Absolute symbol: 0xa0558310
Absolute symbol: 0x846a56b6
Absolute symbol: 0x3b90389e
Absolute symbol: 0xc2b0a736
Absolute symbol: 0xa3190884
Absolute symbol: 0xc4af74bb
Absolute symbol: 0xc7be60c5
Absolute symbol: 0xc39970a0
Absolute symbol: 0x8ef8af4c
Absolute symbol: 0xc4aa05f4
Absolute symbol: 0x8aebc0b9
Absolute symbol: 0x47fc6738
Absolute symbol: 0xcf398f1e
Absolute symbol: 0x62ffb0b6
Absolute symbol: 0xa2834c44
Absolute symbol: 0x8a0b604a
Absolute symbol: 0x8e4c6c0d
Absolute symbol: 0x30a94e00
Absolute symbol: 0x663f0053
Absolute symbol: 0xe1028403
Absolute symbol: 0x0a473434
Absolute symbol: 0x168c56f1
Absolute symbol: 0xd7bdb9c8
Absolute symbol: 0xd4e0e715
Absolute symbol: 0x0b8ff53e
Absolute symbol: 0x00000000
Absolute symbol: 0x6e224a7a
Absolute symbol: 0x75cbe04a
Absolute symbol: 0x31205b45
Absolute symbol: 0x5b193ba1
Absolute symbol: 0x6ff01efc
Absolute symbol: 0x4a3e4b8a
Absolute symbol: 0x579d7b28
Absolute symbol: 0xe5d11085
Absolute symbol: 0x895efcbd
Failed to find symbol ip_conntrack_tcp_update
Failed to find symbol ip_conntrack_untracked
Failed to find symbol ip_conntrack_hash
Failed to find symbol ip_conntrack_lock
Failed to find symbol ip_conntrack_htable_size
Failed to find symbol ip_ct_gather_frags
Failed to find symbol ip_conntrack_tuple_taken
Failed to find symbol ip_conntrack_unexpect_related
Failed to find symbol ip_conntrack_expect_related
Failed to find symbol ip_conntrack_expect_put
Failed to find symbol ip_conntrack_expect_alloc
Failed to find symbol __ip_ct_refresh_acct
Failed to find symbol ip_ct_iterate_cleanup
Failed to find symbol ip_conntrack_helper_unregister
Failed to find symbol ip_conntrack_helper_register
Failed to find symbol need_conntrack
Failed to find symbol ip_conntrack_destroyed
Failed to find symbol ip_conntrack_alter_reply
Failed to find symbol invert_tuplepr
Failed to find symbol ip_ct_get_tuple
Failed to find symbol ip_conntrack_protocol_unregister
Failed to find symbol ip_conntrack_protocol_register
Failed to find symbol ip_ct_log_invalid
Failed to find symbol ip_ct_port_nfattr_to_tuple
Failed to find symbol ip_ct_port_tuple_to_nfattr
Failed to find symbol ip_conntrack_checksum
Failed to find symbol __ip_conntrack_proto_find
Failed to find symbol ip_conntrack_proto_put
Failed to find symbol ip_conntrack_proto_find_get
Failed to find symbol __ip_conntrack_helper_find_byname
Failed to find symbol ip_conntrack_helper_put
Failed to find symbol ip_conntrack_helper_find_get
Failed to find symbol ip_ct_remove_expectations
Failed to find symbol ip_conntrack_hash_insert
Failed to find symbol ip_conntrack_free
Failed to find symbol ip_conntrack_alloc
Failed to find symbol __ip_conntrack_find
Failed to find symbol ip_conntrack_flush
Failed to find symbol ip_conntrack_find_get
Failed to find symbol ip_ct_unlink_expect
Failed to find symbol ip_conntrack_expect_list
Failed to find symbol ip_conntrack_expect_find
Failed to find symbol __ip_conntrack_expect_find
Failed to find symbol per_cpu__ip_conntrack_ecache
Failed to find symbol __ip_ct_event_cache_init
Failed to find symbol ip_conntrack_unregister_notifier
Failed to find symbol ip_conntrack_register_notifier
Failed to find symbol ip_conntrack_expect_chain
Failed to find symbol ip_conntrack_chain
ip_conntrack version 2.4 (2048 buckets, 16384 max) - 304 bytes per
conntrack
load_module: umod=00000000800321e0, len=259255, uargs=000000008001c4e0
Core section allocation order:
	.text
	.exit.text
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20ad8044 .text
	0x20ad80b8 .exit.text
	0x20836000 .init.text
	0x20ad80f8 __versions
	0x20ad8238 .eh_frame
	0x20aeb1f0 .data
	0x20aeb1f0 .data.rel
	0x20aeb300 .gnu.linkonce.this_module
	0x20aef600 .bss
	0x20ad82d8 .symtab
	0x20ae6f48 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
xt_state does not use x_tables!
Allocating new usage for xt_state.
xt_state uses x_tables!
xt_state does not use ip_conntrack!
Allocating new usage for xt_state.
xt_state uses ip_conntrack!
Absolute symbol: 0x00000000
load_module: umod=0000020000016010, len=343895, uargs=000000008001f130
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20b13150 .text
	0x20b13b34 .exit.text
	0x20836000 .init.text
	0x20b13b40 .rodata
	0x20b13be8 .rodata.str1.2
	0x20b13c98 __versions
	0x20b14158 .eh_frame
	0x20b2c0e0 .data
	0x20b2c0e0 .data.rel
	0x20b2c200 .gnu.linkonce.this_module
	0x20b30500 .bss
	0x20b14208 .symtab
	0x20b266d0 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
ipt_REJECT does not use x_tables!
Allocating new usage for ipt_REJECT.
Absolute symbol: 0x00000000
ipt_REJECT uses x_tables!
load_module: umod=0000020000016010, len=312752, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.rodata
	.rodata.str1.2
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__param
	.data.rel
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20bab078 .text
	0x20bab1c0 .exit.text
	0x20836000 .init.text
	0x20bab1d0 .rodata
	0x20bab1e8 .rodata.str1.2
	0x20bab1f8 __versions
	0x20bab438 .eh_frame
	0x20bc2830 .data
	0x20bc2840 __param
	0x20bc2868 .data.rel
	0x20bc2900 .gnu.linkonce.this_module
	0x20bc6c00 .bss
	0x20bab4b0 .symtab
	0x20bbd120 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
ip_conntrack_netbios_ns does not use ip_conntrack!
Allocating new usage for ip_conntrack_netbios_ns.
ip_conntrack_netbios_ns uses ip_conntrack!
ip_conntrack_netbios_ns uses ip_conntrack!
ip_conntrack_netbios_ns uses ip_conntrack!
ip_conntrack_netbios_ns uses ip_conntrack!
ip_conntrack_netbios_ns uses ip_conntrack!
process `sysctl' is using deprecated sysctl (syscall)
net.ipv6.neigh.lo.retrans_time; Use net.ipv6.neigh.lo.retrans_time_ms
instead.
load_module: umod=0000020000016010, len=3698065, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.fixup
	.rodata
	.rodata.str1.2
	__ksymtab_strings
	__ex_table
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	__ksymtab
	__kcrctab
	.data.rel.local
	.data.rel.ro.local
	.data.rel
	.data.read_mostly
	__ksymtab_gpl
	__kcrctab_gpl
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x2159c4e8 .text
	0x215b28dc .exit.text
	0x20836000 .init.text
	0x215b293c .fixup
	0x215b2968 .rodata
	0x215b3210 .rodata.str1.2
	0x215b6296 __ksymtab_strings
	0x215b6a18 __ex_table
	0x215b6a58 __versions
	0x215b93d8 .eh_frame
	0x216994f0 .data
	0x21699560 __ksymtab
	0x21699c80 __kcrctab
	0x2169a010 .data.rel.local
	0x2169a508 .data.rel.ro.local
	0x2169a538 .data.rel
	0x2169b230 .data.read_mostly
	0x2169b260 __ksymtab_gpl
	0x2169b270 __kcrctab_gpl
	0x2169b300 .gnu.linkonce.this_module
	0x2169f600 .bss
	0x215bca50 .symtab
	0x2168d280 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x4ed2b878
Absolute symbol: 0x6b3f33b6
Absolute symbol: 0x9648cf89
Absolute symbol: 0xe37673cf
Absolute symbol: 0xab871b5b
Absolute symbol: 0x4c93818f
Absolute symbol: 0x2e5f5aba
Absolute symbol: 0x5bd26000
Absolute symbol: 0x375492a4
Absolute symbol: 0xdcdaef8e
Absolute symbol: 0x5b5964f5
Absolute symbol: 0x6545181d
Absolute symbol: 0x94c59cf8
Absolute symbol: 0x55620777
Absolute symbol: 0x9cfc086d
Absolute symbol: 0x3230cee8
Absolute symbol: 0x6888c584
Absolute symbol: 0x9cf0fd47
Absolute symbol: 0xfbdaa3f0
Absolute symbol: 0xbbcca4c8
Absolute symbol: 0x7bd87272
Absolute symbol: 0xf39ed382
Absolute symbol: 0xa704b994
Absolute symbol: 0xe59001ca
Absolute symbol: 0x29c6f164
Absolute symbol: 0x5e158f4c
Absolute symbol: 0x72a89330
Absolute symbol: 0x59d9cff7
Absolute symbol: 0x97ed970a
Absolute symbol: 0x53445f68
Absolute symbol: 0xe05f5d67
Absolute symbol: 0x7334c6fd
Absolute symbol: 0x6eea229d
Absolute symbol: 0x4c4e6301
Absolute symbol: 0x4277a192
Absolute symbol: 0xfa968714
Absolute symbol: 0x39840d0a
Absolute symbol: 0x56fa8210
Absolute symbol: 0x2e1c4369
Absolute symbol: 0xabc0fe0c
Absolute symbol: 0xedcf6be4
Absolute symbol: 0x57ebcef8
Absolute symbol: 0x587d494b
Absolute symbol: 0xaae13001
Absolute symbol: 0x37122434
Absolute symbol: 0x8b77a6ca
Absolute symbol: 0xbfbd3027
Absolute symbol: 0xc68a62bd
Absolute symbol: 0xb33dda16
Absolute symbol: 0xd42a4ce4
Absolute symbol: 0x4bfc8d01
Absolute symbol: 0xe25d64b1
Absolute symbol: 0xd9e627a9
Absolute symbol: 0x73d6b433
Absolute symbol: 0xe068df91
Absolute symbol: 0xae0dfa17
Absolute symbol: 0xb0484123
Absolute symbol: 0x0f668ba9
Absolute symbol: 0xe57fd5e7
Absolute symbol: 0xbf9d1b96
Absolute symbol: 0xed3c4655
Absolute symbol: 0xfbcfa4e2
Absolute symbol: 0x3d47fcf4
Absolute symbol: 0xf1306007
Absolute symbol: 0xcbac60a6
Absolute symbol: 0x1be57115
Absolute symbol: 0x476c613e
Absolute symbol: 0x0f360a21
Absolute symbol: 0x9adf53d5
Absolute symbol: 0x23670af2
Absolute symbol: 0x87591443
Absolute symbol: 0x618b1951
Absolute symbol: 0x2e27c993
Absolute symbol: 0xc8e96dea
Absolute symbol: 0xc4c88768
Absolute symbol: 0xaeb1596c
Absolute symbol: 0x0227fd5e
Absolute symbol: 0x19fbdcf4
Absolute symbol: 0x0e9e79d5
Absolute symbol: 0x2aa17774
Absolute symbol: 0xbabf0f35
Absolute symbol: 0xe7003d04
Absolute symbol: 0xe6bb968e
Absolute symbol: 0xb7f657f9
Absolute symbol: 0x50ad54bf
Absolute symbol: 0x905b1f50
Absolute symbol: 0x71fa908a
Absolute symbol: 0xe21d3cd0
Absolute symbol: 0xaf5bf6ef
Absolute symbol: 0x271f07a8
Absolute symbol: 0x9e8073b1
Absolute symbol: 0xd94b3425
Absolute symbol: 0x500162aa
Absolute symbol: 0xe639c0b3
Absolute symbol: 0x7905ee25
Absolute symbol: 0xbce67dc0
Absolute symbol: 0xebed841f
Absolute symbol: 0xe97f4ce5
Absolute symbol: 0x5658890a
Absolute symbol: 0x00000000
Absolute symbol: 0x12e280e3
Absolute symbol: 0xe2e0b173
Absolute symbol: 0x1373c9c8
Absolute symbol: 0x2298a5d9
Absolute symbol: 0x46d63b71
Absolute symbol: 0x807b344f
Absolute symbol: 0x35ece787
Absolute symbol: 0xaf718408
Absolute symbol: 0x978ba780
Absolute symbol: 0x56b0a719
Absolute symbol: 0x0f988023
Absolute symbol: 0xd41ac93e
Absolute symbol: 0x6ae91b1c
Absolute symbol: 0xcc721917
Absolute symbol: 0xbaff2bbe
Absolute symbol: 0x31a89d59
Failed to find symbol rpc_force_rebind
Failed to find symbol rpc_max_payload
Failed to find symbol rpc_run_task
Failed to find symbol rpc_put_task
Failed to find symbol rpc_exit_task
Failed to find symbol __rpc_wait_for_completion_task
Failed to find symbol rpc_init_wait_queue
Failed to find symbol svc_sock_names
Failed to find symbol svc_auth_unregister
Failed to find symbol xdr_enter_page
Failed to find symbol xdr_read_pages
Failed to find symbol xdr_inline_decode
Failed to find symbol xdr_init_decode
Failed to find symbol xdr_write_pages
Failed to find symbol xdr_reserve_space
Failed to find symbol xdr_init_encode
Failed to find symbol xdr_encode_opaque
Failed to find symbol xdr_encode_opaque_fixed
Failed to find symbol nlm_debug
Failed to find symbol nfsd_debug
Failed to find symbol nfs_debug
Failed to find symbol rpc_debug
Failed to find symbol read_bytes_from_xdr_buf
Failed to find symbol xdr_buf_read_netobj
Failed to find symbol xdr_buf_subsegment
Failed to find symbol xdr_buf_from_iov
Failed to find symbol xdr_decode_array2
Failed to find symbol xdr_encode_array2
Failed to find symbol xdr_decode_word
Failed to find symbol xdr_encode_word
Failed to find symbol xdr_shift_buf
Failed to find symbol xdr_inline_pages
Failed to find symbol xdr_encode_pages
Failed to find symbol xdr_encode_netobj
Failed to find symbol xdr_decode_netobj
Failed to find symbol xdr_decode_string_inplace
Failed to find symbol xdr_encode_string
Failed to find symbol unix_domain_find
Failed to find symbol svcauth_unix_purge
Failed to find symbol qword_get
Failed to find symbol qword_addhex
Failed to find symbol qword_add
Failed to find symbol cache_unregister
Failed to find symbol cache_register
Failed to find symbol cache_purge
Failed to find symbol cache_flush
Failed to find symbol cache_check
Failed to find symbol auth_unix_lookup
Failed to find symbol auth_unix_forget_old
Failed to find symbol auth_unix_add_addr
Failed to find symbol auth_domain_put
Failed to find symbol auth_domain_find
Failed to find symbol svc_seq_show
Failed to find symbol svc_proc_unregister
Failed to find symbol svc_proc_register
Failed to find symbol rpc_proc_unregister
Failed to find symbol rpc_proc_register
Failed to find symbol svc_set_client
Failed to find symbol svc_authenticate
Failed to find symbol auth_domain_lookup
Failed to find symbol svc_auth_register
Failed to find symbol svc_reserve
Failed to find symbol svc_makesock
Failed to find symbol svc_wake_up
Failed to find symbol svc_recv
Failed to find symbol svc_process
Failed to find symbol svc_drop
Failed to find symbol svc_destroy
Failed to find symbol svc_exit_thread
Failed to find symbol svc_create_thread
Failed to find symbol svc_create
Failed to find symbol put_rpccred
Failed to find symbol rpcauth_init_credcache
Failed to find symbol rpcauth_free_credcache
Failed to find symbol rpcauth_lookup_credcache
Failed to find symbol rpcauth_lookupcred
Failed to find symbol rpcauth_create
Failed to find symbol rpcauth_unregister
Failed to find symbol rpcauth_register
Failed to find symbol xprt_set_timeout
Failed to find symbol xprt_create_proto
Failed to find symbol rpc_mkpipe
Failed to find symbol rpc_queue_upcall
Failed to find symbol rpc_wake_up
Failed to find symbol rpc_unlink
Failed to find symbol rpc_setbufsize
Failed to find symbol rpc_restart_call
Failed to find symbol rpc_delay
Failed to find symbol rpc_clnt_sigunmask
Failed to find symbol rpc_clnt_sigmask
Failed to find symbol rpc_call_setup
Failed to find symbol rpc_call_async
Failed to find symbol rpc_call_sync
Failed to find symbol rpc_killall_tasks
Failed to find symbol rpc_shutdown_client
Failed to find symbol rpc_destroy_client
Failed to find symbol rpc_bind_new_program
Failed to find symbol rpc_clone_client
Failed to find symbol rpc_new_client
Failed to find symbol rpc_create_client
Failed to find symbol rpc_wake_up_status
Failed to find symbol rpc_new_task
Failed to find symbol rpciod_up
Failed to find symbol rpciod_down
Failed to find symbol rpc_wake_up_task
Failed to find symbol rpc_wake_up_next
Failed to find symbol rpc_sleep_on
Failed to find symbol rpc_init_task
Failed to find symbol rpc_execute
Failed to find symbol sunrpc_cache_update
Failed to find symbol sunrpc_cache_lookup
Failed to find symbol rpc_print_iostats
Failed to find symbol rpc_free_iostats
Failed to find symbol rpc_alloc_iostats
Failed to find symbol svc_addsock
load_module: umod=0000020000016010, len=856257, uargs=000000008001f0b0
Core section allocation order:
	.text
	.exit.text
	.fixup
	.rodata
	.rodata.str1.2
	__ex_table
	__versions
	.eh_frame
	.symtab
	.strtab
	.data
	.data.rel
	.data.rel.local
	.data.rel.ro
	.gnu.linkonce.this_module
	.bss
Init section allocation order:
	.init.text
final section addresses:
	0x20c5f544 .text
	0x20c62f64 .exit.text
	0x20836000 .init.text
	0x20c62f70 .fixup
	0x20c62fc0 .rodata
	0x20c63118 .rodata.str1.2
	0x20c63338 __ex_table
	0x20c633b8 __versions
	0x20c64338 .eh_frame
	0x20c99124 .data
	0x20c99128 .data.rel
	0x20c99348 .data.rel.local
	0x20c995e0 .data.rel.ro
	0x20c99800 .gnu.linkonce.this_module
	0x20c9db00 .bss
	0x20c64910 .symtab
	0x20c95750 .strtab
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
Absolute symbol: 0x00000000
eth0: no IPv6 routers present


