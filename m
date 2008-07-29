Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYG2CAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYG2CAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYG2CAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:00:23 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:37633 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752752AbYG2CAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:00:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ENRWqpLd9BlhbOhZDO1tebJTT611pIBF6ob49PAsG8hLxR9ViXgaW+GLeriysERwTBKFw15JfKojojlMBXh7tFn2q3ppeDKCotcpUmYA78WjXkGcZHQK/pnV5dMMNNxU6m9HYegDJGlQ+e83sdzDI/t+fbyTt8PfOlfg0GBdp3M=  ;
X-YMail-OSG: rnqTbLwVM1nsfU3Yr_p81Q73sob8w3PeGQ4LSrXTw.Q1pE3Txa9TGVVx4BcGVCGOgXJlhHqDCi7XR6JEd9LaKV5mLZjoA5HpXFZ.NpeJQdL.QOHsr0C3MYgdEm7nXmPhALk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jack Steiner <steiner@sgi.com>
Subject: Re: GRU driver feedback
Date: Tue, 29 Jul 2008 12:00:09 +1000
User-Agent: KMail/1.9.5
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080723141229.GB13247@wotan.suse.de> <20080728173605.GB28480@sgi.com>
In-Reply-To: <20080728173605.GB28480@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291200.09907.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 03:36, Jack Steiner wrote:
> I appreciate the thorough review. The GRU is a complicated device. I
> tried to provide comments in the code but I know it is still difficult
> to understand.
>
> You appear to have a pretty good idea of how it works. I've added a
> few new comments to the code to make it clearer in a few cases.

Hi Jack,

Thanks very much for your thorough comments in return. I will take longer
to digest them, but quick reply now because you're probably rushing to
get things merged... So I think you've resolved all my concerns except one.


> > - GRU driver -- gru_intr finds mm to fault pages from, does an "atomic
> > pte lookup" which looks up the pte atomically using similar lockless
> > pagetable walk from get_user_pages_fast. This only works because it can
> > guarantee page table existence by disabling interrupts on the CPU where
> > mm is currently running.  It looks like atomic pte lookup can be run on
> > mms which are not presently running on the local CPU. This would have
> > been noticed if it had been using a specialised function in
> > arch/*/mm/gup.c, because it would not have provided an mm_struct
> > parameter ;)
>
> Existence of the mm is guaranteed thru an indirect path. The  mm
> struct cannot go away until the GRU context that caused the interrupt
> is unloaded.  When the GRU hardware sends an interrupt, it locks the
> context & prevents it from being unloaded until the interrupt is
> serviced.  If the atomic pte is successful, the subsequent TLB dropin
> will unlock the context to allow it to be unloaded. The mm can't go
> away until the context is unloaded.

It is not existence of the mm that I am worried about, but existence
of the page tables. get_user_pages_fast works the way it does on x86
because x86's pagetable shootdown and TLB flushing requires that an
IPI be sent to all running threads of a process before page tables
are freed. So if `current` is one such thread, and wants to do a page
table walk of its own mm, then it can guarantee page table existence
by turning off interrupts (and so blocking the IPI).

This will not work if you are trying to walk down somebody else's
page tables because there is nothing to say the processor you are
running on will get an IPI. This is why get_user_pages_fast can not
work if task != current or mm != current->mm.

So I think there is still a problem.
