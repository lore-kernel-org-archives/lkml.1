Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYIHNtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYIHNtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYIHNsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:48:52 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:46935 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751713AbYIHNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:48:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G7y2a6xmaP+fwOhyC93LaunjRVnAY5Jq7B1uTMCYxt8YE04PY0bpJVlsR5406cK4+zkuQK0wBWC0tzVMmXtGc3tQ+l06e3b0vBIrtNQD36F/KIxdXrNWXqzyS2ahRanK3gt+yjMs+8Ke0I3UbOv38fJITWtZiQ5rjnefdlF/IUU=  ;
X-YMail-OSG: dvxnwCEVM1n3yMFIrCsFONbZC5gAvJDT2wHdZRWyVUze1Bg3Ub4AKeDg6r3UemSFFpvqKbiul6ntnyaTuPrEM_Q0sIJI5PQcrwHyAhjh4r8fP4r9NkyrcZnX0zGGKDlz5Fc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Date: Mon, 8 Sep 2008 23:48:33 +1000
User-Agent: KMail/1.9.5
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20080905215452.GF11692@us.ibm.com> <200809082119.32725.nickpiggin@yahoo.com.au> <20080908113025.GF26079@one.firstfloor.org>
In-Reply-To: <20080908113025.GF26079@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082348.34674.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 21:30, Andi Kleen wrote:
> > Sorry, by "block", I really mean spin I guess. I mean that the CPU will
> > be forced to stop executing due to the page fault during this sequence:
>
> It's hard for NMIs at least. They cannot execute faults.

Well, just for executing code (and reading RO data), then it shouldn't
matter at all actually if the CPU starts executing from the new page
or the old page, so long as there is a way to quiesce NMIs before freeing
the old page.

So the NMI can run, and read data, but it may have a problem with stores.
At least, some kind of redesign of NMI handlers might be required so that
they can make a note of the pending operation and try to do something
sane in that case. Or, there could be a small region of memory; a page or
two, which does not get migrated and NMIs can write to it. I don't think
you need to go so far as saying the entire kernel image must be non
movable just for NMIs.


> In the end you would need to define a core kernel which
> cannot be remapped and the rest which can and you end up
> with even more micro kernel like mess.

Are there any important NMIs that really can't fit with this?


> > ptep_clear_flush(ptep)         <--- from here
> > set_pte(ptep, newpte)          <--- until here
> >
> > for prot RW, the window also would include the memcpy, however if that
> > adds too much latency for execute/reads, then it can be mapped RO first,
> > then memcpy, then flushed and switched.
> >
> > > Then that would be essentially a hypervisor or micro kernel approach.
> >
> > What would be? Blocking in interrupts? Or non-linear kernel mapping in
>
> Well in general someone remapping all the memory beyond you.
> That's essentially a hypervisor in my book.

I don't see it. It is among one of the things a hypervisor may do.
But anyway, call it what you will.
