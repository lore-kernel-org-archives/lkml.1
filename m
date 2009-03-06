Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZCFTZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZCFTZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZCFTZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:25:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48915 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbZCFTZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:25:37 -0500
Date: Fri, 6 Mar 2009 20:28:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       jan sonnek <ha2nny@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression - locking (all from 2.6.28)
Message-ID: <20090306192812.GA26767@elf.ucw.cz>
References: <20090302121127.e46dc4be.akpm@linux-foundation.org> <1236076864.8547.20.camel@pc1117.cambridge.arm.com> <1236092480.8547.67.camel@pc1117.cambridge.arm.com> <1236214452.22399.68.camel@nimitz> <1236357616.3882.66.camel@pc1117.cambridge.arm.com> <1236358369.10626.58.camel@nimitz> <1236359888.3882.77.camel@pc1117.cambridge.arm.com> <1236360415.10626.67.camel@nimitz> <1236362436.3882.80.camel@pc1117.cambridge.arm.com> <1236367186.10626.84.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236367186.10626.84.camel@nimitz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri 2009-03-06 11:19:46, Dave Hansen wrote:
> On Fri, 2009-03-06 at 18:00 +0000, Catalin Marinas wrote:
> > > I think you should be more worried about consistency rather than missing
> > > entries.  Take these two lines of code:
> > > 
> > >       start_pfn = node->node_start_pfn;
> > >       /* hotplug occurs here */
> > >       end_pfn = start_pfn + node->node_spanned_pages;
> > > 
> > > What if someone comes in and adds memory to the node, at the beginning
> > > of the node, after you have calculated start_pfn?  Try to think of what
> > > value you'll get for end_pfn and whether it is consistent and was *ever*
> > > valid at all.  Would that oops the kernel?
> > 
> > I assume pfn_valid() should handle this and kmemleak wouldn't scan the
> > page, unless we need locks around pfn_valid as well but I haven't seen
> > any used in the kernel.
> 
> You assume incorrectly. :(
> 
> Take my above example, and assume that you have two nodes which are
> right next to each other.  You might run over the end of one node and
> into the next one.  Your pages will be pfn_valid() but you will be on
> the wrong node.
> 
> Please take a look at those locks that I mentioned.  Notice that they
> are lock the pgdat *span*, not the validity of pages inside the pgdat.
> Your code deals with what pages the pgdats *span* and thus needs that
> lock.  Notice that my example also had to do with those two lines of
> code incorrectly guessing the pgdat's *span*.
> 
> We recently went to some pain to make sure that the software suspend
> code (which walks pgdat ranges as well) worked with memory hotplug.
> There really isn't that much code around that actually cares at runtime
> about which physical areas a particular node or zone spans.  Yours is a
> rarity and will require some caution.
> 
> You could probably also use the memory hotplug mutex found here:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2008-November/018884.html
> 
> But I'm not sure where those patches have gone.  Hmmm.  Pavel?

I don't think they were applied. They probably should... Rafael was
about to look into that, but he lost the patch pointer.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
