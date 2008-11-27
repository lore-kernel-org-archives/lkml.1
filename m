Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYK0NwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYK0NwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYK0NwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:52:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYK0NwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:52:10 -0500
Date: Thu, 27 Nov 2008 14:51:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
	trace output
Message-ID: <20081127135155.GA23076@elte.hu>
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu> <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/27 Ingo Molnar <mingo@elte.hu>:
> > But in fact, it might be even better to display the costs like this,
> > on the left side [mockup]:
> >
> > ---------------------------------------------------------
> > CPU)     cost    |  function
> > ---------------------------------------------------------
> >
> >  0)             |  sys_read() {
> >  0)    0.331 us |    fget_light();
> >  0)             |    vfs_read() {
> >  0)             |      rw_verify_area() {
> >  0)             |        security_file_permission() {
> >  0)    0.306 us |          cap_file_permission();
> >  0)    0.300 us |          cap_file_permission();
> >  0)    8.909 us |        }
> >  0)    0.993 us |      }
> >  0)   11.649 us |    }
> >  0)             |    do_sync_read() {
> >  0)             |      sock_aio_read() {
> >  0)             |        __sock_recvmsg() {
> >  0)             |          security_socket_recvmsg() {
> >  0)  100.319 us |            cap_socket_recvmsg();
> > ---------------------------------------------------------
> >
> > note the 8 small tweaks i did to optimize the visual real estate of
> > the tracer output:
> >
> > 1) we done need reminders on the left side that this is about CPU
> >   numbers. It will be obvious anyway if it's "all mixed up".
> >   (microseconds is different - that is a unit that will be quoted and
> >    it's also a number that actually matters more in the daily use of
> >    such traces )
> >
> > 2) no need for [] on the left side - a single separator is enough. I
> >   picked ')' as it looks pretty natural and unintrusive.
> >
> > 3) we should use the CPU number width on the left side that
> >   log10(cpus_weight_nr(cpu_online_map)) tells us. So if a system has
> >   just two cores, we should print single-width. If it has 16 CPUs, we
> >   should print 00..01....15.
> >
> > 4) I left 4 decimal points for the cost. That's up to 9999.999
> >   microseconds, after that point we should lose precision and print:
> >   99999.99, then should print up to 999999.9, and then print up to
> >   99999999 microseconds. Always keep the length of the number at 8
> >   characters. Above that, just let the rest shift to the right a bit.
> >   (but that will be about delays of more than 100 seconds - that does
> >   not really matter in practice)
> >
> > 5) Note, by printing the cost at fixed width, we can leave out the '+'
> >   and '!' visual alerts (sorry! :-). The visible width of the numbers
> >   will be enough of an attention grabber - as you can see it in the
> >   mockup above already.
> >
> > 6) Note the vertical '|' separator. I tried it with and without, and i
> >   think the code on the right side looks more structured that way. It
> >   looks like a sheet of paper, and it looks tidier - so please add
> >   it.
> >
> > 7) Note how unobscured the right side code portion looks like this
> >   way. Since this is the only piece of information that is heavily
> >   variable-width, we keep it at the end and dont worry about length
> >   problems.
> 
> 
> Yeah, I will miss a bit the overhead signs, they were really useful 
> to find in one quick sight a costly function call. I know that the 
> decimal. The visible width of the duration replaces it but not as 
> much efficiently. Moreover, put these times on the full left will be 
> perhaps harder for the eyes to retrieve the concerned function 
> return (thinking of a deep calls).

We can still add the overhead signs.

We still have a single space in the first column before the CPU number 
(that looks better when these traces are pasted into email, which is 
one of the most common uses of them), and we can add the sign there.

I.e. something like this:

> > ---------------------------------------------------------
> > CPU)     cost   |  function
> > ---------------------------------------------------------
> >
> >  0)             |  sys_read() {
> >  0)    0.331 us |    fget_light();
> >  0)             |    vfs_read() {
> >  0)             |      rw_verify_area() {
> >  0)             |        security_file_permission() {
> >  0)    0.306 us |          cap_file_permission();
> >  0)    0.300 us |          cap_file_permission();
> >  0)    8.909 us |        }
> >  0)    0.993 us |      }
> > +0)   11.649 us |    }
> >  0)             |    do_sync_read() {
> >  0)             |      sock_aio_read() {
> >  0)             |        __sock_recvmsg() {
> >  0)             |          security_socket_recvmsg() {
> > !0)  100.319 us |            cap_socket_recvmsg();
> > ---------------------------------------------------------

Or we could add them to the function name bit - there we have two free 
space characters anyway:

Something like this:

> > ---------------------------------------------------------
> > CPU)     cost   |  function
> > ---------------------------------------------------------
> >
> >  0)             |  sys_read() {
> >  0)    0.331 us |    fget_light();
> >  0)             |    vfs_read() {
> >  0)             |      rw_verify_area() {
> >  0)             |        security_file_permission() {
> >  0)    0.306 us |          cap_file_permission();
> >  0)    0.300 us |          cap_file_permission();
> >  0)    8.909 us |        }
> >  0)    0.993 us |      }
> >  0)   11.649 us |+   }
> >  0)             |    do_sync_read() {
> >  0)             |      sock_aio_read() {
> >  0)             |        __sock_recvmsg() {
> >  0)             |          security_socket_recvmsg() {
> >  0)  100.319 us |!           cap_socket_recvmsg();
> > ---------------------------------------------------------

Hm?

> I don't know, perhaps that will actually be better in practice...

i think it will be better. I'm biased, so i gave the output to two 
people with good visual taste (one of them female), [note, i gave them 
the mockup from the previous mail] and the first question of both of 
them was: "why arent the times on the left?".

I think we could make the time column a trace_option as well - 
default-enabled.

	Ingo
