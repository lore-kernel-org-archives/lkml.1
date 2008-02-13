Return-Path: <linux-kernel-owner+w=401wt.eu-S1765095AbYBMXni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765095AbYBMXni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbYBMXnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:43:24 -0500
Received: from web32510.mail.mud.yahoo.com ([68.142.207.220]:48749 "HELO
	web32510.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758627AbYBMXnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:43:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=euT/mTmd+Fv8vPkIZy1kQktKnnhfIjVH4qoRrKttX2qx6uE7ptWsePVgQRqdTPXJnPYZ7gadhPdYcr0O9yt6XuITX8vkj0GqiXmVoJdmM6Ei5grc/KNkECpxYHdAUgt0MIrXJa58wRunU0IOUME5B+m55BwkmirIjZLlOmKZUIM=;
X-YMail-OSG: yCvj_vcVM1mIVxg_2b2fM.oq7IzzQzgEbOo74yj.gCub.R1Q0Fx1vDHXJzYJBEqJdJXj_9KR.QhcxQKOoCf9cGcDXkA2IyflxbT6KEWGjXt8n3uXzhM-
Date: Wed, 13 Feb 2008 15:43:17 -0800 (PST)
From: Kanoj Sarcar <kanojsarcar@yahoo.com>
Subject: Re: [ofa-general] Re: Demand paging for memory regions
To: Christoph Lameter <clameter@sgi.com>
Cc: Christian Bell <christian.bell@qlogic.com>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       Roland Dreier <rdreier@cisco.com>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0802131452410.22542@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <866658.37093.qm@web32510.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 13 Feb 2008, Kanoj Sarcar wrote:
> 
> > It seems that the need is to solve potential
> memory
> > shortage and overcommit issues by being able to
> > reclaim pages pinned by rdma driver/hardware. Is
> my
> > understanding correct?
> 
> Correct.
> 
> > If I do understand correctly, then why is rdma
> page
> > pinning any different than eg mlock pinning? I
> imagine
> > Oracle pins lots of memory (using mlock), how come
> > they do not run into vm overcommit issues?
> 
> Mlocked pages are not pinned. They are movable by
> f.e. page migration and 
> will be potentially be moved by future memory defrag
> approaches. Currently 
> we have the same issues with mlocked pages as with
> pinned pages. There is 
> work in progress to put mlocked pages onto a
> different lru so that reclaim 
> exempts these pages and more work on limiting the
> percentage of memory 
> that can be mlocked.
> 
> > Are we up against some kind of breaking c-o-w
> issue
> > here that is different between mlock and rdma
> pinning?
> 
> Not that I know.
> 
> > Asked another way, why should effort be spent on a
> > notifier scheme, and rather not on fixing any
> memory
> > accounting problems and unifying how pin pages are
> > accounted for that get pinned via mlock() or rdma
> > drivers?
> 
> There are efforts underway to account for and limit
> mlocked pages as 
> described above. Page pinning the way it is done by
> Infiniband through
> increasing the page refcount is treated by the VM as
> a temporary 
> condition not as a permanent pin. The VM will
> continually try to reclaim 
> these pages thinking that the temporary usage of the
> page must cease 
> soon. This is why the use of large amounts of pinned
> pages can lead to 
> livelock situations.

Oh ok, yes, I did see the discussion on this; sorry I
missed it. I do see what notifiers bring to the table
now (without endorsing it :-)).

An orthogonal question is this: is IB/rdma the only
"culprit" that elevates page refcounts? Are there no
other subsystems which do a similar thing?

The example I am thinking about is rawio (Oracle's
mlock'ed SHM regions are handed to rawio, isn't it?).
My understanding of how rawio works in Linux is quite
dated though ...

Kanoj

> 
> If we want to have pinning behavior then we could
> mark pinned pages 
> specially so that the VM will not continually try to
> evict these pages. We 
> could manage them similar to mlocked pages but just
> not allow page 
> migration, memory unplug and defrag to occur on
> pinned memory. All of 
> theses would have to fail. With the notifier scheme
> the device driver 
> could be told to get rid of the pinned memory. This
> would make these 3 
> techniques work despite having an RDMA memory
> section.
> 
> > Startup benefits are well understood with the
> notifier
> > scheme (ie, not all pages need to be faulted in at
> > memory region creation time), specially when most
> of
> > the memory region is not accessed at all. I would
> > imagine most of HPC does not work this way though.
> 
> No for optimal performance  you would want to
> prefault all pages like 
> it is now. The notifier scheme would only become
> relevant in memory 
> shortage situations.
> 
> > Then again, as rdma hardware is applied
> (increasingly?) towards apps 
> > with short lived connections, the notifier scheme
> will help with startup 
> > times.
> 
> The main use of the notifier scheme is for stability
> and reliability. The 
> "pinned" pages become unpinnable on request by the
> VM. So the VM can work 
> itself out of memory shortage situations in
> cooperation with the 
> RDMA logic instead of simply failing.
> 
> --
> To unsubscribe, send a message with 'unsubscribe
> linux-mm' in
> the body to majordomo@kvack.org.  For more info on
> Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org">
> email@kvack.org </a>
> 



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
