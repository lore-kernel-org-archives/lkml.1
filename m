Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZBCVf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZBCVf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZBCVfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:35:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52421 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZBCVfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:35:19 -0500
Date: Tue, 3 Feb 2009 22:32:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090203213244.GA29040@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com> <20090201174159.4a52e15c.akpm@linux-foundation.org> <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com> <20090202165606.GA13346@redhat.com> <498754EF.8090604@redhat.com> <3f43f78b0902021239s21566f76hf7f59850b2dbf45a@mail.gmail.com> <3f43f78b0902021839j1eb1eb04u49be47277c99900d@mail.gmail.com> <20090203133313.GA5679@redhat.com> <3f43f78b0902031151ta841190i2c7898facc34cb95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f43f78b0902031151ta841190i2c7898facc34cb95@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Kaz Kylheku wrote:
>
> Well, it doesn't bother me that that has to be thrown out.
> In fact, I do not agree with the requirement that the thread
> which calls pthread_exit must not respond to signals;
> the original patch works for me.

What about other users? We can't know what how much they
depend on the current behaviour.

> I.e. in my embedded GNU/Linux distro, that requirement
> doesn't exist. And since I can't find it in the Single
> Unix Specification, so much for that!
>
> Nothing in the spec says that once pthread_exit is called,
> signals are stopped. This function invokes cleanup handling,
> and thread-specific-storage destruction. During any of those
> tasks, signals can still be happening.  Any of those
> tasks can easily enter into an indefinite wait. What if
> a cleanup handler performs a blocking RPC to a remote
> server? Well, there you are, stuck in pthread_exit,
> handling signals, and not cleaning up your robust list, etc.
>
> I also don't require robust locks to be cleaned up
> instantly if they are owned by a main thread that has
> called pthread_exit.

OK, OK. Please forget about signals, futexes, etc.
Simple program:

	pthread_t main_thread;

	void *tfunc(void *a)
	{
		pthread_joni(main_thread, NULL);
		return NULL;
	}

	int main(void)
	{
		pthread_t thr;

		main_thread = pthread_self();
		pthread_create(&thr, NULL, tfunc, NULL);
		pthread_exit(NULL);
	}

I bet this will hang with your patch applied. Because
we depend on sys_futex(->clear_child_tid, FUTEX_WAKE, ...).

Kaz, you know, it is not easy to say "you patch is wrong
in any case, no matter how much it will be improved" ;)
But even if the current behaviour is not optimal, we must not
change it unless we think it leads to bugs. We can't know
which application can suffer. The current behaviour is old.

> Face it, allowing the thread leader to exit is as wrong as doing
> other stupid things to the leader, like unsharing the signal
> handler.

Perhaps. That is why I said _something_ like your patch perhaps
makes sense. But this is tricky, and I don't see a simple/clean
way to improve things. And, otoh, I do not see _real_ problems
with the zombie leaders.


As for original problem, it should be fixed anyway. wait_task_stopped()
should take SIGNAL_STOP_STOPPED into account, not task->state.
Unless we are ptracer, of course.

Oleg.

