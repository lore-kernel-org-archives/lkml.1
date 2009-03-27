Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbZC0Wam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbZC0Wam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZC0Wad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:30:33 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41978 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZC0Wac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hkZKDNIsXiWVne2tIHthq8Zcet/Q0FMBiK09We25h0b1+NOAGuT5VZQAmpeWmbI5DG
         Zgg+3mgAUs2Z8ZpK4JXfR5Znj4U61KCmK/RYAZbKThiFc7h/iFUhbZZHFHWOSqOlDsGR
         yU4ISURgCXUjLnm/k0Qp7tGMRXTPSv7C97tqE=
MIME-Version: 1.0
In-Reply-To: <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <49CAA055.5060603@goop.org>
	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>
	 <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>
	 <49CD4967.2090606@msgid.tls.msk.ru>
	 <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com>
Date: Fri, 27 Mar 2009 23:30:25 +0100
Message-ID: <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at libevent of niels provos, and even him, is apparently
doing a mistake :

static int
epoll_add(void *arg, struct event *ev)
{
	struct epollop *epollop = arg;
	struct epoll_event epev = {0, {0}};

        /* ... some code here ... */
	if (epoll_ctl(epollop->epfd, op, ev->ev_fd, &epev) == -1)
			return (-1);

	/* Update events responsible */
	if (ev->ev_events & EV_READ)
		evep->evread = ev;
	if (ev->ev_events & EV_WRITE)
		evep->evwrite = ev;

	return (0);
}

the structure pointed to by &epev is allocated on the stack, so how
the kernel could keep track of it?

2009/3/27 nicolas sitbon <nicolas.sitbon@gmail.com>:
> Well, first, thanks for your answer, then, there is a difference
> between saying the kernel modify or not the structure and the kernel
> keep track of it. Consider this user :
> http://www.csplayer.org/2009/02/a-tutorial-example-of-epoll-usage/, he
> thinks the kernel doesn't keep track of the event, and I'm sure he is
> not the first, so please, at least, be more explicit in the
> documentation and again thanks for your answer. And what about size
> parameter in epoll_create()? why is it an int and not a size_t?
>
> 2009/3/27 Michael Tokarev <mjt@tls.msk.ru>:
>> nicolas sitbon wrote:
>>>
>>> Please, can anyone answer me, I need a response.
>>
>>> 2009/3/25 nicolas sitbon <nicolas.sitbon@gmail.com>:
>>>>
>>>> You don't teach me anything, I know that, the fact is the
>>>> documentation is incomplete, so rather saying that, please answer my
>>>> questions. For the moment, only the documenation and the prototype of
>>>> epoll are buggy.
>>
>> So which response do you want -- the one saying that the documentation
>> is buggy or or epoll prototype?  Or something else?
>>
>> []
>>>>>>
>>>>>>  or the good prototype is
>>>>>>
>>>>>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const
>>>>>> *event);
>>
>> Why should it be const?  There is no guarantee the argument will not be
>> modified by the kernel.  Documentation does not say that.  Current prototype
>> does not say that.  If you need such a guarantee, you're free to add another
>> system call into your kernel, and fix both your documentation and your
>> prototype to match.  What's the deal?
>>
>> Back from useless rants and to the technical points.
>>
>> Again: there's no guarantee the `event' argument will not be modified.
>> Even if kernel CURRENTLY indeed does not modify it, but the interface
>> does not PROMISE it to be that way for ever.
>>
>> Why does it not promise that is another question.  Just one example:
>> what, some day, stops us from adding some EPOLL_CTL_GET operation
>> to RETRIEVE information associated with that filedescriptor in kernel
>> currently and STORE that info in the structure pointed to by `event'
>> argument?  That way it will not be const anymore.
>>
>> So.. what's your problem?
>>
>> /mjt
>>
>
