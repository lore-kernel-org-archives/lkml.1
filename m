Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXCLXB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXCLXB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXCLXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:01:27 -0400
Received: from smtp006.mail.ukl.yahoo.com ([217.12.11.95]:32155 "HELO
	smtp006.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752083AbXCLXBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:01:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Gg/OWZSPXnO2jLt5hd4lBWWLW4vvTGLK1mkNcqq1PrnISYRmMspklAE82bCPKC2I6Xsgp8FqWKEFtlpFS0uR5NCOEqI6/lBy86hXnY9DocSh5/leSyuWltBiLqkPmN5F1x2DUzX3bizVVzwKfhWrm8mGedHVhN/p4Hx8eG/7PxE=  ;
X-YMail-OSG: 5hUs33MVM1kqnmOYKhEiLp0sasTBVg1YiYMKRgq6fIJ9SGIAIUtHALH_.c9VDgPshueEhjZwxHz8.2Dixp2h0o8GFiYmf89SRF4Yun6ogwJJkCyEt4qDrGWPK6izK0Eu6SNrkHVUfL9I
From: Blaisorblade <blaisorblade@yahoo.it>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Date: Tue, 13 Mar 2007 00:01:13 +0100
User-Agent: KMail/1.9.5
Cc: Bill Irwin <bill.irwin@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070221023735.6306.83373.sendpatchset@linux.site> <20070307094947.GE8609@wotan.suse.de> <20070307100242.GG8609@wotan.suse.de>
In-Reply-To: <20070307100242.GG8609@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130001.13467.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 11:02, Nick Piggin wrote:
> On Wed, Mar 07, 2007 at 10:49:47AM +0100, Nick Piggin wrote:
> > On Wed, Mar 07, 2007 at 01:44:20AM -0800, Bill Irwin wrote:
> > > On Wed, Mar 07, 2007 at 10:28:21AM +0100, Nick Piggin wrote:
> > > > Depending on whether anyone wants it, and what features they want, we
> > > > could emulate the old syscall, and make a new restricted one which is
> > > > much less intrusive.
> > > > For example, if we can operate only on MAP_ANONYMOUS memory and
> > > > specify that nonlinear mappings effectively mlock the pages, then we
> > > > can get rid of all the objrmap and unmap_mapping_range handling,
> > > > forget about the writeout and msync problems...
> > >
> > > Anonymous-only would make it a doorstop for Oracle, since its entire
> > > motive for using it is to window into objects larger than user virtual
> >
> > Uh, duh yes I don't mean MAP_ANONYMOUS, I was just thinking of the shmem
> > inode that sits behind MAP_ANONYMOUS|MAP_SHARED. Of course if you don't
> > have a file descriptor to get a pgoff, then remap_file_pages is a
> > doorstop for everyone ;)
> >
> > > address spaces (this likely also applies to UML, though they should
> > > really chime in to confirm). Restrictions to tmpfs and/or ramfs would
> > > likely be liveable, though I suspect some things might want to do it to
> > > shm segments (I'll ask about that one). There's definitely no need for
> > > a persistent backing store for the object to be remapped in Oracle's
> > > case, in any event. It's largely the in-core destination and source of
> > > IO, not something saved on-disk itself.
> >
> > Yeah, tmpfs/shm segs are what I was thinking about. If UML can live with
> > that as well, then I think it might be a good option.
>
> Oh, hmm.... if you can truncate these things then you still need to
> force unmap so you still need i_mmap_nonlinear.

Well, we don't need truncate(), but MADV_REMOVE for memory hotunplug, which is 
way similar I guess.

About the restriction to tmpfs, I have just discovered 
'[PATCH] mm: tracking shared dirty pages' (commit 
d08b3851da41d0ee60851f2c75b118e1f7a5fc89), which already partially conflicts 
with remap_file_pages for file-based mmaps (and that's fully fine, for now).

Even if UML does not need it, till now if there is a VMA protection and a page 
hasn't been remapped with remap_file_pages, the VMA protection is used (just 
because it makes sense).

However, it is only used when the PTE is first created - we can never change 
protections on a VMA  - so it vma_wants_writenotify() is true (on all 
file-based and on no shmfs based mapping, right?), and we write-protect the 
VMA, it will always be write-protected.

That's no problem for UML, but for any other user (I guess I'll have to 
prevent callers from trying such stuff - I started from a pretty generic 
patch).

> But come to think of it, I still don't think nonlinear mappings are
> too bad as they are ;)

Btw, I really like removing ->populate and merging the common code together. 
filemap_populate and shmem_populate are so obnoxiously different that I 
already wanted to do that (after merging remap_file_pages() core).

Also, I'm curious. Since my patches are already changing remap_file_pages() 
code, should they be absolutely merged after yours?
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
