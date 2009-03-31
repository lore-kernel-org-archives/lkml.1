Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZCaIt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZCaIt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZCaItQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:49:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34113 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbZCaItP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:49:15 -0400
Subject: Re: [patch 2/3] slub: scan partial list for free slabs when
	thrashing
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903310043060.5579@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903301033380.13333@qirst.com>
	 <1238483617.26587.32.camel@penberg-laptop>
	 <alpine.DEB.2.00.0903310043060.5579@chino.kir.corp.google.com>
Date: Tue, 31 Mar 2009 11:49:11 +0300
Message-Id: <1238489352.26587.40.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 2009-03-30 at 10:37 -0400, Christoph Lameter wrote:
> > > That adds fastpath overhead and it shows for small objects in your tests.

On Tue, 31 Mar 2009, Pekka Enberg wrote:
> > Yup, and looking at this:
> > 
> > +       u16 fastpath_allocs;    /* Consecutive fast allocs before slowpath */
> > +       u16 slowpath_allocs;    /* Consecutive slow allocs before watermark */
> > 
> > How much do operations on u16 hurt on, say, x86-64?

On Tue, 2009-03-31 at 01:23 -0700, David Rientjes wrote:
> As opposed to unsigned int?  These simply use the word variations of the 
> mov, test, cmp, and inc instructions instead of long.  It's the same 
> tradeoff when using the u16 slub fields within struct page except it's not 
> strictly required in this instance because of size limitations, but rather 
> for cacheline optimization.

I was thinking of partial register stalls. But looking at it on x86-64,
the generated asm seems sane. I see tons of branch instructions, though,
so simplifying this somehow:

+       if (is_empty) {
+               if (c->fastpath_allocs < s->min_free_watermark)
+                       c->slowpath_allocs++;
+               else if (c->slowpath_allocs)
+                       c->slowpath_allocs--;
+       } else
+               c->slowpath_allocs = 0;
+       c->fastpath_allocs = 0;

would be most welcome.

			Pekka

