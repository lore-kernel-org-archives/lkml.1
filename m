Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYIUUt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYIUUt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYIUUrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:47:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:41792 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbYIUUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=iVBgQIDDjsW3hs/UkpiuldWObBV3tG9zmWL84y9FdvhDy0mjV/VwPdu0mmCMw5olTO
         DV5X0R413O6Ie7QfWKdqiVjvmYZoYusC4XoJCXUxo3U1Ag7teP0z5gBEP7rrxle/0NKl
         PpH3dnsEu5IGoKBoZ2jyyBz0FkfIJ81Y53Kn8=
Date: Sun, 21 Sep 2008 22:45:42 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] uvesafb: don't treat mode info retrieval failures as errors
Message-ID: <20080921204542.GA21215@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>

Some BIOSes return error codes when queried for information about
modes from their own modelist.  uvesafb treats this as an error
case and bails out.

Change this behavior so that broken modes do not prevent the driver
from working.  Only the failure to retrieve information about any
usable video mode is considered to be an error case.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 5074422..6c2d37f 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -516,10 +516,12 @@ static int __devinit uvesafb_vbe_getmodes(struct uvesafb_ktask *task,
 
 		err = uvesafb_exec(task);
 		if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
-			printk(KERN_ERR "uvesafb: Getting mode info block "
+			printk(KERN_WARNING "uvesafb: Getting mode info block "
 				"for mode 0x%x failed (eax=0x%x, err=%d)\n",
 				*mode, (u32)task->t.regs.eax, err);
-			return -EINVAL;
+			mode++;
+			par->vbe_modes_cnt--;
+			continue;
 		}
 
 		mib = task->buf;
@@ -548,7 +550,10 @@ static int __devinit uvesafb_vbe_getmodes(struct uvesafb_ktask *task,
 			mib->depth = mib->bits_per_pixel;
 	}
 
-	return 0;
+	if (par->vbe_modes_cnt > 0)
+		return 0;
+	else
+		return -EINVAL;
 }
 
 /*

