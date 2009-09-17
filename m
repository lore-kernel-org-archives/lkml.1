Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZIQSS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZIQSS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZIQSS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:18:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54002 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbZIQSS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:18:26 -0400
Date: Thu, 17 Sep 2009 19:18:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917181831.GA714@csn.ul.ie>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <1253186019.4975.32.camel@penberg-laptop> <20090917111828.GB7205@csn.ul.ie> <20090917114116.GL18404@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090917114116.GL18404@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:41:16PM +0200, Nick Piggin wrote:
> On Thu, Sep 17, 2009 at 12:18:28PM +0100, Mel Gorman wrote:
> > On Thu, Sep 17, 2009 at 02:13:39PM +0300, Pekka Enberg wrote:
> > > On Thu, 2009-09-17 at 11:08 +0100, Mel Gorman wrote:
> > > > > > The danger is if SLQB is being silently disabled, it'll never be noticed
> > > > > > or debugged :/
> > > > > 
> > > > > Maybe, but that's not an excuse to push something that's known to break. 
> > > 
> > > On Thu, 2009-09-17 at 11:57 +0100, Mel Gorman wrote:
> > > > Wow, this is from back in May! Lame.
> > > 
> > > Heh, my (lame) excuse is lack of relevant hardware.... ;-)
> > > 
> > 
> > I'm not blaming you. It's just ... unfortunate :/
> 
> Ahh... it's pretty lame of me. Sachin has been a willing tester :(
> I have spent quite a few hours looking at it but I never found
> many good leads. Much appreciated if you can make more progress on
> it.

Nothing much so far. I've reproduced the problem based on 2.6.31 and slqb-core
from Pekka's tree but not a whole pile else. I don't know SLQB at all so the
investigation is fuzzy. It appears to initialise SLQB ok but crashes later when
setting up SCSI. Not 100% sure what the triggering event is but it might be
userspace starting up and other CPUs get involved, possibly corrupting lists.

This machine has two CPUs (0, 1) and two nodes with actual memory (2,3).
After applying a patch to kmem_cache_create, I see in the console

MEL::Creating cache pgd_cache CPU 0 Node 0
MEL::Creating cache pmd_cache CPU 0 Node 0
MEL::Creating cache pid_namespace CPU 0 Node 0
MEL::Creating cache shmem_inode_cache CPU 0 Node 0
MEL::Creating cache scsi_data_buffer CPU 1 Node 0

It crashes at this point during creation before the struct kmem_cache has
been allocated from kmem_cache_cache. Note it's kmem_cache_cache we are
failing to allocate from, not scsi_data_buffer.

I have no theories yet but will stick with it. Any suggestions on where
to investigate are welcome. Will pick this up again tomorrow.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
