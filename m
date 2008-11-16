Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYKPS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYKPS5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYKPS5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:57:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:38582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYKPS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:57:14 -0500
Date: Sun, 16 Nov 2008 10:57:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Message-ID: <20081116105725.12458b13@infradead.org>
In-Reply-To: <20081116.001926.150424480.davem@davemloft.net>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081115205229.765f7ee3@infradead.org>
	<20081116.001926.150424480.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 00:19:26 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Arjan van de Ven <arjan@infradead.org>
> Date: Sat, 15 Nov 2008 20:52:29 -0800
> 
> > On Sun, 16 Nov 2008 12:33:15 +0800
> > Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> > > 
> > > some subsystem needs vmalloc() when required memory is large.
> > > but current kernel has not APIs for this requirement.
> > > this patch introduces simple_malloc() and simple_free().
> > 
> > I kinda really don't like this approach. vmalloc() (and especially,
> > vfree()) is a really expensive operation, and vmalloc()'d memory is
> > also slower (due to tlb pressure). Realistically, people should try
> > hard to use small datastructure instead....
> 
> This is happening in many places, already, for good reason.
> 
> There are lots of places where we can't (core hash tables, etc.)  and
> we want NUMA spreading and reliable allocation, and thus vmalloc it
> is.

vmalloc() isn't 100% evil; for truely long term stuff it's sometimes a
quite reasonable solution.

There are some issues with it still: the vmalloc() space is shared
with ioremap, modules and others and it's not all that big on 32 bit; on
x86 you could well end up with only 64Mb total (after taking out the
various ioremap's etc). 

Yes there's places where it's then totally fine to dip into this space
at boot/init time. You mention a few very good users.
(There's still the tlb miss cost on use but on modern cpus a tlb miss
is actually quite cheap)

But this doesn't make vmalloc() the magic bullet that solves the "oh
Linux can't allocate large chunks of memory" problem. Specifically in
driver space for things that get ported from other OSes.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
