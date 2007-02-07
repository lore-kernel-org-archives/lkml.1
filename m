Return-Path: <linux-kernel-owner+w=401wt.eu-S1161417AbXBGSAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161417AbXBGSAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161416AbXBGSAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:00:18 -0500
Received: from web38503.mail.mud.yahoo.com ([209.191.125.49]:20835 "HELO
	web38503.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161412AbXBGSAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:00:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FRIjRC+ik925QaQ9u7Oo3Rc/W6qpMnGZ6GI5iaJ+L2ZAX2a3Tu+Wqa5iAHDXioWxwA+heA+Alrh3FTIjyoVkr5KiaosBWg1vwVkWGdk4G9cLDkvT2opZaJobAKy5Y/lc2bYVsavzKkk9qXSyntQihzmCg4wvBp1PgoJ9M2zw+Qs=;
X-YMail-OSG: IL7j8xEVM1mbkpxxan5NXp3WuLP6.MMcMKLW0tp2
Date: Wed, 7 Feb 2007 10:00:15 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Re: [PATCH] [NET] dmfe : number of fixes and features
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <861713.74052.qm@web38503.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Levitsky <maximlevitsky@yahoo.com>
Subject: [PATCH] [NET] [003] dmfe : fix link detection

Cleanup link detection
Fix link not detected when using external PHY

Signed-off-by: Maxim Levitsky <maximlevitsky@yahoo.com>

---

CR12's bits 0 and 1 show link status/speed only for internal PHY.
In case external one is used, only bit 6 shows link status via special line , and can be left
unnconected
Thus we need to check bit 6 and also query PHY for link status
Note: internal phy is standard phy , so will indicate link status too.

--- linux-2.6.20-mod/drivers/net/tulip/dmfe.c	2007-02-07 18:40:33.000000000 +0200
+++ linux-2.6.20-test/drivers/net/tulip/dmfe.c	2007-02-07 18:44:01.000000000 +0200
@@ -147,7 +147,7 @@
 	printk(KERN_ERR DRV_NAME ": %s %lx\n", (msg), (long) (value))
 
 #define SHOW_MEDIA_TYPE(mode) \
-	printk(KERN_ERR DRV_NAME ": \
+	printk(KERN_INFO DRV_NAME ": \
 	Change Speed to %sMhz %s duplex\n",mode & 1 ?"100":"10", \
 	mode & 4 ? "full":"half");
 
@@ -242,7 +242,6 @@ struct dmfe_board_info {
 	u8 media_mode;			/* user specify media mode */
 	u8 op_mode;			/* real work media mode */
 	u8 phy_addr;
-	u8 link_failed;			/* Ever link failed */
 	u8 wait_reset;			/* Hardware failed, need to reset */
 	u8 dm910x_chk_mode;		/* Operating mode check */
 	u8 first_in_callback;		/* Flag to record state */
@@ -536,7 +535,6 @@ static int dmfe_open(struct DEVICE *dev)
 	db->tx_packet_cnt = 0;
 	db->tx_queue_cnt = 0;
 	db->rx_avail_cnt = 0;
-	db->link_failed = 1;
 	db->wait_reset = 0;
 
 	db->first_in_callback = 0;
@@ -1091,6 +1089,8 @@ static void dmfe_timer(unsigned long dat
 	struct dmfe_board_info *db = netdev_priv(dev);
  	unsigned long flags;
 
+	int link_ok, link_ok_phy;
+
 	DMFE_DBUG(0, "dmfe_timer()", 0);
 	spin_lock_irqsave(&db->lock, flags);
 
@@ -1155,22 +1155,45 @@ static void dmfe_timer(unsigned long dat
 	else
 		tmp_cr12 = inb(db->ioaddr + DCR12);	/* DM9102/DM9102A */
 
+	
 	if ( ((db->chip_id == PCI_DM9102_ID) &&
 		(db->chip_revision == 0x02000030)) ||
 		((db->chip_id == PCI_DM9132_ID) &&
 		(db->chip_revision == 0x02000010)) ) {
 		/* DM9102A Chip */
 		if (tmp_cr12 & 2)
-			tmp_cr12 = 0x0;		/* Link failed */
+			link_ok = 0;
 		else
-			tmp_cr12 = 0x3;	/* Link OK */
+			link_ok = 1;
+	}
+	else
+		/*0x43 is used instead of 0x3 because bit 6 should be 
+			connected to external PHY and specify its link status.*/
+		link_ok = (tmp_cr12 & 0x43) ? 1 : 0;
+	
+	
+	/* If chip reports that link is failed it could be because external 
+		PHY is not conected correctly to chip (through pin 89).
+		To be sure ask PHY too.
+	*/
+	
+	/* need a dummy read because of PHY's register latch*/
+	phy_read (db->ioaddr, db->phy_addr, 1, db->chip_id); 
+	link_ok_phy = (phy_read (db->ioaddr, 
+		       db->phy_addr, 1, db->chip_id) & 0x4) ? 1 : 0;
+	
+
+	
+	if (link_ok_phy != link_ok) {
+		DMFE_DBUG (0, "PHY and chip report different link status", 0);
+		link_ok = link_ok | link_ok_phy;
 	}
 
-	if ( !(tmp_cr12 & 0x3) && !db->link_failed ) {
+	if ( !link_ok && netif_carrier_ok(dev) ) {
 		/* Link Failed */
 		DMFE_DBUG(0, "Link Failed", tmp_cr12);
-		db->link_failed = 1;
-		netif_carrier_off(db->dev);
+		
+		netif_carrier_off(dev);
 
 		/* For Force 10/100M Half/Full mode: Enable Auto-Nego mode */
 		/* AUTO or force 1M Homerun/Longrun don't need */
@@ -1184,19 +1207,17 @@ static void dmfe_timer(unsigned long dat
 			db->cr6_data&=~0x00000200;	/* bit9=0, HD mode */
 			update_cr6(db->cr6_data, db->ioaddr);
 		}
-	} else
-		if ((tmp_cr12 & 0x3) && db->link_failed) {
-			DMFE_DBUG(0, "Link link OK", tmp_cr12);
-			db->link_failed = 0;
+		
+	} else if (!netif_carrier_ok(dev)) {
+		
+		DMFE_DBUG(0, "Link OK", tmp_cr12);
 
 			/* Auto Sense Speed */
-			if ( (db->media_mode & DMFE_AUTO) &&
-				dmfe_sense_speed(db) )
-				db->link_failed = 1;
-			else
-				netif_carrier_on(db->dev);
+		if (! (db->media_mode & DMFE_AUTO) || !dmfe_sense_speed(db)) {
+			netif_carrier_on(dev);
+			SHOW_MEDIA_TYPE(db->op_mode);
+		}
 			dmfe_process_mode(db);
-			/* SHOW_MEDIA_TYPE(db->op_mode); */
 		}
 
 	/* HPNA remote command check */
@@ -1243,7 +1264,7 @@ static void dmfe_dynamic_reset(struct DE
 	db->tx_packet_cnt = 0;
 	db->tx_queue_cnt = 0;
 	db->rx_avail_cnt = 0;
-	db->link_failed = 1;
+	netif_carrier_off(dev);
 	db->wait_reset = 0;
 
 	/* Re-initilize DM910X board */



 
____________________________________________________________________________________
Any questions? Get answers on any topic at www.Answers.yahoo.com.  Try it now.
