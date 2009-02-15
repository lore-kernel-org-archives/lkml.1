Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZBOKU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZBOKU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZBOKUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:20:13 -0500
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:41963 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZBOKUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:20:12 -0500
Message-ID: <4997EC57.1020608@numericable.fr>
Date: Sun, 15 Feb 2009 11:20:07 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.mNF.9r0lJB@chimera> <4997E7D7.60205@numericable.fr>
In-Reply-To: <4997E7D7.60205@numericable.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12613
>> Subject		: [Suspend regression][DRM, RADEON]
>> Submitter	: etienne <etienne.basset@numericable.fr>
>> Date		: 2009-01-28 22:00 (18 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
>> References	: http://marc.info/?l=linux-kernel&m=123318030419558&w=4
>> 		  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
>> 		  http://lkml.org/lkml/2009/2/8/203
>>
>>
>>
hello,

yes it is still present in -rc5;
the following unreviewed patch fixes it for me;

regards,
Etienne, who should learn to send correct emails

Signed-off-by: <etienne.basset@numericable.fr>
---
diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index df4cf97..6554adf 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -557,7 +557,8 @@ static int radeon_do_engine_reset(struct drm_device * dev)
 }
 
 static void radeon_cp_init_ring_buffer(struct drm_device * dev,
-				       drm_radeon_private_t * dev_priv)
+				       drm_radeon_private_t * dev_priv,
+				       struct drm_radeon_master_private *master)
 {
 	u32 ring_start, cur_read_ptr;
 	u32 tmp;
@@ -668,13 +669,13 @@ static void radeon_cp_init_ring_buffer(struct drm_device * dev,
 		RADEON_WRITE(RADEON_BUS_CNTL, tmp);
 	} /* PCIE cards appears to not need this */
 
-	dev_priv->scratch[0] = 0;
+	master->sarea_priv->last_frame = dev_priv->scratch[0] = 0;
 	RADEON_WRITE(RADEON_LAST_FRAME_REG, 0);
 
-	dev_priv->scratch[1] = 0;
+	master->sarea_priv->last_dispatch = dev_priv->scratch[1] = 0;
 	RADEON_WRITE(RADEON_LAST_DISPATCH_REG, 0);
 
-	dev_priv->scratch[2] = 0;
+	master->sarea_priv->last_clear = dev_priv->scratch[2] = 0;
 	RADEON_WRITE(RADEON_LAST_CLEAR_REG, 0);
 
 	radeon_do_wait_for_idle(dev_priv);
@@ -1215,7 +1216,7 @@ static int radeon_do_init_cp(struct drm_device *dev, drm_radeon_init_t *init,
 	}
 
 	radeon_cp_load_microcode(dev_priv);
-	radeon_cp_init_ring_buffer(dev, dev_priv);
+	radeon_cp_init_ring_buffer(dev, dev_priv, master_priv);
 
 	dev_priv->last_buf = 0;
 
@@ -1281,9 +1282,11 @@ static int radeon_do_cleanup_cp(struct drm_device * dev)
  *
  * Charl P. Botha <http://cpbotha.net>
  */
-static int radeon_do_resume_cp(struct drm_device * dev)
+static int radeon_do_resume_cp(struct drm_device * dev,
+			       struct drm_file * file_priv)
 {
 	drm_radeon_private_t *dev_priv = dev->dev_private;
+	struct drm_radeon_master_private * master_priv = file_priv->master->driver_priv;
 
 	if (!dev_priv) {
 		DRM_ERROR("Called with no initialization\n");
@@ -1304,7 +1307,7 @@ static int radeon_do_resume_cp(struct drm_device * dev)
 	}
 
 	radeon_cp_load_microcode(dev_priv);
-	radeon_cp_init_ring_buffer(dev, dev_priv);
+	radeon_cp_init_ring_buffer(dev, dev_priv, master_priv);
 
 	radeon_do_engine_reset(dev);
 	radeon_irq_set_state(dev, RADEON_SW_INT_ENABLE, 1);
@@ -1480,7 +1483,7 @@ int radeon_cp_idle(struct drm_device *dev, void *data, struct drm_file *file_pri
 int radeon_cp_resume(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 
-	return radeon_do_resume_cp(dev);
+	return radeon_do_resume_cp(dev, file_priv);
 }
 
 int radeon_engine_reset(struct drm_device *dev, void *data, struct drm_file *file_priv)
