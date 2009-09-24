Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZIXP0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZIXP0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIXP0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:26:52 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42881 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZIXP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:26:52 -0400
Date: Thu, 24 Sep 2009 15:26:53 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, greg@kroah.org,
       Lars Ericsson <Lars_Ericsson@telia.com>, David.Woodhouse@intel.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org,
       "'Ivo van Doorn'" <ivdoorn@gmail.com>
Subject: Re: [patch -stable] firware_class oops: fix firmware_loading_store
	locking
Message-ID: <20090924152653.GA19966@gambetta>
References: <20090916205717.GB12117@gambetta> <8A019019C4474E589B9EC14F451C0579@gotws1589> <20090921133223.GA13038@gambetta> <alpine.LFD.2.01.0909230936320.3303@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909230936320.3303@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:42:41AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 21 Sep 2009, Frederik Deweerdt wrote:
> <
> > I'd rather wait someone picks it up for mainline inclusion. I've added
> > your {Reported,Tested}-by tags.
> > 
> > The bug its vanilla 2.6.31, and should be considered for -stable inclusion.
> > 
> > Regards,
> > Frederik
> > 
> > ----
> > 
> > The code introduced by commit 6e03a201bbe8137487f340d26aa662110e324b20 leads
> > to a potential null deref. The following patch adds the proper locking
> > around the accesses to fw_priv->fw.
> > See http://bugzilla.kernel.org/show_bug.cgi?id=14185 for a full bug report.
> 
> I don't think this is correct.
> 
> I think you should protect the FW_STATUS_LOADING bit too, shouldn't you?
> 
> As it is, it does this:
> 
> 	if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
> 		mutex_lock(&fw_lock);
> 		...
> 		clear_bit(FW_STATUS_LOADING, &fw_priv->status);
> 		mutex_unlock(&fw_lock);
> 		break;
> 	}
> 
> and if this code can race (which it obviously can, since your addition of 
> fw_lock mutex matters), then I think it can race on that FW_STATUS_LOADING 
> bit too. No?
> 
> So my gut feel is that the whole damn function should be protected by the 
> mutex_lock thing. IOW, the patch would be something like the appended.
> 
> UNTESTED. Somebody needs to test this, verify, and send it back to me.
> 
> Am I missing something?
You're right, the status must be protected too, but we would want to
keep the check on fw_priv->fw not being NULL (patch follows).

I cannot reproduce the bug here, Lars could you please have a look ?

Regards,
Frederik

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7376367..21ac040 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -150,13 +150,15 @@ static ssize_t firmware_loading_store(struct device *dev,
 	int loading = simple_strtol(buf, NULL, 10);
 	int i;
 
+
+	mutex_lock(&fw_lock);
+	if (!fw_priv->fw) {
+		mutex_unlock(&fw_lock);
+		return -ENODEV;
+	}
+
 	switch (loading) {
 	case 1:
-		mutex_lock(&fw_lock);
-		if (!fw_priv->fw) {
-			mutex_unlock(&fw_lock);
-			break;
-		}
 		vfree(fw_priv->fw->data);
 		fw_priv->fw->data = NULL;
 		for (i = 0; i < fw_priv->nr_pages; i++)
@@ -167,7 +169,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 		fw_priv->nr_pages = 0;
 		fw_priv->fw->size = 0;
 		set_bit(FW_STATUS_LOADING, &fw_priv->status);
-		mutex_unlock(&fw_lock);
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
@@ -195,6 +196,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		fw_load_abort(fw_priv);
 		break;
 	}
+	mutex_unlock(&fw_lock);
 
 	return count;
 }
