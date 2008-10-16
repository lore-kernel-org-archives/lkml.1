Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYJPSBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYJPSBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYJPSA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:00:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:36033 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbYJPSA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:00:27 -0400
Date: Thu, 16 Oct 2008 10:56:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       linux-wireless <linux-wireless@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [patch 03/14] mac80211: fix two issues in debugfs
Message-ID: <20081016175625.GD12850@suse.de>
References: <20081016174814.734527827@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-fix-two-issues-in-debugfs.patch"
In-Reply-To: <20081016175525.GA12850@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

Not in trees above 2.6.27 as it is fixed differently in .28.

This fixes RHBZ 466264, whenever the master interface is
renamed this code would BUG_ON. Also fixes a separately
reported bug with the debugfs dir being NULL.

This patch is not applicable to the next kernel version
because both these issues have been fixed, the first one
by not having the master interface have a ieee80211_ptr
at all, and the second one by also leaving the function
early.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/debugfs_netdev.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -537,6 +537,7 @@ static int netdev_notify(struct notifier
 {
 	struct net_device *dev = ndev;
 	struct dentry *dir;
+	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	char buf[10+IFNAMSIZ];
 
@@ -549,10 +550,19 @@ static int netdev_notify(struct notifier
 	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
 		return 0;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	/*
+	 * Do not use IEEE80211_DEV_TO_SUB_IF because that
+	 * BUG_ONs for the master netdev which we need to
+	 * handle here.
+	 */
+	sdata = netdev_priv(dev);
 
-	sprintf(buf, "netdev:%s", dev->name);
 	dir = sdata->debugfsdir;
+
+	if (!dir)
+		return 0;
+
+	sprintf(buf, "netdev:%s", dev->name);
 	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
 		printk(KERN_ERR "mac80211: debugfs: failed to rename debugfs "
 		       "dir to %s\n", buf);

-- 
