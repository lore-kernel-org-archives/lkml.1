Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab0COIaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:30:23 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41959 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab0COIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=oG1dt1BE210WJq3cObVYuYz46X2YKi4rs3cKDBCTB1HZ27DbhkgG631bSlUBhXVK1S
         PY0FG+GioYPLL7rablsgpPg28D4xxHu5FM0+5QYQjFZlwLpKP6QkFLFM4XKdhTdDm9iq
         7tcMfaYPA8N35Ce6HAsno1o0CFCB44BKQltvU=
Date: Mon, 15 Mar 2010 11:30:08 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: bug list: range checking issues 2.6.34-rc1
Message-ID: <20100315083008.GK18181@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the list of range checking issues and potential array 
overflows reported by smatch for 2.6.34-rc1.  I hand edited the list
to remove false positives.  Also I changed the format a bit to  make
the lines shorter.

filename.c +[line number] function() 'array_name' [array size] <= [array offset]

Take the first one as an example:

fs/btrfs/ctree.c +1003 balance_level() 'path->slots' 8 <= 8
  1001          if (level < BTRFS_MAX_LEVEL - 1)
  1002                  parent = path->nodes[level + 1];
  1003          pslot = path->slots[level + 1];

In this case path->slots[] has 8 elements.  Smatch assumes that "level"
can be equal to BTRFS_MAX_LEVEL - 1 which is 7.  "level" + 1 equals 8.
Because 8 <= 8 we could potentially go past the end of the array.

regards,
dan carpenter

