Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYK0PEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYK0PEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYK0PD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:03:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbYK0PDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:03:55 -0500
Date: Thu, 27 Nov 2008 16:03:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
	trace output
Message-ID: <20081127150343.GA10188@elte.hu>
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu> <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com> <20081127135155.GA23076@elte.hu> <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com> <20081127144648.GB4672@elte.hu> <c62985530811270658x47f4f950m6c4c71f8674d27f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811270658x47f4f950m6c4c71f8674d27f1@mail.gmail.com>
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
> >
> > * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> >> >  0)    0.993 us |      }
> >> >> > +0)   11.649 us |    }
> >> >> >  0)             |    do_sync_read() {
> >> >> >  0)             |      sock_aio_read() {
> >> >> >  0)             |        __sock_recvmsg() {
> >> >> >  0)             |          security_socket_recvmsg() {
> >> >> > !0)  100.319 us |            cap_socket_recvmsg();
> >> >> > ---------------------------------------------------------
> >>
> >> I like it before the CPU number. The main purpose would be to scroll
> >> quickly the file and find the overheads. That would be easy if set
> >> as a first character.
> >>
> >> I will set it as a default disabled option.
> >
> > lets keep it default-enabled, ok? It makes sense.
> 
> Ok.
> BTW I understand why it is better to have a "pipe" if there is no time:
> 
>   0)             |    do_sync_read() {
>   0)             |      sock_aio_read() {
>   0)             |        __sock_recvmsg() {
>   0)             |          security_socket_recvmsg() {
> 
> But I don't see why it is necessary to have one just after the time:
> 
> !0)  100.319 us |            cap_socket_recvmsg();
> 
> It appears to me as noise....

if you look at it on a console where you look at code, it all looks 
like a straight line:


  0)             |  sys_read() {
  0)    0.331 us |    fget_light();
  0)             |    vfs_read() {
  0)             |      rw_verify_area() {
  0)             |        security_file_permission() {
  0)    0.306 us |          cap_file_permission();
  0)    0.300 us |          cap_file_permission();
  0)    8.909 us |        }
  0)    0.993 us |      }
  0)   11.649 us |    }
  0)             |    do_sync_read() {
                 .   -------------------------
  0)             ==> [ bash-2794 => cat-1234 ]
                     -------------------------


as if the code to the right was on a sheet of paper.


If i understand you correct, are you suggesting this format:

  0)             |  sys_read() {
  0)    0.331 us      fget_light();
  0)             |    vfs_read() {
  0)             |      rw_verify_area() {
  0)             |        security_file_permission() {
  0)    0.306 us            cap_file_permission();
  0)    0.300 us            cap_file_permission();
  0)    8.909 us          }
  0)    0.993 us        }
  0)   11.649 us      }
  0)             |    do_sync_read() {
                 .   -------------------------
  0)             ==> [ bash-2794 => cat-1234 ]
                     -------------------------

i dont think that looks very good.

	Ingo
