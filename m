Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYGaG0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYGaG0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYGaG0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:26:24 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:37414 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752437AbYGaG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:26:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4szgqNJ/EJzIgsm4svhjIsjOgocWXGgq8zgDuOdrORKXQOe/KlCb5zLLnGR6S9zH1fgoG0xF7xLFOClddZZr0lgdOcSdVnBeC+gWM/QV2KTPMCNpfM1QWQ7uXHoHamfm7Qccp0U9JILVG9Hd+V1s78RbwiVG+Bb+PD9JmAQ272k=  ;
X-YMail-OSG: 3bVFOecVM1kvjr.rNRAB1xj4JsDL7HcBZGAm748MpBXFvaDIepeIPVU7W_Fw8_V.m95xirVcI1LhVe.hW0agPmOXH73FnamXOoiGICDRgnVouIiOcvvcimYBF5aTqql5Jao-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Date: Thu, 31 Jul 2008 16:26:15 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, Eric Munson <ebmunson@us.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net
References: <cover.1216928613.git.ebmunson@us.ibm.com> <200807311604.14349.nickpiggin@yahoo.com.au> <20080730231428.a7bdcfa7.akpm@linux-foundation.org>
In-Reply-To: <20080730231428.a7bdcfa7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311626.15709.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 16:14, Andrew Morton wrote:
> On Thu, 31 Jul 2008 16:04:14 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > > Do we expect that this change will be replicated in other
> > > memory-intensive apps?  (I do).
> >
> > Such as what? It would be nice to see some numbers with some HPC or java
> > or DBMS workload using this. Not that I dispute it will help some cases,
> > but 10% (or 20% for ppc) I guess is getting toward the best case, short
> > of a specifically written TLB thrasher.
>
> I didn't realise the STREAM is using vast amounts of automatic memory.
> I'd assumed that it was using sane amounts of stack, but the stack TLB
> slots were getting zapped by all the heap-memory activity.  Oh well.

An easy mistake to make because that's probabably how STREAM would normally
work. I think what Mel had done is to modify the stream kernel so as to
have it operate on arrays of stack memory.


> I guess that effect is still there, but smaller.

I imagine it should be, unless you're using a CPU with seperate TLBs for
small and huge pages, and your large data set is mapped with huge pages,
in which case you might now introduce *new* TLB contention between the
stack and the dataset :)

Also, interestingly I have actually seen some CPUs whos memory operations
get significantly slower when operating on large pages than small (in the
case when there is full TLB coverage for both sizes). This would make
sense if the CPU only implements a fast L1 TLB for small pages.

So for the vast majority of workloads, where stacks are relatively small
(or slowly changing), and relatively hot, I suspect this could easily have
no benefit at best and slowdowns at worst.

But I'm not saying that as a reason not to merge it -- this is no
different from any other hugepage allocations and as usual they have to be
used selectively where they help.... I just wonder exactly where huge
stacks will help.


> I agree that few real-world apps are likely to see gains of this
> order.  More benchmarks, please :)

Would be nice, if just out of morbid curiosity :)
