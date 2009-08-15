Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZHORxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZHORxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZHORxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:53:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZHORxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:53:03 -0400
Date: Sat, 15 Aug 2009 10:52:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@redhat.com>
cc: Christoph Thielecke <christoph.thielecke@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kernel bugs 2.6.31-rc6
In-Reply-To: <alpine.LFD.2.01.0908150957060.3162@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908151036290.3162@localhost.localdomain>
References: <200908151014.22910.christoph.thielecke@gmx.de> <alpine.LFD.2.01.0908150957060.3162@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Aug 2009, Linus Torvalds wrote:
> 
> For example, fsnotify_remove_priv_from_event() will remove the private 
> data event from the list, but what if there are _multiple_ entries with 
> the same 'group' entry? If so, it will remove just the first one.

Hmm. Looking closer, that shouldn't much matter. Each time we added an 
entry in private_data_list, we would have done a 
'fsnotify_get_event(event)' due to adding it to the 'golder->event_list'.

That said, there does seem to be some dubious code there. For example, 
in 'inotify_ignored_and_remove_idr()', we do this:

        fsnotify_add_notify_event(group, ignored_event, fsn_event_priv);

        /* did the private data get added? */
        if (list_empty(&fsn_event_priv->event_list))
                inotify_free_event_priv(fsn_event_priv);

and we do it without holding any locks at all. So as far as I can tell, 
what could happen is that 'fsnotify_add_notify_event()' actually adds the 
private event (fsn_event_priv), but then before we check that the 
event_list is empty, another user (on another CPU, or preempted on the 
same CPU - Christoph has both PREEMPT and SMP on) comes along, picks up 
the private event and frees it (and re-uses it).

That looks like a pretty small window, but preemption could make it much 
bigger. Who knows? Maybe there are other things like that.

And maybe I'm just full of sh*t, and the above can't even happen for some 
reason I'm missing.

		Linus
