Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbZEAC77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbZEAC77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbZEAC7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:59:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756083AbZEAC7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:59:49 -0400
Date: Thu, 30 Apr 2009 19:54:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: elladan@eskimo.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       tytso@mit.edu, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
Message-Id: <20090430195439.e02edc26.akpm@linux-foundation.org>
In-Reply-To: <20090430215034.4748e615@riellaptop.surriel.com>
References: <20090428044426.GA5035@eskimo.com>
	<20090428192907.556f3a34@bree.surriel.com>
	<1240987349.4512.18.camel@laptop>
	<20090429114708.66114c03@cuia.bos.redhat.com>
	<20090430072057.GA4663@eskimo.com>
	<20090430174536.d0f438dd.akpm@linux-foundation.org>
	<20090430205936.0f8b29fc@riellaptop.surriel.com>
	<20090430181340.6f07421d.akpm@linux-foundation.org>
	<20090430215034.4748e615@riellaptop.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 21:50:34 -0400 Rik van Riel <riel@redhat.com> wrote:

> > Which would cause exactly the problem Elladan saw?
> 
> Yes.  It was not noticable in the initial split LRU code,
> but after we decided to ignore the referenced bit on active
> file pages and deactivate pages regardless, it has gotten
> exacerbated.
> 
> That change was very good for scalability, so we should not
> undo it.  However, we do need to put something in place to
> protect the working set from streaming IO.
> 
> > > Currently the kernel has no effective code to protect the 
> > > page cache working set from streaming IO.  Elladan's bug
> > > report shows that we do need some kind of protection...
> > 
> > Seems to me that reclaim should treat swapcache-backed mapped mages in
> > a similar fashion to file-backed mapped pages?
> 
> Swapcache-backed pages are not on the same set of LRUs as
> file-backed mapped pages.

yup.

> Furthermore, there is no streaming IO on the anon LRUs like
> there is on the file LRUs. Only the file LRUs need (and want)
> use-once replacement, which means that we only need special
> protection of the working set for file-backed pages.

OK.

> When we implement working set protection, we might as well
> do it for frequently accessed unmapped pages too.  There is
> no reason to restrict this protection to mapped pages.

Well.  Except for empirical observation, which tells us that biasing
reclaim to prefer to retain mapped memory produces a better result.

