Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYHSAnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYHSAnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYHSAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:43:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbYHSAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:43:12 -0400
Date: Mon, 18 Aug 2008 17:42:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anthony Liguori <aliguori@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Avi Kivity <avi@qumranet.com>,
       virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] virtio_balloon: fix towards_target when deflating
 balloon
In-Reply-To: <1219097731-1224-1-git-send-email-aliguori@us.ibm.com>
Message-ID: <alpine.LFD.1.10.0808181740500.3324@nehalem.linux-foundation.org>
References: <1219097731-1224-1-git-send-email-aliguori@us.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Aug 2008, Anthony Liguori wrote: <
> 
> This handles the case where v < vb->num_pages and ensures we get a 
> small, negative, s64 as the result.

That's just horrible code.

Maybe the compiler notices that you're doing something stupid, but 
basically, please don't do this.

> -	return v - vb->num_pages;
> +	if (v < vb->num_pages)
> +		return -(s64)(vb->num_pages - v);
> +	else
> +		return v - vb->num_pages;

What's wrong with just doing

	return (s64)v - vb->num_pages;

instead?

Casting 'v' to s64 guarantees that the subtraction will eb done in 64 
bits, and the compiler can just generate the trivial non-conditional code.

		Linus
