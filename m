Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZGVT1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZGVT1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZGVT1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:27:50 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:28135 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZGVT1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:27:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFsFZ0qrR7PE/2dsb2JhbAC6O4glkQAFhA4
X-IronPort-AV: E=Sophos;i="4.43,248,1246838400"; 
   d="scan'208";a="87112172"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [PATCH/RFC] ummunot: Userspace support for MMU notifications
References: <ada3a8oobis.fsf@cisco.com>
	<20090722111538.58a126e3.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 22 Jul 2009 12:27:42 -0700
In-Reply-To: <20090722111538.58a126e3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 22 Jul 2009 11:15:38 -0700")
Message-ID: <adad47smsb5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jul 2009 19:27:46.0264 (UTC) FILETIME=[7DD82D80:01CA0B02]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
 > > and follow-up messages, libraries using RDMA would like to track
 > > precisely when application code changes memory mapping via free(),
 > > munmap(), etc.
 > 
 > It isn't "precisely" - the tracker has a delayed view of the trackee,
 > of course.  Only really solvable by blocking the trackee each time it
 > does something.
 > 
 > The time-skew makes the facility considerably weaker.  Obviously this
 > is OK for your application but it's a fairly important design point
 > which it would be interesting to hear about.

Fair enough.  Of course as you say "precise" is impossible if we have
multiple threads running on multiple CPUs without synchronization
between them.  As you alluded to, for the specific use that inspired
this, it would be a bug in the userspace code for any changes to occur
at the moment that the library cares about things.

 > >  1. ioctl() to register/unregister an address range to watch in the
 > >     kernel (cf struct ummunot_register_ioctl in <linux/ummunot.h>).
 > > 
 > >  2. read() to retrieve events generated when a mapping in a watched
 > >     address range is invalidated (cf struct ummunot_event in
 > >     <linux/ummunot.h>).  select()/poll()/epoll() and SIGIO are handled
 > >     for this IO.
 > > 
 > >  3. mmap() one page at offset 0 to map a kernel page that contains a
 > >     generation counter that is incremented each time an event is
 > >     generated.  This allows userspace to have a fast path that checks
 > >     that no events have occurred without a system call.
 > 
 > If you stand back and squint, each of 1, 2 and 3 are things which the
 > kernel already provides for the delivery of ftrace events to userspace.
 > 
 > Did you look at reusing all that stuff?

No, not really... will investigate a bit further.  Any pointers to how
the ftrace stuff might work?  Specifically how #3 maps to ftrace is a
little obscure to me; and also as I understand it, ftrace is controlled
through debugfs, which means there's a bit of hassle to make this usable
on a default install.  And also I'm not sure how the ftrace control path
really maps to "here's a 100 address ranges I'd like events for".

So at a first glance after unsquinting a bit I'm not sure how good the
fit really is.

 > I looked at the code, asked "wtf is that rbtree being used for", went
 > to the defining data structure and ...  nothing.
 > 
 > And without knowing what the data structures do, and the relationship
 > between them it's hard to follow the code.  But you need to follow the
 > code to be able to reverse-engineer the data structures.

OK, will document data structures a bit more in the next version.  The
specific questions here:

 > What's the rbtree for?

To keep track of what ranges userspace is interested in so that it's
reasonably efficient to go through them in sort order and reasonably
efficient to add/remove ranges too.

 > What's a "hint"?

If userspace asks us to monitor a range X...Y and we get an event that
invalidates some subrange W...Q then we tell userspace that only the
subrange is invalid as a hint.  If multiple events hit a single range,
we give up and don't try to tell userspace what parts got invalidated.
So it's a "hint" in the sense of "here's some information that might be
helpful that we may give you, but don't count on getting it every time"

 > What's on dirty_list?

list of address ranges being watched that have been invalidated.

 > I really really want to do s/not/notify/g on this patch ;)

The name is of course very provisional... I'd be happy with ummunotify
or even perhaps something with _s in it to be more readable.  I'll go
with ummunotify next time.

 > > +static void ummunot_inval_page(struct mmu_notifier *mn,

 > "invalidate"

sure.

 > hm, how do you set the permissions on a miscdevice node?

On my system I have a udev rule

KERNEL=="ummunot", MODE="0666"

and that seems to work.  (Will need to change it to KERNEL=="ummunotify"
I guess ;)

 > > +	max = min(PAGE_SIZE, count) / sizeof *events;

 > It used to be the case that architectures disagreed over the type of
 > PAGE_SIZE - unsigned versus unsigned long, iirc.

 > If still true, this will warn.

Will check it out... anyway it's easy to switch to min_t() to be safe.

Thanks for the review,
  Roland

