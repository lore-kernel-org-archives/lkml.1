Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044Ab0AWAVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0AWAVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279Ab0AWATB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:19:01 -0500
Received: from kroah.org ([198.145.64.141]:35082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab0AWAS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:12 2010
Message-Id: <20100123001112.769683534@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [20/29] drm/i915: Read the response after issuing DDC bus switch command
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 6a304caf0bf9c429fc261f260b86cabf5bde2cbb upstream.

For some SDVO cards based on conexant chip, we can't read the EDID if
we don't read the response after issuing SDVO DDC bus switch
command.

>From the SDVO spec once when another I2C transaction is finished after
completing the I2C transaction of issuing the bus switch command, it
will be switched back to the SDVO internal state again. So we can't
initiate a new I2C transaction to read the response after issuing the
DDC bus switch command. Instead we should issue DDC bus switch command
and read the response in the same I2C transaction.

https://bugs.freedesktop.org/show_bug.cgi?id=23842
https://bugs.freedesktop.org/show_bug.cgi?id=24458
https://bugs.freedesktop.org/show_bug.cgi?id=24522
https://bugs.freedesktop.org/show_bug.cgi?id=24282

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Tested-by: Sebastien Caty <sebastien.caty@mrnf.gouv.qc.ca>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_sdvo.c |   57 +++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -472,14 +472,63 @@ static int intel_sdvo_get_pixel_multipli
 }
 
 /**
- * Don't check status code from this as it switches the bus back to the
- * SDVO chips which defeats the purpose of doing a bus switch in the first
- * place.
+ * Try to read the response after issuie the DDC switch command. But it
+ * is noted that we must do the action of reading response and issuing DDC
+ * switch command in one I2C transaction. Otherwise when we try to start
+ * another I2C transaction after issuing the DDC bus switch, it will be
+ * switched to the internal SDVO register.
  */
 static void intel_sdvo_set_control_bus_switch(struct intel_output *intel_output,
 					      u8 target)
 {
-	intel_sdvo_write_cmd(intel_output, SDVO_CMD_SET_CONTROL_BUS_SWITCH, &target, 1);
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	u8 out_buf[2], cmd_buf[2], ret_value[2], ret;
+	struct i2c_msg msgs[] = {
+		{
+			.addr = sdvo_priv->slave_addr >> 1,
+			.flags = 0,
+			.len = 2,
+			.buf = out_buf,
+		},
+		/* the following two are to read the response */
+		{
+			.addr = sdvo_priv->slave_addr >> 1,
+			.flags = 0,
+			.len = 1,
+			.buf = cmd_buf,
+		},
+		{
+			.addr = sdvo_priv->slave_addr >> 1,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = ret_value,
+		},
+	};
+
+	intel_sdvo_debug_write(intel_output, SDVO_CMD_SET_CONTROL_BUS_SWITCH,
+					&target, 1);
+	/* write the DDC switch command argument */
+	intel_sdvo_write_byte(intel_output, SDVO_I2C_ARG_0, target);
+
+	out_buf[0] = SDVO_I2C_OPCODE;
+	out_buf[1] = SDVO_CMD_SET_CONTROL_BUS_SWITCH;
+	cmd_buf[0] = SDVO_I2C_CMD_STATUS;
+	cmd_buf[1] = 0;
+	ret_value[0] = 0;
+	ret_value[1] = 0;
+
+	ret = i2c_transfer(intel_output->i2c_bus, msgs, 3);
+	if (ret != 3) {
+		/* failure in I2C transfer */
+		DRM_DEBUG_KMS("I2c transfer returned %d\n", ret);
+		return;
+	}
+	if (ret_value[0] != SDVO_CMD_STATUS_SUCCESS) {
+		DRM_DEBUG_KMS("DDC switch command returns response %d\n",
+					ret_value[0]);
+		return;
+	}
+	return;
 }
 
 static bool intel_sdvo_set_target_input(struct intel_output *intel_output, bool target_0, bool target_1)


