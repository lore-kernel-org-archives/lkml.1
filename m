Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZAHLzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZAHLzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZAHLzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:55:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZAHLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:55:43 -0500
Date: Thu, 8 Jan 2009 12:55:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
Message-ID: <20090108115530.GA1539@elte.hu>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com> <20090107212912.e2903579.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107212912.e2903579.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 7 Jan 2009 23:58:39 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  kernel/trace/ring_buffer.c |    8 +++++++-
> 
> <looks>
> 
> heavens, what a lot of inlining.  Looks like something from 1997 :)
> 
> Prove me wrong!
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
>           text    data     bss     dec     hex filename
> before:  11320     228       8   11556    2d24 kernel/trace/ring_buffer.o
> after:   10592     228       8   10828    2a4c kernel/trace/ring_buffer.o

You are wrong :-)

With x86 defconfig and gcc 4.3.2 i get zero change in size:

  kernel/trace/ring_buffer.o:

     text	   data	    bss	    dec	    hex	filename
    11485	    228	      8	  11721	   2dc9	ring_buffer.o.before
    11485	    228	      8	  11721	   2dc9	ring_buffer.o.after

  md5:
     55447563cd459bbb02c6234b2544fcc2  ring_buffer.o.before.asm
     55447563cd459bbb02c6234b2544fcc2  ring_buffer.o.after.asm

(i took out the free_page() bit to only measure the inlining)

That is the same with and without CONFIG_OPTIMIZE_INLINING - i.e. recent 
GCC gets the inlining right.

Really, we should stop bothering about inlines on the source code level 
(the kernel has 20,000 inlines and around 100,000 functions - do we really 
want to maintain inlining information on a per function basis?) - and we 
should tell the GCC folks when the compiler messes up some detail.

Or if GCC messes up inlining so much in the future that we cannot live 
with it, we can go back to "always inline" and manual annotations again. 
Or write a new compiler. (the latter is probably less work ;-)

	Ingo
