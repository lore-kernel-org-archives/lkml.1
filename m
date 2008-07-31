Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYGaHDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYGaHDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYGaHDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbYGaHDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:03:17 -0400
Date: Thu, 31 Jul 2008 00:02:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Adrian Bunk <bunk@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Message-Id: <20080731000257.59830c25.akpm@linux-foundation.org>
In-Reply-To: <48915F2F.4020407@qumranet.com>
References: <200807301438.55941.rusty@rustcorp.com.au>
	<20080730033523.0f38f7e4.akpm@linux-foundation.org>
	<20080730154736.GC21597@cs181140183.pp.htv.fi>
	<20080730100355.f1402dcf.akpm@linux-foundation.org>
	<20080730170939.GA28604@cs181140183.pp.htv.fi>
	<20080730101438.e1484440.akpm@linux-foundation.org>
	<4890A375.4060103@qumranet.com>
	<20080730102928.6216d234.akpm@linux-foundation.org>
	<48915F2F.4020407@qumranet.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 09:43:59 +0300 Avi Kivity <avi@qumranet.com> wrote:

> > #ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
> > /*
> >  * get_user_pages_fast provides equivalent functionality to get_user_pages,
> >  * operating on current and current->mm (force=0 and doesn't return any vmas).
> >  *
> >  * get_user_pages_fast may take mmap_sem and page tables, so no assumptions
> >  * can be made about locking. get_user_pages_fast is to be implemented in a
> >  * way that is advantageous (vs get_user_pages()) when the user memory area is
> >  * already faulted in and present in ptes. However if the pages have to be
> >  * faulted in, it may turn out to be slightly slower).
> >  */
> > int get_user_pages_fast(unsigned long start, int nr_pages, int write,
> > 			struct page **pages);
> >
> > #else
> > /*
> >  * Should probably be moved to asm-generic, and architectures can include it if
> >  * they don't implement their own get_user_pages_fast.
> >  */
> > #define get_user_pages_fast(start, nr_pages, write, pages)	\
> > ({								\
> > 	struct mm_struct *mm = current->mm;			\
> > 	int ret;						\
> > 								\
> > 	down_read(&mm->mmap_sem);				\
> > 	ret = get_user_pages(current, mm, start, nr_pages,	\
> > 					write, 0, pages, NULL);	\
> > 	up_read(&mm->mmap_sem);					\
> > 								\
> > 	ret;							\
> > })
> > #endif
> >
> >   
> 
> Surprised.  Why not an out-of-line function?  Would eliminate the 
> present discussion as well.

Excellent question!
