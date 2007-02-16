Return-Path: <linux-kernel-owner+w=401wt.eu-S966166AbXBPHuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966166AbXBPHuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966167AbXBPHuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:50:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58178 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966166AbXBPHuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:50:40 -0500
Date: Thu, 15 Feb 2007 23:49:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
Message-Id: <20070215234904.f3fbcdf0.akpm@linux-foundation.org>
In-Reply-To: <45D55DB1.7040002@goop.org>
References: <20070216022449.739760547@goop.org>
	<20070216022531.417300365@goop.org>
	<20070215224322.5c73d8e9.akpm@linux-foundation.org>
	<45D55852.9000103@goop.org>
	<20070215232447.5ee67f50.akpm@linux-foundation.org>
	<45D55DB1.7040002@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 23:30:57 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > If you really need to run atomically, that gets ugly.  Even of one were to
> > run handle_mm_fault() by hand, it still needs to allocate memory.
> >
> > Two ugly options might be:
> >
> > a) touch all the pages, then go atomic, then touch them all again.  If
> >    one of them faults (ie: you raced with swapout) then go back and try
> >    again.  Obviously susceptible to livelocking.
> >
> > b) Do get_user_pages() against all the pages, then go atomic, then do
> >    put_page() against them all.  Of course, they can immediately get
> >    swapped out.
> >
> > But that function's already racy against swapout and I guess it works OK. 
> > I don't have clue what it is actually trying to do, so I'm guessing madly
> > here.
> >   
> 
> It's for populating the pagetable in a vmalloc area.  There's magic in
> the fault handler to synchronize the vmalloc mappings between different
> process's kernel mappings, so if the mapping isn't currently present, it
> will fault and create the appropriate mapping.  It's not operating on
> swappable user memory, so swapping isn't an issue; but if the fault
> handler exits immediately with preempt disabled, then there's a problem.
> 

oh, I see.  The vmalloc fault can run atomically.  In fact it can run at
hard iRQ.  So no probs (apart from the fact that it required an email
dialogue to work this out rather than reading the code, but I do go on).

