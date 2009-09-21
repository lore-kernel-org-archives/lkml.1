Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZIUNc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZIUNc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZIUNcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:32:25 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:45788 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZIUNcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:32:24 -0400
Date: Mon, 21 Sep 2009 13:32:23 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: greg@kroah.org, torvalds@linux-foundation.org,
       Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'Frederik Deweerdt'" <frederik.deweerdt@xprog.eu>,
       David.Woodhouse@intel.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, "'Ivo van Doorn'" <ivdoorn@gmail.com>
Subject: [patch -stable] firware_class oops: fix firmware_loading_store
	locking
Message-ID: <20090921133223.GA13038@gambetta>
References: <20090916205717.GB12117@gambetta> <8A019019C4474E589B9EC14F451C0579@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A019019C4474E589B9EC14F451C0579@gotws1589>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
On Fri, Sep 18, 2009 at 07:53:40PM +0200, Lars Ericsson wrote:
> > On Wed, Sep 16, 2009 at 08:44:43PM +0200, Lars Ericsson wrote:
> > > Hi,
> > > 
> > > I have discovered a Oops in the firmware_loading_store function. 
> > > At first it looks like a timing issue but after adding a 
> > BUG_ON test,
> > > it fails every time. 
> > > 
> > > drivers\base\firmware_class:
> > > ------------------------------
> > >  541 01c0 F6463401 	testb $1,52(%esi)
> > >  542 01c4 0F843FFF 	je .L38
> > >  542      FFFF
> > >  543              	.loc 1 174 0
> > >  544 01ca 8B4630   	movl 48(%esi),%eax
> > >  545 01cd 8B4004   	movl 4(%eax),%eax	<---- Oops
> > >  546 01d0 E8FCFFFF 	call vfree
> > >  546      FF
> > > 
> > > The code that fails was introduced in commit
> > > 6e03a201bbe8137487f340d26aa662110e324b20 
> > Could you try the following patch?
> 
> No, problem.
> I have tried the patch and it works for me. I will continue my 
> tests and report any problems. 
> 
> Should I close the http://bugzilla.kernel.org/show_bug.cgi?id=14185 ,
> which I have created before I noticed you reply ?
> 
I'd rather wait someone picks it up for mainline inclusion. I've added
your {Reported,Tested}-by tags.

The bug its vanilla 2.6.31, and should be considered for -stable inclusion.

Regards,
Frederik

----

The code introduced by commit 6e03a201bbe8137487f340d26aa662110e324b20 leads
to a potential null deref. The following patch adds the proper locking
around the accesses to fw_priv->fw.
See http://bugzilla.kernel.org/show_bug.cgi?id=14185 for a full bug report.


Reported-by: Lars Ericsson <Lars_Ericsson@telia.com>
Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Tested-by: Lars Ericsson <Lars_Ericsson@telia.com>


diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8a267c4..49105ed 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -171,12 +171,18 @@ static ssize_t firmware_loading_store(struct device *dev,
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
+			mutex_lock(&fw_lock);
+			if (!fw_priv->fw) {
+				mutex_unlock(&fw_lock);
+				break;
+			}
 			vfree(fw_priv->fw->data);
 			fw_priv->fw->data = vmap(fw_priv->pages,
 						 fw_priv->nr_pages,
 						 0, PAGE_KERNEL_RO);
 			if (!fw_priv->fw->data) {
 				dev_err(dev, "%s: vmap() failed\n", __func__);
+				mutex_unlock(&fw_lock);
 				goto err;
 			}
 			/* Pages will be freed by vfree() */
@@ -185,6 +191,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
 			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
+			mutex_unlock(&fw_lock);
 			break;
 		}
 		/* fallthrough */

