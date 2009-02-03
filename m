Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZBCXGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZBCXGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZBCXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:06:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:13303 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZBCXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:06:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=niYdgpL+buMX1Ag99o228rz8C80Uj/IQLexIeSFz7zNS+HsfJIUy+rN4vUXexSXH5g
         GknC7dvkxt5kXvbmP+Rrc+9vMQpQWOlJTGK9YcsWgpy7JtQFsSedin6sHYWIB4oSrpDj
         eEdZGMPaibUBxVbn9cgJ02qp6M7t87eIlnPd0=
MIME-Version: 1.0
In-Reply-To: <20090203213244.GA29040@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	 <20090202064509.GA20237@redhat.com>
	 <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	 <20090202165606.GA13346@redhat.com> <498754EF.8090604@redhat.com>
	 <3f43f78b0902021239s21566f76hf7f59850b2dbf45a@mail.gmail.com>
	 <3f43f78b0902021839j1eb1eb04u49be47277c99900d@mail.gmail.com>
	 <20090203133313.GA5679@redhat.com>
	 <3f43f78b0902031151ta841190i2c7898facc34cb95@mail.gmail.com>
	 <20090203213244.GA29040@redhat.com>
Date: Tue, 3 Feb 2009 15:06:12 -0800
Message-ID: <3f43f78b0902031506p366026ffldc13a42f37697c40@mail.gmail.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 1:32 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/03, Kaz Kylheku wrote:
>>
>> Well, it doesn't bother me that that has to be thrown out.
>> In fact, I do not agree with the requirement that the thread
>> which calls pthread_exit must not respond to signals;
>> the original patch works for me.
>
> What about other users? We can't know what how much they
> depend on the current behaviour.

If they haven't run into this gaping job control issue,
they haven't done a whole lot of testing, obviously!

Those who have run into it would certainly have to implement
a workaround --- like not calling pthread_exit from the main
thread!

I.e.  ``Q: Doctor, it hurts when I do this; A: So don't
do that!''.

> OK, OK. Please forget about signals, futexes, etc.
> Simple program:
>
>        pthread_t main_thread;
>
>        void *tfunc(void *a)
>        {
>                pthread_joni(main_thread, NULL);
>                return NULL;
>        }
>
>        int main(void)
>        {
>                pthread_t thr;
>
>                main_thread = pthread_self();
>                pthread_create(&thr, NULL, tfunc, NULL);
>                pthread_exit(NULL);
>        }

This test case appears to be conforming, so it
has to work.

The initial thread is considered joinable.

For instance a Rationale note in Issue 6 of the
SUS claims that one reason for the existence of
pthread_detach is so that the initial thread could
be detached, which cannot be done through thread
creation attributes for that thread. So the intent
is clearly that the initial thread is joinable!

> I bet this will hang with your patch applied.

It almost certainly will, and it does have to do with
futexes.

The main thread hasn't gone through the step where
it clears the TID, so the lll_wait_tid
futex wait in pthread_join will block. There is no
short-circuit indication in the library to indicate that
the main thread has died.

This TID trick is analogous to the robust list clean up. It's the same
kind of thing: fixing up a value of some registered
user-space memory location, signaling.

> Kaz, you know, it is not easy to say "you patch is wrong
> in any case, no matter how much it will be improved" ;)

Sure it is!

I will save you from that, because I do not believe in piling
hacks on top of hacks to fix something that may be
the wrong approach, even in situations where there is a
good chance that after some finite number of hacks,
it will finally be right.  I did that in LinuxThreads once upon
a time (mind you, that was so great, FreeBSD had to have it!)

I do think there is a clean, non-hacky way to reason
about this.

If we think about the process-containing-threads model that
the kernel is trying to emulate, and what should happen
when threads exit, we come to the following reasoning:

When a thread exits, there does have to be certain cleanup
with respect to that thread. But the process-wide cleanup
is not performed until all the threads are gone (thread
count hits zero).  This is easy to implement under the
process-contains-threads model.

These actions are not cleanly separated in Linux. There
is a do_exit function which handles both the thread-things
and the process-things in one swoop, so to speak.

The zombie problem occurs because do_exit goes too
far, cleaning up things that it shouldn't; things that
are necessary in holding up the POSIX-conforming
illusion that there is a process that contains threads.

My kneejerk approch was: hey wait, let's hold back
from doing /anything/ in do_exit; in fact let's not
call it at all if we're the initial thread and there are
still others. But obviously, it's not just anything in
do_exit that causes problems. Maybe some in-between
approach can work.  The pthread_join test case can
be fixed in a clean way, as can robust cleanup.

The thread can signal pthread_join by resetting its TID
to zero and hitting the futex. It can do the robust
list cleanup, etc.

If you can identify a good separation about what to do
first, and what to do later, maybe you can some decent
compromise among the concerns. Breaking up the
do_exit logic into

   do_exit_thread
   do_exit_process

would probably not hurt. You then have to pick whether
each action belongs to one or the other and stick
it into the appropriate function, with some clear
guidelines about what goes where.

In sys_exit, the two pieces could be used somehow like this:

   do_exit_thread();

   if (leader and not_empty(group))
     { special_logic(); }

   do_exit_process();

As one rule (for instance), any cleanup that threatens
the integrity of the process/thread model goes into do_exit_process.

So for instance if you ptrace that process, it still has all of its
memory areas intact (you don't have to look for a different
PID in the process list in order to find them).
