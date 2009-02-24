Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZBXPbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZBXPbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZBXPaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:30:55 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:37839 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752134AbZBXPay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:30:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ra8RwkZASABDkhAHJeJsYuL9zYuiAraRvgZtGocSeltsFyEEXoEpgzKw9MkVCXIIR/sVpU+PNQtQrt6n+laaHZl+34EXCh5jmR+E9/Qqk3vTIGujQfLBjbwN0RQnHhTUc4P4ykNGxIOiAUVK3d4OZL1bD2M9zmHrOKJ2PqZs3tY=  ;
X-YMail-OSG: geNihRoVM1n6RZwxR18zJxxzm_5h7VGED1CWVO4rrwSZegTzgaajZxilBy0621A7zEG2HkFwb7OipInn9xS47ZX9w.1KkJvK3icnS5r6S5uvLU6ctsHo.mOZM95fbl7rWE1VeDzBEbTmmpNBCVrBtVZG05c.U_SetumwJg4SmfwGV4OTE1uLij3NcGUfW0Rb6PMKTQtO44yxPYYfaCmTx0Dfte8G6yiR
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk allocation
Date: Wed, 25 Feb 2009 02:30:17 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Tejun Heo <tj@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, ink@jurassic.park.msu.ru
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <49A4087B.8080405@kernel.org> <20090224151920.GB12438@elte.hu>
In-Reply-To: <20090224151920.GB12438@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902250230.18703.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 02:19:20 Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> > Hi,
> >
> > Ingo Molnar wrote:
> > --snip--
> >
> > > So what i'm saying is that these are strong reasons for us to
> > > want to make the unit size to be something like 2MB - on 64-bit
> > > x86 at least.
> > >
> > > ( Using a 2MB unit size will also have another advantage: _iff_
> > >   we can still allocate a hugepage at that point we can map it
> > >   straight there when extending the dynamic area. )
> >
> > Thanks for the explanation.  Yeap, it would be nice to have
> > units aligned on 2MB boundary.  We'll need to add @align to vm
> > area alloc function to do it correctly.  As for using large
> > page, it would be nice if we can do that automatically.
> > Upfront 2MB unit allocation is probably too expensive but
> > merging 4k pages into a large page (if we can get them) will
> > add a lot of irregular latency too.  Hmmm...
>
> Yeah, largepage support - if we ever get there (the chances of
> finding a proper 2MB aligned 2MB sized chunk of physical memory
> are not very good except the first few minutes of uptime),
> should indeed be automatic to all get_vm_area() users -
> vmalloc(), ioremap() and now percpu.c.

The problem is that it doesn't always know what the callers want.
It would be trivial (there is already support in the virtual
address allocator) to specify alignment. Then kernel page table
setup could presumably use larger size mappings if it is given
contiguous memory.


> I think a far more realistic angle to utilize more of the 2MB
> TLB will be to gradually increase PERCPU_ENOUGH_ROOM, as we
> observe more and more percpu_alloc() sites in the kernel. Right
> now it's pretty rare so going beyond the 8K we do for modules
> would probably be a waste of RAM.

It might possibly be useful for smaller NUMA machines using
hashdist for the big early hashes (hash sizes scale log, but
number of nodes tends to scale linearly with memory size, so
2MB per node for hashes would probably be far too much on big
machines).

