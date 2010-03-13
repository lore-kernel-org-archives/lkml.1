Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab0CMIxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:53:34 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45521 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932875Ab0CMIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:53:33 -0500
Date: Sat, 13 Mar 2010 09:53:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>, Greg KH <greg@kroah.com>
Subject: staging/dream: remove last bits of earlysuspend support
Message-ID: <20100313085324.GQ12554@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove last bits of earlysuspend support.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/TODO b/drivers/staging/dream/TODO
index c07c880..dcd3ba8 100644
--- a/drivers/staging/dream/TODO
+++ b/drivers/staging/dream/TODO
@@ -1,4 +1,3 @@
-* remove support for wakelocks since those are not in mainline
 
 * camera driver uses old V4L API
 
diff --git a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
index df87ca3..351bf63 100644
--- a/drivers/staging/dream/qdsp5/audio_out.c
+++ b/drivers/staging/dream/qdsp5/audio_out.c
@@ -181,9 +181,6 @@ struct audio {
 	int stopped; /* set when stopped, cleared on flush */
 	unsigned volume;
 
-	struct wake_lock wakelock;
-	struct wake_lock idlelock;
-
 	int adrc_enable;
 	struct adrc_filter adrc;
 
@@ -197,14 +194,10 @@ struct audio {
 static void audio_prevent_sleep(struct audio *audio)
 {
 	printk(KERN_INFO "++++++++++++++++++++++++++++++\n");
-	wake_lock(&audio->wakelock);
-	wake_lock(&audio->idlelock);
 }
 
 static void audio_allow_sleep(struct audio *audio)
 {
-	wake_unlock(&audio->wakelock);
-	wake_unlock(&audio->idlelock);
 	printk(KERN_INFO "------------------------------\n");
 }
 
@@ -839,8 +832,6 @@ static int __init audio_init(void)
 	mutex_init(&the_audio.write_lock);
 	spin_lock_init(&the_audio.dsp_lock);
 	init_waitqueue_head(&the_audio.wait);
-	wake_lock_init(&the_audio.wakelock, WAKE_LOCK_SUSPEND, "audio_pcm");
-	wake_lock_init(&the_audio.idlelock, WAKE_LOCK_IDLE, "audio_pcm_idle");
 	return (misc_register(&audio_misc) || misc_register(&audpp_misc));
 }
 
diff --git a/drivers/staging/dream/smd/smd_rpcrouter_servers.c b/drivers/staging/dream/smd/smd_rpcrouter_servers.c
index 2597bbb..3ae1f45 100644
--- a/drivers/staging/dream/smd/smd_rpcrouter_servers.c
+++ b/drivers/staging/dream/smd/smd_rpcrouter_servers.c
@@ -26,7 +26,6 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/wakelock.h>
 
 #include <linux/msm_rpcrouter.h>
 #include <linux/uaccess.h>
@@ -41,7 +40,6 @@ static struct msm_rpc_endpoint *endpoint;
 static LIST_HEAD(rpc_server_list);
 static DEFINE_MUTEX(rpc_server_list_lock);
 static int rpc_servers_active;
-static struct wake_lock rpc_servers_wake_lock;
 
 static void rpc_server_register(struct msm_rpc_server *server)
 {
@@ -135,10 +133,8 @@ static int rpc_servers_thread(void *data)
 	int rc;
 
 	for (;;) {
-		wake_unlock(&rpc_servers_wake_lock);
 		rc = wait_event_interruptible(endpoint->wait_q,
 						!list_empty(&endpoint->read_q));
-		wake_lock(&rpc_servers_wake_lock);
 		rc = msm_rpc_read(endpoint, &buffer, -1, -1);
 		if (rc < 0) {
 			printk(KERN_ERR "%s: could not read: %d\n",
@@ -218,7 +214,6 @@ static struct platform_driver rpcservers_driver = {
 
 static int __init rpc_servers_init(void)
 {
-	wake_lock_init(&rpc_servers_wake_lock, WAKE_LOCK_SUSPEND, "rpc_server");
 	return platform_driver_register(&rpcservers_driver);
 }
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
