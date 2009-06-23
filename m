Return-Path: <linux-kernel-owner+w=401wt.eu-S1759710AbZFWNiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710AbZFWNiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758963AbZFWNiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:38:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbZFWNiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:38:17 -0400
Subject: Re: mm: dirty page problem
From: Peter Zijlstra <peterz@infradead.org>
To: xue yong <ultraice.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fc71709d0906230632qefb072bj5ea7597b20972aa3@mail.gmail.com>
References: <fc71709d0906230117h2bee4d7en9f3aadeae3cb9545@mail.gmail.com>
	 <fc71709d0906230202w14da8ffdpf457f7a6ed658a28@mail.gmail.com>
	 <1245753219.19816.1586.camel@twins>
	 <fc71709d0906230443pf8c4b34pcd4b7fa798fbf1ed@mail.gmail.com>
	 <1245757970.19816.1675.camel@twins>
	 <fc71709d0906230632qefb072bj5ea7597b20972aa3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Jun 2009 15:38:22 +0200
Message-Id: <1245764302.19816.1800.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 21:32 +0800, xue yong wrote:
> On Tue, Jun 23, 2009 at 7:52 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> > On Tue, 2009-06-23 at 19:43 +0800, xue yong wrote:
> >> Thanks a lot, Peter.
> >> Your reply resolved my doubt.
> >>
> >> we have a service program (just say A) running with about 14G mmaped data.
> >> and there is another daemon (just say B) do msync( SYNC) periodically.
> >>
> >> so I want to know in this pattern, was the data flushed to disk?
> >
> > I don't think so.
> >
> > The problem is that msync() only scans the current process' page tables,
> > which would be clean since B doesn't write, only A does.
> >
> > So you'd have to modify your program, A, to do the msync() itself --
> > possibly from a thread (threads share the vm context and thus page
> > tables).
> >
> 
> 
> :)  I did have this thought, because there was littile bo(block out),
> and pmap showed that
> the dirty pages belong to a process was always growing.
> 
> I believe you are the authority. Your confirmation matters.

I'm one of the people who knows this code rather well, yes ;-)

> In "Understanding the Linux® Virtual Memory Manager" page 163, Mel
> Gorman said that
> Process-mapped pages are not easily swappable because there is no
> way to map struct pages to PTEs except to search every page table, which is far
> too expensive.
> So  neither kswapd nor other kernel daemons do the scan job.
> Without explicit action these pages would stay hidden.

While a great book to learn some of the basics from, it is severely
out-dated. I think in his 2.6 chapter he does mention something about
reverse map, or rmap as its called.

These days we do keep a data structure whereby it is easier to find all
ptes for a particular mapping (mm/rmap.c).

In particular try_to_unmap() is the routine used to remove all ptes in
order to swap a page.


