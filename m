Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbXAVUsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbXAVUsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbXAVUsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:48:11 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:29778 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932603AbXAVUsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:48:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LX/fvNfcgo3APgikcMbrP2XHhYbAK7ShGco/LT/l7vHYbX6i8MKpmkUJEKXcVARmnvaFnoPeEacnvxqtgox0PJlxXB9LMoNoqhPSGKRCvshoGjcLCiXlT+izlLYrncDEUmupaUdMcyL23oFhERkN3zpKkWz+HeeiHATWrc4UdvM=  ;
X-YMail-OSG: Q0NrfpMVM1m20U8lwuLUUw8fpNHE__naNqUKAIB2BXlgvaNkANQe5YbtC4gRv7_fI0hJEyNsorEQ1fYbzqjVKtanHmFYHa1dkm70cESBJcnp7cCKZ8g-
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.20-rc5] rm pointless dmaengine exports
Date: Mon, 22 Jan 2007 09:57:36 -0800
User-Agent: KMail/1.7.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701220957.36554.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This removes several pointless exports from drivers/dma/dmaengine.c;
the dma_async_memcpy_*() functions are inlined by <linux/dmaengine.h>
so those exports are inappropriate.

It also moves the existing EXPORT_SYMBOL declarations next to their
functions, so it's now trivial to confirm one-to-one correspondence
between exports and nonstatic symbols.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

---
By the way ... I'm sure that I'm not the only one to observe how odd it
is that a "DMA Engine" framework is purely a memcpy() offload engine.

It overlooks the primary use of DMA in Linux:  peripheral I/O, which
may well involve the same kind of dual-access engines this framework
assumes.  DMA controllers on embedded Linuxes commonly support a few
dozen logical DMA channels supporting hardware-synchronized transfers
to/from most peripheral devices.  Memory-to-memory DMA would often
also work ... but wouldn't address IRQ rate issues of PIO drivers.

 drivers/dma/dmaengine.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

Index: g26/drivers/dma/dmaengine.c
===================================================================
--- g26.orig/drivers/dma/dmaengine.c	2007-01-22 09:19:27.000000000 -0800
+++ g26/drivers/dma/dmaengine.c	2007-01-22 09:19:29.000000000 -0800
@@ -176,6 +176,7 @@ void dma_chan_cleanup(struct kref *kref)
 	chan->client = NULL;
 	kref_put(&chan->device->refcount, dma_async_device_cleanup);
 }
+EXPORT_SYMBOL(dma_chan_cleanup);
 
 static void dma_chan_free_rcu(struct rcu_head *rcu)
 {
@@ -261,6 +262,7 @@ struct dma_client *dma_async_client_regi
 
 	return client;
 }
+EXPORT_SYMBOL(dma_async_client_register);
 
 /**
  * dma_async_client_unregister - unregister a client and free the &dma_client
@@ -287,6 +289,7 @@ void dma_async_client_unregister(struct 
 	kfree(client);
 	dma_chans_rebalance();
 }
+EXPORT_SYMBOL(dma_async_client_unregister);
 
 /**
  * dma_async_client_chan_request - request DMA channels
@@ -304,6 +307,7 @@ void dma_async_client_chan_request(struc
 	client->chans_desired = number;
 	dma_chans_rebalance();
 }
+EXPORT_SYMBOL(dma_async_client_chan_request);
 
 /**
  * dma_async_device_register - registers DMA devices found
@@ -346,6 +350,7 @@ int dma_async_device_register(struct dma
 
 	return 0;
 }
+EXPORT_SYMBOL(dma_async_device_register);
 
 /**
  * dma_async_device_cleanup - function called when all references are released
@@ -390,23 +395,12 @@ void dma_async_device_unregister(struct 
 	kref_put(&device->refcount, dma_async_device_cleanup);
 	wait_for_completion(&device->done);
 }
+EXPORT_SYMBOL(dma_async_device_unregister);
 
 static int __init dma_bus_init(void)
 {
 	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
-
 subsys_initcall(dma_bus_init);
 
-EXPORT_SYMBOL(dma_async_client_register);
-EXPORT_SYMBOL(dma_async_client_unregister);
-EXPORT_SYMBOL(dma_async_client_chan_request);
-EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
-EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
-EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
-EXPORT_SYMBOL(dma_async_memcpy_complete);
-EXPORT_SYMBOL(dma_async_memcpy_issue_pending);
-EXPORT_SYMBOL(dma_async_device_register);
-EXPORT_SYMBOL(dma_async_device_unregister);
-EXPORT_SYMBOL(dma_chan_cleanup);
