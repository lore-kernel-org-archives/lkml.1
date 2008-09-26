Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYIZFqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYIZFqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYIZFqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:46:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:19945 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYIZFqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nfjvOmkhFBrIhylhLX50gkA0Hi4SBkoN2k8J2nV3ihy8WEzwz3gHdBK/KXqC3Pks1q
         XFNnMt4kbNyVQEM5vS16K438h0gs8ZKJXLc6IDkGUNn5kb0aMFNgu2I/r9cPeJAnJtZT
         OA8Q3OSQ1eVGpjuElOWg2OlRLQTwHv5mniSwE=
Date: Fri, 26 Sep 2008 05:46:00 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, shemminger@vyatta.com
Subject: Re: [PATCH 1/1] Use RCU for the UDP hash lock
Message-ID: <20080926054600.GA4141@ff.dom.local>
References: <20080926031832.GA27289@minyard.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926031832.GA27289@minyard.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:18:33PM -0500, Corey Minyard wrote:
...
> This patch is the second try; I believe I fixed all issues that people
> raised.

Actually, you've skipped my first question, so I still don't know, why
you don't use an _init version of sk_del_node (even if it's safe in the
current implementation), while the non-rcu code uses only this?

...
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 06c5259..65110a6 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
...
>  static inline int sk_unhashed(const struct sock *sk)
>  {
>  	return hlist_unhashed(&sk->sk_node);
> @@ -361,6 +374,27 @@ static __inline__ int sk_del_node_init(struct sock *sk)
>  	return rc;
>  }
>  
> +static inline int __sk_del_node_rcu(struct sock *sk)
> +{
> +	if (sk_hashed(sk)) {
> +		hlist_del_rcu(&sk->sk_node);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static inline int sk_del_node_rcu(struct sock *sk)
> +{
> +	int rc = __sk_del_node_rcu(sk);
> +
> +	if (rc) {
> +		/* paranoid for a while -acme */
> +		WARN_ON(atomic_read(&sk->sk_refcnt) == 1);
> +		__sock_put(sk);
> +	}
> +	return rc;
> +}
...

Jarek P.
