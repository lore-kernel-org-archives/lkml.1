Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZFYT4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZFYT4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZFYT4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:56:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbZFYTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:55:59 -0400
Date: Thu, 25 Jun 2009 12:55:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: rientjes@google.com, torvalds@linux-foundation.org, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090625125539.74e3507e.akpm@linux-foundation.org>
In-Reply-To: <20090625194423.GB6472@mit.edu>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
	<20090624123624.26c93459.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
	<20090624130121.99321cca.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
	<alpine.LFD.2.01.0906241334260.3154@localhost.localdomain>
	<20090624150714.c7264768.akpm@linux-foundation.org>
	<20090625132544.GB9995@mit.edu>
	<alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
	<20090625193806.GA6472@mit.edu>
	<20090625194423.GB6472@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 15:44:23 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Jun 25, 2009 at 03:38:06PM -0400, Theodore Tso wrote:
> > Hmm, is there a reason to avoid using GFP_ATOMIC on the first
> > allocation, and only adding GFP_ATOMIC after the first failure?
> 
> Never mind, stupid question; I hit the send button before thinking
> about this enough.  Obviously we should try without GFP_ATOMIC so the
> allocator can try to release some memory.

One use GFP_KERNEL|__GFP_HIGH, which bestows GFP_ATOMIC's special
reserve-dipping powers upon GFP_KERNEL.

Maybe one could set PF_MEMALLOC on kjournald too, as it is a thing
which can clean memory, as long as it is given a bit of memory itself. 
This would be a risky step.

In fact they're both risky steps, because the block layer needs memory
too.  If JBD uses __GFP_HIGH/PF_MEMALLOC tricks to get more memory,
that just deprives the block layer of some.

OTOH the block layer uses special immortal mepools to avoid starvation.

otoh2, ext3 can be backed by devices other than plain old disks.
