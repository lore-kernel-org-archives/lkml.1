Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbXFCOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbXFCOjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXFCOjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:39:17 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:22906 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752758AbXFCOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:39:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=r3TSizyn6zo8xyHdFUGKrW7d0X4ufYdqG8+JGUtaNid/UEWu269GSesgmYoBfoVR2Fw6Z2oyeZwsGLW6Gj43FSg1TkFkQqGXq/hTZbgEyl2BUdLG2sPFHcVo9d2fEdolx6f3fkGfGWDscY9kl5uHI4uKB7GiEE/H4zlpTxiNs3s=;
X-YMail-OSG: 25REAxUVM1nVTvipsZ.CiOLx7If96.Erj19TmBmNgQ.bpFds3g8mrBg0lnN0wYxvqLRdlA--
Date: Sun, 3 Jun 2007 07:39:14 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 2/36] drivers edac add edac_mc_find API
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <147202.82456.qm@web50104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

This simple patch adds an important CORE API for EDAC that
EDAC drivers can use to find their edac_mc control structure by passing
a mem_ctl_info 'instance' value

Needed for subsequent patches

Signed-off-by:  Douglas Thompson <dougthompson@xmission.com>
--
 edac_mc.c |   28 ++++++++++++++++++++++++++++
 edac_mc.h |    1 +
 2 files changed, 29 insertions(+)
--
diff -puN
drivers/edac/edac_mc.c~edac-new-opteron-athlon64-memory-controller-driver
drivers/edac/edac_mc.c
---
a/drivers/edac/edac_mc.c~edac-new-opteron-athlon64-memory-controller-driver
+++ a/drivers/edac/edac_mc.c
@@ -1457,6 +1457,34 @@ static void del_mc_from_global_list(stru
 }
 
 /**
+ * edac_mc_find: Search for a mem_ctl_info structure whose index is
'idx'.
+ *
+ * If found, return a pointer to the structure.
+ * Else return NULL.
+ *
+ * Caller must hold mem_ctls_mutex.
+ */
+struct mem_ctl_info * edac_mc_find(int idx)
+{
+	struct list_head *item;
+	struct mem_ctl_info *mci;
+
+	list_for_each(item, &mc_devices) {
+		mci = list_entry(item, struct mem_ctl_info, link);
+
+		if (mci->mc_idx >= idx) {
+			if (mci->mc_idx == idx)
+				return mci;
+
+			break;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(edac_mc_find);
+
+/**
  * edac_mc_add_mc: Insert the 'mci' structure into the mci global list
and
  *                 create sysfs entries associated with mci structure
  * @mci: pointer to the mci structure to be added to the list
diff -puN
drivers/edac/edac_mc.h~edac-new-opteron-athlon64-memory-controller-driver
drivers/edac/edac_mc.h
---
a/drivers/edac/edac_mc.h~edac-new-opteron-athlon64-memory-controller-driver
+++ a/drivers/edac/edac_mc.h
@@ -430,6 +430,7 @@ void edac_mc_dump_mci(struct mem_ctl_inf
 void edac_mc_dump_csrow(struct csrow_info *csrow);
 #endif  /* CONFIG_EDAC_DEBUG */
 
+extern struct mem_ctl_info * edac_mc_find(int idx);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci,int mc_idx);
 extern struct mem_ctl_info * edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,

