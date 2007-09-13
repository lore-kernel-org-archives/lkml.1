Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbXIMJEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbXIMJEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbXIMJEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:04:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504AbXIMJED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:04:03 -0400
Date: Thu, 13 Sep 2007 02:03:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Micah Gruber <micah.gruber@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [CORRECTION][PATCH] Fix a potential NULL pointer dereference in
 uli526x_interrupt() in drivers/net/tulip/uli526x.c
Message-Id: <20070913020346.979647c1.akpm@linux-foundation.org>
In-Reply-To: <46DD13CE.6010905@gmail.com>
References: <46DD13CE.6010905@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Sep 2007 16:14:06 +0800 Micah Gruber <micah.gruber@gmail.com> wrote:

> This patch fixes a potential null dereference bug where we dereference dev before a null check. This patch simply moves the dereferencing after the null check.
> 
> Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> ---
> 
> --- a/drivers/net/tulip/uli526x.c
> +++ b/drivers/net/tulip/uli526x.c
> @@ -663,7 +663,7 @@
>  {
>  	struct net_device *dev = dev_id;
>  	struct uli526x_board_info *db = netdev_priv(dev);
> -	unsigned long ioaddr = dev->base_addr;
> +	unsigned long ioaddr;
>  	unsigned long flags;
>  
>  	if (!dev) {
> @@ -671,6 +671,8 @@
>  		return IRQ_NONE;
>  	}
>  
> +	ioaddr = dev->base_addr;
> +
>  	spin_lock_irqsave(&db->lock, flags);
>  	outl(0, ioaddr + DCR7);
> 

I suspect the fix we want is:


--- a/drivers/net/tulip/uli526x.c~fix-a-potential-null-pointer-dereference-in-uli526x_interrupt
+++ a/drivers/net/tulip/uli526x.c
@@ -666,11 +666,6 @@ static irqreturn_t uli526x_interrupt(int
 	unsigned long ioaddr = dev->base_addr;
 	unsigned long flags;
 
-	if (!dev) {
-		ULI526X_DBUG(1, "uli526x_interrupt() without DEVICE arg", 0);
-		return IRQ_NONE;
-	}
-
 	spin_lock_irqsave(&db->lock, flags);
 	outl(0, ioaddr + DCR7);
 
_

