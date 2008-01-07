Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYAGRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYAGRWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAGRWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:22:33 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42602 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYAGRWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:22:33 -0500
Date: Mon, 7 Jan 2008 09:20:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Brice Figureau <brice+lklm@daysofwonder.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange freeze on 2.6.22 (deadlock?)
Message-Id: <20080107092048.4bf12349.randy.dunlap@oracle.com>
In-Reply-To: <1199720934.11173.49.camel@localhost.localdomain>
References: <1199720934.11173.49.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jan 2008 16:48:54 +0100 Brice Figureau wrote:

> Hi,
> 
> I'm seeing a strange complete server freeze/lock-up on an bi-Xeon HT
> amd64 server running standard debian 2.6.22 (and before that vanilla
> 2.6.19.x and 2.6.20.x which exhibited the same issue).
> 
> I'm only reporting it now, since I could get a full sysrq-t only this
> morning.
> 
> The symptoms are that every 5 to 7 days, the server (which acts as a MX
> along with a few low traffic websites) locks-up. The ipmi watchdog is
> unable to reboot the server (and doesn't even trigger, since there is no
> evidence in the esmlog), the machine is still pingable. I can't ssh to
> it, but I can enter my login & password on a serial console, but no
> shell is started.
> 
> Pressing sysrq-t produced the trace hosted here:
> http://www.daysofwonder.com/bug/crash-server1.txt.gz
> 
> It happened one time when I was connected to the server through ssh and
> I could see that the load started to increase well above 100. It was
> then impossible to launch new process from the command-line (and I had
> to reboot manually).
> It happened also last week, and the server was stuck for about 6 hours.
> When I started investigating what was wrong, it slowly came back to life
> (with an avg 1-min load of more than 1500, and tons of cron processes
> running in parallel).
> 
> I'm not really familiar with kernel development so I can't really find
> the issue in the aforementioned trace output.
> What I think is that for some reason there is a race/deadlock that
> finally prevents new processes to really start (which in turns produces
> the high load).
> 
> What seems suspect in the aforementioned trace is:
>  *) lot of processes stacktrace ends in __mod_timer+0xc3/0xd3
> which seems to be this line from kernel/timer.c
> 
> 415	timer->expires = expires;
> 416	internal_add_timer(base, timer);
> -->	spin_unlock_irqrestore(&base->lock, flags);
> 
> 419	return ret;
> 420  }
> 
>  *) lot of processes stacktrace ends in __mutex_lock_slowpath and/or zone_statistics

There are also lots of processes in D state (usually waiting
for I/O to complete).  And jbd is in their stack traces.

How is/are the ext3 filesystems mounted?  I mean what data=xyz
mode?  data=journal (the heaviest duty mode) has at least one
known deadlock.  If you are using data=journal, you could try
switching to data=ordered...


> Anyway, I will soon reboot to a 2.6.23.x to see if that symptom
> persists.
> More information (config, server specs) are available on request.
> 
> I'm not subscribed to the list, so please CC: me for any anwser.
> Many thanks,


---
~Randy
