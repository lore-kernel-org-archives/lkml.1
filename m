Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYHDOtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYHDOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYHDOtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:49:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYHDOtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:49:07 -0400
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Austin Zhang <austin_zhang@linux.intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20080804072015.0fcd23e7@infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
	 <1217846726.3454.589.camel@pmac.infradead.org>
	 <20080804140435.GA11227@gondor.apana.org.au>
	 <20080804072015.0fcd23e7@infradead.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 15:49:01 +0100
Message-Id: <1217861341.3454.641.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 07:20 -0700, Arjan van de Ven wrote:
> On Mon, 4 Aug 2008 22:04:35 +0800
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > There only three crc32c users in the kernel tree and the crypto
> > interface will serve the perfectly.
> 
> isn't it a bit heavy for something as simple as a crc?
> (which after all is one instruction now ;0)

It does seem that way. For users who care about 'bloat' and are _only_
interested in crc32, it's yet another chunk of extra infrastructure
which offers no benefit to them.

And even for people who don't care about that, it doesn't look
particularly good. It looks like btrfs would need either to keep setting
up a crypto context and then tearing it down, or have a pool of
long-standing contexts and do some kind of locking on them -- neither of
which seem particularly optimal compared with just calling into
libcrc32c.

We can't even set up one context per cpu and disable preempt while we
use it, can we? The routines are allowed to sleep?

(Although I have to admit I do like the fact that it'd only be available
through EXPORT_SYMBOL_GPL if we do force people to use the crypto
API...)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



