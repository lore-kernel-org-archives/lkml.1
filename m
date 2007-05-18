Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXERQaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXERQaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbXERQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:30:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:25039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXERQaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,553,1170662400"; 
   d="scan'208";a="229552057"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22-rc1-mm1 - s390 vs. md
Date: Fri, 18 May 2007 09:30:09 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201DEA930@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070518073946.716132f4@gondolin.boeblingen.de.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22-rc1-mm1 - s390 vs. md
Thread-Index: AceZDvTiHuZ9aL/ZSR28JB76mq0OxwAWQT3Q
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "NeilBrown" <neilb@suse.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "linux-s390" <linux-s390@vger.kernel.org>
X-OriginalArrivalTime: 18 May 2007 16:30:03.0803 (UTC) FILETIME=[C9B4BEB0:01C79969]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cornelia Huck [mailto:cornelia.huck@de.ibm.com]
> Finer granularity is certainly better here, but I'm not quite sure if
> this solves our s390 problem (we don't have dma support). All those
> backends should also have a non-dma version...

In fact that is already there.  Here is the form of async_memcpy for
example:
... async_memcpy( ... )
{
	struct dma_chan *chan = async_tx_find_channel(depend_tx,
DMA_MEMCPY);
	struct dma_device *device = chan ? chan->device : NULL;
	int int_en = callback ? 1 : 0;
	struct dma_async_tx_descriptor *tx = device ?
		device->device_prep_dma_memcpy(chan, len,
		int_en) : NULL;

	if (tx) { /* run the memcpy asynchronously */

		...

	} else { /* run the memcpy synchronously */

		...
	}
}

When CONFIG_DMA_ENGINE=n async_tx_find_channel takes the form:
... async_tx_find_channel( ... )
{
	return NULL;
}

So in the S390 case the entire asynchronous path will be compiled away.

--
Dan
