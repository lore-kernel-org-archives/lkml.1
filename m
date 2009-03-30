Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZC3Obb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZC3Obb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZC3Oan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:30:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:4576 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZC3Oak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:30:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,446,1233561600"; 
   d="scan'208";a="677155897"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>, Ilya Yanok <yanok@emcraft.com>,
       Yuri Tikhonov <yur@emcraft.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Mar 2009 15:30:22 +0100
Subject: RE: [PATCH 07/13] async_tx: add support for asynchronous RAID6
 recovery	operations
Thread-Topic: [PATCH 07/13] async_tx: add support for asynchronous RAID6
 recovery	operations
Thread-Index: Acmn/qqxnXRndn6nQs+MPLqovt90lQJM1MGA
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8BF24@irsmsx504.ger.corp.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
 <20090318192052.20375.68157.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090318192052.20375.68157.stgit@dwillia2-linux.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Williams, Dan J wrote:
> +ddr_sync:
> +	{
> +		void **sptrs = (void **)lptrs;
> +		/*
> +		 * Failed to compute asynchronously, do it in
> +		 * synchronous manner
> +		 */
> +
> +		/* wait for any prerequisite operations */
> +		async_tx_quiesce(&depend_tx);
> +		if (flags & ASYNC_TX_DEP_ACK)
> +			async_tx_ack(depend_tx);
> +
> +		i = disks;
> +		while (i--)
> +			sptrs[i] = page_address(ptrs[i]);
> +		raid6_2data_recov(disks, bytes, faila, failb, sptrs);
> +
> +		async_tx_sync_epilog(cb, cb_param);
> +	}
(...)
> +dpr_sync:
> +	{
> +		void **sptrs = (void **) lptrs;
> +		/*
> +		 * Failed to compute asynchronously, do it in
> +		 * synchronous manner
> +		 */
> +
> +		/* wait for any prerequisite operations */
> +		async_tx_quiesce(&depend_tx);
> +		if (flags & ASYNC_TX_DEP_ACK)
> +			async_tx_ack(depend_tx);
> +
> +		i = disks;
> +		while (i--)
> +			sptrs[i] = page_address(ptrs[i]);
> +		raid6_datap_recov(disks, bytes, faila, (void *)sptrs);
> +
> +		async_tx_sync_epilog(cb, cb_param);
> +	}

These synchronous sections in async_r6_dd_recov() and async_r6_dp_recov()
look almost the same. What about placing the code in a common function?

Regards,
Maciej