Return-Path: <linux-kernel-owner+w=401wt.eu-S933677AbYBMWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbYBMWvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbYBMWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:51:16 -0500
Received: from web32509.mail.mud.yahoo.com ([68.142.207.219]:38736 "HELO
	web32509.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759650AbYBMWvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:51:14 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 17:51:14 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=eZV8zFwdgqNvj20J1bpXpbSGKtgmIURUKj4Gu5VYZUXfr8CM1CbGHTFxTi20iCqUcygS4gMWbkldDOc0LNiHkWikc/JEgVFGJUR2bskptvLZqQxEtO9U08jXnR5UqtTO/g+fHDCfzEf1lv/HUzozdJES9XnehuedIXsz3IB2Q/0=;
X-YMail-OSG: UYFe6LQVM1mpBN0LDnl9sb6VPdtFBfvmeCicSBf4HCMdRLaS.YB2KRpttXKKuFvPBRsMrapyJS.FzRRf7OlyXVlEq9XBST6qwyEk5ijyzLldnM4nnhBe8yAafQduhg--
Date: Wed, 13 Feb 2008 14:44:34 -0800 (PST)
From: Kanoj Sarcar <kanojsarcar@yahoo.com>
Subject: Re: [ofa-general] Re: Demand paging for memory regions
To: Christoph Lameter <clameter@sgi.com>,
       Christian Bell <christian.bell@qlogic.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       Roland Dreier <rdreier@cisco.com>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0802131227200.20156@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <320000.75105.qm@web32509.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 13 Feb 2008, Christian Bell wrote:
> 
> > not always be in the thousands but you're still
> claiming scalability
> > for a mechanism that essentially logs who accesses
> the regions.  Then
> > there's the fact that reclaim becomes a collective
> communication
> > operation over all region accessors.  Makes me
> nervous.
> 
> Well reclaim is not a very fast process (and we
> usually try to avoid it 
> as much as possible for our HPC). Essentially its
> only there to allow 
> shifts of processing loads and to allow efficient
> caching of application 
> data.
> 
> > However, short of providing user-level
> notifications for pinned pages
> > that are inadvertently released to the O/S, I
> don't believe that the
> > patchset provides any significant added value for
> the HPC community
> > that can't optimistically do RDMA demand paging.
> 
> We currently also run XPmem with pinning. Its great
> as long as you just 
> run one load on the system. No reclaim ever iccurs.
> 
> However, if you do things that require lots of
> allocations etc etc then 
> the page pinning can easily lead to livelock if
> reclaim is finally 
> triggerd and also strange OOM situations since the
> VM cannot free any 
> pages. So the main issue that is addressed here is
> reliability of pinned 
> page operations. Better VM integration avoids these
> issues because we can 
> unpin on request to deal with memory shortages.
> 
> 

I have a question on the basic need for the mmu
notifier stuff wrt rdma hardware and pinning memory.

It seems that the need is to solve potential memory
shortage and overcommit issues by being able to
reclaim pages pinned by rdma driver/hardware. Is my
understanding correct?

If I do understand correctly, then why is rdma page
pinning any different than eg mlock pinning? I imagine
Oracle pins lots of memory (using mlock), how come
they do not run into vm overcommit issues?

Are we up against some kind of breaking c-o-w issue
here that is different between mlock and rdma pinning?

Asked another way, why should effort be spent on a
notifier scheme, and rather not on fixing any memory
accounting problems and unifying how pin pages are
accounted for that get pinned via mlock() or rdma
drivers?

Startup benefits are well understood with the notifier
scheme (ie, not all pages need to be faulted in at
memory region creation time), specially when most of
the memory region is not accessed at all. I would
imagine most of HPC does not work this way though.
Then again, as rdma hardware is applied
(increasingly?) towards apps with short lived
connections, the notifier scheme will help with
startup times.

Kanoj



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

