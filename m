Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZJXIa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZJXIa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 04:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZJXIa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 04:30:59 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:61640 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZJXIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 04:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ShVKDd7aJqLyuGJpiN5TNo8E5q1A1DHLa4xiaZlbLKjgdywPcKwTjllPOcyxXYHzZi
         uorc5jyLb3jXf5/XwoWa+I6WEIlbNJA6ZbHPiDh30msNL0c7xfjuxgjgK489O7GBEJoE
         JrP2K34XiZH+/7yJ9TLGxnDRPhB+Xa3WU+jMQ=
MIME-Version: 1.0
Date: Sat, 24 Oct 2009 18:31:01 +1000
Message-ID: <e7d8f83e0910240131k3d2d1f94i162c576aeba6f3c6@mail.gmail.com>
Subject: Been thinking about the current schedulers. Should we consider a 
	layers scheduler.
From: Peter Dolding <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cgroups already exist for the top layer of of a layered scheduler.

Inside cfs and most schedulers we do have problems.  If a program is
designed for a different style of scheduler it can run badly.  Dead
line scheduler makes some programs run well but others run Shockley
bad.  CFS can have same issues with particular programs.   We have to
accept no scheduler that runs in a single mode is going to be good for
every application out there.

Most of these issues relate to internal of application locking or the
numbers of threads application creates.

If time is handed out on a per process base then the threads inside
the process gets time allocated as per the processes scheduler.
Internal application design can be allowed for.

Layered scheduler also allows natural greed control before having to
resort cgroups.  If a program creates thousands of threads due to time
being allocated on a per process base then split application with
thousands of threads don't stave the application with only 1 thread
out from getting cpu time.  cgroups can be used to control
applications that go multi PID to stave the system out.

One of the biggest headaches we have are items like pulseaudio and x11
server.  dri2 has reduced X11 server issue.   Application sends
message to these services time is taken to process applications
request from the applications time so allowing pulseaudio and X11 to
skip the waiting until there turn.

A kind of service interlink maybe able to assist web servers under
heavy load from having databases failing to provide data so making
problem worse.   What is the point of open more database requests if
database has not had the chance to process any as you see php and
others do when called by apache to fill request.   In the end
scripting language ends up sending out a whole stack of messages
saying cannot talk to database.  This is only making matters worse.
Not only was the system short of time to process the database requests
is now wasted time sending out junk no one really wants to see or pay
for.

Get a relationship between programs system in scheduler could allow
the scheduler to make more sane selections of what to skip from
getting processor time when under high load.  Like skipping items that
will cause more database requests than database sever can handle.  So
allowing system to be more resistant.


We need some form of system in scheduler to allow scheduler to be
smart and balance on relationships/dependencies.  Its pointless give a
task more processor time if its waiting on an answer from a service
current system is aware of.  But is also a issue of that task is
waiting on an answer giving it time to where the answer must come from
can be a major benefit.

Now a learning system would be great.  This task here communally needs
to wait for X application over here.  So make sure X gets processing
time when task is waiting before queing up more.

This is one place where a dead line gets ahead of CFS.  Items don't
end up queing up waiting on something to get processor time.
Relationship tracking could be key to put processes on the right cpu's
as well.    If X application needs to always talk to Y put them in the
same NUMA section.

Peter Dolding
