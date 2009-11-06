Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbZKFWfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbZKFWfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbZKFWf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:35:29 -0500
Received: from kroah.org ([198.145.64.141]:56895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760187AbZKFWXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:45 2009
Message-Id: <20091106221545.241612251@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [48/99] mac80211: check interface is down before type change
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=mac80211-check-interface-is-down-before-type-change.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

commit c1f9a764cf47686b1f5a0cf87ada68d90056136a upstream.

For some strange reason the netif_running() check
ended up after the actual type change instead of
before, potentially causing all kinds of problems
if the interface is up while changing the type;
one of the problems manifests itself as a warning:

WARNING: at net/mac80211/iface.c:651 ieee80211_teardown_sdata+0xda/0x1a0 [mac80211]()
Hardware name: Aspire one
Pid: 2596, comm: wpa_supplicant Tainted: G        W  2.6.31-10-generic #32-Ubuntu
Call Trace:
 [] warn_slowpath_common+0x6d/0xa0
 [] warn_slowpath_null+0x15/0x20
 [] ieee80211_teardown_sdata+0xda/0x1a0 [mac80211]
 [] ieee80211_if_change_type+0x4a/0xc0 [mac80211]
 [] ieee80211_change_iface+0x61/0xa0 [mac80211]
 [] cfg80211_wext_siwmode+0xc7/0x120 [cfg80211]
 [] ioctl_standard_call+0x58/0xf0

(http://www.kerneloops.org/searchweek.php?search=ieee80211_teardown_sdata)

Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/cfg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -87,6 +87,9 @@ static int ieee80211_change_iface(struct
 	if (!dev)
 		return -ENODEV;
 
+	if (netif_running(dev))
+		return -EBUSY;
+
 	if (!nl80211_type_check(type))
 		return -EINVAL;
 
@@ -96,9 +99,6 @@ static int ieee80211_change_iface(struct
 	if (ret)
 		return ret;
 
-	if (netif_running(sdata->dev))
-		return -EBUSY;
-
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
 		ieee80211_sdata_set_mesh_id(sdata,
 					    params->mesh_id_len,


