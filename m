Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbYBNSLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbYBNSLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYBNSLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:11:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:26880 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYBNSLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:11:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I6xA+7uLSQ+UFQV+lBBT/lzxfBLe0rZGmRKLsDUbuxW8GR1nAxtOrXD09OrP0wcyGevduApRWn6BcvI+egEbs6HOMftBIQBffRcNxu30G7T7CChD5sqs/Fn+C+me9SwzUMsmJfqukVEIcUFKVTMwpIG1mSGHsvK9xrjZP1XHrBE=
Subject: [PATCH 05/11v2] ata: replace macro with static inline in libata.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080214120101.150a3284@core>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
	 <1202966058.2748.19.camel@brick>  <20080214120101.150a3284@core>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 10:11:37 -0800
Message-Id: <1203012697.2748.55.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using min/max_t(short... use a static inline to get
typechecking.

As a bonus, avoid a metric ton of sparse warnings like:
drivers/ata/pata_ali.c:176:14: warning: symbol '__x' shadows an earlier one
drivers/ata/pata_ali.c:176:14: originally declared here

Due to nesting min_t macro inside max_t macro which both use a __x
identifier internally.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Alan, is this more to your liking?

 include/linux/libata.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index bc5a8d0..b5590fb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -764,7 +764,14 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
+static inline short FIT(short v, short vmin, short vmax)
+{
+	if (v >= vmax)
+		return vmax;
+	if (v <= vmin)
+		return vmin;
+	return v;
+}
 
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
-- 
1.5.4.1.1278.gc75be



