Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbZCWJ2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbZCWJ2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZCWJ2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:28:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36979 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZCWJ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:28:35 -0400
Date: Mon, 23 Mar 2009 09:28:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 04/13] fsnotify: add in inode fsnotify markings
Message-ID: <20090323092830.GN28946@ZenIV.linux.org.uk>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com> <20090319180514.17449.34794.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319180514.17449.34794.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 02:05:14PM -0400, Eric Paris wrote:
> This patch creates in inode fsnotify markings.  dnotify will make use of in
> inode markings to mark which inodes it wishes to send events for.  fanotify
> will use this to mark which inodes it does not wish to send events for.

Hrm...  What happens if fsnotify_clear_marks_by_inode() is called, gets
the only mark we had for a group, removes it from all lists, drops all
locks and races with the final fsnotify_put_group()?  Said put_group
sees nothing whatsoever on the per-group mark list (the only mark we
used to have there is already evicted) and the group is cheerfully
freed.  Then fsnotify_destroy_mark_by_entry() calls
	group->ops->freeing_mark(entry, group)
with group already freed...  Gets really interesting in case of inotify -
there ->freeing_mark() leads to blocking allocations and really touches
group in non-trivial ways.

Note that for inotify ->freeing_mark() will happily add notification to
group's queue and that's another race of the same nature - even if
group itself isn't yet freed, that final put_group() might bloody well
get past flushing the queue.

I really don't like the idea of having marks contributing to group refcount -
that would have solved this one, but we'd get potential leaks from hell ;-/
Maybe a separate counter controlling only actual freeing of group?
