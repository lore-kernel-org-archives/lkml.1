Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZEXK45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZEXK45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 06:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZEXK4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 06:56:48 -0400
Received: from r00tworld.com ([212.85.137.21]:32997 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZEXK4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 06:56:47 -0400
X-Greylist: delayed 2036 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2009 06:56:47 EDT
From: pageexec@freemail.hu
To: "Larry H." <research@subreption.com>,
       Arjan van de Ven <arjan@infradead.org>
Date: Sun, 24 May 2009 12:19:48 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] Support for unconditional page sanitization
Reply-to: pageexec@freemail.hu
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Message-ID: <4A191F44.24468.2C006647@pageexec.freemail.hu>
In-reply-to: <20090523140509.5b4a59e4@infradead.org>
References: <20090520183045.GB10547@oblivion.subreption.com>, <20090523182141.GK13971@oblivion.subreption.com>, <20090523140509.5b4a59e4@infradead.org>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Sun, 24 May 2009 12:21:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2009 at 14:05, Arjan van de Ven wrote:

> On Sat, 23 May 2009 11:21:41 -0700
> "Larry H." <research@subreption.com> wrote:
> 
> > +static inline void sanitize_highpage(struct page *page)
> 
> any reason we're not reusing clear_highpage() for this?
> (I know it's currently slightly different, but that is fixable)

KM_USER0 users are not supposed to be called from soft/hard irq
contexts for high memory pages, something that cannot be guaranteed
at this low level of page freeing (i.e., we could be interrupting
a clear_highmem and overwrite its KM_USER0 mapping, leaving it dead
in the water when we return there). in other words, sanitization
must be able to nest within KM_USER*, so that pretty much calls for
its own slot.

the alternative is to change KM_USER* semantics and allow its use
from the same contexts as free_page et al., but given the existing
users, that may very well be considered overkill.

on a related note, one could already say that disabling interrupts
during a memset over a page or more is already bad enough for your
real-time response times, so you may want to make this whole change
depend on the kernel's preemption model or at least document it.

> also, have you checked that you stopped clearing the page in the
> normal anonymous memory pagefault handler path? If the page is 
> guaranteed to be clear already you can save that copy
> (basically you move the clear from allocate to free..)

all new page allocations end up in prep_new_page and the clear_highpage
(memset) there depends on !sanitize_all_mem.

