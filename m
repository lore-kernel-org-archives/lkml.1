Return-Path: <linux-kernel-owner+w=401wt.eu-S938421AbXG3FkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938421AbXG3FkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbXG3FkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:40:12 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:56795
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755290AbXG3FkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:40:10 -0400
Date: Mon, 30 Jul 2007 07:40:04 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP driver
Message-ID: <20070730054004.GI3432@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Satyam Sharma <satyam@infradead.org>, Michael Buesch <mb@bu3sch.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070729212909.GC3432@traven> <20070729213434.GD3432@traven> <200707300006.42397.mb@bu3sch.de> <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0707300904360.10861@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707300904360.10861@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Jul 30, 2007 at 09:17:25AM +0530 Satyam Sharma ha dit:

> Whoops ...
> 
> 
> On Mon, 30 Jul 2007, Satyam Sharma wrote:
> 
> > On Mon, 30 Jul 2007, Michael Buesch wrote:
> > 
> > > On Sunday 29 July 2007 23:34, Matthias Kaehlcke wrote:
> > > > The Host AP driver uses a semaphore as mutex. Use the mutex API
> > > > instead of the (binary) semaphore.
> > > > 
> > > > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> > 
> > [ Something seems to have gone wrong with your diff / patch / script.
> >   There was no diff header here, which should have been. ]
> > 
> > > > -	res = down_interruptible(&local->rid_bap_sem);
> > > > +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
> > > >  	if (res)
> > > >  		return res;
> > > >  
> > > > @@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
> > > >  	/* RID len in words and +1 for rec.rid */
> > > >  	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
> > > >  
> > > > -	res = down_interruptible(&local->rid_bap_sem);
> > > > +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
> > > >  	if (res)
> > > >  		return res;
> > > >  
> > > 
> > > Is res returned to userspace? If yes, that's not right.
> > 
> > Yup, that's not right.
> > 
> > > On a interrupted mutex allocation you should return
> > > -ERESTARTSYS to userspace.
> > 
> > Nope, userspace must not see ERESTARTSYS (I /think/ this is the third
> > time I'm participating in this exact same discussion :-)
> > 
> > If the return would be caught by a previous in-kernel caller in the
> > call chain, ERESTARTSYS is okay and it could try to restart the
> > operation. However, if the return goes unfiltered directly to
> > userspace, EINTR is the correct choice.
> 
> Eek, and because mutex_lock_interruptible() *does* return -EINTR when
> interrupted by a signal, and I noticed that hfa384x_set_rid() could be
> called from an ioctl(2) codepath with no intermediate caller trying to
> restart it, so the code is perfectly alright, actually.
> 
> But the patch doesn't have the diff header anyway, so Matthias would
> probably have to resend in any case :-)

thanks for reviewing the patch and for your comments, here is the
patch with the diff header (no idea what when wrong with the other
one)

regards

matthias

--

The Host AP driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 959887b..d3dacbc 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -825,7 +825,7 @@ static int hfa384x_get_rid(struct net_device *dev, u16 rid, void *buf, int len,
 	    local->hw_downloading)
 		return -ENODEV;
 
-	res = down_interruptible(&local->rid_bap_sem);
+	res = mutex_lock_interruptible(&local->rid_bap_mtx);
 	if (res)
 		return res;
 
@@ -834,7 +834,7 @@ static int hfa384x_get_rid(struct net_device *dev, u16 rid, void *buf, int len,
 		printk(KERN_DEBUG "%s: hfa384x_get_rid: CMDCODE_ACCESS failed "
 		       "(res=%d, rid=%04x, len=%d)\n",
 		       dev->name, res, rid, len);
-		up(&local->rid_bap_sem);
+		mutex_unlock(&local->rid_bap_mtx);
 		return res;
 	}
 
@@ -861,7 +861,7 @@ static int hfa384x_get_rid(struct net_device *dev, u16 rid, void *buf, int len,
 		res = hfa384x_from_bap(dev, BAP0, buf, len);
 
 	spin_unlock_bh(&local->baplock);
-	up(&local->rid_bap_sem);
+	mutex_unlock(&local->rid_bap_mtx);
 
 	if (res) {
 		if (res != -ENODATA)
@@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
 	/* RID len in words and +1 for rec.rid */
 	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
 
-	res = down_interruptible(&local->rid_bap_sem);
+	res = mutex_lock_interruptible(&local->rid_bap_mtx);
 	if (res)
 		return res;
 
@@ -917,12 +917,12 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
 	if (res) {
 		printk(KERN_DEBUG "%s: hfa384x_set_rid (rid=%04x, len=%d) - "
 		       "failed - res=%d\n", dev->name, rid, len, res);
-		up(&local->rid_bap_sem);
+		mutex_unlock(&local->rid_bap_mtx);
 		return res;
 	}
 
 	res = hfa384x_cmd(dev, HFA384X_CMDCODE_ACCESS_WRITE, rid, NULL, NULL);
-	up(&local->rid_bap_sem);
+	mutex_unlock(&local->rid_bap_mtx);
 
 	if (res) {
 		printk(KERN_DEBUG "%s: hfa384x_set_rid: CMDCODE_ACCESS_WRITE "
@@ -3171,7 +3171,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	spin_lock_init(&local->cmdlock);
 	spin_lock_init(&local->baplock);
 	spin_lock_init(&local->lock);
-	init_MUTEX(&local->rid_bap_sem);
+	mutex_init(&local->rid_bap_mtx);
 
 	if (card_idx < 0 || card_idx >= MAX_PARM_DEVICES)
 		card_idx = 0;
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index 87a54aa..a42325c 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -3,6 +3,7 @@
 
 #include <linux/wireless.h>
 #include <linux/netdevice.h>
+#include <linux/mutex.h>
 #include <net/iw_handler.h>
 
 #include "hostap_config.h"
@@ -641,7 +642,7 @@ struct local_info {
 			      * when removing entries from the list.
 			      * TX and RX paths can use read lock. */
 	spinlock_t cmdlock, baplock, lock;
-	struct semaphore rid_bap_sem;
+	struct mutex rid_bap_mtx;
 	u16 infofid; /* MAC buffer id for info frame */
 	/* txfid, intransmitfid, next_txtid, and next_alloc are protected by
 	 * txfidlock */

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             You must have a plan. If you don't have a plan,
               you'll become part of somebody else's plan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
