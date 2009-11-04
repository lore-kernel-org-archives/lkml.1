Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZKDCXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZKDCXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZKDCXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:23:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:15416 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbZKDCXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:23:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,677,1249282800"; 
   d="scan'208";a="464122815"
Subject: Re: [BUGFIX for .32] crypto, gcm, fix another complete call in
 complete fuction
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20091103155339.GC9186@gondor.apana.org.au>
References: <1257216017.30470.1183.camel@yhuang-dev.sh.intel.com>
	 <20091103155339.GC9186@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 10:23:43 +0800
Message-Id: <1257301423.22519.172.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 23:53 +0800, Herbert Xu wrote: 
> On Tue, Nov 03, 2009 at 10:40:17AM +0800, Huang Ying wrote:
> > The flow of the complete function (xxx_done) in gcm.c is as follow:
> > 
> > void complete(struct crypto_async_request *areq, int err)
> > {
> > 	if (!err) {
> > 		err = async_next_step();
> > 		if (err == -EINPROGRESS || err == -EBUSY)
> > 			return;
> > 	}
> > 
> > 	complete_for_next_step(areq, err);
> > }
> > 
> > But *areq may be destroyed in async_next_step(), this makes
> > complete_for_next_step() can not work properly. To fix this, one of
> > following methods is used for each complete function.
> 
> So why is async_next_step destroying areq? Can you give me a
> concrete example?

I have seen one example, in gcm_encrypt_done, which is called when
encryption phase finished in asynchronous mode. The areq passed in may
be in the context of pctx->u.abreq (due to cryptd etc). Then hash phase
begin, and ghash is called, which operates on pctx->u.ahreq (share same
memory of pctx->u.abreq) and its context. Now, *areq may be destroyed.

To avoid similar issue in the future, I add protective processing in
every xxx_done function. Let complete_for_next_step() uses areq setup
for async_next_step().

Best Regards,
Huang Ying

