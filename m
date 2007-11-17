Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbXKQQ04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbXKQQ04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 11:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXKQQ0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 11:26:47 -0500
Received: from homer.mvista.com ([63.81.120.158]:10148 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXKQQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:26:46 -0500
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
From: Daniel Walker <dwalker@mvista.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 17 Nov 2007 08:22:30 -0800
Message-Id: <1195316550.25393.21.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-11-17 at 12:44 +0100, Remy Bohmer wrote:
> Hello Steven,
> 
> > The taker of a mutex must also be the one that releases it.  I don't see
> > how you could use a mutex for this. It really requires some kind of
> > completion, or a compat_semaphore.
> 
> I tried several ways of working around the bug, even tried
> implementing it with kernel threads and protecting global data with
> mutexes. Therefor I know that I have the same problem with mutexes. I
> just created a simple example that showed the problem quickly, this
> does not mean that this is the only case that does not work.

I tried your example and I was able to reproduce the OOPS that you
found.. Although there is one problem, you don't have the same number of
up()'s to down() calls so you end up leaving the dummy_read function
with the lock still held ..

Reviewing the OOPS and the warnings it looks like your progressively
corrupting the mutex waiter list since remove_waiter() actually leaves
the stack based waiter object on the waiter list.. (That's what it looks
like anyway)..

So I converted your code to use a compat_semaphore, and no oops
happens.. Which makes sense because compat_semaphores are designed to
work the way your using them.

Daniel

