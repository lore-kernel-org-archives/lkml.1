Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYBXGwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYBXGwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 01:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBXGwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 01:52:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:52910 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbYBXGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 01:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nyj2AhSTNxWRysCmWbNMlN8Z4mlc1waaJxC1orDajXF6WKyO72efO3eY+fuZAwC8YNW6yVzFwyndNrPKfgGdtNrgGKP/wWn9d1MYkOyUHwLv6ZxuDrcMjd0frEOI7ddLDeHOlpSs/zeZXHgORbE1Mu3OF4aJbikhers1TZlJpbs=
Message-ID: <170fa0d20802232252x7e52c5ebga726dcd7736261ba@mail.gmail.com>
Date: Sun, 24 Feb 2008 01:52:02 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 15/28] netvm: network reserve infrastructure
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <20080220150307.208040000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220144610.548202000@chello.nl>
	 <20080220150307.208040000@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 9:46 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Provide the basic infrastructure to reserve and charge/account network memory.
...

>  Index: linux-2.6/net/core/sock.c
>  ===================================================================
>  --- linux-2.6.orig/net/core/sock.c
>  +++ linux-2.6/net/core/sock.c
...
>  +/**
>  + *     sk_adjust_memalloc - adjust the global memalloc reserve for critical RX
>  + *     @socks: number of new %SOCK_MEMALLOC sockets
>  + *     @tx_resserve_pages: number of pages to (un)reserve for TX
>  + *
>  + *     This function adjusts the memalloc reserve based on system demand.
>  + *     The RX reserve is a limit, and only added once, not for each socket.
>  + *
>  + *     NOTE:
>  + *        @tx_reserve_pages is an upper-bound of memory used for TX hence
>  + *        we need not account the pages like we do for RX pages.
>  + */
>  +int sk_adjust_memalloc(int socks, long tx_reserve_pages)
>  +{
>  +       int nr_socks;
>  +       int err;
>  +
>  +       err = mem_reserve_pages_add(&net_tx_pages, tx_reserve_pages);
>  +       if (err)
>  +               return err;
>  +
>  +       nr_socks = atomic_read(&memalloc_socks);
>  +       if (!nr_socks && socks > 0)
>  +               err = mem_reserve_connect(&net_reserve, &mem_reserve_root);
>  +       nr_socks = atomic_add_return(socks, &memalloc_socks);
>  +       if (!nr_socks && socks)
>  +               err = mem_reserve_disconnect(&net_reserve);
>  +
>  +       if (err)
>  +               mem_reserve_pages_add(&net_tx_pages, -tx_reserve_pages);
>  +
>  +       return err;
>  +}

EXPORT_SYMBOL_GPL(sk_adjust_memalloc); is needed here to build sunrpc
as a module.

Mike
