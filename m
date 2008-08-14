Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYHNNrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYHNNrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYHNNrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:47:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48870 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYHNNrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:47:12 -0400
Date: Thu, 14 Aug 2008 06:46:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: tvrtko.ursulin@sophos.com
Cc: Eric Paris <eparis@redhat.com>, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814064656.13361901@infradead.org>
In-Reply-To: <20080814094701.A65372FE89E@pmx1.sophos.com>
References: <1218653864.3540.109.camel@localhost.localdomain>
	<20080814094701.A65372FE89E@pmx1.sophos.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 10:46:55 +0100
tvrtko.ursulin@sophos.com wrote:

> So the whole question is at which point should be performing an async 
> scan. Close seems like a natural point which should be ideal for
> majority of applications, I don't see how any time-based
> lumping/delaying scheme can be better than close?

close isn't the answer just because you can write content to the file
after that (and that's not just theoretical, glibc stdio supports mmap
etc); "dirty" *has* to be the event anyway. It's not impossible to
solve; even say a 1 second rearming delay would avoid 99.9% of the
useless rescans while still making sure everything gets scanned at some
point. Anyway this kind of policy can be done in userspace (and you can
get really fancy there and offer the admin various policies)

> 
> > > for the open() case, I would argue that you don't need synchronous
> > > behavior as long as the read() case is synchronous. I can imagine
> > > that open() kicks off an async scan, and if it's done by the time
> > > the first read() happens, no blocking at all happens.
> > 
> > An interesting addition.  Trying to keep these queues of events gets
> > much more complex, but if people really think the open to read race
> > is that important I've always said it wasn't impossible to close.
> 
> This really sounds pretty interesting. Not necessariliy so much as a 
> performance optimisation, because I am not sure there are so many
> programs where first read comes long after the first open, but as
> closing the open-read race. 

there's quite a few programs that open() but never read.
open+fstat is not uncommon as programming pattern for example;
with async-in-open (and then wait or sync in read) we wouldn't have the
big hit caused by the latency for the sync scan.
(I realize this pattern is much more likely to happen on posixy systems
than it is on windows.. one of those differences ;-)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
