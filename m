Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYDGFOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYDGFOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYDGFNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:13:50 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:45900 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751129AbYDGFNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:13:49 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: rusty@rustcorp.com.au (Rusty Russell)
Subject: Re: [PATCH RFC 4/5] tun: vringfd xmit support.
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, maxk@qualcomm.com
Organization: Core
In-Reply-To: <200804052206.33922.rusty@rustcorp.com.au>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev,apana.lists.os.linux.virtualization
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Jijfs-0004Lo-00@gondolin.me.apana.org.au>
Date: Mon, 07 Apr 2008 13:13:44 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> +/* We are done with this skb: put it in the used pile. */
> +static void skb_finished(struct skb_shared_info *sinfo)
> +{
> +       struct skb_shinfo_tun *sht = (void *)(sinfo + 1);
> +
> +       /* FIXME: Race prevention */
> +       vring_used_buffer_atomic(sht->tun->outring, sht->id, sht->len);
> +       vring_wake(sht->tun->outring);
> +
> +       /* Release device. */
> +       dev_put(sht->tun->dev);
> +}

On second thought, this is not going to work.  The network stack
can clone individual pages out of this skb and put it into a new
skb.  Therefore whatever scheme we come up with will either need
to be page-based, or add a flag to tell the network stack that it
can't clone those pages.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
