Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXH3Ula@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXH3Ula (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbXH3UlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:41:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:48257 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXH3UlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VCizB7ULTghBm4ZpCrmGI90AeB7mDeoefABHXMdQprrVrylqA54umjqsyME7dNZAMI5WY50C7qJDkferC46a8JkHImoN6CN5jtYZNxk8PBanRHcpgfSKCIKmNnacXIB4iP+w8lDYAT+GA+aPsCo92frj3DLv4XckWCVy1eC+pEU=
Message-ID: <e9c3a7c20708301341r197fb401j17c07c733609c61a@mail.gmail.com>
Date: Thu, 30 Aug 2007 13:41:18 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Re: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
       "Nelson, Shannon" <shannon.nelson@intel.com>
In-Reply-To: <c70ff3ad0708301143w55bf296p37b0991d7f099fd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com>
	 <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com>
	 <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
	 <0C7297FA1D2D244A9C7F6959C0BF1E52025B10E4@azsmsx413.amr.corp.intel.com>
	 <c70ff3ad0708301143w55bf296p37b0991d7f099fd6@mail.gmail.com>
X-Google-Sender-Auth: 412674f0d12e8bff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, saeed bishara <saeed.bishara@gmail.com> wrote:
> you are right, I've another question regarding the function
> dma_wait_for_async_tx from async_tx.c, here is the body of the code:
>        /* poll through the dependency chain, return when tx is complete */
> 1.        do {
> 2.                 iter = tx;
> 3.                 while (iter->cookie == -EBUSY)
> 4.                         iter = iter->parent;
> 5.
> 6.                 status = dma_sync_wait(iter->chan, iter->cookie);
> 7.         } while (status == DMA_IN_PROGRESS || (iter != tx));
>
> assume that:
> - The interrupt capability is not provided.
> - Request A was sent to chan 0
> - Request B that depends on A is sent to chan 1
> - Request C that depends on B is send to chan 2.
> - Also, assume that when C is handled by async_tx_submit(), B is still
> not queued to the dmaengine (cookie equals to -EBUSY).
>
> In this case, dma_wait_for_async_tx will be called for C, now, it
> looks for me that the do while will loop forever, even when A gets
> completed. this is because the iter will point to B after line 4, thus
> the iter != tx (C) will always become true.
>
You are right.  There are no drivers in the tree that can hit this,
but it needs to be fixed up.

I'll submit the following change:

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 0350071..bc18cbb 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -80,6 +80,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
        enum dma_status status;
        struct dma_async_tx_descriptor *iter;
+       struct dma_async_tx_descriptor *parent;

        if (!tx)
                return DMA_SUCCESS;
@@ -87,8 +88,15 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
        /* poll through the dependency chain, return when tx is complete */
        do {
                iter = tx;
-               while (iter->cookie == -EBUSY)
-                       iter = iter->parent;
+
+               /* find the root of the unsubmitted dependency chain */
+               while (iter->cookie == -EBUSY) {
+                       parent = iter->parent;
+                       if (parent && parent->cookie == -EBUSY)
+                               iter = iter->parent;
+                       else
+                               break;
+               }

> saeed

Regards,
Dan
