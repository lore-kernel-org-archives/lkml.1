Return-Path: <linux-kernel-owner+w=401wt.eu-S933841AbXLNR4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbXLNR4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXLNR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:56:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:31769 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbXLNRz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:55:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="439125647"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] dmaengine: Simple DMA memcpy test client
Date: Fri, 14 Dec 2007 09:45:26 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03A18493@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071214033221.GA23365@lixom.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] dmaengine: Simple DMA memcpy test client
Thread-Index: Acg+AS5VyR+vvQbtQfiVvqheQiAsGAAdtMMA
References: <1195832076-13022-1-git-send-email-hskinnemoen@atmel.com> <20071214033221.GA23365@lixom.net>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Olof Johansson" <olof@lixom.net>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>, "Sam Ravnborg" <sam@ravnborg.org>
X-OriginalArrivalTime: 14 Dec 2007 17:45:27.0535 (UTC) FILETIME=[1CCEF7F0:01C83E79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Olof Johansson [mailto:olof@lixom.net] 
>Sent: Thursday, December 13, 2007 7:32 PM
>To: Haavard Skinnemoen
>Cc: Nelson, Shannon; Williams, Dan J; 
>linux-kernel@vger.kernel.org; Sam Ravnborg
>Subject: Re: [PATCH v2] dmaengine: Simple DMA memcpy test client
>
>On Fri, Nov 23, 2007 at 04:34:36PM +0100, Haavard Skinnemoen wrote:
>> This client tests DMA memcpy using various lengths and 
>various offsets
>> into the source and destination buffers. It will initialize both
>> buffers with a know pattern and verify that the DMA engine copies the
>> requested region and nothing more.
>> 
>> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
>
>Hi,
>
>First of all: Thanks for sharing this, it's quite useful! I've been
>playing around with this a bit today, and I've been seeing some odd
>behaviour.
>
>It seems that once a channel is allocated to dmatest, it will never be
>freed, i.e. the drivers device_free_chan_resources will never be called
>on it. Looking at the dma stack, I'm not sure just where it's expected
>to happen. Once the channel is allocated, the dma_chan_get/put 
>calls all
>just modify the per-cpu variables, and nothing will ever boil down to a
>call to kref_put() of the refcount until the _driver_ is deregistered.
>Not even deregistering the client seems to do it.
>
>Or am I missing something here? Shannon? Dan?
>
>I happened to catch it due to a BUG_ON() in my 
>device_alloc_chan_resources
>that checked to make sure it wasn't allocated twice without a free
>inbetween. It hit on the second load of the dmatest module, since they
>were never freed on unload.
>
>
>-Olof
>

No, you're not missing anything, you've read it right.  Notice at the
top of the ioatdma's ioat_dma_alloc_chan_resources() we check to see if
we've already been here.

I suspect this is a hangover from the earlier dmaengine design where TCP
was the only client and it never released things, so the only time we
needed to free the resources was when ioatdma was unloaded.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.

