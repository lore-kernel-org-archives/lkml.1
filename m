Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXJXW16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXJXW16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXJXW1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:27:50 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:20586 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753953AbXJXW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:27:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GSPD1G3C1AHm6/0seTUG3TD/iuExHPUoi8NBGoGgLdOMxH1Dxn5L8bTaGne9CkwZOAFrky2b9+w2GgYHQYtEHHucrpbIpnx5nAtTcipJ9lngJdbSArc3Dwq5j0GhjzFGUIJ6gSkPTriHRjYk0yA5J597PpF2vRcYyusA3bP2V8g=  ;
X-YMail-OSG: 1MHLY00VM1nHhmZq8SJmphxVLFswqopmx_9yyhEMSzXrPBR1eLZQEYae1u2m0.VsjhhLT0SNUA--
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: mmc_spi stopped working
Date: Wed, 24 Oct 2007 15:27:46 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tonyj@suse.de,
       spi-devel-general@lists.sourceforge.net
References: <20071017211923.31fde15e@poseidon.drzeus.cx> <20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071017215217.177cdb14@poseidon.drzeus.cx>
In-Reply-To: <20071017215217.177cdb14@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710241527.46458.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2007, Pierre Ossman wrote:
> 
> On Wed, 17 Oct 2007 12:37:13 -0700
> David Brownell <david-b@pacbell.net> wrote:
> > That issue is 49dce689ad4ef0fd1f970ef762168e4bd46f69a3, the
> > classdev-elimination patch from Tony Jones.  It broke the
> > "does this bus have more than one device" test by relocating
> > the relevant sysfs nodes.
> > 
> > Quick workaround for that one is to disable the fault return
> > after that test.
> > 
> 
> Annoying. Feel free to ping me when you've pushed fixes to Linus.

This is another case where whacking around in sysfs seems
unavoidable, even when it breaks things.  The patch below
works around that that change.  It seems like something that
should go through you, not directly through Linus...

- Dave

================	CUT HERE
Fix mmc-over-spi regression

Patch 49dce689ad4ef0fd1f970ef762168e4bd46f69a3 changed the sysfs data
structures for SPI in a way which broke the MMC-over-SPI host driver.

This patch fixes that regression by changing the scheme used to keep
from knowingly trying to use a shared bus segment, and updates the
adjacent comments slightly to better explain the issue.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/drivers/mmc/host/mmc_spi.c	2007-10-23 21:24:41.000000000 -0700
+++ b/drivers/mmc/host/mmc_spi.c	2007-10-24 14:46:59.000000000 -0700
@@ -1165,6 +1165,23 @@ mmc_spi_detect_irq(int irq, void *mmc)
 	return IRQ_HANDLED;
 }
 
+struct count_children {
+	unsigned	n;
+	struct bus_type	*bus;
+};
+
+static int maybe_count_child(struct device *dev, void *c)
+{
+	struct count_children *ccp = c;
+
+	if (dev->bus == ccp->bus) {
+		if (ccp->n)
+			return -EBUSY;
+		ccp->n++;
+	}
+	return 0;
+}
+
 static int mmc_spi_probe(struct spi_device *spi)
 {
 	void			*ones;
@@ -1188,33 +1205,30 @@ static int mmc_spi_probe(struct spi_devi
 		return status;
 	}
 
-	/* We can use the bus safely iff nobody else will interfere with
-	 * us.  That is, either we have the experimental exclusive access
-	 * primitives ... or else there's nobody to share it with.
+	/* We can use the bus safely iff nobody else will interfere with us.
+	 * Most commands consist of one SPI message to issue a command, then
+	 * several more to collect its response, then possibly more for data
+	 * transfer.  Clocking access to other devices during that period will
+	 * corrupt the command execution.
+	 *
+	 * Until we have software primitives which guarantee non-interference,
+	 * we'll aim for a hardware-level guarantee.
+	 *
+	 * REVISIT we can't guarantee another device won't be added later...
 	 */
 	if (spi->master->num_chipselect > 1) {
-		struct device	*parent = spi->dev.parent;
+		struct count_children cc;
 
-		/* If there are multiple devices on this bus, we
-		 * can't proceed.
-		 */
-		spin_lock(&parent->klist_children.k_lock);
-		if (parent->klist_children.k_list.next
-				!= parent->klist_children.k_list.prev)
-			status = -EMLINK;
-		else
-			status = 0;
-		spin_unlock(&parent->klist_children.k_lock);
+		cc.n = 0;
+		cc.bus = spi->dev.bus;
+		status = device_for_each_child(spi->dev.parent, &cc,
+				maybe_count_child);
 		if (status < 0) {
 			dev_err(&spi->dev, "can't share SPI bus\n");
 			return status;
 		}
 
-		/* REVISIT we can't guarantee another device won't
-		 * be added later.  It's uncommon though ... for now,
-		 * work as if this is safe.
-		 */
-		dev_warn(&spi->dev, "ASSUMING unshared SPI bus!\n");
+		dev_warn(&spi->dev, "ASSUMING SPI bus stays unshared!\n");
 	}
 
 	/* We need a supply of ones to transmit.  This is the only time
