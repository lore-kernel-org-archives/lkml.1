Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbXH1Qpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbXH1Qpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbXH1QpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:45:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44349 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853AbXH1QpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:45:16 -0400
Date: Tue, 28 Aug 2007 09:44:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Boldi <a1426z@gawab.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070828094438.2af76c39@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.999.0708280929000.25853@woody.linux-foundation.org>
References: <200708111344.42934.a1426z@gawab.com>
	<200708280737.53439.a1426z@gawab.com>
	<alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
	<200708280823.53663.a1426z@gawab.com>
	<alpine.LFD.0.999.0708280929000.25853@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 09:34:03 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 28 Aug 2007, Al Boldi wrote:
> > 
> > I like your analysis, but how do you explain that these stalls
> > vanish when __update_curr is disabled?
> 
> It's entirely possible that what happens is that the X scheduling is
> just a slightly unstable system - which effectively would turn a
> small scheduling difference into a *huge* visible difference.

one thing that happens if you remove __update_curr is the following
pattern (since no apps will get preempted involuntarily)

app 1 submits a full frame worth of 3D stuff to X 
app 1 then sleeps/waits for that to complete
X gets to run, has 1 full frame to render, does this
X now waits for more input
app 2 now gets to run and submits a full frame
app 2 then sleeps again
X gets to run again to process and complete
X goes to sleep
app 3 gets to run and submits a full frame
app 3 then sleeps
X runs
X sleeps
app 1 gets to submit a frame

etc etc

so without preemption happening, you can get "perfect" behavior, just
because everything is perfectly doing 1 thing at a time cooperatively.
once you start doing timeslices and enforcing limits on them, this
"perfect pattern" will break down (remember this is all software
rendering in the problem being described), and whatever you get won't
be as perfect as this.
