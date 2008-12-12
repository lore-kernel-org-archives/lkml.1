Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYLLAtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYLLAtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 19:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbYLLAtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 19:49:32 -0500
Received: from ozlabs.org ([203.10.76.45]:48986 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbYLLAtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 19:49:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18753.46301.944770.779390@cargo.ozlabs.ibm.com>
Date: Fri, 12 Dec 2008 11:48:29 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yuri Tikhonov <yur@emcraft.com>, wd@denx.de, dzu@denx.de,
       linux-kernel@vger.kernel.org, miltonm@bga.com, linuxppc-dev@ozlabs.org,
       viro@zeniv.linux.org.uk, Geert.Uytterhoeven@sonycom.com,
       yanok@emcraft.com
Subject: Re: [PATCH][v2] fork_init: fix division by zero
In-Reply-To: <20081211121635.ff58193f.akpm@linux-foundation.org>
References: <200812101950.51958.yur@emcraft.com>
	<20081211121635.ff58193f.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> > +#if (8 * THREAD_SIZE) > PAGE_SIZE
> >  	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
> > +#else
> > +	max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
> > +#endif
> 
> The expression you've chosen here can be quite inacccurate, because
> ((PAGE_SIZE / (8 * THREAD_SIZE)) is a small number.  The way to
> preserve accuracy is

The assumption is that THREAD_SIZE is a power of 2, as is PAGE_SIZE.

I think Yuri should be increasing THREAD_SIZE for the larger page
sizes he's implementing, because we have on-stack arrays whose size
depends on the page size.  I suspect that having THREAD_SIZE less than
1/8 of PAGE_SIZE risks stack overflows, and the better fix is for Yuri
to make sure THREAD_SIZE is at least 1/8 of PAGE_SIZE.  (In fact, more
may be needed - someone should work out what fraction is actually
needed.)

Paul.
