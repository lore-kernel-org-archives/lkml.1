Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbXHJOdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbXHJOdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbXHJOd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:33:29 -0400
Received: from web54403.mail.yahoo.com ([206.190.49.133]:45918 "HELO
	web54403.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757594AbXHJOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:33:28 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 10:33:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3ZKESlx1ZInxQbr0v7Tl++pbDN+N/b8vW0I2rjPVA8dRqHRUPP5lSm/IM1QGElq3FbqiDtaUtGxHjpIuN5kfMazLTy3kGRByLdFtnynfjPiqW1UTel+I8rg58S9tPMJDjS7A+yHUOL3AIQYLtDaAp0SSDWDUryBmu/ciPwDJTE0=;
X-YMail-OSG: 1NxIoMAVM1lSdyesjRQgJ50_.W_hykd_GF2VtxelqLq.07F3zk6klu2Z28RRNMPqNOsXvZ29sNZ.mKliMMQNl.fqlJYgPkym6HnOnUuL4UfhtV1Ln2pvPyFHJ7d1
Date: Fri, 10 Aug 2007 07:26:46 -0700 (PDT)
From: Vlad <vladc6@yahoo.com>
Subject: Noatime vs relatime
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <233939.75965.qm@web54403.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> What we could do is to make "relatime" updates a bit smarter.
> 
> A bit smarter would be:
> 
> - update atime if the old atime is <= than mtime/ctime
>
> Logic: things like mailers can care about whether some
> new state has 
> been read or not. This is the current relatime.
> 
> - update atime if the old atime is more than X seconds
> in the past (defaulting to one day or something)
> 
> Logic: things like tmpwatch and backup
> software may want to remove 
> stuff that hasn't been touched in a long time, but they
> sure don't care about "exact" atime.

Relatime seems to be wasteful of both IO resources _and_ CPU cycles.
Instead of performing a single IO operation (as atime does), relatime
performs at least three IO operations and three CPU-dependent
operations:

1) a read IO operation to find out the old atime
2) a read IO operation to find out the old ctime
3) a read IO operation to find out the old mtime
4) Comparison of "old atime is <= than mtime/ctime"
5) Find out current time
6) Comparison of "current time minus old atime is > X"

People are going to wonder why all of the sudden everything is running
so slow due to atimes being updated after a long break.

I suggest treating atime as if it were a subsystem that is scheduled
for an overhaul - there have been plenty of those in the past. Give
users/distros a config option to disable atime, but default this
option in favor of atime for a couple of kernel release cycles. Print
a line in dmesg that states something like:

"Warning: Atime will be disabled by default in future kernel versions,
but you will still be able to turn it on when configuring the kernel."

This should give a heads-up to the 0.001% of people who still use
atime so that they know to customize this option or start using modern
file-monitoring techniques like inotify.

Vlad


       
____________________________________________________________________________________
Pinpoint customers who are looking for what you sell. 
http://searchmarketing.yahoo.com/
