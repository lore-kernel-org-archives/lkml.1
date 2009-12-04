Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZLDEO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZLDEO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 23:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZLDEO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 23:14:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755454AbZLDEO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 23:14:56 -0500
Date: Thu, 3 Dec 2009 20:14:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: [PATCH] ip2: Remove #ifdef MODULE from ip2main.c
Message-Id: <20091203201433.bea0f893.akpm@linux-foundation.org>
In-Reply-To: <b9df5fa10912010102p405b429dg102843fe88932b9d@mail.gmail.com>
References: <b9df5fa10912010102p405b429dg102843fe88932b9d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 15:02:56 +0600 Rakib Mullick <rakib.mullick@gmail.com> wrote:

> >From kernel command line we can pass "module parameters".
> So #ifdef MODULE is obsolute now. Remove it completely.
> When CONFIG_PCI=n and building ip2main.c then we are hit
> by the following warning. So move *pdev into #ifdef CONFIG_PCI.
> 
> drivers/char/ip2/ip2main.c: In function `ip2_loadmain':
> drivers/char/ip2/ip2main.c:542: warning: unused variable `pdev'

x86_64 allmodconfig:

drivers/char/ip2/ip2main.c: In function 'ip2_loadmain':
drivers/char/ip2/ip2main.c:657: error: 'pdev' undeclared (first use in this function)
drivers/char/ip2/ip2main.c:657: error: (Each undeclared identifier is reported only once
drivers/char/ip2/ip2main.c:657: error: for each function it appears in.)


I suppose this:

--- a/drivers/char/ip2/ip2main.c~ip2-remove-ifdef-module-from-ip2mainc-fix
+++ a/drivers/char/ip2/ip2main.c
@@ -636,6 +636,7 @@ static int __init ip2_loadmain(void)
 				dev_err(&pdev->dev, "I/O address error\n");
 
 			ip2config.irq[i] = pdev->irq;
+			pci_dev_put(pdev);
 		}
 #else
 			printk(KERN_ERR "IP2: PCI card specified but PCI "
@@ -654,7 +655,6 @@ static int __init ip2_loadmain(void)
 			break;
 		}	/* switch */
 	}	/* for */
-	pci_dev_put(pdev);
 
 	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		if (ip2config.addr[i]) {
_

but it needs checking - does pci_get_device() need a balancing pci_dev_put()?
