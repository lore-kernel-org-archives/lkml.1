Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbYB0VZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbYB0VZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760439AbYB0VW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:22:27 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41803 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759781AbYB0VWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:22:25 -0500
Date: Wed, 27 Feb 2008 23:21:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Marco Gittler <g.marco@freenet.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb-usb/opera1.c: fix a memory leak
Message-ID: <20080227212115.GS29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak in the "testval == 0x67" case spotted by 
the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/dvb-usb/opera1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6/drivers/media/dvb/dvb-usb/opera1.c.old	2008-02-27 22:27:03.000000000 +0200
+++ linux-2.6/drivers/media/dvb/dvb-usb/opera1.c	2008-02-27 22:27:23.000000000 +0200
@@ -450,65 +450,65 @@ static int opera1_xilinx_load_firmware(s
 		p = kmalloc(fw->size, GFP_KERNEL);
 		opera1_xilinx_rw(dev, 0xbc, 0x00, &testval, 1, OPERA_READ_MSG);
 		if (p != NULL && testval != 0x67) {
 
 			u8 reset = 0, fpga_command = 0;
 			memcpy(p, fw->data, fw->size);
 			/* clear fpga ? */
 			opera1_xilinx_rw(dev, 0xbc, 0xaa, &fpga_command, 1,
 					 OPERA_WRITE_MSG);
 			for (i = 0; i < fw->size;) {
 				if ( (fw->size - i) <fpgasize){
 				    fpgasize=fw->size-i;
 				}
 				b = (u8 *) p + i;
 				if (opera1_xilinx_rw
 					(dev, OPERA_WRITE_FX2, 0x0, b , fpgasize,
 						OPERA_WRITE_MSG) != fpgasize
 					) {
 					err("error while transferring firmware");
 					ret = -EINVAL;
 					break;
 				}
 				i = i + fpgasize;
 			}
 			/* restart the CPU */
 			if (ret || opera1_xilinx_rw
 					(dev, 0xa0, 0xe600, &reset, 1,
 					OPERA_WRITE_MSG) != 1) {
 				err("could not restart the USB controller CPU.");
 				ret = -EINVAL;
 			}
-			kfree(p);
 		}
 	}
+	kfree(p);
 	if (fw) {
 		release_firmware(fw);
 	}
 	return ret;
 }
 
 static struct dvb_usb_device_properties opera1_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-opera-01.fw",
 	.size_of_priv = sizeof(struct opera1_state),
 
 	.power_ctrl = opera1_power_ctrl,
 	.i2c_algo = &opera1_i2c_algo,
 
 	.rc_key_map = opera1_rc_keys,
 	.rc_key_map_size = ARRAY_SIZE(opera1_rc_keys),
 	.rc_interval = 200,
 	.rc_query = opera1_rc_query,
 	.read_mac_address = opera1_read_mac_address,
 	.generic_bulk_ctrl_endpoint = 0x00,
 	/* parameter for the MPEG2-data transfer */
 	.num_adapters = 1,
 	.adapter = {
 		{
 			.frontend_attach = opera1_frontend_attach,
 			.streaming_ctrl = opera1_streaming_ctrl,
 			.tuner_attach = opera1_tuner_attach,
 			.caps =
 				DVB_USB_ADAP_HAS_PID_FILTER |
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,

