Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbZDABPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbZDABPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbZDABPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:15:04 -0400
Received: from france.micfo.com ([92.48.68.3]:45044 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbZDABPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:15:02 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 and the "30 second window of death"
Date: Wed, 1 Apr 2009 03:14:55 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28-ARCH; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <200903311645.29038.info@gnebu.es> <20090401000447.GG15063@mit.edu>
In-Reply-To: <20090401000447.GG15063@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904010314.55288.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted,

I agree with all you've said and now I really think we're making way too much 
fuss about a quite simple issue (we, stupid users). 

On Wednesday 01 April 2009 02:04:47 Theodore Tso wrote:
> Quite frankly, the people who are complaining about "fsync() will burn
> too much problem" are really protesting way too much.  

Yes, I guess you're right. Filesystem behaviour is not going to make that much 
difference, it's user's and application's behaviour what will determine battery 
life (plus hardware capabilities, obviously).

> Firefox wants to replace a large number of files (and in practice
> writes 2.5 megabytes of data) each time you click on a link.  (This is
> not great for SSD write endurance; after browsing 400 links, you've
> written over a gigabyte to your SSD.) 

Agreed. In fact I always thought that the ext3+fsync problem with Firefox was 
mostly a myth. The fact is that Firefox 3 has some rather unrealistic settings 
that cause an insane amount of I/O (disk, but also network I/O). I was using 
an old computer with a very slow 40Gb @ 5400 IDE HD at the time F3 came out 
and had some problems. After going through all the options and choosing 
reasonable settings the problems went away forever (but then I use Firefox 
reasonably, not with a couple hundreds of tabs opened at the same time - no 
filesystem can fix that).

> But let's be realistic here; if
> you're browsing the web, the power used by running flash animations by
> the web browser, not to mention the power costs of the WiFi is
> probably at least as much if not more than the cost of spinning up the
> disk.

Since I just tested this the other day, I'll post the numbers: With flash 
enabled, Konqueror visiting 3 pages, one of them with one small flash add, my 
battery lasted for 184 minutes (for an average or 8.5 watts out of my 26w/h 
battery). Without flash, 205 minutes, an average of 7.6 watts (this is on an HP 
mini netbook).

Anyway, I agree with all the below too. Thanks again for the detailed 
explanation.

Regards,
Alberto.

>
> At least when I'm running on batteries, I keep the number of
> applications down to a minimum, and regardless of whether we are
> batching I/O's using laptop mode or not, it's *always* going to save
> more power to not do file I/O at all than to do file I/O with some
> kind of batching scheme.  So the folks who are saying that they can't
> afford to fsync() every single file for power reasons really are
> making an excuse; the reality is that if they were really worried
> about power consumption, they would be going out of their way to avoid
> file writes unless it's really necessary.  It's one thing if a user
> wants to save their Open Office document; when the user wants to save
> it, they should save it, and it should go to disk pretty fast --- how
> much work the user is willing to risk should be based on how often the
> user manually types ^S, or how the user configures their application
> to do periodic auto-saves --- whether that's once a minute, or every 3
> minutes, or every 5 minutes, or every 10 minutes.
>
> But if there's some application which is replacing hundreds of files a
> minute, then that's the real problem, whether they use fsync() or not.
>
> Now, while I think the whole, "we can't use fsync() for power reasons
> is an excuse", it's also true that we're not going to be able to
> change all applications at a drop of a hat, and may in fact be
> impossible to fix all applications, perhaps for years to come.  It is
> for that reason that ext4 has the replace-via-truncate and
> replace-via-rename workarounds.  These currently start I/O as soon as
> the file is closed (if it had been previously truncated), or renamed
> (if it overwrites a target file).  From a power perspective, it would
> have been better to wait until the next commit boundary to initiate
> the I/O (although doing it right away is better from an I/O smoothing
> perspective and to reduce fsync latencies).  But again, if the
> application is replacing a huge number of files on a frequent basis,
> that's what's going to suck the most amount of power; batching to
> allow the disk to spin down might save a little, but fundamentally the
> application is doing something that's going to be a massive power
> drain anyway.
>
> > The problem I guess is that right now application writers targeting
> > Ext4 must choose between using fsync and giving users the 'A'
> > behaviour or not using fsync and giving them the 'C' behaviour. But
> > what most users would like is 'B', I'm afraid (at least, it's what I
> > want, I might be an exception).
>
> So no, application programmers don't have to choose; if they do things
> the broken (old) way, assuming ext3 semantics, users won't lose
> existing files, thanks to the workaround patches.  Those applications
> will be unsafe for many other filesystems and operating systems, but
> maybe those application writers don't care.  Unfortunately, I confused
> a lot of people by telling people they should use fsync(), instead of
> saying, "that's OK, ext4 will take care of it for you", because I care
> about application portability.  But I implemented the application
> workarounds *first* because I knew that it would take a long time for
> people to fix their applications.   Users will be protected either way.
>
> If applications use fsync(), they really won't be using much in the
> way of extra power, really!  If they are replacing hundreds of files
> in a very short time interval, and doing that all the time, then that's
> going to burn power no matter what the filesystem tries to do.
>
> Regards,
>
> 						- Ted

