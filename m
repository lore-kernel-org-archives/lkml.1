Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYGDO3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYGDO3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYGDO3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:29:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51457 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYGDO3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:29:39 -0400
Date: Fri, 4 Jul 2008 15:29:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Philippe De Muyter <phdm@macqel.be>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       libdc1394-devel@lists.sourceforge.net,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: mmap'ed memory in core files ?
In-Reply-To: <486DC42A.2080105@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0807041459130.2674@blonde.site>
References: <20080701132149.GA32510@frolo.macqel>    
 <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>    
 <20080702105027.GA1111@frolo.macqel>     <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com>
     <486C4CC5.2060006@hitachi.com> <20080703092247.GA13430@frolo.macqel>
 <486DBA21.3080106@hitachi.com> <486DC42A.2080105@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008, Stefan Richter wrote:
> Hidehiro Kawai wrote:
> > Philippe De Muyter wrote:
> > >
> > > As I don't know the real meaning of VM_RESERVED, I do not know which
> > > choice
> > > is the best one for the official kernel tree,
> 
> I don't know these things either.  But among else, VM_RESERVED prevents a vma
> from being swapped out.  Makes kind of sense, given that besides the CPUs also
> the FireWire controller writes to this memory.
> 
> > > but locally I'll go for
> > > adding VM_ALWAYSDUMP in ieee1394::dma_region_mmap.
> > 
> > I'm afraid I don't know real usages of VM_RESERVED and VM_IO, either.

They're rather an embarrassment, nobody can say quite what VM_RESERVED
and VM_IO really mean, beyond not-your-ordinary-vma: VM_VOODOO, beware.
They both say "count me as reserved_vm", which means /proc/<pid>/status
leaves them out of VmSize.

Certainly VM_IO hints at special I/O memory, but in most cases there's
nothing very special about either: just memory preallocated by a driver.

In 2.4 VM_RESERVED indeed prevented swapout from looking at the pages
of that vma.  We probably ought to have killed it as part of the 2.5
switch to rmap.  In 2.6 the pages of a VM_RESERVED vma wouldn't be
considered for swapout, because they're not put on any LRU for that.
I think I promised (ah, that's a shameful phrase!) to get rid of it
a few years ago, but never quite got around to it.

VM_RESERVED and VM_IO are treated as equivalent in most tests, but
there's just a few places, e.g. get_user_pages, where we're scared
off by VM_IO but don't mind VM_RESERVED.

VM_ALWAYSDUMP: marvellous, a flag with an understandable name and
a clear purpose.

Hugh
