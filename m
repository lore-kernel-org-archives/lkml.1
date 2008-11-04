Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYKDLOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYKDLOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 06:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKDLOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 06:14:35 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:34139 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYKDLOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 06:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rValyCWSXgnG3/OLgx6b60qHIajb13eZXE/18s5x+tJ+6mDSvvL/sYeLm8RAlOKejB
         Sk7J085TkaIO2NBCrQEkebDLbQBKx7R5x2JnZMcdZocEozIu9fsh9UUJA0fwLfgjQq23
         uIl3b8lDLVKUWho5e3P0e58dNyyG2hXjMjdBs=
Message-ID: <c62985530811040314o13394d43t201ae3fc2f1304be@mail.gmail.com>
Date: Tue, 4 Nov 2008 12:14:33 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081104094341.GO23790@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490E3F73.1000405@gmail.com>
	 <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
	 <20081103064647.GA4826@elte.hu>
	 <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com>
	 <20081104094341.GO23790@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/4 Ingo Molnar <mingo@elte.hu>:
> lockdep works via a completely different principle: it instruments all
> the actual lock acquire/release calls and builds a graph of lock
> dependencies in the system, as it happens.
>
> It also guarantees that all the observed locking rules are followed
> (i.e. it proves that as long as you dont get any messages from
> lockdep, all the locking patterns are mathematically safe).
>
> So a lockdep message will most of the time occur much easier than a
> real lockup would occur - as lockdep only needs to observe
> inconsistent locking patterns to prove that a lockup _could_ occur.


Ok, so if there is such an error, I could (hopefully) see it with
early_printk....


> The NMI watchdog just observes the system and complains if it sees
> hardirqs not progressing (i.e. a hard lockup). It will detect anything
> that causes a hard lockup. (assuming that the NMI watchdog itself is
> not locked up)
>
> Regarding your lockup ... it's quite hard. Maybe you can get more
> output out of the system by using:
>
>  earlyprintk=vga,keep
>
> plus disablig regular tty output. (i.e. not passing any 'console=tty'
> line to the kernel bootup.)
>
> this way you wont get any normal printk activities (which might lock
> up), you should only get the very simple early-printk output.



Good idea. After reading your mail, I had a look on early_printk and
it shoudn't cause any tracing recursion after
your patch: the strings are directly writed to the vga. Great.


> ... but that's still not a guarantee that you'll be able to debug it
> this way :-/ Bootstrapping something this intrusive and wide is one of
> the hardest kernel development activities possible.


I've been on it for two weeks now. Yes it's very hard. But exciting!

>        Ingo
>
> ---------------->
> From 6cf87efbc7a3676e0ad7c9622ec6aec244a593bc Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 4 Nov 2008 10:42:23 +0100
> Subject: [PATCH] x86 debug: mark early_printk.o as notrace
>
> Impact: do not do function-tracing in the early-printk code
>
> this is useful when earlyprintk=vga,keep is used to debug tracer
> plugins.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index e489ff9..943fe60 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -12,6 +12,7 @@ CFLAGS_REMOVE_tsc.o = -pg
>  CFLAGS_REMOVE_rtc.o = -pg
>  CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
>  CFLAGS_REMOVE_ftrace.o = -pg
> +CFLAGS_REMOVE_early_printk.o = -pg
>  endif
>
>  #
>

I will test your advices this evening and pull latest -tip to get this
patch. Thanks!
