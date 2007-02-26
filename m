Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXBZNgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXBZNgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXBZNgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:36:17 -0500
Received: from smtp105.plus.mail.mud.yahoo.com ([68.142.206.238]:27620 "HELO
	smtp105.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030224AbXBZNgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:36:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=Ea90tlet+PGZ/SprbpX7/delnNbUicPxg+bKj1PephoKB1+tOLyLTwGxw3BHlghStiT74tezEeioO6NRVCtNtWhi2wgoBLQxvQtTqhR5n9KvRok2EAQw8wjCBQwJfWfe5wCZg68G2xJGLF7gasjEAppgHqr1xfgw7FQX72cWMt0=  ;
X-YMail-OSG: VuQ2ZKoVM1lIYiqjorY2iSliAMw9FdOGXXnF9ZUiwoTwgjyWPQmbx0It0SNLB8l7gmLKR7D0g5yA6c1QWLXDIbV_96A6OrWaduAfWpw5vGyGzPFI.l3wOK0TMLZrPsWaIIUqMyCh8ietdVk-
Message-ID: <45E2E244.8040009@yahoo.com.au>
Date: Tue, 27 Feb 2007 00:36:04 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Lorenzo Allegrucci <l_allegrucci@yahoo.it>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com>
In-Reply-To: <45E21FEC.9060605@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050500020307000701080104"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050500020307000701080104
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Rik van Riel wrote:
> Lorenzo Allegrucci wrote:
> 
>> Hi lkml,
>>
>> according to the test below (sysbench) Linux seems to have scalability
>> problems beyond 8 client threads:
>> http://jeffr-tech.livejournal.com/6268.html#cutid1
>> http://jeffr-tech.livejournal.com/5705.html
>> Hardware is an 8-core amd64 system and jeffr seems willing to try more
>> Linux versions on that machine.
>> Anyway, is there anyone who can reproduce this?
> 
> 
> I have reproduced it on a quad core test system.
> 
> With 4 threads (on 4 cores) I get a high throughput, with
> approximately 58% user time and 42% system time.
> 
> With 8 threads (on 4 cores) I get way lower throughput,
> with 37% user time, 29% system time 35% idle time!
> 
> The maximum time taken per query also increases from
> 0.0096s to 0.5273s. Ouch!
> 
> I don't know if this is MySQL, glibc or Linux kernel,
> but something strange is going on...

Like you, I'm also seeing idle time start going up as threads increase.

I initially thought this was a problem with the multiprocessor scheduler,
because the pattern is exactly like some artificat in the load balancing.

However, after looking at the stats, and testing a couple of things, I
think it may not be after all.

I've reproduced this on a 8-socket/16-way dual core Opteron. So far what
I am seeing is that MySQL is having trouble putting enough load into the
scheduler.

Virtually all of the sleep time is coming from unix_stream_recvmsg, which
seems to be what the clients and server threads use to communicate with.
There doesn't seem to be any other tell-tale event that the database is
blocking on.

It seems like it might at least partially be a problem with MySQL
thread/connection management.

I found a couple of interesting issues so far. Firstly, the MySQL version
that I'm using (5.0.26-Max) is making lots of calls to sched_setscheduler
attempting to fiddle with SCHED_OTHER priority in what looks like an
attempt to boot CPU time while holding some resource. All these calls
actually fail, because you cannot change SCHED_OTHER priority like that.
Adding a hack to make it fall through to set_user_nice provides a boost
which eliminates the cliff (but a downward degredation is still there).

Secondly, I've raised the thread numbers from 16 to 32 for my system,
which also provides a bit more (although doesn't help the downward
slope).

Combined, it looks like around 30-40% improvement past 16 threads. It
isn't anything like making up for the dropoff seen in the blog link, but
different systems, different mysql version... I wonder how close we are
with this hack in place?

Attached is a graph of my numbers, from 1 to 32 clients. plain = 2.6.20.1,
sched is with the attached sched patch, and thread is with 32 rather than
16 clients.

Anyway, I'll keep experimenting. If anyone from MySQL wants to help look
at this, send me a mail (eg. especially with the sched_setscheduler issue,
you might be able to do something better).

Nick

-- 
SUSE Labs, Novell Inc.

--------------050500020307000701080104
Content-Type: image/png;
 name="graph.png"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="graph.png"

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
QmCC
--------------050500020307000701080104
Content-Type: text/plain;
 name="mysql-hack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mysql-hack.patch"

--- kernel/sched.c.orig	2007-02-26 11:46:46.849841000 +0100
+++ kernel/sched.c	2007-02-26 12:04:09.283056000 +0100
@@ -4227,8 +4227,6 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if (is_rt_policy(policy) != (param->sched_priority != 0))
-		return -EINVAL;
 
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
@@ -4302,6 +4300,13 @@ recheck:
 
 	rt_mutex_adjust_pi(p);
 
+	if (!is_rt_policy(policy)) {
+                if (param->sched_priority == 8)
+                        set_user_nice(p, -20);
+                else
+                        set_user_nice(p, param->sched_priority-6);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);

--------------050500020307000701080104--
Send instant messages to your online friends http://au.messenger.yahoo.com 
