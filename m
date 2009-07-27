Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZG0Vhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZG0Vhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZG0Vhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:37:35 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:38965 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbZG0Vhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=aY6xCPE9hrGudrCm4R+iYrq63jqjWzZ1P3Lbv4RFnCs+sFDZvQVLFKd34dlYn49hri
         zjq1WIo2vooku4qq/f84lN2wZ60/OgSjQ74V7EKxYhOx0OcLBhk0aZHO0ssM1qiPRmC0
         Zjb9yBnpbRi/EVMz2zzsN6OgrBdn4S4Fz2FJE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: smatch and tun.c
Date: Mon, 27 Jul 2009 23:30:48 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
References: <alpine.DEB.2.00.0907241400310.12573@bicker> <200907262340.57339.bzolnier@gmail.com>
In-Reply-To: <200907262340.57339.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907272330.49101.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009 23:40:57 Bartlomiej Zolnierkiewicz wrote:
> On Saturday 25 July 2009 14:21:54 Dan Carpenter wrote:
> > Jonathan Corbet from lwn.net suggested that I write a smatch 
> > (http://repo.or.cz/w/smatch.git) script to prevent the tun.c type bugs 
> > from happening again.
> > 
> > I wrote two scripts.  One just looks for bugs where a variable is 
> > dereferenced while initializing a local variable and checked for NULL like 
> > this:
> > 	int x = foo->bar;
> > 	BUG_ON(!foo);  
> > I have a theory that sometimes peoople are sloppy when they initialize 
> > variables.  This script printed 96 warnings.  The other script prints 
> > those messages along with every other time a variable is dereferenced and 
> > then checked for NULL.  This script printed 685 messages.
> > 
> > Smatch scripts tends to have a lot of false positives.  The script that 
> > only printed problems with variable initialization was maybe 40% actual 
> > bugs but the one that checked everything was maybe 15% actual bugs.  I 
> > guess my theory is correct.
> > 
> > One thing that causes false positives is that some macros need to 
> > check for NULL pointers.  Also smatch doesn't handle loops correctly yet.  
> > Sometimes variables get changed inside another function and that isn't 
> > handled correctly yet.
> 
> Indeed there is still a lot of false positives but the functionality
> is already very useful so big thanks for doing it!
> 
> > By bugs, I don't mean security bugs, I mean picky little things.  Quite 
> > often places have useless checks for NULL.  But still it's worth fixing.
> 
> Yes, moreover they are a "noise" which makes discovery of real issues more
> time consuming and difficult. 
> 
> > I feel bad for just sending this email instead of proper bug reports and 
> > patches, but the truth is that I'm cycling through Africa on a bycicle.  I 
> > sleep in a tent.  It took me days to scrape together enough electricity 
> > and internet to send this one email...
> 
> You've just became my personal when it comes to the best use of available
> resources! ;)
> 
> > I have attached a zip file with the warnings from 2.6.31-rc3 allmodconfig.
> > Here are the instructions if you want to use a different config.
> >     git clone git://repo.or.cz/smatch.git
> >     cd smatch
> >     make
> >     cd /usr/src/linux
> >     make C=1 CHECK=/path/to/smatch modules bzImage | tee warns.txt 
> >     egrep '(warn|error):' warns.txt | egrep '(before|initializer)'
> 
> The last line needs to be:
> 
> 	egrep '(warn|warning|error):' warns.txt | egrep '(before|initializer)'
> 
> to make it work, also if somebody wants to see the same list but against
> current -next kernel it is here:
> 
> http://www.kernel.org/pub/linux/kernel/people/bart/null-pointer-err-list-next-0724.gz
> 
> [ some issues have been fixed already and some line numbers have changed ]
> 
> PS I'll also post a "filtered" list (without false positives) in a few days
> (I've verified ~50% of entries till now).

The filtered list (at the end of the mail) is down to 260 entries,
I removed all false positives, all macro related ones, all that have
been fixed by me or other people and all that were making my head
spin for too long.. ;)

I've also put quilt series (against current -next) with my patches
from Saturday (the TODO list is also there):

	http://www.kernel.org/pub/linux/kernel/people/bart/null-pointers/

Since I'm also going to fix some entries myself later (as my time permits,
I'll try to fix one such issue per day) please cc: me on related patches
to prevent duplicating efforts (thanks!).

I'll be updating the TODO list and patch series to keep track of the work
progress (I've just saw another patch series from Julia and I will make
needed updates to account for it tomorrow) -- once the patch is upstream
or in subsystem tree I'll drop it from my tree.


