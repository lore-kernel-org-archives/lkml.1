Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZBRJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZBRJzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZBRJyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:54:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbZBRJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:54:51 -0500
Date: Wed, 18 Feb 2009 01:53:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, x86@kernel.org,
       oleg@redhat.com, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: mmotm 2009-02-17-12-33 uploaded
Message-Id: <20090218015356.4454f758.akpm@linux-foundation.org>
In-Reply-To: <499BD65B.2080307@gmail.com>
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
	<499B465D.9080502@gmail.com>
	<499BD2AE.2020205@gmail.com>
	<499BD65B.2080307@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 10:35:23 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> On 18.2.2009 10:19, Jiri Slaby wrote:
> > On 18.2.2009 00:21, Jiri Slaby wrote:
> >> On 17.2.2009 21:33, akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2009-02-17-12-33 has been uploaded to
> >
> > This one:
> > kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
> 
> This hunk fixes the problem for me. I have no idea if it is correct though.
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index c1c3763..caed471 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -73,6 +73,7 @@ static int kthread(void *_create)
> 
>          /* OK, tell user we're spawned, wait for stop or wakeup */
>          __set_current_state(TASK_UNINTERRUPTIBLE);
> +       create->result = current;
>          complete(&create->done);
>          schedule();

hm, it does seem to forget to initialise ->result on the success path.

Someone else has been mucking with kthread.c in linux-next, and a
couple of days ago that mucking got dropped from linux-next.  Perhaps
this churn broke Oleg's patch.

And if it was Stephen who dropped the offending tree, that mucking
about will come back soon and will re-muck things up.

<checks>

	Undropped tree:
		rr

And what does that do?  yup,

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -76,6 +76,7 @@ static int kthread(void *_create)
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
+	create->result = current;
 	complete(&create->started);
 	schedule();
 

guys, please stop mucking things up?

