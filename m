Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbXKOGnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbXKOGnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXKOGme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55063 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXKOGmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:31 -0500
Date: Wed, 14 Nov 2007 22:39:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>,
       "John W. Linville" <linville@tuxdriver.com>,
       Al Viro <viro@ftp.linux.org.uk>, Dan Williams <dcbw@redhat.com>
Subject: [patch 01/16] libertas: more endianness breakage
Message-ID: <20071115063936.GA18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libertas-more-endianness-breakage.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Al Viro <viro@ftp.linux.org.uk>

based on patch 8362cd413e8116306fafbaf414f0419db0595142 in mainline.

	domain->header.len is le16 and has just been assigned
cpu_to_le16(arithmetical expression).  And all fields of adapter->logmsg
are __le32; not a single 16-bit among them...
	That's incremental to the previous one

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/11d.c  |    2 +-
 drivers/net/wireless/libertas/wext.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/libertas/11d.c
+++ b/drivers/net/wireless/libertas/11d.c
@@ -562,7 +562,7 @@ int libertas_cmd_802_11d_domain_info(wla
 		       nr_subband * sizeof(struct ieeetypes_subbandset));
 
 		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
-					     domain->header.len +
+					     le16_to_cpu(domain->header.len) +
 					     sizeof(struct mrvlietypesheader) +
 					     S_DS_GEN);
 	} else {
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -973,7 +973,7 @@ static struct iw_statistics *wlan_get_wi
 	/* Quality by TX errors */
 	priv->wstats.discard.retries = priv->stats.tx_errors;
 
-	tx_retries = le16_to_cpu(adapter->logmsg.retry);
+	tx_retries = le32_to_cpu(adapter->logmsg.retry);
 
 	if (tx_retries > 75)
 		tx_qual = (90 - tx_retries) * POOR / 15;
@@ -989,10 +989,10 @@ static struct iw_statistics *wlan_get_wi
 		    (PERFECT - VERY_GOOD) / 50 + VERY_GOOD;
 	quality = min(quality, tx_qual);
 
-	priv->wstats.discard.code = le16_to_cpu(adapter->logmsg.wepundecryptable);
-	priv->wstats.discard.fragment = le16_to_cpu(adapter->logmsg.rxfrag);
+	priv->wstats.discard.code = le32_to_cpu(adapter->logmsg.wepundecryptable);
+	priv->wstats.discard.fragment = le32_to_cpu(adapter->logmsg.rxfrag);
 	priv->wstats.discard.retries = tx_retries;
-	priv->wstats.discard.misc = le16_to_cpu(adapter->logmsg.ackfailure);
+	priv->wstats.discard.misc = le32_to_cpu(adapter->logmsg.ackfailure);
 
 	/* Calculate quality */
 	priv->wstats.qual.qual = max(quality, (u32)100);

-- 
