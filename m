Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbXGaH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbXGaH4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXGaH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:56:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59077 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751934AbXGaH4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:56:13 -0400
Date: Tue, 31 Jul 2007 09:55:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       "Agarwal, Lomesh" <lomesh.agarwal@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: which signal is sent to freeze process?
Message-ID: <20070731075551.GE22419@elf.ucw.cz>
References: <46A506F8.2020206@colorfullife.com> <200707232211.15543.rjw@sisk.pl> <46A50AF0.70305@colorfullife.com> <46A64984.1070808@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A64984.1070808@colorfullife.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Can you generate small testcase that demonstrates the problem?
> >
> >> Then what would be the correct way to handle resume process. The other
> >> way of course is to make all the applications check the errno in case of
> >> failure. But that seems more more problematic then system call checking.
> >> What do you say?
> >
> >Hmm, does that testcase behave correctly over SIGSTOP/SIGCONT? I'm not
> >saying kernel behaves nicely here, but perhaps fixing the apps to
> >check errno properly is the right thing to do? :-)
> Perhaps the kernel should use ERESTARTNOHAND instead of EINTR?
> The current code is more than odd:
> - select() and sys_ppoll() both use ERESTARTNOHAND (i.e.: 
> the functions do not return to user space with SIGSTOP/SIGCONT or freezer())
> 
> - sys_poll() uses EINTR (i.e.: SIGSTOP/SIGCONT/freezer() return to user 
> space)
> 
> Attached is a patch that switches sys_poll to ERESTARTNOHAND and a poll 
> test app.
> Boot tested with FC6.
> 
> What do you think? With ERESTARTNOHAND, poll would only return to user 
> space if the app has a SIGCONT handler installed.

I think the patch looks okay... but I expected some discussoin here
and it did not happen :-(. Can you try to send it to andrew?

> --- 2.6/fs/select.c	2007-05-20 09:52:32.000000000 +0200
> +++ build-2.6/fs/select.c	2007-07-23 22:10:21.000000000 +0200
> @@ -723,7 +723,7 @@
>    	}
>  	err = fdcount;
>  	if (!fdcount && signal_pending(current))
> -		err = -EINTR;
> +		err = -ERESTARTNOHAND;
>  out_fds:
>  	walk = head;
>  	while(walk!=NULL) {
> @@ -794,7 +794,7 @@
>  	ret = do_sys_poll(ufds, nfds, &timeout);
>  
>  	/* We can restart this syscall, usually */
> -	if (ret == -EINTR) {
> +	if (ret == -ERESTARTNOHAND) {
>  		/*
>  		 * Don't restore the signal mask yet. Let do_signal() deliver
>  		 * the signal on the way back to userspace, before the signal
> @@ -805,7 +805,6 @@
>  					sizeof(sigsaved));
>  			set_thread_flag(TIF_RESTORE_SIGMASK);
>  		}
> -		ret = -ERESTARTNOHAND;
>  	} else if (sigmask)
>  		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
