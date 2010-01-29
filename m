Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380Ab0A2XY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0A2XY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575Ab0A2XY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:24:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46761 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0A2XYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:24:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ptCzlqCr9QhQSfn4XX1+E3n2iySkhnVJAXo7WkeRgFAscT6Ww77+8sc7WYzH0C0nAg
         0Z07b7hybIIb4y/788n+rfkzv5pKGcEwmx2zp9oVa+A/veYCulno8AxNhAVWOuTAdjxr
         +er6l+oex75hP8DJBQiTPym0WUVgWCmmL5YAE=
Date: Sat, 30 Jan 2010 00:17:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Lock dependency based tree report in perf lock
Message-ID: <20100129231723.GB5052@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at the report layout we have with perf lock, it gives
a cool overview of per lock waittime, acquire time, by avg/max,
that's cool.

Now to complete the overview through another dimension we could
have another mode on top of a lock dependency based tree:

-- 125 ms -- lock1
             |
             -- 100 ms -- lock2
             |              |
             |               -- 99 ms -- lock 3
             |              |
             |               -- 16 us -- lock 4
             |                            |
             |                            ----- [...]
             |
             --  25 ms -- lock 5


Having such view can tell you which lock is delaying another
one. We could have this view by average or maximum of acquired
time (waittime here would be pointless).

And we can also report the outer locking noise time for these
reports.
Taking the above example:

-- 100 ms/84 us -- lock2
                   |
                   -- 99 ms -- lock 3
                   |
                   -- 16 us -- lock 4
                               |
                               ----- [...]


100 ms is the time lock2 has been acquired.
Lock 3 has been acquired 99 ms and lock 4 during 16 us,
which means the outer locking noise (the code executed
outside children locks) is of 84 us.

This noise can give a good rough glance of the influence
childs locks can have on a parent. This is somehow the child
weight, this all can even be expressed using percentages,
we could even reproduce the absolute/relative percentage
we currently have with the callchains in perf report
(-g graph for absolute, -g fractal for relative).

Or we can have a ghost child for each locks that represent
the outer child locks noise:

-- parent percentage -- lock2
                        |
                        -- 99 %   -- lock 3
                        |
                        -- 0.84 % -- noise // could have its own color for quick distinguishing
                        |
                        -- 0.16 % -- lock 4
                                     |
                                     ----- [...]

May be just one tricky thing.
Say we have lock3 and lock4 that depend on lock2,
it doesn't always means lock4 will always be taken after
lock3, it doesn't even mean lock4 will ever be taken after
lock3.

So we shouldn't have one branch per dependency but one
branch per practical scenario encountered.

So imagine we have the following dependency:

lock2
 |
 --- lock3
 |
 --- lock4
 |
 --- lock5

But we can actually have only the following scenarios:

lock2
|
-- lock3
|
-- lock4

lock2
|
-- lock4

lock2
|
-- lock5


Then we need three branches:

-- lock2 percentage -- lock2
                        |
                        -- 60 %
                        |   |
                        |   -- 90 % -- lock 3
                        |   |
                        |    -- 9 %  -- noise
                        |   |
                        |    -- 1 %  -- lock 4
                        |
                        -- 20 %
                        |   |
                        |    -- 99 % -- lock4
                        |   |
                        |   --  1 %  -- noise
                        |
                        -- 20 %
                            |
                             -- 14 % -- lock5
                            |
                             -- 86 % -- noise



Hopefully we could have such expandable tree using
ncurses, but we can probably start like callchains in
perf report.

There might also be a problem with the accuracy.
The max time lock2 is acquired won't always match
the path where lock3 and lock4 had their max time too,
but this should give, most of the time, a view close to
the reality, especially once we enter non-sleepable lock
branches.

Anyway, that's just an idea, not trivial I must admit.