arch/x86/kernel/apic/io_apic.c +3241 destroy_irq(11) warning: variable derefenced before check 'desc'
arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced in initializer 'vcpu'
arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced before check 'vcpu'
arch/x86/mm/fault.c +1026 do_page_fault(91) warning: variable derefenced before check 'mm'
kernel/irq/resend.c +73 check_irq_resend(17) warning: variable derefenced before check 'desc->chip'
kernel/lockdep.c +1167 find_usage_backwards(22) warning: variable derefenced before check 'source'
kernel/lockdep.c +2588 __lock_acquire(57) warning: variable derefenced before check 'class'
fs/btrfs/inode.c +2607 btrfs_truncate_inode_items(28) warning: variable derefenced before check 'path'
fs/btrfs/inode.c +4788 btrfs_rename(36) warning: variable derefenced before check 'old_inode'
fs/btrfs/free-space-cache.c +339 btrfs_remove_free_space(77) warning: variable derefenced before check 'info'
fs/cifs/connect.c +2500 cifs_mount(244) warning: variable derefenced before check 'tcon'
fs/cifs/file.c +1088 cifs_user_write(85) warning: variable derefenced before check 'file->f_path.dentry'
fs/cifs/file.c +1205 cifs_write(99) warning: variable derefenced before check 'file->f_path.dentry'
fs/cifs/transport.c +582 SendReceive2(144) warning: variable derefenced before check 'midQ->resp_buf'
fs/cifs/transport.c +773 SendReceive(139) warning: variable derefenced before check 'midQ->resp_buf'
fs/coda/inode.c +204 coda_fill_super(62) warning: variable derefenced before check 'vc'
fs/configfs/dir.c +1050 configfs_depend_prep(6) warning: variable derefenced in initializer 'origin'
fs/configfs/dir.c +1050 configfs_depend_prep(6) warning: variable derefenced before check 'origin'
fs/ecryptfs/crypto.c +347 encrypt_scatterlist(12) warning: variable derefenced before check 'crypt_stat'
fs/fscache/page.c +561 fscache_write_op(42) warning: variable derefenced before check 'page'
fs/isofs/inode.c +1403 isofs_read_inode(186) warning: variable derefenced before check 'bh'
fs/jfs/namei.c +1179 jfs_rename(113) warning: variable derefenced before check 'new_ip'
fs/lockd/svclock.c +554 nlmsvc_testlock(84) warning: variable derefenced before check 'block'
fs/ncpfs/ioctl.c +445 __ncp_ioctl(180) warning: variable derefenced before check 'inode'
fs/nfs/client.c +1078 nfs_create_server(47) warning: variable derefenced before check 'server->nfs_client'
fs/nfs/client.c +1079 nfs_create_server(48) warning: variable derefenced before check 'server->nfs_client->rpc_ops'
fs/nfs/client.c +1363 nfs4_create_server(43) warning: variable derefenced before check 'server->nfs_client'
fs/nfs/client.c +1364 nfs4_create_server(44) warning: variable derefenced before check 'server->nfs_client->rpc_ops'
fs/nfs/nfs4proc.c +4290 nfs4_proc_exchange_id(20) warning: variable derefenced before check 'clp'
fs/ntfs/attrib.c +350 ntfs_attr_vcn_to_lcn_nolock(10) warning: variable derefenced before check 'ni'
fs/ntfs/attrib.c +473 ntfs_attr_find_vcn_nolock(10) warning: variable derefenced before check 'ni'
fs/ntfs/file.c +315 ntfs_attr_extend_initialized(203) warning: variable derefenced before check 'ctx'
fs/ntfs/mft.c +1991 ntfs_mft_data_extend_allocation_nolock(277) warning: variable derefenced before check 'ctx'
fs/ocfs2/aops.c +281 ocfs2_readpage(7) warning: variable derefenced in initializer 'page'
fs/ocfs2/dlmglue.c +1495 ocfs2_create_new_inode_locks(5) warning: variable derefenced before check 'inode'
fs/ocfs2/dlmglue.c +1543 ocfs2_rw_lock(6) warning: variable derefenced before check 'inode'
fs/ocfs2/dlmglue.c +1594 ocfs2_open_lock(6) warning: variable derefenced before check 'inode'
fs/ocfs2/dlmglue.c +1622 ocfs2_try_open_lock(6) warning: variable derefenced before check 'inode'
fs/ocfs2/dlmglue.c +2221 ocfs2_inode_lock_full_nested(12) warning: variable derefenced before check 'inode'
fs/ocfs2/inode.c +525 ocfs2_read_locked_inode(143) warning: variable derefenced before check 'args'
fs/ocfs2/journal.c +352 ocfs2_start_trans(5) warning: variable derefenced in initializer 'osb'
fs/ocfs2/journal.c +352 ocfs2_start_trans(5) warning: variable derefenced before check 'osb'
fs/ocfs2/namei.c +1237 ocfs2_rename(219) warning: variable derefenced before check 'newfe_bh'
fs/ocfs2/namei.c +1237 ocfs2_rename(219) warning: variable derefenced before check 'newfe_bh'
fs/ocfs2/namei.c +1237 ocfs2_rename(219) warning: variable derefenced before check 'newfe_bh'
fs/reiserfs/lbalance.c +895 leaf_paste_in_buffer(23) warning: variable derefenced in initializer 'bi'
fs/reiserfs/lbalance.c +895 leaf_paste_in_buffer(23) warning: variable derefenced before check 'bi'
fs/ubifs/io.c +703 ubifs_read_node_wbuf(9) warning: variable derefenced in initializer 'wbuf'
fs/ubifs/io.c +703 ubifs_read_node_wbuf(9) warning: variable derefenced before check 'wbuf'
fs/ubifs/tnc.c +1654 read_wbuf(7) warning: variable derefenced in initializer 'wbuf'
fs/ubifs/tnc.c +1654 read_wbuf(7) warning: variable derefenced before check 'wbuf'
fs/xfs/xfs_dir2_leaf.c +1559 xfs_dir2_leaf_removename(126) warning: variable derefenced before check 'dbp'
fs/xfs/xfs_log_recover.c +142 xlog_bread_noalign(22) warning: variable derefenced before check 'bp'
fs/xfs/xfs_mru_cache.c +387 xfs_mru_cache_create(49) warning: variable derefenced before check 'mru'
security/smack/smack_lsm.c +2299 smack_d_instantiate(114) warning: variable derefenced before check 'opt_dentry'
drivers/atm/fore200e.c +1512 fore200e_close(7) warning: variable derefenced before check 'vcc'
drivers/atm/fore200e.c +1573 fore200e_send(18) warning: variable derefenced before check 'vcc'
drivers/atm/fore200e.c +1575 fore200e_send(20) warning: variable derefenced before check 'fore200e'
drivers/base/core.c +273 show_uevent(22) warning: variable derefenced before check 'kset->uevent_ops'
drivers/base/core.c +718 device_add_class_symlinks(52) warning: variable derefenced before check 'dev->parent'
drivers/base/core.c +1677 device_move(43) warning: variable derefenced before check 'old_parent'
drivers/block/DAC960.c +2345 DAC960_V2_ReportDeviceConfiguration(19) warning: variable derefenced before check 'PhysicalDeviceInfo'
drivers/char/ip2/ip2main.c +1637 ip2_close(48) warning: variable derefenced in initializer 'tty'
drivers/char/ip2/ip2main.c +1637 ip2_close(48) warning: variable derefenced before check 'tty'
drivers/char/pcmcia/synclink_cs.c +1120 cts_change(18) warning: variable derefenced before check 'tty'
drivers/char/pcmcia/synclink_cs.c +1130 cts_change(28) warning: variable derefenced before check 'tty'
drivers/char/nozomi.c +1621 ntty_close(7) warning: variable derefenced before check 'nport'
drivers/char/rocket.c +438 rp_do_transmit(10) warning: variable derefenced before check 'info'
drivers/char/mxser.c +905 mxser_startup(49) warning: variable derefenced in initializer 'tty'
drivers/char/mxser.c +905 mxser_startup(49) warning: variable derefenced before check 'tty'
drivers/char/mxser.c +1090 mxser_close(9) warning: variable derefenced before check 'info'
drivers/char/mxser.c +2224 mxser_transmit_chars(41) warning: variable derefenced before check 'tty'
drivers/char/isicom.c +922 isicom_shutdown_port(28) warning: variable derefenced before check 'tty'
drivers/char/isicom.c +962 isicom_close(7) warning: variable derefenced before check 'ip'
drivers/char/synclink.c +1372 mgsl_isr_io_pin(85) warning: variable derefenced before check 'info->port.tty'
drivers/char/synclink.c +1382 mgsl_isr_io_pin(95) warning: variable derefenced before check 'info->port.tty'
drivers/char/synclink.c +2034 mgsl_put_char(14) warning: variable derefenced in initializer 'tty'
drivers/char/synclink.c +2034 mgsl_put_char(14) warning: variable derefenced before check 'tty'
drivers/char/synclink.c +2124 mgsl_write(14) warning: variable derefenced in initializer 'tty'
drivers/char/synclink.c +2124 mgsl_write(14) warning: variable derefenced before check 'tty'
drivers/cpuidle/governors/ladder.c +72 ladder_select_state(7) warning: variable derefenced in initializer 'ldev'
drivers/cpuidle/governors/ladder.c +72 ladder_select_state(7) warning: variable derefenced before check 'ldev'
drivers/edac/i3000_edac.c +434 i3000_probe1(129) warning: variable derefenced before check 'mci'
drivers/edac/x38_edac.c +406 x38_probe1(88) warning: variable derefenced before check 'mci'
drivers/firmware/efivars.c +197 efivar_guid_read(5) warning: variable derefenced before check 'entry'
drivers/firmware/efivars.c +214 efivar_attr_read(6) warning: variable derefenced before check 'entry'
drivers/firmware/efivars.c +237 efivar_size_read(6) warning: variable derefenced before check 'entry'
drivers/firmware/efivars.c +254 efivar_data_read(5) warning: variable derefenced before check 'entry'
drivers/firmware/efivars.c +318 efivar_show_raw(5) warning: variable derefenced before check 'entry'
drivers/gpu/drm/i915/intel_sdvo.c +2047 intel_sdvo_init(178) warning: variable derefenced before check 'intel_output->i2c_bus'
drivers/gpu/drm/i915/intel_tv.c +1275 intel_tv_mode_set(159) warning: variable derefenced before check '
drivers/infiniband/hw/mlx4/cq.c +400 mlx4_ib_resize_cq(56) warning: variable derefenced before check 'cq->resize_buf'
drivers/isdn/hardware/eicon/message.c +4956 sig_ind(126) warning: variable derefenced before check 'plci'
drivers/isdn/hisax/l3dss1.c +2215 l3dss1_cmd_global(49) warning: variable derefenced before check 'pc'
drivers/isdn/hisax/l3dss1.c +2220 l3dss1_cmd_global(54) warning: variable derefenced before check 'pc'
drivers/isdn/hysdn/hysdn_net.c +193 hysdn_rx_netpkt(6) warning: variable derefenced in initializer 'lp'
drivers/isdn/hysdn/hysdn_net.c +193 hysdn_rx_netpkt(6) warning: variable derefenced before check 'lp'
drivers/md/raid5.c +4631 run(171) warning: variable derefenced before check 'conf'
drivers/media/dvb/dvb-usb/anysee.c +482 anysee_probe(30) warning: variable derefenced before check 'd'
drivers/media/dvb/dvb-usb/opera1.c +487 opera1_xilinx_load_firmware(49) warning: variable derefenced before check 'fw'
drivers/media/dvb/frontends/stv0900_core.c +1419 stv0900_init_internal(29) warning: variable derefenced before check 'state->internal'
drivers/media/video/cpia.c +3746 cpia_mmap(17) warning: variable derefenced before check 'cam'
drivers/media/video/ov511.c +5920 ov51x_disconnect(10) warning: variable derefenced before check 'ov'
drivers/media/video/ov511.c +5949 ov51x_disconnect(39) warning: variable derefenced before check 'ov'
drivers/media/video/s2255drv.c +2625 s2255_disconnect(22) warning: variable derefenced before check 'dev'
drivers/media/video/cx18/cx18-dvb.c +254 cx18_dvb_start_feed(44) warning: variable derefenced in initializer 'stream'
drivers/media/video/cx18/cx18-dvb.c +254 cx18_dvb_start_feed(44) warning: variable derefenced before check 'stream'
drivers/media/video/cx18/cx18-dvb.c +286 cx18_dvb_stop_feed(10) warning: variable derefenced in initializer 'stream'
drivers/media/video/cx18/cx18-dvb.c +286 cx18_dvb_stop_feed(10) warning: variable derefenced before check 'stream'
drivers/media/video/cx231xx/cx231xx-core.c +125 cx231xx_register_extension(8) warning: variable derefenced before check 'dev'
drivers/media/video/cx231xx/cx231xx-core.c +141 cx231xx_unregister_extension(6) warning: variable derefenced before check 'dev'
drivers/media/video/et61x251/et61x251_core.c +2634 et61x251_usb_probe(98) warning: variable derefenced before check 'cam'
drivers/media/video/pvrusb2/pvrusb2-io.c +476 buffer_complete(41) warning: variable derefenced before check 'sp'
drivers/media/video/sn9c102/sn9c102_core.c +3378 sn9c102_usb_probe(132) warning: variable derefenced before check 'cam'
drivers/media/video/usbvideo/ibmcam.c +406 ibmcam_parse_lines(16) warning: variable derefenced before check 'uvd'
drivers/media/video/usbvideo/quickcam_messenger.c +699 qcm_stop_data(6) warning: variable derefenced before check 'uvd'
drivers/media/video/usbvision/usbvision-video.c +1495 usbvision_register_video(39) warning: variable derefenced before check 'usbvision->vdev'
drivers/media/video/zc0301/zc0301_core.c +2020 zc0301_usb_probe(84) warning: variable derefenced before check 'cam'
drivers/message/fusion/mptbase.c +593 mptbase_reply(20) warning: variable derefenced before check 'reply'
drivers/message/i2o/i2o_block.c +724 i2o_block_transfer(14) warning: variable derefenced before check 'dev->i2o_dev'
drivers/message/i2o/i2o_scsi.c +535 i2o_scsi_queuecommand(26) warning: variable derefenced before check 'i2o_dev'
drivers/mtd/chips/cfi_cmdset_0002.c +512 cfi_	amdstd_setup(59) warning: variable derefenced in initializer 'mtd'
drivers/mtd/chips/cfi_cmdset_0002.c +512 cfi_amdstd_setup(59) warning: variable derefenced before check 'mtd'
drivers/mtd/chips/cfi_cmdset_0001.c +604 cfi_intelext_setup(69) warning: variable derefenced in initializer 'mtd'
drivers/mtd/chips/cfi_cmdset_0001.c +604 cfi_intelext_setup(69) warning: variable derefenced before check 'mtd'
drivers/mtd/maps/nettel.c +390 nettel_init(227) warning: variable derefenced before check 'amd_mtd'
drivers/net/hamradio/6pack.c +675 sixpack_open(90) warning: variable derefenced before check 'dev'
drivers/net/hamradio/yam.c +870 yam_open(9) warning: variable derefenced before check 'dev'
drivers/net/irda/nsc-ircc.c +1260 nsc_ircc_change_speed(10) warning: variable derefenced in initializer 'self'
drivers/net/irda/nsc-ircc.c +1260 nsc_ircc_change_speed(10) warning: variable derefenced before check 'self'
drivers/net/ixgbe/ixgbe_ethtool.c:1181:5: warning: symbol 'before' shadows an earlier one
drivers/net/ixgbe/ixgbe_ethtool.c:1186:5: warning: symbol 'before' shadows an earlier one
drivers/net/ixgbe/ixgbe_ethtool.c:1196:5: warning: symbol 'before' shadows an earlier one
drivers/net/ixgbe/ixgbe_ethtool.c:1201:5: warning: symbol 'before' shadows an earlier one
drivers/net/ixgbe/ixgbe_ethtool.c:1206:5: warning: symbol 'before' shadows an earlier one
drivers/net/qlge/qlge_main.c +1803 ql_clean_outbound_rx_ring(35) warning: variable derefenced before check 'net_rsp'
drivers/net/tokenring/tms380tr.c +1352 tms380tr_reset_adapter(75) warning: variable derefenced before check 'fw_entry'
drivers/net/tokenring/tms380tr.c +1358 tms380tr_reset_adapter(81) warning: variable derefenced before check
drivers/net/wireless/arlan-proc.c +625 arlan_sysctl_info(220) warning: variable derefenced before check 'ctl'
drivers/net/wireless/at76c50x-usb.c +1536 at76_rx_tasklet(9) warning: variable derefenced in initializer 'urb'
drivers/net/wireless/at76c50x-usb.c +1536 at76_rx_tasklet(9) warning: variable derefenced before check 'urb'
drivers/net/wireless/ray_cs.c +1514 ray_get_wireless_stats(6) warning: variable derefenced in initializer 'local'
drivers/net/wireless/ray_cs.c +1514 ray_get_wireless_stats(6) warning: variable derefenced before check 'local'
drivers/net/wireless/rndis_wlan.c +2490 rndis_wlan_unbind(13) warning: variable derefenced before check 'priv'
drivers/net/wireless/mwl8k.c +1457 mwl8k_txq_xmit(64) warning: variable derefenced before check 'skb'
drivers/net/wireless/mwl8k.c +2240 mwl8k_finalize_join(37) warning: variable derefenced before check 'payload'
drivers/net/wireless/mac80211_hwsim.c +431 mac80211_hwsim_tx_frame(28) warning: variable derefenced before check 'data->channel'
drivers/net/wireless/hostap/hostap_plx.c +568 prism2_plx_probe(137) warning: variable derefenced before check 'dev'
drivers/net/wireless/hostap/hostap_pci.c +356 prism2_pci_probe(67) warning: variable derefenced before check 'dev'
drivers/net/wireless/ipw2x00/ipw2200.c +8472 ipw_rx(173) warning: variable derefenced before check 'rxb->skb'
drivers/net/wireless/ipw2x00/libipw_rx.c +802 ieee80211_rx(471) warning: variable derefenced before check 'skb'
drivers/net/wireless/iwlwifi/iwl3945-base.c +1416 iwl3945_rx_handle(74) warning: variable derefenced before check 'rxb'
drivers/net/wireless/iwlwifi/iwl3945-base.c +1416 iwl3945_rx_handle(74) warning: variable derefenced before check 'rxb->skb'
drivers/net/wireless/iwlwifi/iwl-agn.c +836 iwl_rx_handle(78) warning: variable derefenced before check 'rxb'
drivers/net/wireless/iwlwifi/iwl-agn.c +836 iwl_rx_handle(78) warning: variable derefenced before check 'rxb->skb'
drivers/net/wireless/iwmc3200wifi/rx.c +708 iwm_mlme_update_bss_table(48) warning: variable derefenced before check 'bss'
drivers/net/wireless/libertas/cmdresp.c +421 lbs_process_command_response(142) warning: variable derefenced before check 'priv->cur_cmd'
drivers/net/wireless/libertas/if_usb.c +356 if_usb_disconnect(12) warning: variable derefenced before check 'priv'
drivers/net/wireless/libertas_tf/cmd.c +653 lbtf_process_rx_command(73) warning: variable derefenced before check 'priv->cur_cmd'
drivers/net/rrunner.c +221 rr_init_one(130) warning: variable derefenced before check 'pdev'
drivers/net/pcnet32.c +1855 pcnet32_probe1(264) warning: variable derefenced before check 'a'
drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'
drivers/net/tlan.c +568 TLan_probe1(38) warning: variable derefenced before check 'pdev'
drivers/net/ppp_synctty.c +601 ppp_sync_txmunge(41) warning: variable derefenced before check 'skb'
drivers/net/ppp_synctty.c +677 ppp_sync_push(37) warning: variable derefenced before check 'ap->tpkt'
drivers/net/pppol2tp.c +1568 pppol2tp_prepare_tunnel_socket(105) warning: variable derefenced before check 'sock'
drivers/net/ethoc.c +897 ethoc_probe(31) warning: variable derefenced before check 'res'
drivers/pci/hotplug/cpqphp_ctrl.c +2627 configure_new_function(261) warning: variable derefenced before check 'hold_bus_node'
drivers/pci/hotplug/cpqphp_ctrl.c +2627 configure_new_function(261) warning: variable derefenced before check 'bus_node'
drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning: variable derefenced before check 'fujitsu'
drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning: variable derefenced before check 'fujitsu'
drivers/rtc/rtc-ds1307.c +899 ds1307_probe(276) warning: variable derefenced before check 'ds1307->rtc'
drivers/rtc/rtc-m48t59.c +507 m48t59_rtc_probe(113) warning: variable derefenced before check 'm48t59'
drivers/scsi/aacraid/aachba.c +1531 io_callback(50) warning: variable derefenced before check 'fibptr'
drivers/scsi/aacraid/commsup.c +820 aac_handle_aif(44) warning: variable derefenced before check 'dev'
drivers/scsi/aacraid/commsup.c +1071 aac_handle_aif(295) warning: variable derefenced before check 'dev'
drivers/scsi/aacraid/commsup.c +1736 aac_command_thread(227) warning: variable derefenced before check 'dev->queues'
drivers/scsi/cxgb3i/cxgb3i_pdu.c +464 cxgb3i_conn_pdu_ready(28) warning: variable derefenced in initializer 'c3cn'
drivers/scsi/cxgb3i/cxgb3i_pdu.c +464 cxgb3i_conn_pdu_ready(28) warning: variable derefenced before check 'c3cn'
drivers/scsi/fcoe/fcoe.c +1208 fcoe_percpu_receive_thread(38) warning: variable derefenced before check 'skb->dev'
drivers/scsi/lpfc/lpfc_sli.c +4626 lpfc_mbox_timeout_handler(13) warning: variable derefenced before check 'pmbox'
drivers/scsi/lpfc/lpfc_sli.c +5716 __lpfc_sli_issue_iocb_s3(91) warning: variable derefenced before check 'piocb'
drivers/scsi/lpfc/lpfc_els.c +2747 lpfc_els_retry(234) warning: variable derefenced before check 'ndlp'
drivers/scsi/lpfc/lpfc_scsi.c +2210 lpfc_scsi_cmd_iocb_cmpl(29) warning: variable derefenced in initializer 'cmd->device'
drivers/scsi/lpfc/lpfc_scsi.c +2210 lpfc_scsi_cmd_iocb_cmpl(29) warning: variable derefenced before check 'cmd->device'
drivers/scsi/mpt2sas/mpt2sas_scsih.c +3543 _scsih_expander_add(126) warning: variable derefenced before check 'sas_expander'
drivers/scsi/mvsas/mv_sas.c +1363 mvs_dev_gone_notify(9) warning: variable derefenced in initializer 'mvi_dev'
drivers/scsi/mvsas/mv_sas.c +1363 mvs_dev_gone_notify(9) warning: variable derefenced before check 'mvi_dev'
drivers/scsi/qla2xxx/qla_os.c +2065 qla2x00_remove_one(9) warning: variable derefenced before check 'vha'
drivers/scsi/qla2xxx/qla_init.c +3295 qla2x00_update_fcports(6) warning: variable derefenced before check 'fcport'
drivers/scsi/qla2xxx/qla_mbx.c +2773 qla24xx_report_id_acquisition(39) warning: variable derefenced before check 'vp'
drivers/scsi/sym53c8xx_2/sym_hipd.c +2625 sym_int_ma(223) warning: variable derefenced before check 'cp'
drivers/scsi/ncr53c8xx.c +4799 ncr_detach(95) warning: variable derefenced before check 'np->ccb'
drivers/scsi/ncr53c8xx.c +5642 ncr_setup_tags(10) warning: variable derefenced before check 'tp'
drivers/scsi/ncr53c8xx.c +5642 ncr_setup_tags(10) warning: variable derefenced in initializer 'sdev'
drivers/scsi/ncr53c8xx.c +5642 ncr_setup_tags(10) warning: variable derefenced before check 'sdev'
drivers/scsi/ncr53c8xx.c +6759 ncr_int_sir(67) warning: variable derefenced before check 'cp'
drivers/scsi/ips.c +1872 ips_flash_firmware(37) warning: variable derefenced before check 'scb->scsi_cmd'
drivers/scsi/ips.c +2798 ips_next(189) warning: variable derefenced before check 'scb->scsi_cmd'
drivers/scsi/ips.c +2810 ips_next(201) warning: variable derefenced before check 'scb->scsi_cmd'
drivers/scsi/ips.c +3292 ips_done(64) warning: variable derefenced before check 'scb->scsi_cmd'
drivers/scsi/ips.c +3300 ips_done(72) warning: variable derefenced before check 'scb->scsi_cmd'
drivers/spi/spi_gpio.c +290 spi_gpio_probe(26) warning: variable derefenced before check 'pdata'
drivers/usb/host/r8a66597-hcd.c +825 force_dequeue(10) warning: variable derefenced before check 'td'
drivers/usb/host/r8a66597-hcd.c +2025 get_r8a66597_device(7) warning: variable derefenced before check 'dev'
drivers/usb/misc/ftdi-elan.c +2841 ftdi_elan_probe(93) warning: variable derefenced before check 'ftdi'
drivers/usb/serial/io_ti.c +2141 edge_send(54) warning: variable derefenced in initializer 'tty'
drivers/usb/serial/io_ti.c +2141 edge_send(54) warning: variable derefenced before check 'tty'
drivers/video/geode/gx1fb_core.c +378 gx1fb_probe(56) warning: variable derefenced before check 'info'
drivers/video/geode/lxfb_core.c +584 lxfb_probe(84) warning: variable derefenced before check 'info'
drivers/video/matrox/matroxfb_base.c +1965 matroxfb_unregister_driver(11) warning: variable derefenced before check 'drv'
drivers/video/via/viafbdev.c +1159 viafb_cursor(97) warning: variable derefenced before check 'info->par'
sound/core/pcm.c +957 snd_pcm_dev_register(9) warning: variable derefenced in initializer 'device'
sound/core/pcm.c +957 snd_pcm_dev_register(9) warning: variable derefenced before check 'device'
sound/core/control.c +1123 snd_ctl_tlv_ioctl(33) warning: variable derefenced in initializer 'file'
sound/core/control.c +1123 snd_ctl_tlv_ioctl(33) warning: variable derefenced before check 'file'
sound/oss/uart401.c +416 unload_uart401(20) warning: variable derefenced before check 'devc'
sound/pci/ali5451/ali5451.c +939 snd_ali_update_ptr(25) warning: variable derefenced before check 'pvoice->substream'
sound/pci/emu10k1/emufx.c +2344 _snd_emu10k1_init_efx(561) warning: variable derefenced before check 'icode'
sound/pci/hda/patch_sigmatel.c +3819 stac92xx_parse_auto_config(117) warning: variable derefenced before check 'codec->beep'
sound/soc/soc-jack.c +66 snd_soc_jack_report(7) warning: variable derefenced in initializer 'jack'
sound/soc/soc-jack.c +66 snd_soc_jack_report(7) warning: variable derefenced before check 'jack'
net/9p/trans_rdma.c +246 p9_cm_event_handler(23) warning: variable derefenced in initializer 'c'
net/9p/trans_rdma.c +246 p9_cm_event_handler(23) warning: variable derefenced before check 'c'
net/dcb/dcbnl.c +1005 dcb_doit(6) warning: variable derefenced before check 'skb'
net/decnet/dn_route.c +627 dn_route_rcv(57) warning: variable derefenced before check 'dev'
net/decnet/dn_route.c +1128 dn_route_output_slow(266) warning: variable derefenced before check 'dev_out'
net/econet/af_econet.c +399 econet_sendmsg(136) warning: variable derefenced before check 'dev'
net/ipv4/arp.c +360 arp_solicit(33) warning: variable derefenced before check 'in_dev'
net/ipv4/cipso_ipv4.c +427 cipso_v4_cache_add(46) warning: variable derefenced before check 'entry'
net/ipv4/cipso_ipv4.c +480 cipso_v4_doi_add(12) warning: variable derefenced before check 'doi_def'
net/ipv6/netfilter/ip6t_ah.c +80 ah_mt6(41) warning: variable derefenced before check 'ah'
net/ipv6/netfilter/ip6t_hbh.c +88 hbh_mt6(43) warning: variable derefenced before check 'oh'
net/ipv6/netfilter/ip6t_rt.c +95 rt_mt6(56) warning: variable derefenced before check 'rh'
net/ipv6/ip6_fib.c +799 fib6_add(114) warning: variable derefenced before check 'fn'
net/ipv6/proc.c +262 snmp6_unregister_dev(5) warning: variable derefenced before check 'idev'
net/irda/irlap_event.c +1458 irlap_state_nrm_p(265) warning: variable derefenced before check 'info'
net/irda/irqueue.c +847 hashbin_get_first(8) warning: variable derefenced before check 'hashbin'
net/irda/af_irda.c +596 irda_find_lsap_sel(54) warning: variable derefenced before check 'self->ias_result'
net/irda/ircomm/ircomm_tty.c +499 ircomm_tty_close(7) warning: variable derefenced before check 'tty'
net/irda/ircomm/ircomm_tty.c +1010 ircomm_tty_hangup(10) warning: variable derefenced before check 'tty'
net/llc/af_llc.c +808 llc_ui_recvmsg(146) warning: variable derefenced before check 'skb'
net/netlabel/netlabel_cipso_v4.c +327 netlbl_cipsov4_add_std(186) warning: variable derefenced before check 'doi_def'
net/netrom/nr_route.c +180 nr_add_node(91) warning: variable derefenced before check 'nr_neigh'
net/packet/af_packet.c +826 tpacket_destruct_skb(5) warning: variable derefenced before check 'skb'
net/rfkill/core.c +887 rfkill_register(6) warning: variable derefenced before check 'rfkill'
net/sched/sch_api.c +354 qdisc_get_stab(24) warning: variable derefenced before check 's'
net/sched/act_api.c +968 tc_ctl_action(4) warning: variable derefenced before check 'skb'
net/sched/sch_atm.c +438 atm_tc_enqueue(54) warning: variable derefenced before check 'flow'
net/sctp/endpointola.c +478 sctp_endpoint_bh_rcv(80) warning: variable derefenced before check 'chunk'
net/sctp/associola.c +1093 sctp_assoc_bh_rcv(55) warning: variable derefenced before check 'chunk'
net/sctp/sm_make_chunk.c +472 sctp_make_init_ack(140) warning: variable derefenced before check 'chunk'
net/sctp/outqueue.c +332 sctp_outq_tail(34) warning: variable derefenced before check 'chunk'
net/sctp/outqueue.c +332 sctp_outq_tail(34) warning: variable derefenced before check 'chunk->chunk_hdr'
net/sctp/outqueue.c +979 sctp_outq_flush(261) warning: variable derefenced before check 'chunk'
net/sctp/input.c +511 sctp_err_lookup(73) warning: variable derefenced before check 'asoc'
net/sctp/ipv6.c +584 sctp_v6_addr_valid(13) warning: variable derefenced before check 'sp'
net/unix/af_unix.c +1177 unix_stream_connect(162) warning: variable derefenced before check 'other'
net/wireless/scan.c +512 cfg80211_inform_bss_frame(16) warning: variable derefenced in initializer 'wiphy'
net/wireless/scan.c +512 cfg80211_inform_bss_frame(16) warning: variable derefenced before check 'wiphy'
