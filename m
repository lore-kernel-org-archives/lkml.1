Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYJPSDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYJPSDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYJPSAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:00:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783AbYJPSAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:00:48 -0400
Date: Thu, 16 Oct 2008 10:56:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 08/14] libertas: clear current command on card removal
Message-ID: <20081016175637.GI12850@suse.de>
References: <20081016174814.734527827@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libertas-clear-current-command-on-card-removal.patch"
In-Reply-To: <20081016175525.GA12850@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dan Williams <dcbw@redhat.com>

commit 71b35f3abeb8f7f7e0afd7573424540cc5aae2d5 upstream

If certain commands were in-flight when the card was pulled or the
driver rmmod-ed, cleanup would block on the work queue stopping, but the
work queue was in turn blocked on the current command being canceled,
which didn't happen.  Fix that.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/main.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1196,7 +1196,13 @@ void lbs_remove_card(struct lbs_private 
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_delayed_work_sync(&priv->assoc_work);
 	cancel_work_sync(&priv->mcast_work);
+
+	/* worker thread destruction blocks on the in-flight command which
+	 * should have been cleared already in lbs_stop_card().
+	 */
+	lbs_deb_main("destroying worker thread\n");
 	destroy_workqueue(priv->work_thread);
+	lbs_deb_main("done destroying worker thread\n");
 
 	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
 		priv->psmode = LBS802_11POWERMODECAM;
@@ -1314,14 +1320,26 @@ void lbs_stop_card(struct lbs_private *p
 		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 	}
 
-	/* Flush pending command nodes */
+	/* Delete the timeout of the currently processing command */
 	del_timer_sync(&priv->command_timer);
+
+	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
+	lbs_deb_main("clearing pending commands\n");
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
 		cmdnode->result = -ENOENT;
 		cmdnode->cmdwaitqwoken = 1;
 		wake_up_interruptible(&cmdnode->cmdwait_q);
 	}
+
+	/* Flush the command the card is currently processing */
+	if (priv->cur_cmd) {
+		lbs_deb_main("clearing current command\n");
+		priv->cur_cmd->result = -ENOENT;
+		priv->cur_cmd->cmdwaitqwoken = 1;
+		wake_up_interruptible(&priv->cur_cmd->cmdwait_q);
+	}
+	lbs_deb_main("done clearing commands\n");
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	unregister_netdev(dev);

-- 
