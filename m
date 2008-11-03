Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYKCLUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYKCLUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbYKCLUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:20:08 -0500
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:2833 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbYKCLUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:20:06 -0500
Subject: [PATCH 5/8] p80211wext.c add latest changes & remove extra nulls
	from wext_handlers
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:20:04 +0000
Message-Id: <1225711204.3113.24.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the latest changes from wlan-ng-devel
remove 2 stray nulls from the wext_handler table introduced
by the tidy up patch.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211wext.c |   39
++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 153e5eb..de0789a 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -553,10 +553,13 @@ static int p80211wext_giwencode(netdevice_t *dev,
 
 	DBFENTER;
 
+	i = (erq->flags & IW_ENCODE_INDEX) - 1;
+	erq->flags = 0;
+
 	if (wlandev->hostwep & HOSTWEP_PRIVACYINVOKED)
-		erq->flags = IW_ENCODE_ENABLED;
+		erq->flags |= IW_ENCODE_ENABLED;
 	else
-		erq->flags = IW_ENCODE_DISABLED;
+		erq->flags |= IW_ENCODE_DISABLED;
 
 	if (wlandev->hostwep & HOSTWEP_EXCLUDEUNENCRYPTED)
 		erq->flags |= IW_ENCODE_RESTRICTED;
@@ -619,17 +622,24 @@ static int p80211wext_siwencode(netdevice_t *dev,
 			err = -EFAULT;
 			goto exit;
 		}
-		else {
-			enable = 1;
+
+		/* Set current key number only if no keys are given */
+		if (erq->flags & IW_ENCODE_NOKEY) {
+			result = p80211wext_dorequest(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID, i);
+		
+			if (result) {
+				err = -EFAULT;
+				goto exit;
+			}
 		}
 
-	}
-	else {
-		// Do not thing when no Key Index
+	} else {
+		// Use defaultkey if no Key Index
+		i = wlandev->hostwep & HOSTWEP_DEFAULTKEY_MASK;
 	}
 
 	/* Check if there is no key information in the iwconfig request */
-	if((erq->flags & IW_ENCODE_NOKEY) == 0 && enable == 1) {
+	if((erq->flags & IW_ENCODE_NOKEY) == 0 ) {
 
 		/*------------------------------------------------------------
 		 * If there is WEP Key for setting, check the Key Information
@@ -684,8 +694,7 @@ static int p80211wext_siwencode(netdevice_t *dev,
 	/* Check the PrivacyInvoked flag */
 	if (erq->flags & IW_ENCODE_DISABLED) {
 		result = p80211wext_dorequest(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked, P80211ENUM_truth_false);
-	}
-	else if((erq->flags & IW_ENCODE_ENABLED) || enable == 1) {
+	} else {
 		result = p80211wext_dorequest(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked, P80211ENUM_truth_true);
 	}
 
@@ -694,7 +703,13 @@ static int p80211wext_siwencode(netdevice_t *dev,
 		goto exit;
 	}
 
-	/* Check the ExcludeUnencrypted flag */
+	/*  The  security  mode  may  be open or restricted, and its meaning
+	    depends on the card used. With  most  cards,  in  open  mode  no
+	    authentication  is  used  and  the  card  may  also  accept non-
+	    encrypted sessions, whereas in restricted  mode  only  encrypted
+	    sessions  are  accepted  and the card will use authentication if
+	    available. 
+	*/
 	if (erq->flags & IW_ENCODE_RESTRICTED) {
 		result = p80211wext_dorequest(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted, P80211ENUM_truth_true);
 	}
@@ -1760,8 +1775,6 @@ static iw_handler p80211wext_handlers[] =  {
 	(iw_handler) NULL,                  		/* SIOCGIWAPLIST */
 	(iw_handler) p80211wext_siwscan,		/* SIOCSIWSCAN */
 	(iw_handler) p80211wext_giwscan,		/* SIOCGIWSCAN */
-	(iw_handler) NULL,	/* null */		/* SIOCSIWSCAN */
-	(iw_handler) NULL,	/* null */		/* SIOCGIWSCAN */
 	(iw_handler) p80211wext_siwessid,  		/* SIOCSIWESSID */
 	(iw_handler) p80211wext_giwessid,      		/* SIOCGIWESSID */
 	(iw_handler) NULL,                 		/* SIOCSIWNICKN */
-- 
1.5.6.5



