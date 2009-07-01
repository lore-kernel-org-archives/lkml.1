Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbZGABEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbZGABEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbZGAAfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:10 -0400
Received: from kroah.org ([198.145.64.141]:60485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760246AbZGAAfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:32 2009
Message-Id: <20090701002432.655132080@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 063/108] cfg80211: fix for duplicate userspace replies
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=cfg80211-fix-for-duplicate-userspace-replies.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 729e9c7663190d71fe5e29831634df80f38199c1 upstream.

This fixes an incorrect assumption (BUG_ON) made in
cfg80211 when handling country IE regulatory requests.
The assumption was that we won't try to call_crda()
twice for the same event and therefore we will not
recieve two replies through nl80211 for the regulatory
request. As it turns out it is true we don't call_crda()
twice for the same event, however, kobject_uevent_env()
*might* send the udev event twice and/or userspace can
simply process the udev event twice. We remove the BUG_ON()
and simply ignore the duplicate request.

For details refer to this thread:

http://marc.info/?l=linux-wireless&m=124149987921337&w=2

Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2042,7 +2042,13 @@ static int __set_regdom(const struct iee
 	 * the country IE rd with what CRDA believes that country should have
 	 */
 
-	BUG_ON(!country_ie_regdomain);
+	/*
+	 * Userspace could have sent two replies with only
+	 * one kernel request. By the second reply we would have
+	 * already processed and consumed the country_ie_regdomain.
+	 */
+	if (!country_ie_regdomain)
+		return -EALREADY;
 	BUG_ON(rd == country_ie_regdomain);
 
 	/*


