Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbZIURYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbZIURYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZIURYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:24:18 -0400
Received: from xenotime.net ([72.52.64.118]:35674 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751092AbZIURYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:24:18 -0400
Date: Mon, 21 Sep 2009 10:24:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] powerpc: Allocate per-cpu areas for node IDs for
 SLQB to use as per-node areas
Message-Id: <20090921102418.4692d62c.rdunlap@xenotime.net>
In-Reply-To: <1253553472.9654.236.camel@desktop>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
	<1253549426-917-2-git-send-email-mel@csn.ul.ie>
	<1253553472.9654.236.camel@desktop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 10:17:52 -0700 Daniel Walker wrote:

> On Mon, 2009-09-21 at 17:10 +0100, Mel Gorman wrote:
> > SLQB uses DEFINE_PER_CPU to define per-node areas. An implicit
> > assumption is made that all valid node IDs will have matching valid CPU
> > ids. In memoryless configurations, it is possible to have a node ID with
> > no CPU having the same ID. When this happens, a per-cpu are is not
> > created and the value of paca[cpu].data_offset is some random value.
> > This is later deferenced and the system crashes after accessing some
> > invalid address.
> > 
> > This patch hacks powerpc to allocate per-cpu areas for node IDs that
> > have no corresponding CPU id. This gets around the immediate problem but
> > it should be discussed if there is a requirement for a DEFINE_PER_NODE
> > and how it should be implemented.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  arch/powerpc/kernel/setup_64.c |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> > index 1f68160..a5f52d4 100644
> > --- a/arch/powerpc/kernel/setup_64.c
> > +++ b/arch/powerpc/kernel/setup_64.c
> > @@ -588,6 +588,26 @@ void __init setup_per_cpu_areas(void)
> >  		paca[i].data_offset = ptr - __per_cpu_start;
> >  		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
> >  	}
> > +#ifdef CONFIG_SLQB
> > +	/* 
> > +	 * SLQB abuses DEFINE_PER_CPU to setup a per-node area. This trick
> > +	 * assumes that ever node ID will have a CPU of that ID to match.
> > +	 * On systems with memoryless nodes, this may not hold true. Hence,
> > +	 * we take a second pass initialising a "per-cpu" area for node-ids
> > +	 * that SLQB can use
> > +	 */
> 
> Very trivial, but there's a little trailing whitespace in the first line
> of the comment (checkpatch warns on it.) You also spelled initializing
> wrong.

re: spelling.  Not really.  Think internationally.

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
