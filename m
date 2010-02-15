Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0BOMlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:41:23 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:44212 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab0BOMlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=OeXc6kAo7M2R7QKgJHZpj1VJCHD/67UlfQL01yIwCSxy/Zf0toHjws1dUP4uYeXClt
         WSwSR0DlHSaCHOeSXd+Vidx42rhfooTcS7QazIcuyIjBn96p7d6dBy2dF1w/iLmYlWXt
         ItHL8EwcT7LgrlQfaJ4BOHSC/V6bo0+7HxoPo=
Date: Mon, 15 Feb 2010 15:40:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: bug list: range checking issues
Message-ID: <20100215124046.GB18821@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the results from:
    make C=1 CHECK="/path/to/smatch -p=kernel" bzImage modules | tee warns.txt
    grep -w overflow warns.txt | uniq -f 3 | tee err-list

I hacked on the buffer overflow check last weekend and these are the 
results.  It has way more false positives than the other bug lists 
I've posted, but it's still kinda neat.

It works like this:

lib/zlib_inflate/inftrees.c
   112      for (min = 1; min <= MAXBITS; min++)
   113          if (count[min] != 0) break;
   114      if (root < min) root = min;
smatch thinks "min" can be MAXBITS here.

One bad thing is that if you have code like:
        if (foo == 42)
		frob();
Smatch thinks that "foo" can be 43 after the if statement.

The format is:
file.c +<line> function(<lines into function>) warning 'array_name' <array size> <= <offset>

regards,
dan carpenter

Previous bug lists:
* Putting too much data on the stack
  http://lkml.indiana.edu/hypermail/linux/kernel/1002.1/01252.html

* Assigning negative values to unsigned variables
  http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01222.html

* Doing dma on the stack
  http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01231.html

* Dereferencing variables before verifying they are not null
  http://lkml.indiana.edu/hypermail/linux/kernel/1001.3/01980.html

