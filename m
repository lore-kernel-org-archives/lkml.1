Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXCaM5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXCaM5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 08:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXCaM5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 08:57:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXCaM5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 08:57:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070330151353.95cd56ed.akpm@linux-foundation.org> 
References: <20070330151353.95cd56ed.akpm@linux-foundation.org>  <20070329203913.GA5190@skull.piratehaven.org> <20070330134359.ec6d95bc.akpm@linux-foundation.org> <Pine.LNX.4.64.0703302250050.28059@blonde.wat.veritas.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Brian Pomerantz <bapper@piratehaven.org>,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fix page leak during core dump 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sat, 31 Mar 2007 13:57:29 +0100
Message-ID: <2828.1175345849@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> <would anyone be interested in hearing my opinion on the DUMP_SEEK macro
> again?>

I can guess.  And it's very probably right.  Macros containing return
statements like that are dodgy as they help people screw up the error handling.

However, ...

Andrew Morton <akpm@linux-foundation.org> wrote:

> -				DUMP_SEEK(file->f_pos + PAGE_SIZE);
> -				page_cache_release(page);
> +				if (!dump_seek(file, file->f_pos + PAGE_SIZE)) {
> +					page_cache_release(page);
> +					return 0;
> +				}

Is not correct as you've then eliminated the page_cache_release() on the
success path.  What you probably intended was:

	int tmp;
	...
				tmp = dump_seek(file, file->f_pos + PAGE_SIZE);
				page_cache_release(page);
				if (!tmp)
					return 0;

David
