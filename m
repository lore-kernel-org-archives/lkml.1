Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZCPWEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZCPWEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZCPWEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:04:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZCPWEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:04:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Regression - locking (all from 2.6.28)
Date: Mon, 16 Mar 2009 23:04:27 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       jan sonnek <ha2nny@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20090302121127.e46dc4be.akpm@linux-foundation.org> <1236367186.10626.84.camel@nimitz> <20090306192812.GA26767@elf.ucw.cz>
In-Reply-To: <20090306192812.GA26767@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162304.28944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009, Pavel Machek wrote:
> Hi!
> 
> On Fri 2009-03-06 11:19:46, Dave Hansen wrote:
> > On Fri, 2009-03-06 at 18:00 +0000, Catalin Marinas wrote:
> > > > I think you should be more worried about consistency rather than missing
> > > > entries.  Take these two lines of code:
> > > > 
> > > >       start_pfn = node->node_start_pfn;
> > > >       /* hotplug occurs here */
> > > >       end_pfn = start_pfn + node->node_spanned_pages;
> > > > 
> > > > What if someone comes in and adds memory to the node, at the beginning
> > > > of the node, after you have calculated start_pfn?  Try to think of what
> > > > value you'll get for end_pfn and whether it is consistent and was *ever*
> > > > valid at all.  Would that oops the kernel?
> > > 
> > > I assume pfn_valid() should handle this and kmemleak wouldn't scan the
> > > page, unless we need locks around pfn_valid as well but I haven't seen
> > > any used in the kernel.
> > 
> > You assume incorrectly. :(
> > 
> > Take my above example, and assume that you have two nodes which are
> > right next to each other.  You might run over the end of one node and
> > into the next one.  Your pages will be pfn_valid() but you will be on
> > the wrong node.
> > 
> > Please take a look at those locks that I mentioned.  Notice that they
> > are lock the pgdat *span*, not the validity of pages inside the pgdat.
> > Your code deals with what pages the pgdats *span* and thus needs that
> > lock.  Notice that my example also had to do with those two lines of
> > code incorrectly guessing the pgdat's *span*.
> > 
> > We recently went to some pain to make sure that the software suspend
> > code (which walks pgdat ranges as well) worked with memory hotplug.
> > There really isn't that much code around that actually cares at runtime
> > about which physical areas a particular node or zone spans.  Yours is a
> > rarity and will require some caution.
> > 
> > You could probably also use the memory hotplug mutex found here:
> > 
> > https://lists.linux-foundation.org/pipermail/linux-pm/2008-November/018884.html
> > 
> > But I'm not sure where those patches have gone.  Hmmm.  Pavel?
> 
> I don't think they were applied. They probably should... Rafael was
> about to look into that, but he lost the patch pointer.

Yes.  In fact, sending the patch again to me would be appreciated.

Thanks,
Rafael
