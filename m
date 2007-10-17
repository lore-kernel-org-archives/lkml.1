Return-Path: <linux-kernel-owner+w=401wt.eu-S1763080AbXJQNqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763080AbXJQNqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbXJQNqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:46:47 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34840 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbXJQNqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:46:46 -0400
Message-ID: <47161243.6060007@tiscali.nl>
Date: Wed, 17 Oct 2007 15:46:43 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] fix not-and/or errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    if(!x & y) should either be if(!(x & y)) or if(!x && y)
    I made changes as seemed appropriate, but please review
    this is against current git.
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
index f569b00..46f156f 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
@@ -410,7 +410,7 @@ static int parse_mtoken(const char *ptr,unsigned int len,
 	int msk;
 	*valptr = 0;
 	for (idx = 0, msk = 1; valid_bits; idx++, msk <<= 1) {
-		if (!msk & valid_bits) continue;
+		if (!(msk & valid_bits)) continue;
 		valid_bits &= ~msk;
 		if (!names[idx]) continue;
 		slen = strlen(names[idx]);
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index 7dce318..65c67d1 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -322,7 +322,7 @@ static void write_status(acpi_handle handle, int out, int mask)
 
 	switch (mask) {
 	case MLED_ON:
-		out = !out & 0x1;
+		out = !(out & 0x1);
 		break;
 	case GLED_ON:
 		out = (out & 0x1) + 1;
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index b960f66..6de9d7e 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -343,10 +343,10 @@ static int cmf_copy_block(struct ccw_device *cdev)
 
 	if (sch->schib.scsw.fctl & SCSW_FCTL_START_FUNC) {
 		/* Don't copy if a start function is in progress. */
-		if ((!sch->schib.scsw.actl & SCSW_ACTL_SUSPENDED) &&
+		if ((!(sch->schib.scsw.actl & SCSW_ACTL_SUSPENDED)) &&
 		    (sch->schib.scsw.actl &
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT)) &&
-		    (!sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS))
+		    (!(sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS)))
 			return -EBUSY;
 	}
 	cmb_data = cdev->private->cmb;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 73c44cb..81943ef 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2882,7 +2882,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
-				STp->use_pf = !STp->use_pf | PF_TESTED;
+				STp->use_pf = !(STp->use_pf | PF_TESTED);
 				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 60a8f55..b64309e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -335,7 +335,7 @@ static void kick_khubd(struct usb_hub *hub)
 	to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
 
 	spin_lock_irqsave(&hub_event_lock, flags);
-	if (!hub->disconnected & list_empty(&hub->event_list)) {
+	if (!hub->disconnected && list_empty(&hub->event_list)) {
 		list_add_tail(&hub->event_list, &hub_event_list);
 		wake_up(&khubd_wait);
 	}
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index 1a7d778..1d13dd0 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 	struct i810fb_par *par = info->par;
 	u8 __iomem *mmio = par->mmio_start_virtual;
 
-	if (!par->dev_flags & LOCKUP)
+	if (!(par->dev_flags & LOCKUP))
 		return -ENXIO;
 
 	if (cursor->image.width > 64 || cursor->image.height > 64)
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4ba7f0b..ce62c15 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3946,7 +3946,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	struct ocfs2_merge_ctxt ctxt;
 	struct ocfs2_extent_list *rightmost_el;
 
-	if (!rec->e_flags & OCFS2_EXT_UNWRITTEN) {
+	if (!(rec->e_flags & OCFS2_EXT_UNWRITTEN)) {
 		ret = -EIO;
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 41c76ff..ef09fd2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -670,7 +670,7 @@ static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *loc
 {
 	mlog_entry_void();
 
-	BUG_ON((!lockres->l_flags & OCFS2_LOCK_BUSY));
+	BUG_ON((!(lockres->l_flags & OCFS2_LOCK_BUSY)));
 	BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
 
 	if (lockres->l_requested > LKM_NLMODE &&
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index 9b58dd6..bc67230 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -709,7 +709,7 @@ int ieee80211_wx_get_encodeext(struct ieee80211_device *ieee,
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;
