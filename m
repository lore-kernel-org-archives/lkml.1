Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbYE3FWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbYE3FWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYE3FWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:22:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbYE3FW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:22:29 -0400
Date: Thu, 29 May 2008 22:21:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Message-Id: <20080529222143.5d7aa1e5.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080529215827.b659d032.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 22:03:14 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 29 May 2008, Andrew Morton wrote:
> 
> > All seems reasonable to me.  The obvious question is "how do we size
> > the arena".  We either waste memory or, much worse, run out.
> 
> The per cpu memory use by subsystems is typically quite small. We already 
> have an 8k limitation for percpu space for modules. And that does not seem 
> to be a problem.

eh?  That's DEFINE_PERCPU memory, not alloc_pecpu() memory?

> > And running out is a real possibility, I think.  Most people will only
> > mount a handful of XFS filesystems.  But some customer will come along
> > who wants to mount 5,000, and distributors will need to cater for that,
> > but how can they?
> 
> Typically these are fairly small 8 bytes * 5000 is only 20k.

It was just an example.  There will be others.

	tcp_v4_md5_do_add
	->tcp_alloc_md5sig_pool
	  ->__tcp_alloc_md5sig_pool

does an alloc_percpu for each md5-capable TCP connection.  I think - it
doesn't matter really, because something _could_.  And if something
_does_, we're screwed.

> > I wonder if we can arrange for the default to be overridden via a
> > kernel boot option?
> 
> We could do that yes.

Phew.

> > Another obvious question is "how much of a problem will we have with
> > internal fragmentation"?  This might be a drop-dead showstopper.
> 
> But then per cpu data is not frequently allocated and freed.

I think it is, in the TCP case.  And that's the only one I looked at.

Plus who knows what lies ahead of us?

> Going away from allocpercpu saves a lot of memory. We could make this 
> 128k or so to be safe?

("alloc_percpu" - please be careful about getting this stuff right)

I don't think there is presently any upper limit on alloc_percpu()?  It
uses kmalloc() and kmalloc_node()?

Even if there is some limit, is it an unfixable one?
