Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZLDJhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZLDJhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZLDJhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:37:50 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:37605 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZLDJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:37:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H/Jo63XgKhJ3JqHFEVjIb7rqTeZTlzuFJSABJW20fibr2OBK4e0t3nidtZPOXudShT
         2EuH7sIVbwxpkv5Sc9xCEQSTBUe4EyGWwsWe4wLRI8C3QARmHAorlptpSilG6kknnEpq
         k3ddixwAfQF3aAJaY5/XgPb/vjFlNn0Noup8Y=
MIME-Version: 1.0
In-Reply-To: <20091203201433.bea0f893.akpm@linux-foundation.org>
References: <b9df5fa10912010102p405b429dg102843fe88932b9d@mail.gmail.com>
	 <20091203201433.bea0f893.akpm@linux-foundation.org>
Date: Fri, 4 Dec 2009 15:37:56 +0600
Message-ID: <b9df5fa10912040137g2353f8f0y1c108dcb5547a3f8@mail.gmail.com>
Subject: Re: [PATCH] ip2: Remove #ifdef MODULE from ip2main.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/09, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 1 Dec 2009 15:02:56 +0600 Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
> x86_64 allmodconfig:
>
>  drivers/char/ip2/ip2main.c: In function 'ip2_loadmain':
>
> drivers/char/ip2/ip2main.c:657: error: 'pdev' undeclared (first use in this function)
>  drivers/char/ip2/ip2main.c:657: error: (Each undeclared identifier is reported only once
>  drivers/char/ip2/ip2main.c:657: error: for each function it appears in.)
>
Yes, I've also notice that pci_dev_put was outside of the #ifdef CONFIG_PCI
 context.  I was about to make patch for this.
>
>  I suppose this:
>
>  but it needs checking - does pci_get_device() need a balancing pci_dev_put()?

I thinks - yes. Otherwise we've to face ref counting problem.
And when pci_enable_device fails we need to make sure that we're
calling pci_dev_put.

So.. please checkout the following patch. Following patch has
been made without applying 'ip2-remove-ifdef-module-from-ip2mainc-fix' patch.
Please just check is it okay or not.

---
--- linus/drivers/char/ip2/ip2main.c	2009-12-01 12:41:53.000000000 +0600
+++ rakib/drivers/char/ip2/ip2main.c	2009-12-04 16:32:22.000000000 +0600
@@ -626,7 +626,7 @@ static int __init ip2_loadmain(void)

 			if (pci_enable_device(pdev)) {
 				dev_err(&pdev->dev, "can't enable device\n");
-				break;
+				goto out;
 			}
 			ip2config.type[i] = PCI;
 			ip2config.pci_dev[i] = pci_dev_get(pdev);
@@ -638,6 +638,8 @@ static int __init ip2_loadmain(void)
 				dev_err(&pdev->dev, "I/O address error\n");

 			ip2config.irq[i] = pdev->irq;
+out:
+			pci_dev_put(pdev);
 		}
 #else
 			printk(KERN_ERR "IP2: PCI card specified but PCI "
@@ -656,7 +658,6 @@ static int __init ip2_loadmain(void)
 			break;
 		}	/* switch */
 	}	/* for */
-	pci_dev_put(pdev);

 	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		if (ip2config.addr[i]) {
