Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbZIQA5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbZIQA5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZIQA5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:57:36 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:64933 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbZIQA5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kRlfFxUHup0cC9zUqBjj4Fa58NGdY3OEWONb6EaHNkweLJHnTuqllhgQJnl4HgJviw
         pPJR9qwLMk0B5E1i+SdXmORl8JSEwwOhb2RKlTzIxFy/jrQm9XnyhVwWyhDNVom4YmCS
         l/5lQVS2mzl3DSLln4Ed1uGaU5TwaisjDrkAA=
MIME-Version: 1.0
In-Reply-To: <024801ca3731$38833ad0$a989b070$@com>
References: <023c01ca3724$9f90fcb0$deb2f610$@com> <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com> 
	<024601ca372d$09ad9fb0$1d08df10$@com> <alpine.DEB.2.00.0909161726090.3124@makko.or.mcafeemobile.com> 
	<024701ca372f$81412040$83c360c0$@com> <3e8340490909161745h5c58c165j1726c3433df3baeb@mail.gmail.com> 
	<024801ca3731$38833ad0$a989b070$@com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 16 Sep 2009 20:57:18 -0400
Message-ID: <3e8340490909161757p3c7c297o9c2b77a653835862@mail.gmail.com>
Subject: Re: epoll and closed file descriptors
To: Gilad Benjamini <gilad@altornetworks.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/16 Gilad Benjamini <gilad@altornetworks.com>:
>> Subject: Re: epoll and closed file descriptors
>>
>> On Wed, Sep 16, 2009 at 8:40 PM, Gilad Benjamini
>> <gilad@altornetworks.com> wrote:
>> > Davide wrote:
>> >> On Wed, 16 Sep 2009, Gilad Benjamini wrote:
>> >>
>> >> > I would, but epoll is preventing me from doing so.
>> >> > Early in sys_epoll_ctl there are these lines
>> >> >
>> >> >   file = fget(epfd);
>> >> >   if (!file)
>> >> >     goto error_return;
>> >> >
>> >> > Leaving me in a kind of dead lock
>> >>
>> >> The 'epfd' in there, is the _epoll fd_, which, if fget() fails,
>> means
>> >> you
>> >> close it.
>> >> You see likely failing the 'tfile = fget(fd)' (of course, you closed
>> >> it),
>> >> so if someone else keeps the socket open and you have no chance in
>> >> telling
>> >> it to drop it (really?), you need to remove the socket from the set
>> >> before
>> >> closing it.
>> >>
>> >>
>> >>
>> >> - Davide
>> >
>> > My bad. I meant to quote the line that you mentioned.
>> > I agree that the right thing to do is to remove the fd from epoll
>> before
>> > closing it.
>> > However, due to the way curl works, I cannot do that. Changing the
>> curl code
>> > doesn't seem trivial.
>> >
>> > Regardless, I still don't see how the kernel got into this situation,
>> and if
>> > this situation is valid, why it doesn't bail out of it.
>>
>> epoll references the underlying file object; the fd is used _only_ to
>> obtain this file object, and then never used again. Determining when
>> the fd goes away then requires iterating over all fds, and since epoll
>> was designed to avoid doing exactly that, it isn't an acceptable
>> solution.
>
> Regarding bailing out of the situation, I see the logic in your answer.
> What about the first part ? Any ideas how the kernel actually got into that
> tight spot ?
> Looking into the code I can't find a path that can lead into this situation.

Userspace passes in a fd that is unused (closed). Kernel can't find
the file object corresponding to the fd (because the fd went away when
it wasn't looking), so it says to userspace, "Sorry, no such file!".
And it's completely correct.

So, the basic problem is userspace becomes unable to refer to the file
object. The kernel's doing just fine; it's not in a "tight spot" at
all. It's perfectly happy to refer to the file object by a direct
pointer to it - it's just userspace is unable to tell the kernel to
remove it from the epoll, because the only name userspace had for it
has been removed.
