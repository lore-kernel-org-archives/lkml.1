Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZBSW6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZBSW6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBSW6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:58:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZBSW6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:58:43 -0500
Date: Thu, 19 Feb 2009 14:58:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org, maen@marvell.com
Subject: Re: [PATCH v2] SDIO driver for Marvell SoCs
Message-Id: <20090219145808.796135e4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0902191708330.5511@xanadu.home>
References: <alpine.LFD.2.00.0902172338110.32550@xanadu.home>
	<20090219124418.dfc4dc9a.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0902191708330.5511@xanadu.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 17:14:11 -0500 (EST)
Nicolas Pitre <nico@cam.org> wrote:

> This supports MMC/SD/SDIO currently found on the Kirkwood 88F6281 and
> 88F6192 SoC controllers.

--- a/drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update
+++ a/drivers/mmc/host/mvsdio.c
@@ -783,9 +783,9 @@ out:
 			gpio_free(host->gpio_write_protect);
 		if (host->base)
 			iounmap(host->base);
-		if (host->res)
-			release_resource(host->res);
 	}
+	if (r)
+		release_resource(host->res);
 	if (mmc)
 		mmc_free_host(mmc);
 
_

Nope, this will deref a null pointer on that error path and wouldn't
release the right thing anyway.

Something like this...

--- a/drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update
+++ a/drivers/mmc/host/mvsdio.c
@@ -688,6 +688,7 @@ static int __init mvsd_probe(struct plat
 
 	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
 	if (!mmc) {
+		release_resource(r);
 		ret = -ENOMEM;
 		goto out;
 	}

