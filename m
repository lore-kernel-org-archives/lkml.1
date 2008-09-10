Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYIJXwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYIJXwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYIJXvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:51:55 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:44811 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYIJXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:51:54 -0400
Date: Thu, 11 Sep 2008 01:51:44 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage release.
In-Reply-To: <20080909113817.GA14005@2ka.mipt.ru>
Message-ID: <alpine.LNX.2.00.0809110054020.1542@titan.stealer.net>
References: <20080909113817.GA14005@2ka.mipt.ru>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 10 Sep 2008 23:51:53 +0000
	Bayes: 0.4837 Tokens: new, 166; hammy, 3; neutral, 2; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4837]
X-Spam-Signature: d1b19b596644ce8d2577dde1015f8335a65a6d34
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008, Evgeniy Polyakov wrote:

> I am pleased to announce new Distributed Storage (DST) project release.

Hi,

I just had another quick random look over it and found a small memory
leak in an error path, that was already present in your last post, but I
didn't notice. Also there still seem to be some non-critical style
issues, like an explicit continue at then end of a loop, but I didn't
bother to catch them this time.

Sven

> +static void *dst_crypto_thread_init(void *data)
> +{
> +	struct dst_node *n = data;
> +	struct dst_crypto_engine *e;
> +	int err = -ENOMEM;
> +
> +	e = kzalloc(sizeof(struct dst_crypto_engine), GFP_KERNEL);
> +	if (!e)
> +		goto err_out_exit;
> +	e->src = kzalloc(sizeof(struct scatterlist) * 2 * n->max_pages,
> +			GFP_KERNEL);
> +	if (!e->src)
> +		goto err_out_free;
> +
> +	e->dst = e->src + n->max_pages;
> +
> +	err = dst_crypto_engine_init(e, n);
> +	if (err)
> +		goto err_out_free;
> +
> +	return e;
> +
> +err_out_free:
> +	kfree(e->src);

You leak the memory allocated for e here.

> +err_out_exit:
> +	return ERR_PTR(err);
> +}
