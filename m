Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYLKUqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYLKUqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYLKUpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:45:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbYLKUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:45:52 -0500
Date: Thu, 11 Dec 2008 12:43:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: yur@emcraft.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert.Uytterhoeven@sonycom.com, dhowells@redhat.com, miltonm@bga.com,
       wd@denx.de, dzu@denx.de, yanok@emcraft.com
Subject: Re: [PATCH][v2] fork_init: fix division by zero
Message-Id: <20081211124330.ff9b7483.akpm@linux-foundation.org>
In-Reply-To: <20081211202800.GQ28946@ZenIV.linux.org.uk>
References: <200812101950.51958.yur@emcraft.com>
	<20081211121635.ff58193f.akpm@linux-foundation.org>
	<20081211202800.GQ28946@ZenIV.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 20:28:00 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Dec 11, 2008 at 12:16:35PM -0800, Andrew Morton wrote:
> > > +#if (8 * THREAD_SIZE) > PAGE_SIZE
> > >  	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
> > > +#else
> > > +	max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
> > > +#endif
> > 
> > The expression you've chosen here can be quite inacccurate, because
> > ((PAGE_SIZE / (8 * THREAD_SIZE)) is a small number.  The way to
> > preserve accuracy is
> > 
> > 	max_threads = (mempages * PAGE_SIZE) / (8 * THREAD_SIZE);
> > 
> > so how about avoiding the nasty ifdefs and doing
> 
> Are you sure?

No, not at all.  It's all too hard.  Which is why I'm looking for
simplification.

>  Do they actually cross the page boundaries?

Some flavours of slab have at times done an order-1 allocation for
objects which would fit into an order-0 page (etc) if it looks like
that will be beneficial from a packing POV.  I'm unsure whether that
still happens - I tried to get it stamped out for reliability reasons.

