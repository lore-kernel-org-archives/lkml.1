Return-Path: <linux-kernel-owner+w=401wt.eu-S934683AbYCFOEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbYCFOEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934428AbYCFODs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:03:48 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:9656 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934382AbYCFODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:03:43 -0500
Message-ID: <47CFF9B7.5060803@trash.net>
Date: Thu, 06 Mar 2008 15:03:35 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: netfilter-devel@vger.kernel.org, clameter@sgi.com, joe@perches.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: replace horrible hack with ksize()
References: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> There's a horrible slab abuse in net/netfilter/nf_conntrack_extend.c that 
> can be replaced with a call to ksize().

This doesn't look right.

> @@ -95,7 +85,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct
>  	newlen = newoff + t->len;
>  	rcu_read_unlock();
>  
> -	if (newlen >= ct->ext->real_len) {
> +	if (newlen >= ksize(ct->ext)) {


This needs to look at the currently allocated size, otherwise
it will always realloc when adding new extensions after having
used up ksize(ct->ext) space.

>  		new = kmalloc(newlen, gfp);

And this should use ksize(newlen) and store the real length
in real_len below.

>  		if (!new)
>  			return NULL;
> @@ -114,7 +104,6 @@ void *__nf_ct_ext_add(struct nf_conn *ct
>  			rcu_read_unlock();
>  		}
>  		kfree(ct->ext);
> -		new->real_len = newlen;
>  		ct->ext = new;
>  	}

