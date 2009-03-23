Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZCWJx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZCWJx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZCWJxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:53:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54249 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbZCWJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:53:50 -0400
Date: Mon, 23 Mar 2009 09:53:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 04/13] fsnotify: add in inode fsnotify markings
Message-ID: <20090323095347.GO28946@ZenIV.linux.org.uk>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com> <20090319180514.17449.34794.stgit@paris.rdu.redhat.com> <20090323092830.GN28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323092830.GN28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 09:28:30AM +0000, Al Viro wrote:
> Note that for inotify ->freeing_mark() will happily add notification to
> group's queue and that's another race of the same nature - even if
> group itself isn't yet freed, that final put_group() might bloody well
> get past flushing the queue.
> 
> I really don't like the idea of having marks contributing to group refcount -
> that would have solved this one, but we'd get potential leaks from hell ;-/
> Maybe a separate counter controlling only actual freeing of group?

Actually, let's make it
	number of entries with this ->group +
	1 if group is not past the eviction of marks in destroy_group
Then destroy_group would evict marks, decrement that sucker and if it's 0 -
call rest_of_destroy_group().  And destroy_mark_by_entry() would
do the same decrement-and-call-if-0.  With everything starting at queue
flush done in rest_of_destroy_group().

AFAICS, that would work without creating leaks.  Comments?
