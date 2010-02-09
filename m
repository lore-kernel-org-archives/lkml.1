Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab0BITK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:10:56 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:56129 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751482Ab0BITKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:10:55 -0500
Date: Tue, 9 Feb 2010 22:10:53 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 2/3] of: Introduce safe accessors for node->data
Message-ID: <20100209191053.GA16560@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
 <20100205205043.GB4178@oksana.dev.rtsoft.ru>
 <fa686aa41002090925q30f362d6x4d14894a72439125@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa686aa41002090925q30f362d6x4d14894a72439125@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 10:25:22AM -0700, Grant Likely wrote:
> On Fri, Feb 5, 2010 at 1:50 PM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > Platform code use node->data to store some private information
> > associated with a node.
> >
> > Previously there was no need for any locks and accessors since we were
> > initializing the data mostly at boot time and never modified it later.
> >
> > Though, nowadays OF GPIO infrastructure supports GPIO chips detaching,
> > so to handle this correctly we have to introduce locking for the
> > node->data field.
> 
> I'm not convinced this is needed.  What's wrong with using the
> whole-tree devtree_lock?

Why are you concerned? It doesn't add much of any footprint.

$ grep -c { -r arch/powerpc/boot/dts/ | cut -d: -f2 | sort -n | tail -n1
84

So far we have max 84 nodes, so it's a few hundreds of bytes for all
the dev tree.

Anyway, yes, we can use the devtree lock. Though, this will require a
bit more modifications, and I'm not sure if it's a great idea in
general (i.e. using the global lock in contrast to fine grained
locking).

The thing is that you can't use most of the of_ functions when you
hold the devtree lock (IIRC, rwlock has the same restrictions as a
spinlock, so you can't nest these locks).

I can try to rework OF GPIO calls so that they won't require of_
calls when they hold the lock, and let's see how it'll look like.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
