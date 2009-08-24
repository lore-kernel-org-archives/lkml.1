Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZHXJGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZHXJGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZHXJGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:06:24 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36819 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZHXJGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Aop/kYu8sKs3R3mDwpuW+bYQb8OMIMgyaCsL6oPu/Qgmk8Ln01MfC8NfAZSHV+W+fP
         WIoAnqpeybRs1Q39FKMgQdvuoJWp8upV9TPWAJLZXvBT83TItpGbVsl6E4RDsGxoJsZJ
         AygqOZXTQyB3epavD9afGONEbMBnyJzF9AplQ=
MIME-Version: 1.0
In-Reply-To: <1250378345.14501.92.camel@dhcp231-106.rdu.redhat.com>
References: <200908151014.22910.christoph.thielecke@gmx.de>
	 <alpine.LFD.2.01.0908150957060.3162@localhost.localdomain>
	 <alpine.LFD.2.01.0908151036290.3162@localhost.localdomain>
	 <1250378345.14501.92.camel@dhcp231-106.rdu.redhat.com>
Date: Mon, 24 Aug 2009 11:06:24 +0200
Message-ID: <c4e36d110908240206h339ec9eaq5c5110b61782cdfb@mail.gmail.com>
Subject: Re: kernel bugs 2.6.31-rc6
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Thielecke <christoph.thielecke@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/16 Eric Paris <eparis@redhat.com>:
> On Sat, 2009-08-15 at 10:52 -0700, Linus Torvalds wrote:
>>
>> On Sat, 15 Aug 2009, Linus Torvalds wrote:
>> >
>> > For example, fsnotify_remove_priv_from_event() will remove the private
>> > data event from the list, but what if there are _multiple_ entries with
>> > the same 'group' entry? If so, it will remove just the first one.
>
> I can happen, but ONLY for the staticly declared q_overflow_event in
> notification.c.  If the refcnt on that ever hits 0 to trigger this bug
> we are in some serious dodo.
>
>> Hmm. Looking closer, that shouldn't much matter. Each time we added an
>> entry in private_data_list, we would have done a
>> 'fsnotify_get_event(event)' due to adding it to the 'golder->event_list'.
>>
>> That said, there does seem to be some dubious code there. For example,
>> in 'inotify_ignored_and_remove_idr()', we do this:
>>
>>         fsnotify_add_notify_event(group, ignored_event, fsn_event_priv);
>>
>>         /* did the private data get added? */
>>         if (list_empty(&fsn_event_priv->event_list))
>>                 inotify_free_event_priv(fsn_event_priv);
>
>> and we do it without holding any locks at all. So as far as I can tell,
>> what could happen is that 'fsnotify_add_notify_event()' actually adds the
>> private event (fsn_event_priv), but then before we check that the
>> event_list is empty, another user (on another CPU, or preempted on the
>> same CPU - Christoph has both PREEMPT and SMP on) comes along, picks up
>> the private event and frees it (and re-uses it).
>
> Actually you look correct in your assessment that there is a race here.
> I guess I could imagine a way to make it panic like this, but I would
> have expected a different problem in that after I freed this memory
> (which wasn't mine any more) the other task which owned this memory
> would have to still be able to run list_for_each_entry, but find that
> it's group was no longer there.  Not sure how could screw up the group,
> but not the list entries.
>
> I'll fix this race tonight or in the morning.
>
> I'm downloading and installing KDE, as I guess kde uses inotify pretty
> hard since both Mikko and Christoph were using kde.


Hi

I'm not sure how it is related - but I've got folllowing ooops while
running yum upgrade
I'm using gnome.

I've added the backtrace to the Bugzilla mentioned in this thread.

http://bugzilla.kernel.org/show_bug.cgi?id=13729#c7

Zdenek
