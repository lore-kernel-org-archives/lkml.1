Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZIQA2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZIQA2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZIQA2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:28:18 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:37555 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZIQA2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TVuE+bF5VJbShokKV8/VDhDvH4MSbqtzvlRa2N+IWHoYVh5tsJw7378UGAPmC9fBGC
         Ffqbd3G6ztY2gY8hMpGSYQY9idp0bxPeOS4ih/g8t9xl27u7f7ukz2D++cl3jdHBh+T0
         +QcSk4ZjSWgv4KClBhsvYZ8J3EtmuORTL5OYU=
MIME-Version: 1.0
In-Reply-To: <024601ca372d$09ad9fb0$1d08df10$@com>
References: <023c01ca3724$9f90fcb0$deb2f610$@com> <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com> 
	<024601ca372d$09ad9fb0$1d08df10$@com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 16 Sep 2009 20:28:00 -0400
Message-ID: <3e8340490909161728n5dc5f90gc0ab261bd5cec33e@mail.gmail.com>
Subject: Re: epoll and closed file descriptors
To: Gilad Benjamini <gilad@altornetworks.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 8:23 PM, Gilad Benjamini
<gilad@altornetworks.com> wrote:
> Davide wrote:
>> On Wed, 16 Sep 2009, Gilad Benjamini wrote:
>>
>> > I am running repeatedly into a scenario  where epoll notifies
>> userland of
>> > events on a closed file descriptor.
>> > I am running a single thread application, on a single CPU machine so
>> > multiple threads isn't the issue.
>> >
>> > A sample set of events that I have seen
>> > - File descriptor (13) for a socket is closed
>> > - epoll_wait returns with no events.
>> > - Several epoll related calls happen
>> > - More than 20 seconds after the "close", epoll_wait finds an event
>> on fd 13
>> > with EPOLLIN|EPOLLERR|EPOLLHUP.
>> > - epoll_wait continues to report this event
>>
>> Epoll removes the fd from its container, when the last instance of the
>> underlying kernel file pointer is released (or when you explicitly
>> remove it with epoll_ctl(EPOLL_CTL_DEL)).
>> If you continue to get the event, it means that someone else has an
>> instance of the socket (that, looking at the events, saw a shutdown)
>> open,
>> by hence keeping the kernel object alive.
>> If you don't want to see the events, just remove the socket from the
>> epoll
>> set before closing.
>> Or, you remove the socket the first time you see an EPOLLHUP.
>>
>>
>>
>> - Davide
>
> I would, but epoll is preventing me from doing so.
> Early in sys_epoll_ctl there are these lines
>
>  file = fget(epfd);
>  if (!file)
>    goto error_return;
>
> Leaving me in a kind of dead lock

You could dup() the file descriptor before handing it to curl, and use
your own copy for epoll operations.
