Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZIWQnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZIWQnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZIWQnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:43:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbZIWQnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:43:21 -0400
Date: Wed, 23 Sep 2009 09:42:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
cc: greg@kroah.org, Lars Ericsson <Lars_Ericsson@telia.com>,
       David.Woodhouse@intel.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, "'Ivo van Doorn'" <ivdoorn@gmail.com>
Subject: Re: [patch -stable] firware_class oops: fix firmware_loading_store
 locking
In-Reply-To: <20090921133223.GA13038@gambetta>
Message-ID: <alpine.LFD.2.01.0909230936320.3303@localhost.localdomain>
References: <20090916205717.GB12117@gambetta> <8A019019C4474E589B9EC14F451C0579@gotws1589> <20090921133223.GA13038@gambetta>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Sep 2009, Frederik Deweerdt wrote:
<
> I'd rather wait someone picks it up for mainline inclusion. I've added
> your {Reported,Tested}-by tags.
> 
> The bug its vanilla 2.6.31, and should be considered for -stable inclusion.
> 
> Regards,
> Frederik
> 
> ----
> 
> The code introduced by commit 6e03a201bbe8137487f340d26aa662110e324b20 leads
> to a potential null deref. The following patch adds the proper locking
> around the accesses to fw_priv->fw.
> See http://bugzilla.kernel.org/show_bug.cgi?id=14185 for a full bug report.

I don't think this is correct.

I think you should protect the FW_STATUS_LOADING bit too, shouldn't you?

As it is, it does this:

	if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
		mutex_lock(&fw_lock);
		...
		clear_bit(FW_STATUS_LOADING, &fw_priv->status);
		mutex_unlock(&fw_lock);
		break;
	}

and if this code can race (which it obviously can, since your addition of 
fw_lock mutex matters), then I think it can race on that FW_STATUS_LOADING 
bit too. No?

So my gut feel is that the whole damn function should be protected by the 
mutex_lock thing. IOW, the patch would be something like the appended.

UNTESTED. Somebody needs to test this, verify, and send it back to me.

Am I missing something?

		Linus

---
 drivers/base/firmware_class.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7376367..1b803df 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -150,13 +150,12 @@ static ssize_t firmware_loading_store(struct device *dev,
 	int loading = simple_strtol(buf, NULL, 10);
 	int i;
 
+	mutex_lock(&fw_lock);
 	switch (loading) {
 	case 1:
-		mutex_lock(&fw_lock);
-		if (!fw_priv->fw) {
-			mutex_unlock(&fw_lock);
+		if (!fw_priv->fw)
 			break;
-		}
+
 		vfree(fw_priv->fw->data);
 		fw_priv->fw->data = NULL;
 		for (i = 0; i < fw_priv->nr_pages; i++)
@@ -167,7 +166,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 		fw_priv->nr_pages = 0;
 		fw_priv->fw->size = 0;
 		set_bit(FW_STATUS_LOADING, &fw_priv->status);
-		mutex_unlock(&fw_lock);
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
@@ -195,6 +193,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		fw_load_abort(fw_priv);
 		break;
 	}
+	mutex_unlock(&fw_lock);
 
 	return count;
 }
