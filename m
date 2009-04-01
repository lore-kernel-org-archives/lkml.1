Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbZDAAFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbZDAAFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758976AbZDAAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:04:54 -0400
Received: from thunk.org ([69.25.196.29]:59706 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbZDAAEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:04:53 -0400
Date: Tue, 31 Mar 2009 20:04:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090401000447.GG15063@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alberto Gonzalez <info@gnebu.es>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200903311645.29038.info@gnebu.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903311645.29038.info@gnebu.es>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 04:45:28PM +0200, Alberto Gonzalez wrote:
> 
> A - Writing data to disk immediately and lose no work at all, but get worse 
> performance/battery life/HDD lifespan (this is what happens when an 
> application uses fsync, right?). 

People are stressing over the battery usage of spinning up the disk
when you write a file, but in practice, if you're writing an
OpenOffice file, you're probably only going to be typing ^S every 45
seconds?  Every couple of minutes?  So the fsync() caused by
Openoffice saving out your 300 page Magnum Opus really isn't going to
make that big of a difference to your battery life --- whether it
happens write away when you hit ^S, or whether it happens some 30 or
120 seconds later, isn't really a big deal.

The problem comes when you have lots of applications open on the
desktop, and for some reason they all decide they need to be writing a
huge number of files every few seconds.  That seems to be the concern
that people have with respect to wating to batch spinning up the disk
in order to save power.  So for example, if every time you get an
instant message via AIM or IRC, your Pidgin client wants to write the
message to a log file, should Pidgin try to fsync() that write?  Right
now, if Pidgin doesn't call fsync(), with ext3, in practice your IM
will be written to disk after 5 seconds.  With ext4, your IM might not
get written to disk until around 30 seconds.  Since Pidgin isn't
replacing the log file, but rather appending to it, it's not a case of
losing the previous work, but rather not simply getting the latest
IM's pushed to stable storage as quickly.

Quite frankly, the people who are complaining about "fsync() will burn
too much problem" are really protesting way too much.  How often,
really, should applications be replacing files?  Apparently KDE
replaces hundreds the files in some configurations at desktop startup,
but most people seem to agree this is a bug.

Firefox wants to replace a large number of files (and in practice
writes 2.5 megabytes of data) each time you click on a link.  (This is
not great for SSD write endurance; after browsing 400 links, you've
written over a gigabyte to your SSD.)  But let's be realistic here; if
you're browsing the web, the power used by running flash animations by
the web browser, not to mention the power costs of the WiFi is
probably at least as much if not more than the cost of spinning up the
disk. 

At least when I'm running on batteries, I keep the number of
applications down to a minimum, and regardless of whether we are
batching I/O's using laptop mode or not, it's *always* going to save
more power to not do file I/O at all than to do file I/O with some
kind of batching scheme.  So the folks who are saying that they can't
afford to fsync() every single file for power reasons really are
making an excuse; the reality is that if they were really worried
about power consumption, they would be going out of their way to avoid
file writes unless it's really necessary.  It's one thing if a user
wants to save their Open Office document; when the user wants to save
it, they should save it, and it should go to disk pretty fast --- how
much work the user is willing to risk should be based on how often the
user manually types ^S, or how the user configures their application
to do periodic auto-saves --- whether that's once a minute, or every 3
minutes, or every 5 minutes, or every 10 minutes.

But if there's some application which is replacing hundreds of files a
minute, then that's the real problem, whether they use fsync() or not.

Now, while I think the whole, "we can't use fsync() for power reasons
is an excuse", it's also true that we're not going to be able to
change all applications at a drop of a hat, and may in fact be
impossible to fix all applications, perhaps for years to come.  It is
for that reason that ext4 has the replace-via-truncate and
replace-via-rename workarounds.  These currently start I/O as soon as
the file is closed (if it had been previously truncated), or renamed
(if it overwrites a target file).  From a power perspective, it would
have been better to wait until the next commit boundary to initiate
the I/O (although doing it right away is better from an I/O smoothing
perspective and to reduce fsync latencies).  But again, if the
application is replacing a huge number of files on a frequent basis,
that's what's going to suck the most amount of power; batching to
allow the disk to spin down might save a little, but fundamentally the
application is doing something that's going to be a massive power
drain anyway.

> The problem I guess is that right now application writers targeting
> Ext4 must choose between using fsync and giving users the 'A'
> behaviour or not using fsync and giving them the 'C' behaviour. But
> what most users would like is 'B', I'm afraid (at least, it's what I
> want, I might be an exception).

So no, application programmers don't have to choose; if they do things
the broken (old) way, assuming ext3 semantics, users won't lose
existing files, thanks to the workaround patches.  Those applications
will be unsafe for many other filesystems and operating systems, but
maybe those application writers don't care.  Unfortunately, I confused
a lot of people by telling people they should use fsync(), instead of
saying, "that's OK, ext4 will take care of it for you", because I care
about application portability.  But I implemented the application
workarounds *first* because I knew that it would take a long time for
people to fix their applications.   Users will be protected either way.

If applications use fsync(), they really won't be using much in the
way of extra power, really!  If they are replacing hundreds of files
in a very short time interval, and doing that all the time, then that's
going to burn power no matter what the filesystem tries to do.

Regards,

						- Ted
