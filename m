Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbXCUTqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbXCUTqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCUTqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:46:09 -0400
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:41797 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933883AbXCUTqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:46:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A8d1S7lnCTXIn0MfXWPXHiYrliG1TggsQvWDWBUDPnW3qOrx+SYDe55M/Tn88VwJ7RdDHxzNDhIACGO8xw0MnQ63EmtmVTfIZ3xaIEZKjO06vFBQEEp9r1m9LXbgXa5FuNnhfAhsOCaq8t8OphL9iM0z/y1sVfsGqf8fsTw79Gk=  ;
X-YMail-OSG: XcCGOvAVM1l.1yRdf0CTPC60vHYIli4Tn_Osm5P0ZEQ2.whzXua67YAdxX.1T6Gr9ieOEnaw3b23E8TIPYq6MhQUDRtQmTLuX4k7aRx0zyvxmgKcNJLfmFZWWoF9H17DSKrdeyn8fGJ2
From: Blaisorblade <blaisorblade@yahoo.it>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Date: Wed, 21 Mar 2007 20:45:57 +0100
User-Agent: KMail/1.9.5
Cc: Bill Irwin <bill.irwin@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070221023735.6306.83373.sendpatchset@linux.site> <200703192144.28969.blaisorblade@yahoo.it> <20070320060017.GA21978@wotan.suse.de>
In-Reply-To: <20070320060017.GA21978@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703212045.57634.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2007 07:00, Nick Piggin wrote:
> On Mon, Mar 19, 2007 at 09:44:28PM +0100, Blaisorblade wrote:
> > On Sunday 18 March 2007 03:50, Nick Piggin wrote:
> > > > > Yes, I believe that is the case, however I wonder if that is going
> > > > > to be a problem for you to distinguish between write faults for
> > > > > clean writable ptes, and write faults for readonly ptes?

> > > > I wouldn't be able to distinguish them, but am I going to get write
> > > > faults for clean ptes when vma_wants_writenotify() is false (as seems
> > > > to be for tmpfs)? I guess not.

> > > > For tmpfs pages, clean writable PTEs are mapped as writable so they
> > > > won't give any problem, since vma_wants_writenotify() is false for
> > > > tmpfs. Correct?

> > > Yes, that should be the case. So would this mean that nonlinear
> > > protections don't work on regular files?

> > They still work in most cases (including for UML), but if the initial
> > mmap() specified PROT_WRITE, that is ignored, for pages which are not
> > remapped via remap_file_pages(). UML uses PROT_NONE for the initial mmap,
> > so that's no problem.

> But how are you going to distinguish a write fault on a readonly pte for
> dirty page accounting vs a read-only nonlinear protection?

Hmm... I was only thinking to PTEs which hadn't been remapped via 
remap_file_pages, but just faulted in with initial mmap() protection.

For the other PTEs, however, I overlooked that the current code ignores 
vma_wants_writenotify(), i.e. breaks dirty page accounting for them, and I 
refused to even consider this opportunity, even without knowing the purposes 
of dirty pages accounting (I found the commits explaining this however).

> You can't store any more data in a present pte AFAIK, so you'd have to
> have some out of band data. At which point, you may as well just forget
> about vma_wants_writenotify vmas, considering that everybody is using
> shmem/ramfs.

I was going to do that anyway. I'd guess that I should just disallow in 
remap_file_pages() the VM_MANYPROTS (i.e. MAP_CHGPROT in flags) && 
vma_wants_writenotify() combination, right? Ok, trivial (shouldn't even have 
pointed this out).
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
