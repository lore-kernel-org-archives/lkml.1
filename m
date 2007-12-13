Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbXLMGzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbXLMGzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbXLMGz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbXLMGz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:28 -0500
Date: Wed, 12 Dec 2007 22:50:57 -0800
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
       Marcelo Tosatti <marcelo@kvack.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 01/60] libertas: properly account for queue commands
Message-ID: <20071213065056.GB6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libertas-properly-account-for-queue-commands.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Marcelo Tosatti <marcelo@kvack.org>

patch 29f5f2a19b055feabfcc6f92e1d40ec092c373ea in mainline.

Properly account for queue commands, this fixes a problem reported
by Holger Schurig when using the debugfs interface.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/cmd.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -881,6 +881,10 @@ static int wlan_cmd_mesh_access(wlan_pri
 	return 0;
 }
 
+/*
+ * Note: NEVER use libertas_queue_cmd() with addtail==0 other than for
+ * the command timer, because it does not account for queued commands.
+ */
 void libertas_queue_cmd(wlan_adapter * adapter, struct cmd_ctrl_node *cmdnode, u8 addtail)
 {
 	unsigned long flags;
@@ -910,10 +914,11 @@ void libertas_queue_cmd(wlan_adapter * a
 
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
-	if (addtail)
+	if (addtail) {
 		list_add_tail((struct list_head *)cmdnode,
 			      &adapter->cmdpendingq);
-	else
+		adapter->nr_cmd_pending++;
+	} else
 		list_add((struct list_head *)cmdnode, &adapter->cmdpendingq);
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
@@ -1400,7 +1405,6 @@ int libertas_prepare_and_send_command(wl
 	cmdnode->cmdwaitqwoken = 0;
 
 	libertas_queue_cmd(adapter, cmdnode, 1);
-	adapter->nr_cmd_pending++;
 	wake_up_interruptible(&priv->mainthread.waitq);
 
 	if (wait_option & cmd_option_waitforrsp) {

-- 
