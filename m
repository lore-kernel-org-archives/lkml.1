Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYAGVOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYAGVOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYAGVOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:14:30 -0500
Received: from mail.daysofwonder.com ([213.186.49.53]:48624 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYAGVO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:14:29 -0500
Message-ID: <49567.213.41.177.193.1199740466.squirrel@corp.daysofwonder.com>
Date: Mon, 7 Jan 2008 22:14:26 +0100 (CET)
Subject: Re: Strange freeze on 2.6.22 (deadlock?)
From: "Brice Figureau" <brice+lklm@daysofwonder.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, January 7, 2008 20:06, Brice Figureau wrote:
>
> On Mon, January 7, 2008 18:20, Randy Dunlap wrote:
>> On Mon, 07 Jan 2008 16:48:54 +0100 Brice Figureau wrote:
>>
>>> Hi,
>>>
>>> I'm seeing a strange complete server freeze/lock-up on an bi-Xeon HT
>>> amd64 server running standard debian 2.6.22 (and before that vanilla
>>> 2.6.19.x and 2.6.20.x which exhibited the same issue).
>>>
>>> I'm only reporting it now, since I could get a full sysrq-t only this
>>> morning.
>>>
>>> The symptoms are that every 5 to 7 days, the server (which acts as a MX
>>> along with a few low traffic websites) locks-up. The ipmi watchdog is
>>> unable to reboot the server (and doesn't even trigger, since there is
>>> no
>>> evidence in the esmlog), the machine is still pingable. I can't ssh to
>>> it, but I can enter my login & password on a serial console, but no
>>> shell is started.
>>>
>>> Pressing sysrq-t produced the trace hosted here:
>>> http://www.daysofwonder.com/bug/crash-server1.txt.gz
>>>
>>> It happened one time when I was connected to the server through ssh and
>>> I could see that the load started to increase well above 100. It was
>>> then impossible to launch new process from the command-line (and I had
>>> to reboot manually).
>>> It happened also last week, and the server was stuck for about 6 hours.
>>> When I started investigating what was wrong, it slowly came back to
>>> life
>>> (with an avg 1-min load of more than 1500, and tons of cron processes
>>> running in parallel).
>>>
>>> I'm not really familiar with kernel development so I can't really find
>>> the issue in the aforementioned trace output.
>>> What I think is that for some reason there is a race/deadlock that
>>> finally prevents new processes to really start (which in turns produces
>>> the high load).
>>>
>>> What seems suspect in the aforementioned trace is:
>>>  *) lot of processes stacktrace ends in __mod_timer+0xc3/0xd3
>>> which seems to be this line from kernel/timer.c
>>>
>>> 415	timer->expires = expires;
>>> 416	internal_add_timer(base, timer);
>>> -->	spin_unlock_irqrestore(&base->lock, flags);
>>>
>>> 419	return ret;
>>> 420  }
>>>
>>>  *) lot of processes stacktrace ends in __mutex_lock_slowpath and/or
>>> zone_statistics
>>
>> There are also lots of processes in D state (usually waiting
>> for I/O to complete).  And jbd is in their stack traces.
>>
>> How is/are the ext3 filesystems mounted?  I mean what data=xyz
>> mode?  data=journal (the heaviest duty mode) has at least one
>> known deadlock.  If you are using data=journal, you could try
>> switching to data=ordered...
>
> Thanks for the answer.
> I'm using whatever is the default mount option (which I think is
> data=ordered). The only other mount option I use is nodiratime,noatime.

I'm sorry, I stand corrected, there is a data=journal option but not on a
mount point, as an attribute of a bunch of directories (postfix queues):
# lsattr /var/spool/postfix/
-------A-----j---- /var/spool/postfix/active
-------A-----j---- /var/spool/postfix/bounce
-------A-----j---- /var/spool/postfix/corrupt
-------A-----j---- /var/spool/postfix/defer
-------A-----j---- /var/spool/postfix/deferred
-------A-----j---- /var/spool/postfix/flush
-------A-----j---- /var/spool/postfix/hold
-------A-----j---- /var/spool/postfix/incoming
-------A-----j---- /var/spool/postfix/private
-------A-----j---- /var/spool/postfix/maildrop
-------A-----j---- /var/spool/postfix/public
-------A-----j---- /var/spool/postfix/pid
-------A-----j---- /var/spool/postfix/saved
-------A-----j---- /var/spool/postfix/trace

The idea was that queue file are short-lived files and thus they could
only be stored in the journal and never hit the regular data area.

So I might have hit the deadlock you were talking about.
I just disabled this setup, we'll see if that changes anything.

Note that I was using this setup since 2.4 time, the problem appeared only
a few kernel revisions ago (around 2.6.18 I think).

Thanks
-- 
Brice Figureau

