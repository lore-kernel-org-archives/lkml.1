Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbZLaNYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbZLaNYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 08:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZLaNYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 08:24:43 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:34086 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZLaNYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 08:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mnmijaZ85bTed40IL/1S+2NvOqi5xn/nUvcjJFQobOXtA7KlCX1gV8oqb/kPPdbFaM
         PaxGr1BWw2iZZSOZM9jP2U4xTQ1LD4VbY9+6DXSY9NgtQvvuwek52NG9g64QDuqQlD/x
         znGN+vfGiyY/1T16YjyOuOWVyI0okE76S+tmw=
MIME-Version: 1.0
In-Reply-To: <1261994502.7135.51.camel@laptop>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1261041885.27920.110.camel@laptop>
	 <a6b9f31a0912260543g62785a58w6432f546c2fa6488@mail.gmail.com>
	 <1261994502.7135.51.camel@laptop>
Date: Thu, 31 Dec 2009 22:24:40 +0900
X-Google-Sender-Auth: 4c618dcfe266da5c
Message-ID: <a6b9f31a0912310524ke0c8880o189fe4304a2ff229@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf lock: Fix output of tracing lock events
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 19:01, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2009-12-26 at 22:43 +0900, Hitoshi Mitake wrote:
>
>> > As to removing the waittime, I'm not sure, in this case, yes, but if you
>> > want some other processing that hooks straight into the tracepoints
>> > instead of using a logging structure, it might be useful.
>> >
>> > Removing that do_div() from there and exposing waittime as u64 in nsec,
>> > for sure, that do_div() is just silly.
>> >
>> >
>> >
>>
>> I was too egoist. perf lock is not an only one user of lock events.
>>
>> And I have a suggestion. Adding name of source files and lines of
>> lock instances may be good thing for human's readability.
>> How do you think?
>
> file:line might be interesting indeed, but I worry about the size of the
> event entry.. But lets see how that goes.
>
>> > Why do we need to have instance resolution?
>
> You forgot to answer this question.
>
> Is it purely because the waittime computation as done by lockstat is not
> good enough for you -- should we not fix that instead, that'd benefit
> more people.
>
>
>

Ah, sorry, let me answer to the question.

Yes, I need instance resolution. Name is not enough thing.
Because there are locks which use name which is used by other locks.
For example, at least 5 lock instances use the name "port_lock".

This is copied from output of cscope.

*** drivers/infiniband/core/user_mad.c:
<global>[138]                  static DEFINE_SPINLOCK(port_lock);

*** drivers/net/ehea/ehea.h:
<global>[473]                  struct mutex port_lock;

*** drivers/pcmcia/i82092.c:
<global>[202]                  static DEFINE_SPINLOCK(port_lock);

*** drivers/pcmcia/pd6729.c:
<global>[69]                   static DEFINE_SPINLOCK(port_lock);

*** drivers/usb/gadget/u_serial.c:
<global>[94]                   spinlock_t port_lock;

port_lock of ehea.h and u_serial.c is a member of struct,
so number of instances with this name is more than 5.

So we cannot distinguish between each lock instances by their name.

And waittime caliculated by lockstat is valuable information,
but we can also use timestamp.
waittime is not equal to hold time, and every events have their timestamps.
I think exploiting information from timestamps
(which already be providec) is worthful.
