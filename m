Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbXBWXRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbXBWXRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933262AbXBWXRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:17:48 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50485 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933276AbXBWXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:44 -0500
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@osdl.org>, Stephen Hemminger <shemminger@osdl.org>,
       mlindner@syskonnect.de, rroesler@syskonnect.de,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH] sk98lin: handle pci_enable_device() return value in skge_resume()
References: <Pine.LNX.4.64.0610130002320.29022@twin.jikos.cz>
	<20061012152512.66f147b8@freekitty>
	<Pine.LNX.4.64.0610130028450.29022@twin.jikos.cz>
	<20061012154714.6924f465@freekitty>
	<Pine.LNX.4.64.0610130052440.29022@twin.jikos.cz>
	<20061012175013.87564a57.akpm@osdl.org>
	<Pine.LNX.4.64.0610130310120.29022@twin.jikos.cz>
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Sat, 24 Feb 2007 02:17:19 +0300
In-Reply-To: <Pine.LNX.4.64.0610130310120.29022@twin.jikos.cz> (Jiri Kosina's message of "Fri, 13 Oct 2006 03:12:55 +0200 (CEST)")
Message-ID: <87hctcv4zk.fsf_-_@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Sat, 24 Feb 2007 02:17:03 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This thread looks dead but issue was't fixed.

Jiri Kosina <jikos@jikos.cz> writes:
>> > -	pci_enable_device(pdev);
>> > +	ret = pci_enable_device(pdev);
>> > +	if (ret) {
>> > +		printk(KERN_ERR "sk98lin: Cannot enable PCI device %s during resume\n", 
>> > +				dev->name);
>> > +		unregister_netdev(dev);
>> This looks rather wrong - skge_exit() will run unregister_netdev() again.
>
> You are of course right (the problem was also spotted by Russell King). 
> This I believe is the correct one for the sk98lin case.
>
> [PATCH] fix sk98lin driver, ignoring return value from pci_enable_device()
>
> add check of return value to _resume() function of sk98lin driver.
>
> Signed-off-by: Jiri Kosina <jikos@jikos.cz>
>
> ---
>
> --- a/drivers/net/sk98lin/skge.c
> +++ b/drivers/net/sk98lin/skge.c
> @@ -5070,7 +5070,12 @@ static int skge_resume(struct pci_dev *p
>  
>  	pci_set_power_state(pdev, PCI_D0);
>  	pci_restore_state(pdev);
> -	pci_enable_device(pdev);
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		printk(KERN_WARNING "sk98lin: unable to enable device %s in resume\n",
> +				dev->name);
> +		goto out_err;
> +	}	
[snip]
> +out_err:
> +	pAC->AllocFlag &= ~SK_ALLOC_IRQ;
> +	dev->irq = 0;
> +	pci_disable_device(pdev);
<<<<< Ok what happend if we jump here right after pci_disable_device() has 
      failed, but pci_disable_device() was called anyway, this is wrong and 
      may be fatal because pdev->enable_cnt may becomes negative.  
> +
> +	return ret;
> +
>  }
>  #else
>  #define skge_suspend NULL
This is reworked Jiri's patch:

[PATCH] sk98lin: handle pci_enable_device() return value in skge_resume()

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/net/sk98lin/skge.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/sk98lin/skge.c b/drivers/net/sk98lin/skge.c
index e94ab25..eea753a 100644
--- a/drivers/net/sk98lin/skge.c
+++ b/drivers/net/sk98lin/skge.c
@@ -5125,7 +5125,12 @@ static int skge_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		printk(KERN_WARNING "sk98lin: unable to enable device %s "
+				"in resume\n", dev->name);
+		goto err_out;
+	}	
 	pci_set_master(pdev);
 	if (pAC->GIni.GIMacsFound == 2)
 		ret = request_irq(dev->irq, SkGeIsr, IRQF_SHARED, "sk98lin", dev);
@@ -5133,10 +5138,8 @@ static int skge_resume(struct pci_dev *pdev)
 		ret = request_irq(dev->irq, SkGeIsrOnePort, IRQF_SHARED, "sk98lin", dev);
 	if (ret) {
 		printk(KERN_WARNING "sk98lin: unable to acquire IRQ %d\n", dev->irq);
-		pAC->AllocFlag &= ~SK_ALLOC_IRQ;
-		dev->irq = 0;
-		pci_disable_device(pdev);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_out_disable_pdev;
 	}
 
 	netif_device_attach(dev);
@@ -5153,6 +5156,13 @@ static int skge_resume(struct pci_dev *pdev)
 	}
 
 	return 0;
+
+err_out_disable_pdev:
+	pci_disable_device(pdev);
+err_out:
+	pAC->AllocFlag &= ~SK_ALLOC_IRQ;
+	dev->irq = 0;
+	return ret;
 }
 #else
 #define skge_suspend NULL
-- 
1.4.4.4



