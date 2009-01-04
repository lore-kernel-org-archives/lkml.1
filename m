Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbZADXjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbZADXjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZADXjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:39:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:55279 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751454AbZADXjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:39:01 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/jsOA6ZPLj6OaiCm9vqD3NqRFeTaoui+2Blqf4Aw
	ltaOh4MRA78gXC
Date: Mon, 5 Jan 2009 00:38:55 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090104233855.GA17021@alice>
References: <20090102111819.GC6088@alice> <20090102175853.GC6842@linux.vnet.ibm.com> <20090102185303.GC5743@linux.vnet.ibm.com> <20090102195326.GF6842@linux.vnet.ibm.com> <20090102231239.GA19778@alice> <20090103015748.GL6842@linux.vnet.ibm.com> <20090103094003.GA6149@alice> <20090104013254.GG6958@linux.vnet.ibm.com> <20090104145726.GA14895@alice> <20090104211349.GS6958@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090104211349.GS6958@linux.vnet.ibm.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 00:36:54 up 11:03,  9 users,  load average: 0.28, 0.59, 0.50
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sun, Jan 04, 2009 at 03:57:26PM +0100, Eric Sesterhenn wrote:
> > 
> > Just tell me what i need to do, I am not really familiar with ftrace.
> > I am only able to test 2.6.28-04980-gb58602a, since current -git is not
> > able to boot on this box :|
> 
> Very cool!
> 
> The idea is to have __call_rcu() in kernel/rcutree.c record the
> address of the callback (argument "head") and the function (argument
> "func").  In rcu_do_batch(), just before invoking list->func(list),
> also record the address of the callback ("list") and the function
> (again, "func").
> 
> The new ftrace package has some mechanisms for doing this, but there is
> always the old-fashioned way of using printk(), for example in
> rcu_do_batch():
> 
> 	prefetch(next);
> 	if (rcu_dump_callbacks)
> 		printk("rcu_head=%p, func=%p\n", list, func);
> 	list->func(list);
> 
> Initialize rcu_dump_callbacks to zero, then use a small kernel module
> (or some such) to set it to one just before running your test.

i did it via the ugly printk and captured it via netconsole

for the box with rcutree you can find the log here:
http://www.cccmz.de/~snakebyte/200.log
The interesting part seems start at 155.858923, thats when I load
the rcutorture module

with http://www.cccmz.de/~snakebyte/200_1.log i had another try,
actually saw a rcu_do_batch: rcu_head=d1907720, func=(null) in the traces,
box went into unresponsive mode afterwards

And just in case it helps somehow: http://www.cccmz.de/~snakebyte/200_3.log

for the one with rcupreemt you can find the log here:
http://www.cccmz.de/~snakebyte/201.log
rcutorture is loaded at 87.312399

Greetings, Eric
