Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZCRJqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZCRJqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZCRJpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:45:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33340 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZCRJpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:45:53 -0400
Date: Sat, 14 Mar 2009 17:24:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       jan sonnek <ha2nny@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Regression - locking (all from 2.6.28)
Message-ID: <20090314162425.GC1526@ucw.cz>
References: <20090302121127.e46dc4be.akpm@linux-foundation.org> <1236367186.10626.84.camel@nimitz> <20090306192812.GA26767@elf.ucw.cz> <200903162304.28944.rjw@sisk.pl> <20090317090732.bbb97825.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317090732.bbb97825.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-17 09:07:32, KAMEZAWA Hiroyuki wrote:
> On Mon, 16 Mar 2009 23:04:27 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Friday 06 March 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > On Fri 2009-03-06 11:19:46, Dave Hansen wrote:
> > > > On Fri, 2009-03-06 at 18:00 +0000, Catalin Marinas wrote:
> > > > > > I think you should be more worried about consistency rather than missing
> > > > > > entries.  Take these two lines of code:
> > > > > > 
> > > > > >       start_pfn = node->node_start_pfn;
> > > > > >       /* hotplug occurs here */
> > > > > >       end_pfn = start_pfn + node->node_spanned_pages;
> > > > > > 
> > > > > > What if someone comes in and adds memory to the node, at the beginning
> > > > > > of the node, after you have calculated start_pfn?  Try to think of what
> > > > > > value you'll get for end_pfn and whether it is consistent and was *ever*
> > > > > > valid at all.  Would that oops the kernel?
> > > > > 
> > > > > I assume pfn_valid() should handle this and kmemleak wouldn't scan the
> > > > > page, unless we need locks around pfn_valid as well but I haven't seen
> > > > > any used in the kernel.
> > > > 
> > > > You assume incorrectly. :(
> > > > 
> > > > Take my above example, and assume that you have two nodes which are
> > > > right next to each other.  You might run over the end of one node and
> > > > into the next one.  Your pages will be pfn_valid() but you will be on
> > > > the wrong node.
> > > > 
> > > > Please take a look at those locks that I mentioned.  Notice that they
> > > > are lock the pgdat *span*, not the validity of pages inside the pgdat.
> > > > Your code deals with what pages the pgdats *span* and thus needs that
> > > > lock.  Notice that my example also had to do with those two lines of
> > > > code incorrectly guessing the pgdat's *span*.
> > > > 
> > > > We recently went to some pain to make sure that the software suspend
> > > > code (which walks pgdat ranges as well) worked with memory hotplug.
> > > > There really isn't that much code around that actually cares at runtime
> > > > about which physical areas a particular node or zone spans.  Yours is a
> > > > rarity and will require some caution.
> > > > 
> > > > You could probably also use the memory hotplug mutex found here:
> > > > 
> > > > https://lists.linux-foundation.org/pipermail/linux-pm/2008-November/018884.html
> > > > 
> > > > But I'm not sure where those patches have gone.  Hmmm.  Pavel?
> > > 
> > > I don't think they were applied. They probably should... Rafael was
> > > about to look into that, but he lost the patch pointer.
> > 
> > Yes.  In fact, sending the patch again to me would be appreciated.
> > 
> 
> Ah...but as I wrote, for me, testing this is difficult.
> Could some expert of hibernation update and post this again ? For memoyr hotplug.
> it seems enough that sending the patch witch CC: to linux-mm and including
> "Memory Hotplug" in the subject.
> 

Well, testing this is probably difficult for everyone, as
hotplug-capable machines are rare/expensive.

Can youjust retransmit the patch to rafael?
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
