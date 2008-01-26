Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYAZF3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYAZF3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYAZF3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:29:32 -0500
Received: from [212.12.190.175] ([212.12.190.175]:60692 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532AbYAZF3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:29:30 -0500
From: Al Boldi <a1426z@gawab.com>
To: Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Sat, 26 Jan 2008 08:28:07 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <4799393A.5090605@redhat.com>
In-Reply-To: <4799393A.5090605@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200801260828.07459.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Al Boldi wrote:
> > Greetings!
> >
> > data=ordered mode has proven reliable over the years, and it does this
> > by ordering filedata flushes before metadata flushes.  But this
> > sometimes causes contention in the order of a 10x slowdown for certain
> > apps, either due to the misuse of fsync or due to inherent behaviour
> > like db's, as well as inherent starvation issues exposed by the
> > data=ordered mode.
> >
> > data=writeback mode alleviates data=order mode slowdowns, but only works
> > per-mount and is too dangerous to run as a default mode.
> >
> > This RFC proposes to introduce a tunable which allows to disable fsync
> > and changes ordered into writeback writeout on a per-process basis like
> > this:
> >
> >       echo 1 > /proc/`pidof process`/softsync
> >
> >
> > Your comments are much welcome!
>
> This is basically a kernel workaround for stupid app behavior.

Exactly right to some extent, but don't forget the underlying data=ordered 
starvation problem, which looks like a genuinely deep problem maybe related 
to blockIO.

> It
> wouldn't be the first time we've provided such an option, but we shouldn't
> do it without a very good justification.  At the very least, we need a
> test case that demonstrates the problem

See the 'konqueror deadlocks in 2.6.22' thread.

> and benchmark results that prove that this approach actually fixes it.

8M-record insert into indexed db-table:
         ordered  writeback
sqlite3:  75m22s    8m45s
mysql4 :  23m35s    5m29s

> I suspect we can find a cleaner fix for the problem.

I hope so, but even with a fix available addressing the data=ordered 
starvation issue, this tunable could remain useful for those apps that 
misbehave.


Thanks!

--
Al

