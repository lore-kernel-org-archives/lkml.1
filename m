Return-Path: <linux-kernel-owner+w=401wt.eu-S1760458AbZE2NnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbZE2NnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760138AbZE2Nms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:42:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:38722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760275AbZE2Nmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="416798665"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:41:46 +0100
Subject: RE: [PATCH v2 03/11] async_tx: structify submission arguments, add
 scribble
Thread-Topic: [PATCH v2 03/11] async_tx: structify submission arguments, add
 scribble
Thread-Index: AcndIqSEXuAIYT+3SlS2Ow0HS0GuIQDNnmog
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C6D@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005941.4104.24363.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250321v774c4e8dscd7a466cd2e61168@mail.gmail.com>
In-Reply-To: <f12847240905250321v774c4e8dscd7a466cd2e61168@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> Prepare the api for the arrival of a new parameter, 'scribble'.  This
> will allow callers to identify scratchpad memory for dma address or page
> address conversions.  As this adds yet another parameter, take this
> opportunity to convert the common submission parameters (flags,
> dependency, callback, and callback argument) into an object that is
> passed by reference.
> 
> [ Impact: moves api pass-by-value parameters to a pass-by-reference struct ]
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/async_memcpy.c |   21 ++++-----
>  crypto/async_tx/async_memset.c |   23 ++++------
>  crypto/async_tx/async_tx.c     |   34 +++++++--------
>  crypto/async_tx/async_xor.c    |   93 +++++++++++++++++-----------------------
>  drivers/md/raid5.c             |   59 +++++++++++++++----------
>  include/linux/async_tx.h       |   84 +++++++++++++++++++++++-------------
>  6 files changed, 161 insertions(+), 153 deletions(-)

(...)

> @@ -811,13 +818,11 @@ ops_run_postxor(struct stripe_head *sh, struct
> dma_async_tx_descriptor *tx)
> 
>        atomic_inc(&sh->count);
> 
> -       if (unlikely(count == 1)) {
> -               flags &= ~(ASYNC_TX_XOR_DROP_DST | ASYNC_TX_XOR_ZERO_DST);
> -               tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
> -                       flags, tx, ops_complete_postxor, sh);
> -       } else
> -               tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
> -                       flags, tx, ops_complete_postxor, sh);
> +       init_async_submit(&submit, flags, tx, ops_complete_postxor, sh, NULL);
> +       if (unlikely(count == 1))
> +               tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
> +       else
> +               tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
>  }

What about ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST flags clearing before async_memcpy?

Maciej