fs/btrfs/ctree.c +1003 balance_level() 'path->slots' 8 <= 8
fs/btrfs/ctree.c +1223 push_nodes_for_insert() 'path->slots' 8 <= 8
drivers/gpu/drm/radeon/radeon_atombios.c +1281 radeon_atom_get_tv_timings() 'tv_info->aModeTimings' 2 <= 2
drivers/gpu/drm/radeon/radeon_atombios.c +1319 radeon_atom_get_tv_timings() 'tv_info_v1_2->aModeTimings' 2 <= 3
drivers/gpu/drm/radeon/radeon_legacy_tv.c +633 radeon_legacy_tv_mode_set() 'SLOPE_value' 5 <= 5
drivers/gpu/drm/via/via_video.c +85 via_decoder_futex() 'dev_priv->decoder_queue' 5 <= 5
drivers/gpu/drm/drm_sysfs.c +419 drm_sysfs_connector_add() 'connector_attrs' 4 <= 4
drivers/gpu/drm/drm_edid.c +1032 add_detailed_modes() 'data->data.timings' 5 <= 5
drivers/hwmon/w83627hf.c +1714 w83627hf_update_device() 'regpwm_627hf' 2 <= 2
drivers/infiniband/core/user_mad.c +646 ib_umad_reg_agent() 'umm' 4 <= 6
drivers/input/keyboard/lm8323.c +767 lm8323_probe() 'lm->pwm' 3 <= 127
drivers/isdn/gigaset/capi.c +1305 do_connect_req() 'cip2bchlc' 29 <= 29
drivers/isdn/hardware/eicon/message.c +1486 connect_res() 'cau_t' 9 <= 9
drivers/isdn/i4l/isdn_common.c +2266 register_isdn() 'dev->drv' 32 <= 32
drivers/media/common/tuners/qt1010.c +387 qt1010_init() 'i2c_data' 34 <= 34
drivers/media/dvb/frontends/cx22700.c +171 cx22700_set_tps() 'fec_tab' 6 <= 6
drivers/media/dvb/frontends/cx24110.c +210 cx24110_set_fec() 'rate' 7 <= 8
drivers/media/dvb/frontends/cx24110.c +301 cx24110_set_symbolrate() 'bands' 3 <= 3
drivers/media/dvb/frontends/ds3000.c +745 ds3000_read_snr() 'dvbs2_snr_tab' 80 <= 80
drivers/media/video/msp3400-driver.c +277 msp_set_scart() 'scart_names' 8 <= 8
drivers/media/video/au0828/au0828-video.c +1109 vidioc_enum_input() 'dev->board.input' 4 <= 4
drivers/media/video/et61x251/et61x251_core.c +1730 et61x251_vidioc_s_ctrl() 's->_qctrl' 46 <= 46
drivers/media/video/saa7134/saa7134-tvaudio.c +605 tvaudio_thread() 'tvaudio' 11 <= 11
drivers/media/video/saa7134/saa7134-video.c +1872 saa7134_s_std_internal() 'tvnorms' 12 <= 12
drivers/media/video/sn9c102/sn9c102_core.c +2312 sn9c102_vidioc_s_ctrl() 's->_qctrl' 46 <= 46
drivers/media/video/zc0301/zc0301_core.c +1170 zc0301_vidioc_s_ctrl() 's->_qctrl' 46 <= 46
drivers/message/fusion/mptbase.c +7850 mpt_sas_log_info() 'originator_str' 3 <= 3
drivers/mfd/pcf50633-core.c +223 pcf50633_register_irq() 'pcf->irq_handler' 40 <= 40
drivers/mfd/pcf50633-core.c +241 pcf50633_free_irq() 'pcf->irq_handler' 40 <= 40
drivers/net/tulip/de4x5.c +4772 type3_infoblock() 'lp->phy' 8 <= 8
drivers/net/tulip/de4x5.c +5073 mii_get_phy() 'lp->phy' 8 <= 8
drivers/net/wan/sdla.c +958 sdla_close() 'flp->dlci' 8 <= 8
drivers/net/wan/lmc/lmc_main.c +1894 lmc_softreset() 'sc->lmc_rxring' 32 <= 32
drivers/net/wan/lmc/lmc_main.c +1916 lmc_softreset() 'sc->lmc_txring' 32 <= 32
drivers/net/wireless/atmel.c +1218 service_interrupt() 'irq_order' 8 <= 8
drivers/net/wireless/ray_cs.c +1040 translate_frame() '(ptx->var)->org' 3 <= 3
drivers/net/wireless/iwlwifi/iwl3945-base.c +1959 iwl3945_init_hw_rates() 'iwl3945_rates' 12 <= 12
drivers/net/wireless/iwlwifi/iwl-3945.c +188 iwl3945_hwrate_to_plcp_idx() 'iwl3945_rates' 12 <= 12
drivers/net/wireless/iwlwifi/iwl-agn-rs.c +2707 rs_fill_link_cmd() 'lq_cmd->rs_table' 16 <= 16
drivers/net/wireless/libertas/mesh.c +816 mesh_id_get() 'defs.meshie.val.mesh_id' 32 <= 32
drivers/net/wireless/orinoco/hw.c +738 orinoco_hw_get_act_bitrate() 'bitrate_table' 8 <= 8
drivers/net/defxx.c +2422 dfx_ctl_update_cam() 'bp->uc_table' 6 <= 366
drivers/net/8139too.c +867 rtl8139_init_board() 'rtl_chip_info' 10 <= 10
drivers/net/s2io.c +5812 s2io_vpd_read() 'vpd_data' 256 <= 256
drivers/pci/dmar.c +1223 dmar_get_fault_reason() 'intr_remap_fault_reasons' 7 <= 7
drivers/scsi/bfa/bfa_ioc.c +1936 bfa_ioc_mbox_isr() 'mod->mbhdlr' 32 <= 32
drivers/scsi/aha152x.c +1686 seldo_run() '(&shpnt->hostdata)->msgo' 256 <= 256
drivers/scsi/qla2xxx/qla_dbg.c +746 qla2100_fw_dump() 'fw->risc_ram' 61440 <= 61440
drivers/scsi/sd.c +1984 sd_read_block_limits() 'buffer' 32 <= 32
drivers/scsi/libiscsi.c +227 iscsi_prep_ecdb_ahs() 'ecdb_ahdr->ecdb' 244 <= 244
drivers/scsi/gdth.c +2115 gdth_next() 'ha->hdr' 255 <= 255
drivers/serial/max3100.c +833 max3100_remove() 'max3100s' 4 <= 4
drivers/staging/arlan/arlan-proc.c +471 arlan_sysctl_info() 'priva->card->_3' 13 <= 13
drivers/video/via/viafbdev.c +858 viafb_cursor() 'cr_data->bak' 2048 <= 2048
drivers/video/fbmem.c +1560 register_framebuffer() 'registered_fb' 32 <= 32
drivers/video/cyber2000fb.c +330 cyber2000fb_setcolreg() 'cfb->palette' 256 <= 504
sound/drivers/opl3/opl3_midi.c +652 snd_opl3_kill_voice() 'opl3->voices' 18 <= 20
sound/i2c/other/ak4113.c +94 snd_ak4113_create() 'pgm' 5 <= 6
sound/soc/codecs/wm8994.c +1703 wm8994_write() 'wm8994->reg_cache' 1570 <= 12799
lib/zlib_inflate/inftrees.c +240 zlib_inflate_table() 'count' 16 <= 16
lib/dma-debug.c +578 filter_write() 'current_driver_name' 64 <= 64
