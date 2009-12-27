Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbZL0UPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbZL0UPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZL0UPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:15:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59110 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZL0UPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:15:31 -0500
Date: Sun, 27 Dec 2009 21:15:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Subject: Re: tree with htc dream support
Message-ID: <20091227201514.GA29174@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
 <1260627482.20913.7.camel@desktop>
 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
 <20091213212504.GD5114@elf.ucw.cz>
 <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
 <20091227093537.GD11737@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227093537.GD11737@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-27 10:35:38, Pavel Machek wrote:
> Hi!
> 
> > > One more wish list item: many drivers are now available in
> > > drivers/staging/dream, and are being slowly cleaned up. Would it be
> > > possible to start using those for android-msm-2.6.32 tree?
> > >
> > > You'll need to reapply some stuff I had to remove (like wakelocks),
> > > but it should be still better/less work long term to patch those back
> > > in than maintaining separate copy. Diff should get much smaller...
> > 
> > I do plan to look at these, but I don't know when I'll get to it.
> 
> So... this switches qdsp5 code from private version to version in
> staging. It actually boots.

And when I replace .c's in qdsp5 with -msm version, it also works,
with diff being reasonably small.

Now... how does camera driver work? I did not drivers/media/video/msm/
driver into the kernel, but camera application seems to still
work...?!
								Pavel

diff --git a/drivers/staging/dream/qdsp5/adsp.c b/drivers/staging/dream/qdsp5/adsp.c
index d096456..b976f94 100644
--- a/drivers/staging/dream/qdsp5/adsp.c
+++ b/drivers/staging/dream/qdsp5/adsp.c
@@ -194,7 +194,7 @@ static int adsp_rpc_init(struct msm_adsp_module *adsp_module)
 	adsp_module->rpc_client = msm_rpc_connect(
 			RPC_ADSP_RTOS_ATOM_PROG,
 			RPC_ADSP_RTOS_ATOM_VERS,
-			MSM_RPC_UNINTERRUPTIBLE);
+			MSM_RPC_UNINTERRUPTIBLE | MSM_RPC_ENABLE_RECEIVE);
 
 	if (IS_ERR(adsp_module->rpc_client)) {
 		int rc = PTR_ERR(adsp_module->rpc_client);
@@ -219,7 +219,7 @@ static void  msm_get_init_info(void)
 	adsp_info.init_info_rpc_client = msm_rpc_connect(
 			RPC_ADSP_RTOS_ATOM_PROG,
 			RPC_ADSP_RTOS_ATOM_VERS,
-			MSM_RPC_UNINTERRUPTIBLE);
+			MSM_RPC_UNINTERRUPTIBLE | MSM_RPC_ENABLE_RECEIVE);
 	if (IS_ERR(adsp_info.init_info_rpc_client)) {
 		rc = PTR_ERR(adsp_info.init_info_rpc_client);
 		adsp_info.init_info_rpc_client = 0;
@@ -709,9 +709,11 @@ static void handle_adsp_rtos_mtoa_app(struct rpc_request_hdr *req)
 				     RPC_ACCEPTSTAT_SUCCESS);
 	mutex_unlock(&module->lock);
 #ifdef CONFIG_MSM_ADSP_REPORT_EVENTS
-	modem_event_addr = (uint32_t *)req;
-	module->ops->event(module->driver_data, EVENT_MSG_ID,
-				EVENT_LEN, read_modem_event);
+	if (module->ops != NULL && module->ops->event != NULL) {
+		modem_event_addr = (uint32_t *)req;
+		module->ops->event(module->driver_data, EVENT_MSG_ID,
+					EVENT_LEN, read_modem_event);
+	}
 #endif
 }
 
diff --git a/drivers/staging/dream/qdsp5/adsp_6210.c b/drivers/staging/dream/qdsp5/adsp_6210.c
index 3cf4e99..628c247 100644
--- a/drivers/staging/dream/qdsp5/adsp_6210.c
+++ b/drivers/staging/dream/qdsp5/adsp_6210.c
@@ -16,7 +16,7 @@
 #include "adsp.h"
 
 /* Firmware modules */
