Return-Path: <linux-kernel-owner+w=401wt.eu-S964806AbXCSUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbXCSUoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964839AbXCSUoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:44:38 -0400
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:29588 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964806AbXCSUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:44:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BFYlQJrQgjz+KrvQOztNV6kl5Fz39UL7X6RINKYDMNwdZclR/TXFtVYGHk9MJjOArGsKcKt6UbbEaW0FC4r7eGj3IK8d/bJyOaqYJTiokrjXdTr/R1DOXVE4GB8IenrvotdB99xhzISdG/wE4UzYIKMG55ovX2ar2578pxPUNBA=  ;
X-YMail-OSG: l2YSnTMVM1kK8050QCnCw9cbEknbcO77W3TJ.WZz_o1WWj.tneJrSsCgmsEShwmK.G_gED3WznYfQLLD5exEEHye_4aryrCIhQybI_ulLfEhufUuCrc-
From: Blaisorblade <blaisorblade@yahoo.it>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Date: Mon, 19 Mar 2007 21:44:28 +0100
User-Agent: KMail/1.9.5
Cc: Bill Irwin <bill.irwin@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070221023735.6306.83373.sendpatchset@linux.site> <200703171317.01074.blaisorblade@yahoo.it> <20070318025010.GA1671@wotan.suse.de>
In-Reply-To: <20070318025010.GA1671@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703192144.28969.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 March 2007 03:50, Nick Piggin wrote:
> On Sat, Mar 17, 2007 at 01:17:00PM +0100, Blaisorblade wrote:
> > On Tuesday 13 March 2007 02:19, Nick Piggin wrote:
> > > On Tue, Mar 13, 2007 at 12:01:13AM +0100, Blaisorblade wrote:
> > > > On Wednesday 07 March 2007 11:02, Nick Piggin wrote:
> > > > > > Yeah, tmpfs/shm segs are what I was thinking about. If UML can
> > > > > > live with that as well, then I think it might be a good option.
> > > > >
> > > > > Oh, hmm.... if you can truncate these things then you still need to
> > > > > force unmap so you still need i_mmap_nonlinear.
> > > >
> > > > Well, we don't need truncate(), but MADV_REMOVE for memory hotunplug,
> > > > which is way similar I guess.
> > > >
> > > > About the restriction to tmpfs, I have just discovered
> > > > '[PATCH] mm: tracking shared dirty pages' (commit
> > > > d08b3851da41d0ee60851f2c75b118e1f7a5fc89), which already partially
> > > > conflicts with remap_file_pages for file-based mmaps (and that's
> > > > fully fine, for now).
> > > >
> > > > Even if UML does not need it, till now if there is a VMA protection
> > > > and a page hasn't been remapped with remap_file_pages, the VMA
> > > > protection is used (just because it makes sense).
> > > >
> > > > However, it is only used when the PTE is first created - we can never
> > > > change protections on a VMA  - so it vma_wants_writenotify() is true
> > > > (on all file-based and on no shmfs based mapping, right?), and we
> > > > write-protect the VMA, it will always be write-protected.
> > >
> > > Yes, I believe that is the case, however I wonder if that is going to
> > > be a problem for you to distinguish between write faults for clean
> > > writable ptes, and write faults for readonly ptes?
> >
> > I wouldn't be able to distinguish them, but am I going to get write
> > faults for clean ptes when vma_wants_writenotify() is false (as seems to
> > be for tmpfs)? I guess not.
> >
> > For tmpfs pages, clean writable PTEs are mapped as writable so they won't
> > give any problem, since vma_wants_writenotify() is false for tmpfs.
> > Correct?
>
> Yes, that should be the case. So would this mean that nonlinear protections
> don't work on regular files?

They still work in most cases (including for UML), but if the initial mmap() 
specified PROT_WRITE, that is ignored, for pages which are not remapped via 
remap_file_pages(). UML uses PROT_NONE for the initial mmap, so that's no 
problem.

> I guess that's OK if Oracle and UML both use 
> tmpfs/shm?

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
