Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbXGaN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbXGaN7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbXGaN7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:59:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58145 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751835AbXGaN73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:59:29 -0400
Date: Tue, 31 Jul 2007 15:58:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: ecashin@coraid.com, kernel list <linux-kernel@vger.kernel.org>
Cc: ak@suse.de
Subject: ATA over ethernet swapping and obfuscated code
Message-ID: <20070731135831.GA4604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I wanted to know if it is possible/okay to swap over AOE... 

According to
http://www.coraid.com/support/linux/EtherDrive-2.6-HOWTO-5.html#ss5.20
.. it runs OOM even during normal use, so I guess swapping over it is
no-no?

Can I build both client and server for these using free software?

In the process, I looked at the aoe code, and parts of it look like
obfuscated C contest. The use of switch() as an if was particulary
creative; I'm not even sure if I translated it properly... can you
take a look?

(Patch is 

Signed-off-by: Pavel Machek <pavel@suse.cz>

but I did not even compile test it)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 05a9719..38ba35d 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -64,29 +64,26 @@ aoedev_newdev(ulong nframes)
 
 	d = kzalloc(sizeof *d, GFP_ATOMIC);
 	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
- 	switch (!d || !f) {
- 	case 0:
- 		d->nframes = nframes;
- 		d->frames = f;
- 		e = f + nframes;
- 		for (; f<e; f++) {
- 			f->tag = FREETAG;
- 			f->skb = new_skb(ETH_ZLEN);
- 			if (!f->skb)
- 				break;
- 		}
- 		if (f == e)
- 			break;
+ 	if (!d || !f) {
+		kfree(f);
+		kfree(d);
+		return NULL;
+	}
+
+	d->nframes = nframes;
+	d->frames = f;
+	e = f + nframes;
+	for (; f<e; f++) {
+		f->tag = FREETAG;
+		f->skb = new_skb(ETH_ZLEN);
+		if (!f->skb)
+			break;
+	}
+	if (f != e) {
  		while (f > d->frames) {
  			f--;
  			dev_kfree_skb(f->skb);
  		}
- 	default:
- 		if (f)
- 			kfree(f);
- 		if (d)
- 			kfree(d);
-		return NULL;
 	}
 	INIT_WORK(&d->work, aoecmd_sleepwork);
 	spin_lock_init(&d->lock);


aoedev_by_sysminor_m() returns with spinlock held in error case; I
guess that's bad.

struct aoedev *
aoedev_by_sysminor_m(ulong sysminor, ulong bufcnt)
{
	struct aoedev *d;
	ulong flags;

	spin_lock_irqsave(&devlist_lock, flags);

	for (d=devlist; d; d=d->next)
		if (d->sysminor == sysminor)
			break;

	if (d == NULL) {
		d = aoedev_newdev(bufcnt);
	 	if (d == NULL) {
			spin_unlock_irqrestore(&devlist_lock, flags);
			printk(KERN_INFO "aoe: aoedev_newdev
failure.\n");
			return NULL;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ here
		}
		d->sysminor = sysminor;
		d->aoemajor = AOEMAJOR(sysminor);
		d->aoeminor = AOEMINOR(sysminor);
	}

	spin_unlock_irqrestore(&devlist_lock, flags);
	return d;
}

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