-typedef enum {
+typedef enum { 
 	QDSP_MODULE_KERNEL,
 	QDSP_MODULE_AFETASK,
 	QDSP_MODULE_AUDPLAY0TASK,
diff --git a/drivers/staging/dream/qdsp5/adsp_6220.c b/drivers/staging/dream/qdsp5/adsp_6220.c
index 02225cd..c4c5a55 100644
--- a/drivers/staging/dream/qdsp5/adsp_6220.c
+++ b/drivers/staging/dream/qdsp5/adsp_6220.c
@@ -16,7 +16,7 @@
 #include "adsp.h"
 
 /* Firmware modules */
-typedef enum {
+typedef enum { 
 	QDSP_MODULE_KERNEL,
 	QDSP_MODULE_AFETASK,
 	QDSP_MODULE_AUDPLAY0TASK,
diff --git a/drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c b/drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c
index a56392b..8f09ed2 100644
--- a/drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c
+++ b/drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c
@@ -44,7 +44,7 @@ int adsp_vfe_patch_event(struct msm_adsp_module *module,
 	case VFE_MSG_OP2:
 		return patch_op_event(module, event);
 	case VFE_MSG_STATS_AF:
-	case VFE_MSG_STATS_WB_EXP:
+	case VFE_MSG_STATS_WB_EXP:	
 		return patch_af_wb_event(module, event);
 	default:
 		break;
diff --git a/drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c b/drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c
index 927d50a..d1f3fa8 100644
--- a/drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c
+++ b/drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c
@@ -184,7 +184,7 @@ static int verify_vfe_command_table(struct msm_adsp_module *module,
 		vfe_cmd_axi_op_cfg *cmd = (vfe_cmd_axi_op_cfg *)cmd_data;
 		void **addr1_y, **addr2_y, **addr1_cbcr, **addr2_cbcr;
 
-		if (cmd_size != sizeof(vfe_cmd_axi_op_cfg)) {
+		if (cmd_size != sizeof(vfe_cmd_axi_op_cfg)) { 
 			printk(KERN_ERR "adsp: module %s: invalid VFE TABLE (VFE_CMD_AXI_OP_CFG) command size %d\n",
 				module->name, cmd_size);
 			return -1;
diff --git a/drivers/staging/dream/qdsp5/adsp_video_verify_cmd.c b/drivers/staging/dream/qdsp5/adsp_video_verify_cmd.c
index 53aff77..fdad055 100644
--- a/drivers/staging/dream/qdsp5/adsp_video_verify_cmd.c
+++ b/drivers/staging/dream/qdsp5/adsp_video_verify_cmd.c
@@ -107,7 +107,7 @@ static int verify_vdec_pkt_cmd(struct msm_adsp_module *module,
 
 	/* deref those ptrs and check if they are a frame header packet */
 	frame_header_pkt = (viddec_cmd_frame_header_packet *)subframe_pkt_addr;
-
+	
 	switch (frame_header_pkt->packet_id) {
 	case 0xB201: /* h.264 */
 		num_addr = skip = 8;
diff --git a/drivers/staging/dream/qdsp5/audio_aac.c b/drivers/staging/dream/qdsp5/audio_aac.c
index ad2390f..4232b9f 100644
--- a/drivers/staging/dream/qdsp5/audio_aac.c
+++ b/drivers/staging/dream/qdsp5/audio_aac.c
@@ -666,7 +666,6 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			config.unused[0] = 0;
 			config.unused[1] = 0;
 			config.unused[2] = 0;
-			config.unused[3] = 0;
 			if (copy_to_user((void *)arg, &config,
 					 sizeof(config)))
 				rc = -EFAULT;
@@ -950,7 +949,7 @@ static int audio_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct audio the_aac_audio;
+struct audio the_aac_audio;
 
 static int audio_open(struct inode *inode, struct file *file)
 {
diff --git a/drivers/staging/dream/qdsp5/audio_amrnb.c b/drivers/staging/dream/qdsp5/audio_amrnb.c
index cd818a5..63fe2d0 100644
--- a/drivers/staging/dream/qdsp5/audio_amrnb.c
+++ b/drivers/staging/dream/qdsp5/audio_amrnb.c
@@ -551,7 +551,6 @@ static long audamrnb_ioctl(struct file *file, unsigned int cmd,
 			config.unused[0] = 0;
 			config.unused[1] = 0;
 			config.unused[2] = 0;
-			config.unused[3] = 0;
 			if (copy_to_user((void *)arg, &config,
 					 sizeof(config)))
 				rc = -EFAULT;
diff --git a/drivers/staging/dream/qdsp5/audio_evrc.c b/drivers/staging/dream/qdsp5/audio_evrc.c
index 4b43e18..8ee8d53 100644
--- a/drivers/staging/dream/qdsp5/audio_evrc.c
+++ b/drivers/staging/dream/qdsp5/audio_evrc.c
@@ -517,7 +517,6 @@ static long audevrc_ioctl(struct file *file, unsigned int cmd,
 			config.unused[0] = 0;
 			config.unused[1] = 0;
 			config.unused[2] = 0;
-			config.unused[3] = 0;
 			if (copy_to_user((void *)arg, &config, sizeof(config)))
 				rc = -EFAULT;
 			else
diff --git a/drivers/staging/dream/qdsp5/audio_in.c b/drivers/staging/dream/qdsp5/audio_in.c
index 3d950a2..35a7f7d 100644
--- a/drivers/staging/dream/qdsp5/audio_in.c
+++ b/drivers/staging/dream/qdsp5/audio_in.c
@@ -282,7 +282,7 @@ static void audio_in_get_dsp_frames(struct audio_in *audio)
 	/* XXX check for bogus frame size? */
 
 	frame = (void *) (((char *)audio->in[index].data) - sizeof(*frame));
-
+		
 	spin_lock_irqsave(&audio->dsp_lock, flags);
 	audio->in[index].size = frame->bytes;
 
@@ -524,7 +524,7 @@ static int audio_in_encoder_config(struct audio_in *audio)
 	cmd.samp_rate_index = audio->samp_rate_index;
 	cmd.stereo_mode = audio->channel_mode; /* 0 for mono, 1 for stereo */
 
-	/* FIXME have no idea why cmd.rec_quality is fixed
+	/* FIXME have no idea why cmd.rec_quality is fixed 
 	 * as 0x1C00 from sample code
 	 */
 	cmd.rec_quality = 0x1C00;
@@ -785,7 +785,7 @@ static int audio_in_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct audio_in the_audio_in;
+struct audio_in the_audio_in;
 
 static int audio_in_open(struct inode *inode, struct file *file)
 {
diff --git a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
index b95574f..f09bdcb 100644
--- a/drivers/staging/dream/qdsp5/audio_mp3.c
+++ b/drivers/staging/dream/qdsp5/audio_mp3.c
@@ -1,5 +1,5 @@
 /* arch/arm/mach-msm/qdsp5/audio_mp3.c
- *
+ * 
  * mp3 audio output device
  *
  * Copyright (C) 2008 Google, Inc.
@@ -469,7 +469,7 @@ static void audplay_send_data(struct audio *audio, unsigned needed)
 		 * so that it won't be recycled until the next buffer
 		 * is requested
 		 */
-
+			
 		frame = audio->out + audio->out_tail;
 		if (frame->used) {
 		  BUG_ON(frame->used == 0xffffffff);
@@ -604,7 +604,6 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		config.unused[0] = 0;
 		config.unused[1] = 0;
 		config.unused[2] = 0;
-		config.unused[3] = 0;
 		if (copy_to_user((void *) arg, &config, sizeof(config))) {
 			rc = -EFAULT;
 		} else {
@@ -864,7 +863,7 @@ static int audio_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct audio the_mp3_audio;
+struct audio the_mp3_audio;
 
 static int audio_open(struct inode *inode, struct file *file)
 {
diff --git a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
index d1adcf6..fcb1f13 100644
--- a/drivers/staging/dream/qdsp5/audio_out.c
+++ b/drivers/staging/dream/qdsp5/audio_out.c
@@ -227,7 +227,7 @@ static int audio_enable(struct audio *audio)
 	pr_info("audio_enable()\n");
 
 	if (audio->enabled)
-		return 0;
+		return 0;	
 
 	/* refuse to start if we're not ready */
 	if (!audio->out[0].used || !audio->out[1].used)
@@ -245,7 +245,7 @@ static int audio_enable(struct audio *audio)
 	cfg.codec = RPC_AUD_DEF_CODEC_PCM;
 	cfg.snd_method = RPC_SND_METHOD_MIDI;
 
-	audio_prevent_sleep(audio);
+	audio_prevent_sleep(audio);	
 	rc = audmgr_enable(&audio->audmgr, &cfg);
 	if (rc < 0) {
 		audio_allow_sleep(audio);
@@ -355,7 +355,7 @@ static int audio_dsp_out_enable(struct audio *audio, int yes)
 	audpp_cmd_pcm_intf cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.cmd_id	= AUDPP_CMD_PCM_INTF_2;
+	cmd.cmd_id	= AUDPP_CMD_PCM_INTF_2; 
 	cmd.object_num	= AUDPP_CMD_PCM_INTF_OBJECT_NUM;
 	cmd.config	= AUDPP_CMD_PCM_INTF_CONFIG_CMD_V;
 	cmd.intf_type	= AUDPP_CMD_PCM_INTF_RX_ENA_ARMTODSP_V;
@@ -374,14 +374,14 @@ static int audio_dsp_out_enable(struct audio *audio, int yes)
 		cmd.sample_rate		= audio->out_sample_rate;
 		cmd.channel_mode	= audio->out_channel_mode;
 	}
-
+	
 	return audpp_send_queue2(&cmd, sizeof(cmd));
 }
 
 static int audio_dsp_send_buffer(struct audio *audio, unsigned idx, unsigned len)
 {
 	audpp_cmd_pcm_intf_send_buffer cmd;
-
+	
 	cmd.cmd_id		= AUDPP_CMD_PCM_INTF_2;
 	cmd.host_pcm_object	= AUDPP_CMD_PCM_INTF_OBJECT_NUM;
 	cmd.config		= AUDPP_CMD_PCM_INTF_BUFFER_CMD_V;
@@ -573,7 +573,6 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		config.unused[0] = 0;
 		config.unused[1] = 0;
 		config.unused[2] = 0;
-		config.unused[3] = 0;
 		if (copy_to_user((void*) arg, &config, sizeof(config))) {
 			rc = -EFAULT;
 		} else {
@@ -682,7 +681,7 @@ static ssize_t audio_write(struct file *file, const char __user *buf,
 	LOG(EV_RETURN,(buf > start) ? (buf - start) : rc);
 	if (buf > start)
 		return buf - start;
-	return rc;
+	return rc;	
 }
 
 static int audio_release(struct inode *inode, struct file *file)
@@ -699,7 +698,7 @@ static int audio_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct audio the_audio;
+struct audio the_audio;
 
 static int audio_open(struct inode *inode, struct file *file)
 {
@@ -715,7 +714,7 @@ static int audio_open(struct inode *inode, struct file *file)
 	}
 
 	if (!audio->data) {
-		audio->data = dma_alloc_coherent(NULL, DMASZ,
+		audio->data = dma_alloc_coherent(NULL, DMASZ, 
 						 &audio->phys, GFP_KERNEL);
 		if (!audio->data) {
 			pr_err("audio: could not allocate DMA buffers\n");
@@ -736,7 +735,7 @@ static int audio_open(struct inode *inode, struct file *file)
 	audio->out[0].data = audio->data + 0;
 	audio->out[0].addr = audio->phys + 0;
 	audio->out[0].size = BUFSZ;
-
+	
 	audio->out[1].data = audio->data + BUFSZ;
 	audio->out[1].addr = audio->phys + BUFSZ;
 	audio->out[1].size = BUFSZ;
diff --git a/drivers/staging/dream/qdsp5/audio_qcelp.c b/drivers/staging/dream/qdsp5/audio_qcelp.c
index f0f50e3..9571469 100644
--- a/drivers/staging/dream/qdsp5/audio_qcelp.c
+++ b/drivers/staging/dream/qdsp5/audio_qcelp.c
@@ -531,7 +531,6 @@ static long audqcelp_ioctl(struct file *file, unsigned int cmd,
 			config.unused[0] = 0;
 			config.unused[1] = 0;
 			config.unused[2] = 0;
-			config.unused[3] = 0;
 			if (copy_to_user((void *)arg, &config,
 					 sizeof(config)))
 				rc = -EFAULT;
diff --git a/drivers/staging/dream/qdsp5/audmgr.c b/drivers/staging/dream/qdsp5/audmgr.c
index 1ad8b82..691ea8f 100644
--- a/drivers/staging/dream/qdsp5/audmgr.c
+++ b/drivers/staging/dream/qdsp5/audmgr.c
@@ -208,7 +208,7 @@ int audmgr_open(struct audmgr *am)
 
 	am->ept = msm_rpc_connect(AUDMGR_PROG,
 				AUDMGR_VERS,
-				MSM_RPC_UNINTERRUPTIBLE);
+				MSM_RPC_UNINTERRUPTIBLE | MSM_RPC_ENABLE_RECEIVE);
 
 	init_waitqueue_head(&am->wait);
 
diff --git a/drivers/staging/dream/qdsp5/audmgr.h b/drivers/staging/dream/qdsp5/audmgr.h
index c07c36b..cd2d0c6 100644
--- a/drivers/staging/dream/qdsp5/audmgr.h
+++ b/drivers/staging/dream/qdsp5/audmgr.h
@@ -1,6 +1,6 @@
 /* arch/arm/mach-msm/qdsp5/audmgr.h
  *
- * Copyright 2008 (c) QUALCOMM Incorporated.
+ * Copyright 2008 (c) QUALCOMM Incorporated. 
  * Copyright (C) 2008 Google, Inc.
  *
  * This software is licensed under the terms of the GNU General Public
@@ -131,7 +131,7 @@ struct rpc_audmgr_enable_client_args {
 	uint32_t cb_func;
 	uint32_t client_data;
 };
-
+	
 #define AUDMGR_ENABLE_CLIENT			2
 #define AUDMGR_DISABLE_CLIENT			3
 #define AUDMGR_SUSPEND_EVENT_RSP		4
@@ -159,7 +159,7 @@ struct rpc_audmgr_cb_func_ptr {
 	union {
 		uint32_t handle;
 		uint32_t volume;
-
+		
 	} u;
 };
 
diff --git a/drivers/staging/dream/qdsp5/audmgr_new.h b/drivers/staging/dream/qdsp5/audmgr_new.h
index 49670fe..4381242 100644
--- a/drivers/staging/dream/qdsp5/audmgr_new.h
+++ b/drivers/staging/dream/qdsp5/audmgr_new.h
@@ -1,6 +1,6 @@
 /* arch/arm/mach-msm/qdsp5/audmgr.h
  *
- * Copyright 2008 (c) QUALCOMM Incorporated.
+ * Copyright 2008 (c) QUALCOMM Incorporated. 
  * Copyright (C) 2008 Google, Inc.
  *
  * This software is licensed under the terms of the GNU General Public
@@ -135,7 +135,7 @@ struct rpc_audmgr_enable_client_args {
 	uint32_t cb_func;
 	uint32_t client_data;
 };
-
+	
 #define AUDMGR_ENABLE_CLIENT			2
 #define AUDMGR_DISABLE_CLIENT			3
 #define AUDMGR_SUSPEND_EVENT_RSP		4
diff --git a/drivers/staging/dream/qdsp5/audpp.c b/drivers/staging/dream/qdsp5/audpp.c
index d06556e..32c2847 100644
--- a/drivers/staging/dream/qdsp5/audpp.c
+++ b/drivers/staging/dream/qdsp5/audpp.c
@@ -251,7 +251,7 @@ int audpp_enable(int id, audpp_event_func func, void *private)
 					 AUDPP_MSG_CFG_MSG, AUDPP_MSG_ENA_ENA);
 		local_irq_restore(flags);
 	}
-
+			
 	res = 0;
 out:
 	mutex_unlock(audpp->lock);
@@ -331,7 +331,7 @@ unsigned audpp_avsync_sample_count(int id)
 
 	if (BAD_ID(id))
 		return 0;
-
+	
 	mask = 1 << id;
 	id = id * AUDPP_AVSYNC_INFO_SIZE + 2;
 	local_irq_save(flags);
@@ -375,7 +375,7 @@ int audpp_set_volume_and_pan(unsigned id, unsigned volume, int pan)
 {
 	/* cmd, obj_cfg[7], cmd_type, volume, pan */
 	uint16_t cmd[11];
-
+	
 	if (id > 6)
 		return -EINVAL;
 
diff --git a/drivers/staging/dream/qdsp5/evlog.h b/drivers/staging/dream/qdsp5/evlog.h
index 922ce67..5c0edf1 100644
--- a/drivers/staging/dream/qdsp5/evlog.h
+++ b/drivers/staging/dream/qdsp5/evlog.h
@@ -36,7 +36,7 @@ struct ev_entry {
 	uint32_t id;
 	uint32_t arg;
 };
-
+	
 struct ev_log {
 	struct ev_entry *entry;
 	unsigned max;
@@ -58,7 +58,7 @@ static ssize_t ev_log_read(struct file *file, char __user *buf,
 	int size = 0;
 	unsigned n, id, max;
 	ktime_t now, t;
-
+	
 	max = log->max;
 	now = ktime_get();
 	local_irq_save(flags);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
