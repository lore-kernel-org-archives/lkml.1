Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZHOXTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZHOXTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 19:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZHOXTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 19:19:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZHOXT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 19:19:29 -0400
Subject: Re: kernel bugs 2.6.31-rc6
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Thielecke <christoph.thielecke@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.2.01.0908151036290.3162@localhost.localdomain>
References: <200908151014.22910.christoph.thielecke@gmx.de>
	 <alpine.LFD.2.01.0908150957060.3162@localhost.localdomain>
	 <alpine.LFD.2.01.0908151036290.3162@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 15 Aug 2009 19:19:05 -0400
Message-Id: <1250378345.14501.92.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-15 at 10:52 -0700, Linus Torvalds wrote:
> 
> On Sat, 15 Aug 2009, Linus Torvalds wrote:
> > 
> > For example, fsnotify_remove_priv_from_event() will remove the private 
> > data event from the list, but what if there are _multiple_ entries with 
> > the same 'group' entry? If so, it will remove just the first one.

I can happen, but ONLY for the staticly declared q_overflow_event in
notification.c.  If the refcnt on that ever hits 0 to trigger this bug
we are in some serious dodo.  

> Hmm. Looking closer, that shouldn't much matter. Each time we added an 
> entry in private_data_list, we would have done a 
> 'fsnotify_get_event(event)' due to adding it to the 'golder->event_list'.
> 
> That said, there does seem to be some dubious code there. For example, 
> in 'inotify_ignored_and_remove_idr()', we do this:
> 
>         fsnotify_add_notify_event(group, ignored_event, fsn_event_priv);
> 
>         /* did the private data get added? */
>         if (list_empty(&fsn_event_priv->event_list))
>                 inotify_free_event_priv(fsn_event_priv);

> and we do it without holding any locks at all. So as far as I can tell, 
> what could happen is that 'fsnotify_add_notify_event()' actually adds the 
> private event (fsn_event_priv), but then before we check that the 
> event_list is empty, another user (on another CPU, or preempted on the 
> same CPU - Christoph has both PREEMPT and SMP on) comes along, picks up 
> the private event and frees it (and re-uses it).

Actually you look correct in your assessment that there is a race here.
I guess I could imagine a way to make it panic like this, but I would
have expected a different problem in that after I freed this memory
(which wasn't mine any more) the other task which owned this memory
would have to still be able to run list_for_each_entry, but find that
it's group was no longer there.  Not sure how could screw up the group,
but not the list entries.

I'll fix this race tonight or in the morning.

I'm downloading and installing KDE, as I guess kde uses inotify pretty
hard since both Mikko and Christoph were using kde.

-Eric

