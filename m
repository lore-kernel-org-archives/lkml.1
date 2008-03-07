Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbYCGTSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbYCGTSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763547AbYCGTRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:17:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757948AbYCGTRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:17:51 -0500
Date: Fri, 7 Mar 2008 11:16:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: linux-pcmcia@lists.infradead.org, nico@cam.org, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/pcmcia/soc_common.c: convert
 soc_pcmcia_sockets_lock in a mutex
Message-Id: <20080307111642.8278142f.akpm@linux-foundation.org>
In-Reply-To: <20080307183742.GF2783@traven>
References: <20080307183742.GF2783@traven>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 19:37:42 +0100 Matthias Kaehlcke <matthias@kaehlcke.net> wrote:

> drivers/pcmcia/soc_common.c: the semaphore soc_pcmcia_sockets_lock is
> used as a mutex, convert it to the mutex API
> 

I did this yesterday, when I saw it while grepping around due to your other
patch;)

>  LIST_HEAD(soc_pcmcia_sockets);
> -DECLARE_MUTEX(soc_pcmcia_sockets_lock);
> +DEFINE_MUTEX(soc_pcmcia_sockets_lock);

I made this static.

> -extern struct semaphore soc_pcmcia_sockets_lock;
> +extern struct mutex soc_pcmcia_sockets_lock;

And deleted this.


 drivers/pcmcia/soc_common.c |   15 ++++++++-------
 drivers/pcmcia/soc_common.h |    1 -
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/pcmcia/soc_common.c~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static drivers/pcmcia/soc_common.c
--- a/drivers/pcmcia/soc_common.c~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static
+++ a/drivers/pcmcia/soc_common.c
@@ -37,6 +37,7 @@
 #include <linux/kernel.h>
 #include <linux/timer.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
@@ -578,7 +579,7 @@ EXPORT_SYMBOL(soc_pcmcia_enable_irqs);
 
 
 LIST_HEAD(soc_pcmcia_sockets);
-DECLARE_MUTEX(soc_pcmcia_sockets_lock);
+static DEFINE_MUTEX(soc_pcmcia_sockets_lock);
 
 static const char *skt_names[] = {
 	"PCMCIA socket 0",
@@ -601,11 +602,11 @@ soc_pcmcia_notifier(struct notifier_bloc
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
@@ -642,7 +643,7 @@ int soc_common_drv_pcmcia_probe(struct d
 	struct soc_pcmcia_socket *skt;
 	int ret, i;
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 
 	sinfo = kzalloc(SKT_DEV_INFO_SIZE(nr), GFP_KERNEL);
 	if (!sinfo) {
@@ -782,7 +783,7 @@ int soc_common_drv_pcmcia_probe(struct d
 	kfree(sinfo);
 
  out:
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 	return ret;
 }
 
@@ -793,7 +794,7 @@ int soc_common_drv_pcmcia_remove(struct 
 
 	dev_set_drvdata(dev, NULL);
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 	for (i = 0; i < sinfo->nskt; i++) {
 		struct soc_pcmcia_socket *skt = &sinfo->skt[i];
 
@@ -818,7 +819,7 @@ int soc_common_drv_pcmcia_remove(struct 
 	if (list_empty(&soc_pcmcia_sockets))
 		soc_pcmcia_cpufreq_unregister();
 
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 
 	kfree(sinfo);
 
diff -puN drivers/pcmcia/soc_common.h~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static drivers/pcmcia/soc_common.h
--- a/drivers/pcmcia/soc_common.h~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static
+++ a/drivers/pcmcia/soc_common.h
@@ -133,7 +133,6 @@ extern void soc_common_pcmcia_get_timing
 
 
 extern struct list_head soc_pcmcia_sockets;
-extern struct semaphore soc_pcmcia_sockets_lock;
 
 extern int soc_common_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops, int first, int nr);
 extern int soc_common_drv_pcmcia_remove(struct device *dev);
_

