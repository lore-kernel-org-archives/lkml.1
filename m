Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936548Ab0CMBgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:36:16 -0500
Received: from kroah.org ([198.145.64.141]:60531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934802Ab0CMATf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:35 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:05 2010
Message-Id: <20100313001505.692774660@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dcbw@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 006/123] airo: fix setting zero length WEP key
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit f09c256375c7cf1e112b8ef6306cdd313490d7c0 upstream.

Patch prevents call set_wep_key() with zero key length. That fix long
standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
"airo: clean up WEP key operations". Additionally print call trace when
someone will try to use improper parameters, and remove key.len = 0
assignment, because it is in not possible code path.

Reported-by: Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Bisected-by: Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Tested-by: Chris Siebenmann <cks@cs.toronto.edu>
Cc: Dan Williams <dcbw@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/airo.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5254,11 +5254,7 @@ static int set_wep_key(struct airo_info
 	WepKeyRid wkr;
 	int rc;
 
-	if (keylen == 0) {
-		airo_print_err(ai->dev->name, "%s: key length to set was zero",
-			       __func__);
-		return -1;
-	}
+	WARN_ON(keylen == 0);
 
 	memset(&wkr, 0, sizeof(wkr));
 	wkr.len = cpu_to_le16(sizeof(wkr));
@@ -6405,11 +6401,7 @@ static int airo_set_encode(struct net_de
 		if (dwrq->length > MIN_KEY_SIZE)
 			key.len = MAX_KEY_SIZE;
 		else
-			if (dwrq->length > 0)
-				key.len = MIN_KEY_SIZE;
-			else
-				/* Disable the key */
-				key.len = 0;
+			key.len = MIN_KEY_SIZE;
 		/* Check if the key is not marked as invalid */
 		if(!(dwrq->flags & IW_ENCODE_NOKEY)) {
 			/* Cleanup */
@@ -6590,12 +6582,22 @@ static int airo_set_encodeext(struct net
 		default:
 			return -EINVAL;
 		}
-		/* Send the key to the card */
-		rc = set_wep_key(local, idx, key.key, key.len, perm, 1);
-		if (rc < 0) {
-			airo_print_err(local->dev->name, "failed to set WEP key"
-			               " at index %d: %d.", idx, rc);
-			return rc;
+		if (key.len == 0) {
+			rc = set_wep_tx_idx(local, idx, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name,
+					       "failed to set WEP transmit index to %d: %d.",
+					       idx, rc);
+				return rc;
+			}
+		} else {
+			rc = set_wep_key(local, idx, key.key, key.len, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name,
+					       "failed to set WEP key at index %d: %d.",
+					       idx, rc);
+				return rc;
+			}
 		}
 	}
 


