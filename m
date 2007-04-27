Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXD0It1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXD0It1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbXD0It1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:49:27 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:50258
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755488AbXD0It0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:49:26 -0400
Date: Fri, 27 Apr 2007 10:52:17 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: jim.cromie@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 5/5] scx200: use mutex instead of semaphore
Message-ID: <20070427085217.GG4213@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070427083857.GB4213@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427083857.GB4213@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the scx200 driver use a semaphore as mutex. use the mutex API instead
of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com

--
diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 0b082c5..669d2ac 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -389,7 +389,7 @@ static const struct i2c_algorithm scx200_acb_algorithm = {
 };
 
 static struct scx200_acb_iface *scx200_acb_list;
-static DECLARE_MUTEX(scx200_acb_list_mutex);
+static DEFINE_MUTEX(scx200_acb_list_mutex);
 
 static __init int scx200_acb_probe(struct scx200_acb_iface *iface)
 {
@@ -473,10 +473,10 @@ static int __init scx200_acb_create(struct scx200_acb_iface *iface)
 		return -ENODEV;
 	}
 
-	down(&scx200_acb_list_mutex);
+	mutex_lock(&scx200_acb_list_mutex);
 	iface->next = scx200_acb_list;
 	scx200_acb_list = iface;
-	up(&scx200_acb_list_mutex);
+	mutex_unlock(&scx200_acb_list_mutex);
 
 	return 0;
 }
@@ -633,10 +633,10 @@ static void __exit scx200_acb_cleanup(void)
 {
 	struct scx200_acb_iface *iface;
 
-	down(&scx200_acb_list_mutex);
+	mutex_lock(&scx200_acb_list_mutex);
 	while ((iface = scx200_acb_list) != NULL) {
 		scx200_acb_list = iface->next;
-		up(&scx200_acb_list_mutex);
+		mutex_unlock(&scx200_acb_list_mutex);
 
 		i2c_del_adapter(&iface->adapter);
 
@@ -648,9 +648,9 @@ static void __exit scx200_acb_cleanup(void)
 			release_region(iface->base, 8);
 
 		kfree(iface);
-		down(&scx200_acb_list_mutex);
+		mutex_lock(&scx200_acb_list_mutex);
 	}
-	up(&scx200_acb_list_mutex);
+	mutex_unlock(&scx200_acb_list_mutex);
 }
 
 module_init(scx200_acb_init);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
