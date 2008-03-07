Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbYCGSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbYCGSiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbYCGShw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:37:52 -0500
Received: from mx1.riseup.net ([204.13.164.18]:55564 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbYCGShv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:37:51 -0500
Date: Fri, 7 Mar 2008 19:37:42 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: linux-pcmcia@lists.infradead.org, nico@cam.org, rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] drivers/pcmcia/soc_common.c: convert
	soc_pcmcia_sockets_lock in a mutex
Message-ID: <20080307183742.GF2783@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	linux-pcmcia@lists.infradead.org, nico@cam.org,
	rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pcmcia/soc_common.c: the semaphore soc_pcmcia_sockets_lock is
used as a mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index aa7779d..3490431 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -578,7 +578,7 @@ EXPORT_SYMBOL(soc_pcmcia_enable_irqs);
 
 
 LIST_HEAD(soc_pcmcia_sockets);
-DECLARE_MUTEX(soc_pcmcia_sockets_lock);
+DEFINE_MUTEX(soc_pcmcia_sockets_lock);
 
 static const char *skt_names[] = {
 	"PCMCIA socket 0",
@@ -601,11 +601,11 @@ soc_pcmcia_notifier(struct notifier_block *nb, unsigned long val, void *data)
 	struct cpufreq_freqs *freqs = data;
 	int ret = 0;
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 	list_for_each_entry(skt, &soc_pcmcia_sockets, node)
 		if ( skt->ops->frequency_change )
 			ret += skt->ops->frequency_change(skt, val, freqs);
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 
 	return ret;
 }
@@ -642,7 +642,7 @@ int soc_common_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops
 	struct soc_pcmcia_socket *skt;
 	int ret, i;
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 
 	sinfo = kzalloc(SKT_DEV_INFO_SIZE(nr), GFP_KERNEL);
 	if (!sinfo) {
@@ -782,7 +782,7 @@ int soc_common_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops
 	kfree(sinfo);
 
  out:
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 	return ret;
 }
 
@@ -793,7 +793,7 @@ int soc_common_drv_pcmcia_remove(struct device *dev)
 
 	dev_set_drvdata(dev, NULL);
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 	for (i = 0; i < sinfo->nskt; i++) {
 		struct soc_pcmcia_socket *skt = &sinfo->skt[i];
 
@@ -818,7 +818,7 @@ int soc_common_drv_pcmcia_remove(struct device *dev)
 	if (list_empty(&soc_pcmcia_sockets))
 		soc_pcmcia_cpufreq_unregister();
 
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 
 	kfree(sinfo);
 
diff --git a/drivers/pcmcia/soc_common.h b/drivers/pcmcia/soc_common.h
index 6f14126..a553df5 100644
--- a/drivers/pcmcia/soc_common.h
+++ b/drivers/pcmcia/soc_common.h
@@ -11,6 +11,7 @@
 
 /* include the world */
 #include <linux/cpufreq.h>
+#include <linux/mutex.h>
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/ss.h>
@@ -133,7 +134,7 @@ extern void soc_common_pcmcia_get_timing(struct soc_pcmcia_socket *, struct soc_
 
 
 extern struct list_head soc_pcmcia_sockets;
-extern struct semaphore soc_pcmcia_sockets_lock;
+extern struct mutex soc_pcmcia_sockets_lock;
 
 extern int soc_common_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops, int first, int nr);
 extern int soc_common_drv_pcmcia_remove(struct device *dev);

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

    Tant qu'il y aura sur terre des hommes pour qui existe un concept
    d' 'honneur national', la menace d'une nouvelle guerre subsistera
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
