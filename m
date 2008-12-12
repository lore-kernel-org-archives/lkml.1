Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYLLBIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYLLBIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 20:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbYLLBIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 20:08:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756657AbYLLBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 20:08:09 -0500
Date: Thu, 11 Dec 2008 17:07:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Yuri Tikhonov <yur@emcraft.com>, wd@denx.de, dzu@denx.de,
       linux-kernel@vger.kernel.org, miltonm@bga.com, linuxppc-dev@ozlabs.org,
       viro@zeniv.linux.org.uk, Geert.Uytterhoeven@sonycom.com,
       yanok@emcraft.com
Subject: Re: [PATCH][v2] fork_init: fix division by zero
Message-Id: <20081211170702.fc880a5c.akpm@linux-foundation.org>
In-Reply-To: <18753.46301.944770.779390@cargo.ozlabs.ibm.com>
References: <200812101950.51958.yur@emcraft.com>
	<20081211121635.ff58193f.akpm@linux-foundation.org>
	<18753.46301.944770.779390@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 11:48:29 +1100 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > > +#if (8 * THREAD_SIZE) > PAGE_SIZE
> > >  	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
> > > +#else
> > > +	max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
> > > +#endif
> > 
> > The expression you've chosen here can be quite inacccurate, because
> > ((PAGE_SIZE / (8 * THREAD_SIZE)) is a small number.  The way to
> > preserve accuracy is
> 
> The assumption is that THREAD_SIZE is a power of 2, as is PAGE_SIZE.
> 
> I think Yuri should be increasing THREAD_SIZE for the larger page
> sizes he's implementing, because we have on-stack arrays whose size
> depends on the page size.  I suspect that having THREAD_SIZE less than
> 1/8 of PAGE_SIZE risks stack overflows, and the better fix is for Yuri
> to make sure THREAD_SIZE is at least 1/8 of PAGE_SIZE.  (In fact, more
> may be needed - someone should work out what fraction is actually
> needed.)

OK, yes.

It's the MAX_BUF_PER_PAGE arrays which will hurt.  iirc they nest
three-deep on some codepaths.

