Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXDDOil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXDDOil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXDDOil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:38:41 -0400
Received: from smtp008.mail.ukl.yahoo.com ([217.12.11.62]:26115 "HELO
	smtp008.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753897AbXDDOil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:38:41 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 10:38:40 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Subject:From:To:Content-Type:Date:Message-Id:Mime-Version:X-Mailer;
  b=5+wJEIji3y0a5EjCuVBAwuQSSTVFWud+igCVKtiBQQgPkdtcFaPaA8/W+lX1huh/9WU6si3Xh19/EtQkvalWxukIlHTPga+VM3nJvDl8bFhZLEUj6dS12HV7Z3JLBu2ioQsLs24jQw6Lp9/wGbiHsSdrKNKGx5LupHoxeUpaNYk=  ;
X-YMail-OSG: e5DBuhMVM1k4Nh_BF0o4V8BatEm_SvQYBuQ9s1AkbyC8kNAgbR8.mnvoio8L.OkGyDVMC6KXn6ZmqFoOzrjfAAh2T8KT8Cq0E76UQqns8UoPDSlsgoojm60qLUk-
Subject: [PATCH] b2c2-flexcop-pci spinlock lock problem fix
From: Borgi2008 <borgi2008@yahoo.de>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-Eq0aTYfqXu/warEiZmJr"
Date: Wed, 04 Apr 2007 16:31:58 +0200
Message-Id: <1175697118.6861.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Eq0aTYfqXu/warEiZmJr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

i've created a small patch for the current kernel version which fixes a
bug in the DVB driver for b2c2-flexcop based pci devices. During
initialization of the pci device spin_lock_irq is called before
spin_lock_init. I've also created a bugreport in bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=8301 . It would be nice if
someone could check this patch and perhaps apply it.

Hendrik Borghorst

borgi2008@yahoo.de




--=-Eq0aTYfqXu/warEiZmJr
Content-Disposition: attachment; filename=flexcop-lockdep.patch
Content-Type: application/mbox; name=flexcop-lockdep.patch
Content-Transfer-Encoding: 7bit

>From Hendrik Borghorst (hendrik@borghorst.org)

--- linux-2.6.20/drivers/media/dvb/b2c2/flexcop-pci.c.org	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/drivers/media/dvb/b2c2/flexcop-pci.c	2007-04-04 14:33:31.000000000 +0200
@@ -127,10 +127,11 @@
 {
 	struct flexcop_pci *fc_pci = dev_id;
 	struct flexcop_device *fc = fc_pci->fc_dev;
+	unsigned long flags;
 	flexcop_ibi_value v;
 	irqreturn_t ret = IRQ_HANDLED;
 
-	spin_lock_irq(&fc_pci->irq_lock);
+	spin_lock_irqsave(&fc_pci->irq_lock,flags);
 
 	v = fc->read_ibi_reg(fc,irq_20c);
 
@@ -194,7 +195,7 @@
 		ret = IRQ_NONE;
 	}
 
-	spin_unlock_irq(&fc_pci->irq_lock);
+	spin_unlock_irqrestore(&fc_pci->irq_lock,flags);
 
 	return ret;
 }
@@ -293,12 +294,12 @@
 	}
 
 	pci_set_drvdata(fc_pci->pdev, fc_pci);
-
+	spin_lock_init(&fc_pci->irq_lock);
 	if ((ret = request_irq(fc_pci->pdev->irq, flexcop_pci_isr,
 					IRQF_SHARED, DRIVER_NAME, fc_pci)) != 0)
 		goto err_pci_iounmap;
 
-	spin_lock_init(&fc_pci->irq_lock);
+
 
 	fc_pci->init_state |= FC_PCI_INIT;
 	return ret;

--=-Eq0aTYfqXu/warEiZmJr--

