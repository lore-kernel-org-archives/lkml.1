Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbXJEVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbXJEVBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761944AbXJEVBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:01:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761630AbXJEVBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:01:08 -0400
Date: Fri, 5 Oct 2007 14:00:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: bbpetkov@yahoo.de, linux-kernel@vger.kernel.org, muli@il.ibm.com,
       satyam@infradead.org, amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
Message-Id: <20071005140050.655b7727.akpm@linux-foundation.org>
In-Reply-To: <4706A20A.5060603@goop.org>
References: <20070918194647.GA23800@gollum.tnic>
	<20071005124705.6584e2f9.akpm@linux-foundation.org>
	<4706A20A.5060603@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 13:43:54 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> > Now that we have DMA_BIT_MASK(), these macros are pointless.
> >   
> 
> Except, unfortunately, DMA_64BIT_MASK.  I guess we could special case
> it, assuming this works in all the contexts the macro is used in (ie,
> compile-time constant?):
> 
> #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
> 

doh.  Thanks.

--- a/include/linux/dma-mapping.h~stop-using-dma_xxbit_mask-fix
+++ a/include/linux/dma-mapping.h
@@ -13,7 +13,7 @@ enum dma_data_direction {
 	DMA_NONE = 3,
 };
 
-#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
+#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
 /*
  * NOTE: do not use the below macros in new code and do not add new definitions
@@ -21,7 +21,7 @@ enum dma_data_direction {
  *
  * Instead, just open-code DMA_BIT_MASK(n) within your driver
  */
-#define DMA_64BIT_MASK	(~0ULL)
+#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
 #define DMA_48BIT_MASK	DMA_BIT_MASK(48)
 #define DMA_47BIT_MASK	DMA_BIT_MASK(47)
 #define DMA_40BIT_MASK	DMA_BIT_MASK(40)
_


it's irksome that there doesn't seem to be a neater way of doing
this, until they give us unsigned long long longs.
