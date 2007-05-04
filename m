Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXEDOHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXEDOHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXEDOHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:07:16 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:51896 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbXEDOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Oi9QiG8vTXA6wKFv78qzSewmuH3UilqUYI/Q+IsteebYgNDz/arfC9XQBmJRmThSl5LuULCfyjg7ZZ6cSIGzjUFqftQkr6DWb7RQeQqqxAOGzMjNGCMCZ2KQ3k+7tuZFlR2he3DPq41Kjw2vYF5809xfUFoi9Fw4LLMbzZWKtt0=
Message-ID: <39e6f6c70705040707l4556347akb5d5d8fe9282c041@mail.gmail.com>
Date: Fri, 4 May 2007 11:07:12 -0300
From: "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 16/40] netvm: hook skb allocation to reserves
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Thomas Graf" <tgraf@suug.ch>, "David Miller" <davem@davemloft.net>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Mike Christie" <michaelc@cs.wisc.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Phillips" <phillips@google.com>
In-Reply-To: <20070504103159.150015136@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070504102651.923946304@chello.nl>
	 <20070504103159.150015136@chello.nl>
X-Google-Sender-Auth: 608c95e987ef6d15
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Change the skb allocation api to indicate RX usage and use this to fall back to
> the reserve when needed. Skbs allocated from the reserve are tagged in
> skb->emergency.
>
> Teach all other skb ops about emergency skbs and the reserve accounting.
>
> Use the (new) packet split API to allocate and track fragment pages from the
> emergency reserve. Do this using an atomic counter in page->index. This is
> needed because the fragments have a different sharing semantic than that
> indicated by skb_shinfo()->dataref.
>
> (NOTE the extra atomic overhead is only for those pages allocated from the
> reserves - it does not affect the normal fast path.)
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/skbuff.h |   22 +++++-
>  net/core/skbuff.c      |  161 ++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 157 insertions(+), 26 deletions(-)

>
> +#define skb_alloc_rx(skb) (skb_emergency(skb) ? SKB_ALLOC_RX : 0)

skb_alloc_rx seems to imply "alloc an skb for rx", not "gimme the
right flags to allocate a skb for rx". Can this be changed to
"skb_alloc_rx_flag(skb)", similar to the existing sock_flag() for
socks?

- Arnaldo
