Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbXDPK7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbXDPK7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXDPK7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:59:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35432 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbXDPK7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:59:11 -0400
Date: Mon, 16 Apr 2007 11:59:00 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070416105859.GA18892@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	William Lee Irwin III <wli@holomorphy.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com> <461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org> <461F3961.6030300@yahoo.com.au> <20070413081338.GA27675@infradead.org> <y0m6480x9df.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0m6480x9df.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 05:17:00PM -0400, Frank Ch. Eigler wrote:
> It may be worthwhile to remind people that it is easy to use systemtap
> only to the extent of automating the placement of kprobes: just to
> perform the function-name/source-file/line-number triplet to PC
> mapping.  They can use embedded-C code to do all the same stuff they'd
> do with kprobes.  They are not obligated to write any odd script code
> for probing logic, nor indeed use any of this really wrong runtime.

Umm, yes- as long as you write systemtap the runtime gets linked in
currently.  That doesn't mean you actually use a lot of it in the end,
but the maintaince horror of actually getting all the junk code to
compile still is there.

Now the actual function-name/source-file/line-number triplet to PC is
really useful functionality, and for my tracing work I could really
use this a lot.  Unfortunately systemtap doesn't have a proper layered
approach and you can't use this bit without pulling in all the
junk.  If started some dward based function-name/source-file/line-number
of my own based on acme's work, but it's stalled due to more important
issues going on.

> > We could not really distribute systemtap scripts with the kernel.
> > systemtap is a bloody complicated piece of [software] 
> 
> I don't know if that should be treated a compliment to our team, for
> being able to work quickly on something that a full-grown kernel
> developer finds bloody complicated.  Perhaps your information is
> simply outdated.  Big & bloated?  We have several times asked for
> specifics rather than smears - what about it?

There's a lot of stuff unneeded for basic tasks.  But if you want
a detailed review you could submit your runtime bits for review and
get feedback from everyone.

> > outside the kernel tree that breaks all the time we change kernel
> > internals. [...]
> 
> That's begging the question.  If kernel folks are willing to maintain
> some included systemtap-related code, then by definition it would not
> break all the time.

We'll definitly need a trace transport.  I currently use a hackish
kfifo rinbuffer derived from net/ipv4/tcp_probe.c, but it's showing
it's limitations.  Tom promised long ago to factor our the trace
code from blktrace into generic bits, but as he doesn't deliver
I suspect I'll have to do that myself soon.

The safe dereference bits are a bit questionable, but at least worth
a try to put into the tree proper, because there's no chance they'd
be properly maintained outside.

The register dumps you do would could definitly stand some integration
with the register dumps in panic messages, and would be useful library
functions for proper C language kprobes, but that means detangling
the core from the utterly horrible systemtrap pascal string handling.

Stack backtrace handling could use some integration with the stack
tracing framework in for lockdep and fault injection and be available
more genericly for C kprobes.

With a proper tracing infrastructure we'll need the timing bits for
it aswell, which should superceed the utter mess in systemtap in
that area (I'm hoping for Matthew to come up with something there
as part of lttng)