kernel/pid_namespace.c +96 create_pid_namespace(26) warn: buffer overflow 'ns->pidmap' 1 <= 1
fs/btrfs/ctree.c +1003 balance_level(27) error: buffer overflow 'path->slots' 8 <= 8
fs/btrfs/ctree.c +4131 btrfs_find_next_key(20) error: buffer overflow 'path->nodes' 8 <= 8
fs/btrfs/ctree.c +4134 btrfs_find_next_key(23) error: buffer overflow 'path->locks' 8 <= 8
fs/btrfs/ctree.c +4296 btrfs_next_leaf(101) error: buffer overflow 'path->slots' 8 <= 9
fs/fuse/file.c +592 fuse_readpages_fill(20) error: buffer overflow 'req->pages' 32 <= 32
fs/gfs2/ops_fstype.c +157 gfs2_check_sb(18) error: buffer overflow 'gfs2_old_fs_formats' 1 <= 1
fs/gfs2/ops_fstype.c +174 gfs2_check_sb(35) error: buffer overflow 'gfs2_old_multihost_formats' 1 <= 1
fs/jfs/inode.c +68 jfs_iget(34) error: buffer overflow 'JFS_IP(inode)->u.link._inline' 128 <= 255
fs/jfs/jfs_txnmgr.c +1788 xtLog(86) warn: buffer overflow 'p->xad' 18 <= 256
fs/jfs/jfs_txnmgr.c +1790 xtLog(88) error: buffer overflow 'p->xad' 18 <= 256
fs/jfs/jfs_txnmgr.c +1800 xtLog(98) warn: buffer overflow 'p->xad' 18 <= 256
fs/nfs/callback_xdr.c +104 decode_fh(14) warn: buffer overflow 'fh->data' 128 <= 128
fs/nfsd/nfs4xdr.c +1399 nfsd4_decode_compound(37) warn: buffer overflow 'nfsd4_minorversion' 2 <= 2
fs/xfs/xfs_attr_leaf.c +1097 xfs_attr_leaf_add_work(33) warn: buffer overflow 'hdr->freemap' 3 <= 3
fs/xfs/xfs_da_btree.c +159 xfs_da_split(15) error: buffer overflow 'state->path.blk' 5 <= 5
fs/xfs/xfs_da_btree.c +162 xfs_da_split(18) warn: buffer overflow 'state->path.blk' 5 <= 5
fs/xfs/xfs_dir2_block.c +1152 xfs_dir2_sf_to_block(128) error: buffer overflow 'dep->name' 1 <= 1
fs/xfs/xfs_dir2_leaf.c +504 xfs_dir2_leaf_addname(343) warn: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_leaf.c +585 xfs_dir2_leaf_check(30) error: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_node.c +253 xfs_dir2_leafn_add(69) warn: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_node.c +286 xfs_dir2_leafn_add(102) error: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_node.c +305 xfs_dir2_leafn_add(121) warn: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_node.c +316 xfs_dir2_leafn_add(132) error: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_node.c +320 xfs_dir2_leafn_add(136) warn: buffer overflow 'leaf->ents' 1 <= 2
fs/xfs/xfs_dir2_node.c +321 xfs_dir2_leafn_add(137) warn: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_node.c +361 xfs_dir2_leafn_check(15) error: buffer overflow 'leaf->ents' 1 <= 1
fs/xfs/xfs_dir2_sf.c +115 xfs_dir2_block_sfsize(44) error: buffer overflow 'dep->name' 1 <= 1
fs/xfs/xfs_inode.c +3562 xfs_iext_remove_inline(14) warn: buffer overflow 'ifp->if_u2.if_inline_ext' 2 <= 2
crypto/vmac.c +469 vmac(15) error: buffer overflow 'in_n' 8 <= 15
crypto/vmac.c +497 vmac_set_key(17) error: buffer overflow 'in' 8 <= 15
drivers/ata/pata_cs5535.c +155 cs5535_set_dmamode(16) error: buffer overflow 'mwdma_timings' 3 <= 31
drivers/ata/pata_sc1200.c +139 sc1200_set_dmamode(23) error: buffer overflow 'mwdma_timing[clock]' 3 <= 31
drivers/ata/pata_serverworks.c +291 serverworks_set_dmamode(21) error: buffer overflow 'dma_mode' 3 <= 31
drivers/ata/pata_sil680.c +185 sil680_set_dmamode(33) error: buffer overflow 'dma_table' 3 <= 31
drivers/ata/pata_piccolo.c +60 tosh_set_dmamode(15) error: buffer overflow 'mwdma' 4 <= 31
drivers/block/floppy.c +4434 floppy_release_regions(2) warn: buffer overflow 'io_regions' 3 <= 3
drivers/block/cciss_scsi.c +449 cciss_scsi_remove_entry(14) error: buffer overflow 'ccissscsi[ctlr]->dev' 16 <= 16
drivers/char/tpm/tpm.c +353 tpm_calc_ordinal_duration(11) error: buffer overflow 'tpm_protected_ordinal_duration' 12 <= 243
drivers/gpu/drm/nouveau/nouveau_bios.c +770 get_tmds_index_reg(36) error: buffer overflow 'pramdac_table' 4 <= 4
drivers/gpu/drm/nouveau/nouveau_i2c.c +262 nouveau_i2c_find(9) error: buffer overflow 'bios->bdcb.dcb.i2c' 16 <= 16
drivers/gpu/drm/nouveau/nouveau_i2c.c +263 nouveau_i2c_find(10) warn: buffer overflow 'bios->bdcb.dcb.i2c' 16 <= 16
drivers/gpu/drm/nouveau/nouveau_i2c.c +267 nouveau_i2c_find(14) error: buffer overflow 'bios->bdcb.dcb.i2c' 16 <= 16
drivers/gpu/drm/radeon/radeon_atombios.c +1210 radeon_atom_get_tv_timings(19) error: buffer overflow 'tv_info->aModeTimings' 2 <= 2
drivers/gpu/drm/radeon/radeon_atombios.c +1248 radeon_atom_get_tv_timings(57) warn: buffer overflow 'tv_info_v1_2->aModeTimings' 2 <= 3
drivers/gpu/drm/radeon/radeon_legacy_tv.c +633 radeon_legacy_tv_mode_set(121) error: buffer overflow 'SLOPE_value' 5 <= 5
drivers/gpu/drm/radeon/radeon_legacy_tv.c +637 radeon_legacy_tv_mode_set(125) error: buffer overflow 'YCOEF_EN_value' 5 <= 5
drivers/gpu/drm/radeon/radeon_legacy_tv.c +637 radeon_legacy_tv_mode_set(125) error: buffer overflow 'YCOEF_value' 5 <= 5
drivers/gpu/drm/radeon/radeon_legacy_tv.c +638 radeon_legacy_tv_mode_set(126) error: buffer overflow 'SLOPE_value' 5 <= 5
drivers/gpu/drm/via/via_video.c +85 via_decoder_futex(17) warn: buffer overflow 'dev_priv->decoder_queue' 5 <= 5
drivers/gpu/drm/vmwgfx/vmwgfx_drv.c +494 vmw_unlocked_ioctl(14) warn: buffer overflow 'vmw_ioctls' 15 <= 95
drivers/gpu/drm/drm_sysfs.c +421 drm_sysfs_connector_add(66) warn: buffer overflow 'connector_attrs' 4 <= 4
drivers/hwmon/w83781d.c +394 store_temp_max(0) error: buffer overflow 'data->temp_max_add' 2 <= 2
drivers/hwmon/w83781d.c +395 store_temp_max_hyst(0) error: buffer overflow 'data->temp_max_hyst_add' 2 <= 2
drivers/hwmon/smsc47m192.c +302 set_temp_offset(14) error: buffer overflow 'data->temp_offset' 3 <= 3
drivers/ide/cs5536.c +202 cs5536_set_dma_mode(23) error: buffer overflow 'mwdma_timings' 3 <= 31
drivers/ide/sc1200.c +155 sc1200_set_dma_mode(30) error: buffer overflow 'mwdma_timing[pci_clock]' 3 <= 31
drivers/ide/it8172.c +106 it8172_set_dma_mode(26) error: buffer overflow 'mwdma_to_pio' 3 <= 31
drivers/ide/serverworks.c +171 svwks_set_dma_mode(23) error: buffer overflow 'dma_modes' 3 <= 31
drivers/ide/siimage.c +332 sil_set_dma_mode(34) error: buffer overflow 'dma' 3 <= 31
drivers/ide/sis5513.c +215 sis_ata16_program_timings(18) error: buffer overflow 'pio_timings' 5 <= 23
drivers/ide/slc90e66.c +109 slc90e66_set_dma_mode(35) error: buffer overflow 'mwdma_to_pio' 3 <= 31
drivers/input/keyboard/lm8323.c +767 lm8323_probe(129) error: buffer overflow 'lm->pwm' 3 <= 127
drivers/input/keyboard/lm8323.c +768 lm8323_probe(130) warn: buffer overflow 'lm->pwm' 3 <= 127
drivers/isdn/gigaset/capi.c +1317 do_connect_req(127) error: buffer overflow 'cip2bchlc' 29 <= 29
drivers/isdn/hardware/eicon/message.c +1486 connect_res(73) error: buffer overflow 'cau_t' 9 <= 9
drivers/isdn/hardware/eicon/message.c +4987 sig_ind(159) error: buffer overflow 'esc_law' 1 <= 2
drivers/isdn/hardware/eicon/message.c +5005 sig_ind(177) warn: buffer overflow 'esc_profile' 1 <= 6
drivers/isdn/hardware/eicon/message.c +5005 sig_ind(177) warn: buffer overflow 'esc_profile' 1 <= 10
drivers/isdn/hardware/eicon/message.c +5005 sig_ind(177) warn: buffer overflow 'esc_profile' 1 <= 14
drivers/isdn/hardware/eicon/message.c +5005 sig_ind(177) warn: buffer overflow 'esc_profile' 1 <= 18
drivers/isdn/hardware/eicon/message.c +5005 sig_ind(177) warn: buffer overflow 'esc_profile' 1 <= 46
drivers/isdn/hardware/eicon/message.c +5015 sig_ind(187) warn: buffer overflow 'esc_profile' 1 <= 6
drivers/isdn/hardware/eicon/message.c +5017 sig_ind(189) warn: buffer overflow 'esc_profile' 1 <= 10
drivers/isdn/hardware/eicon/message.c +5018 sig_ind(190) warn: buffer overflow 'esc_profile' 1 <= 14
drivers/isdn/hardware/eicon/message.c +5019 sig_ind(191) warn: buffer overflow 'esc_profile' 1 <= 18
drivers/isdn/hardware/eicon/message.c +5020 sig_ind(192) warn: buffer overflow 'esc_profile' 1 <= 46
drivers/isdn/hardware/eicon/message.c +5032 sig_ind(204) warn: buffer overflow 'esc_profile' 1 <= 50
drivers/isdn/hardware/eicon/message.c +5033 sig_ind(205) warn: buffer overflow 'esc_profile' 1 <= 54
drivers/isdn/hardware/eicon/message.c +5118 sig_ind(290) warn: buffer overflow 'pty_cai' 1 <= 1
drivers/isdn/hardware/eicon/message.c +5132 sig_ind(304) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5155 sig_ind(327) error: buffer overflow 'pty_cai' 1 <= 2
drivers/isdn/hardware/eicon/message.c +5177 sig_ind(349) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5198 sig_ind(370) error: buffer overflow 'pty_cai' 1 <= 2
drivers/isdn/hardware/eicon/message.c +5206 sig_ind(378) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5265 sig_ind(437) error: buffer overflow 'pty_cai' 1 <= 2
drivers/isdn/hardware/eicon/message.c +5291 sig_ind(463) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5324 sig_ind(496) error: buffer overflow 'pty_cai' 1 <= 2
drivers/isdn/hardware/eicon/message.c +5344 sig_ind(516) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5428 sig_ind(600) warn: buffer overflow 'pty_cai' 1 <= 1
drivers/isdn/hardware/eicon/message.c +5429 sig_ind(601) error: buffer overflow 'pty_cai' 1 <= 3
drivers/isdn/hardware/eicon/message.c +5433 sig_ind(605) warn: buffer overflow 'pty_cai' 1 <= 1
drivers/isdn/hardware/eicon/message.c +5434 sig_ind(606) error: buffer overflow 'pty_cai' 1 <= 3
drivers/isdn/hardware/eicon/message.c +5438 sig_ind(610) warn: buffer overflow 'pty_cai' 1 <= 1
drivers/isdn/hardware/eicon/message.c +5439 sig_ind(611) error: buffer overflow 'pty_cai' 1 <= 3
drivers/isdn/hardware/eicon/message.c +5443 sig_ind(615) warn: buffer overflow 'pty_cai' 1 <= 1
drivers/isdn/hardware/eicon/message.c +5444 sig_ind(616) error: buffer overflow 'pty_cai' 1 <= 3
drivers/isdn/hardware/eicon/message.c +5448 sig_ind(620) warn: buffer overflow 'pty_cai' 1 <= 1
drivers/isdn/hardware/eicon/message.c +5449 sig_ind(621) error: buffer overflow 'pty_cai' 1 <= 3
drivers/isdn/hardware/eicon/message.c +5452 sig_ind(624) warn: buffer overflow 'pty_cai' 1 <= 4
drivers/isdn/hardware/eicon/message.c +5453 sig_ind(625) warn: buffer overflow 'pty_cai' 1 <= 6
drivers/isdn/hardware/eicon/message.c +5460 sig_ind(632) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5478 sig_ind(650) warn: buffer overflow 'pty_cai' 1 <= 3
drivers/isdn/hardware/eicon/message.c +5479 sig_ind(651) error: buffer overflow 'pty_cai' 1 <= 2
drivers/isdn/hardware/eicon/message.c +5480 sig_ind(652) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5485 sig_ind(657) warn: buffer overflow 'pty_cai' 1 <= 2
drivers/isdn/hardware/eicon/message.c +5532 sig_ind(704) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5538 sig_ind(710) error: buffer overflow 'pty_cai' 1 <= 6
drivers/isdn/hardware/eicon/message.c +5584 sig_ind(756) error: buffer overflow 'pty_cai' 1 <= 5
drivers/isdn/hardware/eicon/message.c +5600 sig_ind(772) error: buffer overflow 'pty_cai' 1 <= 6
drivers/isdn/hardware/eicon/message.c +8419 add_b23(482) warn: buffer overflow '(&nlc[1])->station_id' 20 <= 20
drivers/isdn/i4l/isdn_common.c +2266 register_isdn(45) error: buffer overflow 'dev->drv' 32 <= 32
drivers/isdn/i4l/isdn_common.c +2267 register_isdn(46) error: buffer overflow 'dev->drvid' 32 <= 32
drivers/isdn/sc/init.c +365 sc_init(324) error: buffer overflow 'boardname' 3 <= 3
drivers/media/dvb/frontends/cx22700.c +171 cx22700_set_tps(47) error: buffer overflow 'fec_tab' 6 <= 6
drivers/media/dvb/frontends/cx24110.c +210 cx24110_set_fec(30) error: buffer overflow 'rate' 7 <= 8
drivers/media/dvb/frontends/cx24110.c +215 cx24110_set_fec(35) error: buffer overflow 'g1' 7 <= 8
drivers/media/dvb/frontends/cx24110.c +216 cx24110_set_fec(36) error: buffer overflow 'g2' 7 <= 8
drivers/media/dvb/frontends/cx24110.c +301 cx24110_set_symbolrate(60) error: buffer overflow 'bands' 3 <= 3
drivers/media/dvb/frontends/zl10036.c +414 zl10036_init_regs(22) error: buffer overflow 'zl10036_init_tab[1]' 2 <= 2
drivers/media/dvb/frontends/ds3000.c +745 ds3000_read_snr(73) error: buffer overflow 'dvbs2_snr_tab' 80 <= 80
drivers/media/dvb/pluto2/pluto2.c +483 lg_tdtpe001p_tuner_set_params(37) error: buffer overflow 'buf' 4 <= 4
drivers/media/dvb/pluto2/pluto2.c +487 lg_tdtpe001p_tuner_set_params(41) error: buffer overflow 'buf' 4 <= 5
drivers/media/video/msp3400-driver.c +277 msp_set_scart(15) error: buffer overflow 'scart_names' 8 <= 8
drivers/media/video/au0828/au0828-video.c +1109 vidioc_enum_input(21) error: buffer overflow 'dev->board.input' 4 <= 4
drivers/media/video/et61x251/et61x251_core.c +1730 et61x251_vidioc_s_ctrl(27) error: buffer overflow 's->_qctrl' 46 <= 46
drivers/media/video/saa7134/saa7134-tvaudio.c +605 tvaudio_thread(132) warn: buffer overflow 'tvaudio' 11 <= 11
drivers/media/video/saa7134/saa7134-video.c +1872 saa7134_s_std_internal(48) error: buffer overflow 'tvnorms' 12 <= 12
drivers/media/video/saa7134/saa7134-video.c +1880 saa7134_s_std_internal(56) warn: buffer overflow 'tvnorms' 12 <= 12
drivers/media/video/saa7134/saa7134-video.c +1996 saa7134_g_tuner(13) error: buffer overflow 'saa7134_boards[dev->board]->inputs' 8 <= 8
drivers/media/video/sn9c102/sn9c102_core.c +2312 sn9c102_vidioc_s_ctrl(27) error: buffer overflow 's->_qctrl' 46 <= 46
drivers/message/fusion/mptbase.c +7849 mpt_sas_log_info(21) error: buffer overflow 'originator_str' 3 <= 3
drivers/mfd/pcf50633-core.c +223 pcf50633_register_irq(6) error: buffer overflow 'pcf->irq_handler' 40 <= 40
drivers/misc/eeprom/eeprom.c +116 eeprom_read(28) error: buffer overflow 'data->data' 256 <= 256
drivers/misc/eeprom/eeprom.c +119 eeprom_read(31) warn: buffer overflow 'data->data' 256 <= 256
drivers/misc/eeprom/max6875.c +129 max6875_read(19) warn: buffer overflow 'data->data' 512 <= 512
drivers/mtd/ubi/wl.c +343 prot_queue_add(7) warn: buffer overflow 'ubi->pq' 10 <= 10
drivers/net/netxen/netxen_nic_init.c +1065 netxen_request_firmware(14) error: buffer overflow 'fw_name' 5 <= 255
drivers/net/tulip/de4x5.c +4774 type3_infoblock(19) error: buffer overflow 'lp->phy' 8 <= 8
drivers/net/wan/sdla.c +958 sdla_close(20) warn: buffer overflow 'flp->dlci' 8 <= 8
drivers/net/wireless/atmel.c +1218 service_interrupt(59) error: buffer overflow 'irq_order' 8 <= 8
drivers/net/wireless/ray_cs.c +1040 translate_frame(13) warn: buffer overflow '(ptx->var)->org' 3 <= 3
drivers/net/wireless/ath/ath9k/eeprom_4k.c +448 ath9k_hw_set_4k_power_cal_table(60) error: buffer overflow 'pEepData->calPierData2G' 1 <= 1
drivers/net/wireless/ath/ath9k/eeprom_9287.c +262 ath9k_hw_get_AR9287_gain_boundaries_pdadcs(45) error: buffer overflow '(pRawDataSet+idxL)->pwrPdg[i]' 1 <= 4
drivers/net/wireless/b43/lo.c +626 lo_probe_possible_loctls(49) error: buffer overflow 'modifiers' 8 <= 8
drivers/net/wireless/b43/dma.c +321 b43_dmacontroller_base(22) error: buffer overflow 'map64' 6 <= 6
drivers/net/wireless/b43/dma.c +325 b43_dmacontroller_base(26) error: buffer overflow 'map32' 6 <= 6
drivers/net/wireless/b43legacy/phy.c +1434 b43legacy_phy_lo_g_state(59) error: buffer overflow 'transitions' 8 <= 8
drivers/net/wireless/b43legacy/dma.c +380 b43legacy_dmacontroller_base(23) error: buffer overflow 'map64' 6 <= 6
drivers/net/wireless/b43legacy/dma.c +384 b43legacy_dmacontroller_base(27) error: buffer overflow 'map32' 6 <= 6
drivers/net/wireless/b43legacy/pio.c +175 parse_cookie(27) warn: buffer overflow 'queue->tx_packets_cache' 256 <= 256
drivers/net/wireless/iwlwifi/iwl-agn-rs.c +2694 rs_fill_link_cmd(108) error: buffer overflow 'lq_cmd->rs_table' 16 <= 16
drivers/net/wireless/iwlwifi/iwl-5000.c +786 iwl5000_txq_update_byte_cnt_tbl(37) error: buffer overflow '(scd_bc_tbl+txq_id)->tfd_offset' 320 <= 512
drivers/net/wireless/libertas/mesh.c +803 mesh_id_get(21) error: buffer overflow 'defs.meshie.val.mesh_id' 32 <= 32
drivers/net/wireless/orinoco/hw.c +738 orinoco_hw_get_act_bitrate(34) error: buffer overflow 'bitrate_table' 8 <= 8
drivers/net/wireless/prism54/oid_mgt.c +428 mgt_set_request(10) error: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +443 mgt_set_request(25) warn: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +490 mgt_set_varlen(10) error: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +493 mgt_set_varlen(13) warn: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +528 mgt_get_request(13) error: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +562 mgt_get_request(47) warn: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +581 mgt_get_request(66) error: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +633 mgt_set(6) warn: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +643 mgt_get(6) error: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/prism54/oid_mgt.c +644 mgt_get(7) warn: buffer overflow 'isl_oid' 140 <= 140
drivers/net/wireless/zd1211rw/zd_mac.c +352 zd_mac_tx_status(26) warn: buffer overflow 'zd_retry_rates' 12 <= 12
drivers/net/cassini.c +5136 cas_init_one(143) error: buffer overflow 'link_modes' 6 <= 6
drivers/net/8139too.c +866 rtl8139_init_board(128) error: buffer overflow 'rtl_chip_info' 10 <= 10
drivers/pci/dmar.c +1223 dmar_get_fault_reason(5) error: buffer overflow 'intr_remap_fault_reasons' 7 <= 7
drivers/scsi/aic7xxx/aic79xx_core.c +9524 ahd_check_patch(8) warn: buffer overflow 'patches' 131 <= 131
drivers/scsi/aic7xxx/aic7xxx_core.c +6974 ahc_check_patch(8) warn: buffer overflow 'patches' 202 <= 202
drivers/scsi/bfa/bfa_ioc.c +1936 bfa_ioc_mbox_isr(17) error: buffer overflow 'mod->mbhdlr' 32 <= 32
drivers/scsi/bfa/bfa_intr.c +182 bfa_msix_rspq(22) error: buffer overflow 'bfa_isrs' 32 <= 32
drivers/scsi/bfa/bfa_uf.c +87 claim_uf_post_msgs(25) warn: buffer overflow '(sge)' 2 <= 2
drivers/scsi/bfa/bfa_uf.c +87 claim_uf_post_msgs(25) error: buffer overflow '(sge)' 2 <= 2
drivers/scsi/bfa/bfa_fcs_lport.c +269 bfa_fcs_port_aen_post(18) error: buffer overflow 'role_str' 3 <= 3
drivers/scsi/aha152x.c +1686 seldo_run(26) warn: buffer overflow '(&shpnt->hostdata)->msgo' 256 <= 256
drivers/scsi/qla2xxx/qla_dbg.c +746 qla2100_fw_dump(182) warn: buffer overflow 'fw->risc_ram' 61440 <= 61440
drivers/scsi/libiscsi.c +227 iscsi_prep_ecdb_ahs(22) warn: buffer overflow 'ecdb_ahdr->ecdb' 244 <= 244
drivers/scsi/aha152x.c +1686 seldo_run(26) warn: buffer overflow '(&shpnt->hostdata)->msgo' 256 <= 256
drivers/scsi/aic7xxx_old.c +1566 aic7xxx_check_patch(8) warn: buffer overflow 'sequencer_patches' 85 <= 85
drivers/scsi/hpsa.c +639 hpsa_scsi_remove_entry(15) error: buffer overflow 'h->dev' 256 <= 256
drivers/scsi/gdth.c +2115 gdth_next(84) warn: buffer overflow 'ha->hdr' 255 <= 255
drivers/scsi/gdth.c +2146 gdth_next(115) error: buffer overflow 'ha->raw[()]->io_cnt' 127 <= 255
drivers/serial/max3100.c +833 max3100_remove(13) error: buffer overflow 'max3100s' 4 <= 4
drivers/staging/batman-adv/device.c +113 bat_device_open(17) error: buffer overflow 'device_client_hash' 256 <= 256
drivers/staging/comedi/drivers/comedi_bond.c +428 doDevConfig(24) error: buffer overflow 'devs_opened' 48 <= 48
drivers/staging/comedi/drivers/dt2801.c +485 dac_range_lkup(4) error: buffer overflow 'dac_range_table' 5 <= 5
drivers/staging/comedi/drivers/pcmmio.c +490 pcmmio_attach(135) error: buffer overflow '(dev->private)->asics' 1 <= 1
drivers/staging/comedi/drivers/pcmmio.c +553 pcmmio_attach(198) error: buffer overflow 'irq' 1 <= 1
drivers/staging/cx25821/cx25821-core.c +1002 cx25821_dev_setup(107) error: buffer overflow 'card' 2 <= 2
drivers/staging/cx25821/cx25821-video.c +882 cx25821_enum_input(14) warn: buffer overflow 'cx25821_boards[dev->board]->input' 2 <= 2
drivers/staging/otus/ioctl.c +939 usbdrvwext_siwessid(17) error: buffer overflow 'EssidBuf' 33 <= 33
drivers/staging/rt2860/sta_ioctl.c +1072 rt_ioctl_giwscan(271) error: buffer overflow 'ralinkrate' 108 <= 108
drivers/staging/rtl8192e/r819xE_phy.c +2598 rtl8192_phy_ConfigRFWithHeaderFile(39) error: buffer overflow 'Rtl8192PciERadioC_Array' 1 <= 1
drivers/staging/rtl8192e/r819xE_phy.c +2610 rtl8192_phy_ConfigRFWithHeaderFile(51) error: buffer overflow 'Rtl8192PciERadioD_Array' 1 <= 1
drivers/staging/rtl8192e/r819xE_cmdpkt.c +796 cmpk_message_handle_rx(99) error: buffer overflow 'priv->stats.rxcmdpkt' 4 <= 7
drivers/staging/rtl8192su/r8192S_phy.c +2032 PHY_SetTxPowerLevel8192S(172) error: buffer overflow 'priv->AntennaTxPwDiff' 2 <= 2
drivers/staging/rtl8192su/r819xU_cmdpkt.c +710 cmpk_message_handle_rx(88) error: buffer overflow 'priv->stats.rxcmdpkt' 4 <= 7
drivers/staging/rtl8192su/r8192S_Efuse.c +2089 efuse_read_data(17) error: buffer overflow 'RTL8712_SDIO_EFUSE_TABLE' 13 <= 13
drivers/staging/rtl8192su/r8192U_core.c +3480 rtl8192SU_ConfigAdapterInfo8192SForAutoLoadFail(108) error: buffer overflow 'priv->RfCckChnlAreaTxPwr' 2 <= 2
drivers/staging/rtl8192su/r8192U_core.c +3479 rtl8192SU_ConfigAdapterInfo8192SForAutoLoadFail(107) error: buffer overflow 'priv->RfTxPwrLevelCck' 2 <= 2
drivers/staging/rtl8192su/r8192U_core.c +3482 rtl8192SU_ConfigAdapterInfo8192SForAutoLoadFail(110) error: buffer overflow 'priv->RfOfdmChnlAreaTxPwr1T' 2 <= 2
drivers/staging/rtl8192su/r8192U_core.c +3481 rtl8192SU_ConfigAdapterInfo8192SForAutoLoadFail(109) error: buffer overflow 'priv->RfTxPwrLevelOfdm1T' 2 <= 2
drivers/staging/rtl8192su/r8192U_core.c +3484 rtl8192SU_ConfigAdapterInfo8192SForAutoLoadFail(112) error: buffer overflow 'priv->RfOfdmChnlAreaTxPwr2T' 2 <= 2
drivers/staging/rtl8192su/r8192U_core.c +3483 rtl8192SU_ConfigAdapterInfo8192SForAutoLoadFail(111) error: buffer overflow 'priv->RfTxPwrLevelOfdm2T' 2 <= 2
drivers/staging/rtl8192u/r819xU_cmdpkt.c +784 cmpk_message_handle_rx(88) error: buffer overflow 'priv->stats.rxcmdpkt' 4 <= 7
drivers/staging/slicoss/slicoss.c +1053 slic_xmit_complete(21) error: buffer overflow 'adapter->slic_handles' 257 <= 257
drivers/staging/slicoss/slicoss.c +1057 slic_xmit_complete(25) warn: buffer overflow 'adapter->slic_handles' 257 <= 257
drivers/staging/slicoss/slicoss.c +2286 slic_card_locate(79) error: buffer overflow 'physcard->adapter' 4 <= 4
drivers/staging/strip/strip.c +2161 process_message(20) warn: buffer overflow 'sendername' 32 <= 32
drivers/staging/vt6655/card.c +1590 CARDbAdd_PMKID_Candidate(38) warn: buffer overflow 'pDevice->gsPMKIDCandidate.CandidateList' 5 <= 5
drivers/staging/vt6655/card.c +1682 CARDvInitChannelTable(68) error: buffer overflow 'ChannelRuleTab' 119 <= 119
drivers/staging/vt6655/wroute.c +157 ROUTEbRelay(89) error: buffer overflow 'pDevice->pMgmt->sNodeDBTable' 65 <= 65
drivers/staging/vt6655/rf.c +1022 RFbSetPower(23) error: buffer overflow 'pDevice->abyCCKPwrTbl' 15 <= 56
drivers/staging/vt6655/rf.c +1023 RFbSetPower(24) error: buffer overflow 'pDevice->abyCCKDefaultPwr' 15 <= 56
drivers/staging/vt6656/rxtx.c +3197 bRelayPacketSend(85) error: buffer overflow 'pMgmt->sNodeDBTable' 65 <= 65
drivers/staging/vt6656/channel.c +502 CHvInitChannelTable(62) error: buffer overflow 'ChannelRuleTab' 119 <= 119
drivers/video/aty/radeon_base.c +1096 radeon_setcolreg(41) error: buffer overflow 'rinfo->palette' 256 <= 510
drivers/video/aty/aty128fb.c +2255 aty128fb_setcolreg(43) error: buffer overflow 'par->green' 64 <= 255
drivers/video/aty/aty128fb.c +2262 aty128fb_setcolreg(50) error: buffer overflow 'par->red' 32 <= 127
drivers/video/aty/aty128fb.c +2263 aty128fb_setcolreg(51) error: buffer overflow 'par->blue' 32 <= 127
drivers/video/fbmem.c +1561 register_framebuffer(69) error: buffer overflow 'registered_fb' 32 <= 32
drivers/video/cyber2000fb.c +330 cyber2000fb_setcolreg(68) error: buffer overflow 'cfb->palette' 256 <= 504
sound/core/seq/oss/seq_oss_init.c +276 snd_seq_oss_open(102) error: buffer overflow 'client_table' 16 <= 16
sound/core/pcm_native.c +320 snd_pcm_hw_refine(159) warn: buffer overflow 'params->masks' 3 <= 10
sound/oss/sequencer.c +1638 compute_finetune(45) error: buffer overflow 'semitone_tuning' 24 <= 99
arch/x86/math-emu/get_address.c +131 vm86_segment(9) error: buffer overflow 'reg_offset_vm86' 7 <= 7
arch/x86/pci/numaq_32.c +171 pci_numaq_init(20) error: buffer overflow 'quad_local_to_mp_bus_id' 8 <= 15
net/9p/trans_virtio.c +304 p9_virtio_create(12) warn: buffer overflow 'channels' 1 <= 1
net/netfilter/nf_conntrack_core.c +586 nf_conntrack_alloc(43) warn: buffer overflow 'ct->tuplehash' 2 <= 2
net/netfilter/nf_conntrack_ftp.c +490 help(143) error: buffer overflow 'search[dir]' 2 <= 2
net/sunrpc/xprtrdma/svc_rdma_marshal.c +225 svc_rdma_xdr_decode_req(34) warn: buffer overflow 'rmsgp->rm_body.rm_padded.rm_pempty' 3 <= 4
net/tipc/eth_media.c +133 enable_bearer(5) warn: buffer overflow 'eth_bearers' 2 <= 2
lib/zlib_inflate/inftrees.c +240 zlib_inflate_table(217) error: buffer overflow 'count' 16 <= 16
lib/dma-debug.c +578 filter_write(52) error: buffer overflow 'current_driver_name' 64 <= 64
arch/x86/boot/compressed/../../../../lib/zlib_inflate/inftrees.c +240 zlib_inflate_table(217) error: buffer overflow 'count' 16 <= 16
