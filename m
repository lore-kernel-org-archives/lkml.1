Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXAVXAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXAVXAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 18:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbXAVXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 18:00:20 -0500
Received: from smtp.ono.com ([62.42.230.12]:24550 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932247AbXAVXAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 18:00:18 -0500
Date: Mon, 22 Jan 2007 23:59:41 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@osdl.org>,
       "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Problem with POSIX threads in latest kernel...
Message-ID: <20070122235941.52b1b228@werewolf-wl>
In-Reply-To: <20070122115630.a3d790f5.akpm@osdl.org>
References: <20070116024710.7e94326c@werewolf-wl>
	<20070122115630.a3d790f5.akpm@osdl.org>
X-Mailer: Claws Mail 2.7.1cvs47 (GTK+ 2.10.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007 11:56:30 -0800, Andrew Morton <akpm@osdl.org> wrote:

> > On Tue, 16 Jan 2007 02:47:10 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:
> > Hi...
> > 
> > I run the (almost) latest -mm kernel (2.6.20-rc3-mm1), and see some strange behaviour
> > with POSIX threads (glibc-2.4).
> > I have downgraded my test to a simple textboox example for a SMP-safe spool
> > queue, it's just a circular queue with a mutex and a condition variable for in
> > and out. I have seen the same structure in several places.
> > 
> > Well, it just sometimes gets blocked. GDB says its stuck in pthread_wait().
> > I could swear it worked on previous kernels. It works as is on IRIX.
> > I will try to build an older kernel to test.
> > I takes a second to block it with something like while :; tst; done.
> > 
> > Any ideas ?
> 
> Do I need to worry about this still?

Oops, no, sorry. It was buggy code that previously seemed to work.
Buggy code:

	pthread_mutex_lock(&slots_mutex);
		while (slots<=0)
			pthread_cond_wait(&slots_cond,&slots_mutex);
		slots--;
		items++;
	pthread_mutex_unlock(&slots_mutex);

	pthread_mutex_lock(&items_mutex);
		pthread_cond_signal(&items_cond);
	pthread_mutex_unlock(&items_mutex);

(buggy because it acceses items without locking. The same in the other
endpoint of the queue).

Correct code:

	pthread_mutex_lock(&slots_mutex);
		while (slots<=0)
			pthread_cond_wait(&slots_cond,&slots_mutex);
		slots--;
	pthread_mutex_unlock(&slots_mutex);

	pthread_mutex_lock(&items_mutex);
		items++;
		pthread_cond_signal(&items_cond);
	pthread_mutex_unlock(&items_mutex);

So don't worry. I was so busy I forgot to post the solution.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam04 (gcc 4.1.2 20061110 (prerelease) (4.1.2-0.20061110.2mdv2007.1)) #0 SMP PREEMPT
