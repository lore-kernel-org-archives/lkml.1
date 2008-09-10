Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYIJQz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYIJQz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYIJQzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:55:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40510 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYIJQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:55:45 -0400
Subject: Re: [RFC v4][PATCH 4/9] Memory management (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:55:28 -0700
Message-Id: <1221065728.6781.19.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
> +       while (addr < end) {
> +               struct page *page;
> +
> +               /*
> +                * simplified version of get_user_pages(): already have vma,
> +                * only need FOLL_TOUCH, and (for now) ignore fault stats.
> +                *
> +                * FIXME: consolidate with get_user_pages()
> +                */
> +
> +               cond_resched();
> +               while (!(page = follow_page(vma, addr, FOLL_TOUCH))) {
> +                       ret = handle_mm_fault(vma->vm_mm, vma, addr, 0);
> +                       if (ret & VM_FAULT_ERROR) {
> +                               if (ret & VM_FAULT_OOM)
> +                                       ret = -ENOMEM;
> +                               else if (ret & VM_FAULT_SIGBUS)
> +                                       ret = -EFAULT;
> +                               else
> +                                       BUG();
> +                               break;
> +                       }
> +                       cond_resched();
> +                       ret = 0;
> +               }

get_user_pages() is really the wrong thing to use here.  It makes pages
*present* so that we can do things like hand them off to a driver.  For
checkpointing, we really don't care about that.  It's a waste of time,
for instance to perform faults to fill the mappings up with zero pages
and page tables.  Just think of what will happen the first time we touch
a very large, very sparse anonymous area.  We'll probably kill the
system just allocating page tables.  Take a look at the comment in
follow_page().  This is a similar operation to core dumping, and we need
to be careful.

This might be fine for a proof of concept, but it needs to be thought
out much more thoroughly before getting merged.  I guess I'm
volunteering to go do that.

-- Dave

