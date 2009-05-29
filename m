Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbZE2W7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbZE2W7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 18:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZE2W7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 18:59:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbZE2W7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 18:59:37 -0400
Date: Fri, 29 May 2009 15:58:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Larry H." <research@subreption.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org, mingo@redhat.com,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-Id: <20090529155859.2cf20823.akpm@linux-foundation.org>
In-Reply-To: <20090520212413.GF10756@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<1242852158.6582.231.camel@laptop>
	<20090520212413.GF10756@oblivion.subreption.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 14:24:13 -0700
"Larry H." <research@subreption.com> wrote:

> Your
> approach means forcing all developers to remember where they have to
> place this explicit clearing, and introducing unnecessary code
> duplication and an ever growing list of places adding these calls.

And your proposed approach requires that developers remember to use
GFP_SENSITIVE at allocation time.  In well-implemented code, there is a
single memory-freeing site, so there's really no difference here.

Other problems I see with the patch are:

- Adds a test-n-branch to all page-freeing operations.  Ouch.  The
  current approach avoids that cost.

- Fails to handle kmalloc()'ed memory.  Fixing this will probably
  require adding a test-n-branch to kmem_cache_alloc().  Ouch * N.

- Once kmalloc() is fixed, the page-allocator changes and
  GFP_SENSITIVE itself can perhaps go away - I expect that little
  security-sensitive memory is allocated direct from the page
  allocator.  Most callsites are probably using
  kmalloc()/kmem_cache_alloc() (might be wrong).

  If not wrong then we end up with a single requirement: zap the
  memory in kmem_cache_free().

  But how to do that?  Particular callsites don't get to alter
  kfree()'s behaviour.  So they'd need to use a new kfree_sensitive(). 
  Which is just syntactic sugar around the code whihc we presently
  implement.

