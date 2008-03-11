Return-Path: <linux-kernel-owner+w=401wt.eu-S1757153AbYCKMmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbYCKMmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYCKMmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:42:09 -0400
Received: from n8a.bullet.mail.mud.yahoo.com ([209.191.87.104]:24497 "HELO
	n8a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751379AbYCKMmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:42:08 -0400
X-Yahoo-Newman-Id: 841854.73183.bm@omp404.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=cWEkqn+7ZfwGLC4Av501lPjmHAoEtUMeJYR9fITZg2D7SnTEkonmfjgxIJeCt06GWFr4ZI+f8i9TIW5E8AowqSNrGKT1znPuMCsH450nRjl6WbFpx8V6uKeJTySin5aqu5M5bBVr77c4qCkVuY9U/wt8/E+0JfM1qT8Qg3OcAa4=  ;
X-YMail-OSG: Xndpf.MVM1kQ4Rdy3A9GUh6GMfjNQfL.12pOd57coSpkcSZ0gSEe8_TC1sEOt_doNBMpoLQzrw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Date: Tue, 11 Mar 2008 23:41:37 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20080310145704.GA6396@APFDCB5C>
In-Reply-To: <20080310145704.GA6396@APFDCB5C>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803112341.38005.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 01:57, Akinobu Mita wrote:

> +static inline int call_once(struct once_control *once_control,
> +			    int (*init_rouine)(void))
> +{
> +	return likely(once_control->done) ? 0
> +			: call_once_slow(once_control, init_rouine);
> +}
> +
> +#endif /* __LINUX_ONCE_H */
> Index: 2.6-rc/lib/once.c
> ===================================================================
> --- /dev/null
> +++ 2.6-rc/lib/once.c
> @@ -0,0 +1,18 @@
> +#include <linux/module.h>
> +#include <linux/once.h>
> +
> +int call_once_slow(struct once_control *once_control, int
> (*init_rouine)(void)) +{
> +	int err = 0;
> +
> +	mutex_lock(&once_control->lock);
> +	if (!once_control->done) {
> +		err = init_rouine();
> +		if (!err)
> +			once_control->done = 1;
> +	}
> +	mutex_unlock(&once_control->lock);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(call_once_slow);

The store "once_control->done = 1" can become visible before
init_routine has finished. The code after calling call_once may
also speculatively load some memory before the load of
once_control->done completes, so you can likewise have a data
race that way too.

To fix this, you need smp_wmb after init_rouine(), and probably
smp_mb() in the fastpath after the check but before returning.

Basically any time you have this situation where you're touching
a shared variable without using locks, then you're vastly
increasing the complexity of the code, and so you must have a
good reason for it.

So acquiring the mutex unconditionally would be the best way to
go, unless you're calling this a lot in fastpaths (in which case
I would say you should probably rework your code)

Thanks,
Nick

