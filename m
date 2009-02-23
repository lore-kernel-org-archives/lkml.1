Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZBWEOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZBWEOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZBWEOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:14:37 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:21787 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751630AbZBWEOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:14:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ujYqv2Erj9UIAX9ySfwamLFHNo6cTBSkDhrNCShe4FieVoOVnxdBK9o7aj8MS13ZLMgyd5chGXncs/ihbS/ABcspnra/4vqCeAOGEDAfWVifN4cX7a4IcB6CdeLn3gjGU88aIg6m0MHUA5UUPqP2fDmhOsdmtqxKTHHsgJ+RdEI=  ;
X-YMail-OSG: LTSyH5AVM1njja9CuCT.G2F1WYZMYJeMuHbsWcC2IEpjs514mJ557ZjFBTujeyy4S3wyADub_VViN.HyO2XAOIS3YGUhPCcLKr2QLo.eUesKMAxmcKw3APCe3HKcTjPuR8TY7qPsaJfPEkqXQ6U1fvGeDoiGa2PcYWksMqqxo09chiSfViwy0JnJ92OIHg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
Date: Mon, 23 Feb 2009 15:14:00 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <49416494.6040009@goop.org> <200902200441.08541.nickpiggin@yahoo.com.au> <499DAEE4.8010507@goop.org>
In-Reply-To: <499DAEE4.8010507@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231514.01965.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 06:11:32 Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Then what is the point of the vm_unmap_aliases? If you are doing it
> > for security it won't work because other CPUs might still be able
> > to write through dangling TLBs. If you are not doing it for
> > security then it does not need to be done at all.
>
> Xen will make sure any danging tlb entries are flushed before handing
> the page out to anyone else.
>
> > Unless it is something strange that Xen does with the page table
> > structure and you just need to get rid of those?
>
> Yeah.  A pte pointing at a page holds a reference on it, saying that it
> belongs to the domain.  You can't return it to Xen until the refcount is 0.

OK. Then I will remember to find some time to get the interrupt
safe patches working. I wonder why you can't just return it to
Xen when (or have Xen hold it somewhere until) the refcount
reaches 0?

Anyway...

> > Or... what if we just allow a compile and/or boot time flag to direct
> > that it does not want lazy vmap unmapping and it will just revert to
> > synchronous unmapping? If Xen needs lots of flushing anyway it might
> > not be a win anyway.
>
> That may be worth considering.

... in the meantime, shall we just do this for Xen? It is probably
safer and may end up with no worse performance on Xen anyway. If
we get more vmap users and it becomes important, you could look at
more sophisticated ways of doing this. Eg. a page could be flagged
if it potentially has lazy vmaps.

