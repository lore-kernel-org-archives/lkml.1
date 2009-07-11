Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZGKKRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZGKKRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 06:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZGKKRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 06:17:03 -0400
Received: from www.tglx.de ([62.245.132.106]:38404 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZGKKRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 06:17:02 -0400
Date: Sat, 11 Jul 2009 12:14:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Sonny Rao <sonnyrao@us.ibm.com>, tglx@linuxtronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       stable@kernel.org, anton@samba.org, rajamony@us.ibm.com,
       speight@us.ibm.com, mstephen@us.ibm.com, grimm@us.ibm.com,
       mikey@ozlabs.au.ibm.com
Subject: Re: [PATCH] futexs: fix infinite loop in get_futex_key on huge
 page
In-Reply-To: <20090711081924.GA10437@elte.hu>
Message-ID: <alpine.LFD.2.00.0907111214200.2768@localhost.localdomain>
References: <20090710231313.GA23572@us.ibm.com> <20090711081924.GA10437@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Ingo Molnar wrote:
> 
> * Sonny Rao <sonnyrao@us.ibm.com> wrote:
> 
> > get_futex_key() can infinitely loop if it is called on a virtual 
> > address that is within a huge page but not aligned to the 
> > beginning of that page.  The call to get_user_pages_fast will 
> > return the struct page for a sub-page within the huge page and the 
> > check for page->mapping will always fail.
> > 
> > The fix is to call compound_head on the page before checking that 
> > it's mapped.
> > 
> > Signed-off-by: Sonny Rao <sonnyrao@us.ibm.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: stable@kernel.org
> > 
> > Index: linux-2.6.31-rc2/kernel/futex.c
> > ===================================================================
> > --- linux-2.6.31-rc2.orig/kernel/futex.c	2009-07-10 17:45:46.181084475 -0500
> > +++ linux-2.6.31-rc2/kernel/futex.c	2009-07-10 17:46:47.345084062 -0500
> > @@ -247,6 +247,7 @@
> >  	if (err < 0)
> >  		return err;
> >  
> > +	page = compound_head(page);
> >  	lock_page(page);
> >  	if (!page->mapping) {
> >  		unlock_page(page);
> 
> Nice catch! Applied it to tip:core/urgent - Thomas, do you agree 
> with the fix?

Acked-by-me.
