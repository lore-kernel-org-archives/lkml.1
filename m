Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbZGAAoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbZGAAoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761069AbZGAAdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:33:04 -0400
Received: from kroah.org ([198.145.64.141]:59862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761046AbZGAAdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:33:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:52 2009
Message-Id: <20090701001552.616407113@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Rottmann <JRottmann@LiPPERTEmbedded.de>,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 25/35] parport_pc: after superio probing restore original register values
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=parport_pc-after-superio-probing-restore-original-register-values.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

commit e2434dc1c19412639dd047a4d4eff8ed0e5d0d50 upstream.

CONFIG_PARPORT_PC_SUPERIO probes for various superio chips by writing
byte sequences to a set of different potential I/O ranges.  But the
probed ranges are not exclusive to parallel ports.  Some of our boards
just happen to have a watchdog in one of them.  Took us almost a week
to figure out why some distros reboot without warning after running
flawlessly for 3 hours.  For exactly 170 = 0xAA minutes, that is ...

Fixed by restoring original values after probing.  Also fixed too small
request_region() in detect_and_report_it87().

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parport/parport_pc.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1413,11 +1413,13 @@ static void __devinit decode_smsc(int ef
 
 static void __devinit winbond_check(int io, int key)
 {
-	int devid,devrev,oldid,x_devid,x_devrev,x_oldid;
+	int origval, devid, devrev, oldid, x_devid, x_devrev, x_oldid;
 
 	if (!request_region(io, 3, __func__))
 		return;
 
+	origval = inb(io); /* Save original value */
+
 	/* First probe without key */
 	outb(0x20,io);
 	x_devid=inb(io+1);
@@ -1437,6 +1439,8 @@ static void __devinit winbond_check(int 
 	oldid=inb(io+1);
 	outb(0xaa,io);    /* Magic Seal */
 
+	outb(origval, io); /* in case we poked some entirely different hardware */
+
 	if ((x_devid == devid) && (x_devrev == devrev) && (x_oldid == oldid))
 		goto out; /* protection against false positives */
 
@@ -1447,11 +1451,15 @@ out:
 
 static void __devinit winbond_check2(int io,int key)
 {
-        int devid,devrev,oldid,x_devid,x_devrev,x_oldid;
+	int origval[3], devid, devrev, oldid, x_devid, x_devrev, x_oldid;
 
 	if (!request_region(io, 3, __func__))
 		return;
 
+	origval[0] = inb(io); /* Save original values */
+	origval[1] = inb(io + 1);
+	origval[2] = inb(io + 2);
+
 	/* First probe without the key */
 	outb(0x20,io+2);
 	x_devid=inb(io+2);
@@ -1470,6 +1478,10 @@ static void __devinit winbond_check2(int
         oldid=inb(io+2);
         outb(0xaa,io);    /* Magic Seal */
 
+	outb(origval[0], io); /* in case we poked some entirely different hardware */
+	outb(origval[1], io + 1);
+	outb(origval[2], io + 2);
+
 	if ((x_devid == devid) && (x_devrev == devrev) && (x_oldid == oldid))
 		goto out; /* protection against false positives */
 
@@ -1480,11 +1492,13 @@ out:
 
 static void __devinit smsc_check(int io, int key)
 {
-        int id,rev,oldid,oldrev,x_id,x_rev,x_oldid,x_oldrev;
+	int origval, id, rev, oldid, oldrev, x_id, x_rev, x_oldid, x_oldrev;
 
 	if (!request_region(io, 3, __func__))
 		return;
 
+	origval = inb(io); /* Save original value */
+
 	/* First probe without the key */
 	outb(0x0d,io);
 	x_oldid=inb(io+1);
@@ -1508,6 +1522,8 @@ static void __devinit smsc_check(int io,
 	rev=inb(io+1);
         outb(0xaa,io);    /* Magic Seal */
 
+	outb(origval, io); /* in case we poked some entirely different hardware */
+
 	if ((x_id == id) && (x_oldrev == oldrev) &&
 	    (x_oldid == oldid) && (x_rev == rev))
 		goto out; /* protection against false positives */
@@ -1544,11 +1560,12 @@ static void __devinit detect_and_report_
 static void __devinit detect_and_report_it87(void)
 {
 	u16 dev;
-	u8 r;
+	u8 origval, r;
 	if (verbose_probing)
 		printk(KERN_DEBUG "IT8705 Super-IO detection, now testing port 2E ...\n");
-	if (!request_region(0x2e, 1, __func__))
+	if (!request_region(0x2e, 2, __func__))
 		return;
+	origval = inb(0x2e);		/* Save original value */
 	outb(0x87, 0x2e);
 	outb(0x01, 0x2e);
 	outb(0x55, 0x2e);
@@ -1568,8 +1585,10 @@ static void __devinit detect_and_report_
 		outb(r | 8, 0x2F);
 		outb(0x02, 0x2E);	/* Lock */
 		outb(0x02, 0x2F);
+	} else {
+		outb(origval, 0x2e);	/* Oops, sorry to disturb */
 	}
-	release_region(0x2e, 1);
+	release_region(0x2e, 2);
 }
 #endif /* CONFIG_PARPORT_PC_SUPERIO */
 


