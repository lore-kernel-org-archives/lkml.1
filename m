Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZF3R06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZF3R06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZF3R0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:26:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39195 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZF3R0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:26:51 -0400
Subject: Re: fanotify: the fscking all notification system
From: Eric Paris <eparis@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net
In-Reply-To: <22424.1246368155@turing-police.cc.vt.edu>
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
	 <22424.1246368155@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 13:26:37 -0400
Message-Id: <1246382797.22562.16.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 09:22 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 29 Jun 2009 16:08:45 EDT, Eric Paris said:
> 
> > fanotify provides two things:
> > 1) a new notification system, sorta like inotify, only instead of an
> > arbitrary 'watch descriptor' which userspace has to know how to map back
> > to an object on the filesystem, fanotify provides an open read-only fd
> > back to the original object.  It should be noted that the set of
> > fanotify events is much smaller than the set of inotify events.
> > 
> > 2) an access system in which processes may be blocked until the fanotify
> > userspace listener has decided if the operation should be allowed.
> 
> I don't care much about virus scanners - but some of us with petabytes of
> disk space to manage could use tis for HSM applications.  The HSM daemon
> could fanotify on the file, notice that the file accessed referred to a
> special "I've been archived" stub/token, and put the file back before
> giving the go-ahead to the process.
> 
> The only sticky question - does this happen early enough that the accessing
> process, when un-blocked, will continue through open() and get the *new*
> version of the newly restored file?

Yes.  Although it going to take just a tiny bit of work from me and you
are limited in how to use it.

You'll need to request FAN_OPEN_PERM on the file in question.  When the
file is opened you will need to bring in all the data and write all that
data into the file.  There is no mechanism to only bring in a piece of a
file since you have no way of knowing what exactly the requesting
process is requesting.   So it's a whole file or nothing type of deal.

Current problems:

1) the fd the fanotify listener gets is O_RDONLY.  I think I'll add an
"f_flags" option which if 0 defaults to O_RDONLY|O_LARGEFILE like we
have today but which you could use to indicate O_RDWR or O_WRONLY.  We
currently give O_RDONLY since you can't request O_WR* on files/libraries
mapped exec, so this won't work for executables.....

2) Right now you have 5 seconds to answer an fanotify permissions
request, if you don't get it in 5 seconds you are done and the original
process gets an allow.  But I have a half finished patch which would
allow you to delay them infinitely.  As long as you keep them delayed
you can modify the file they are about to access however you like.

You can not rename over the fd you are given, you have to actually copy
the data into that fd, since the inode behind the fd you got from
fanotify is the same inode the original process is going to get access
to after your listener sends an allow.

This sound good to you?  I don't know your details, but I believe that
fanotify directed mode with access permissions is going to be almost
exactly what you want....

-Eric

