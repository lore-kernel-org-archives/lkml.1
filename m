Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYCWEhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYCWEhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 00:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYCWEhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 00:37:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:21614 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYCWEhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 00:37:10 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: /dev/stdin, symlinks & permissions
Date: Sun, 23 Mar 2008 05:35:39 +0100
User-Agent: KMail/1.8.2
Cc: Theodore Tso <tytso@mit.edu>, Michael Tokarev <mjt@tls.msk.ru>,
       Andreas Schwab <schwab@suse.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
References: <47DEFE26.80101@msgid.tls.msk.ru> <20080318125445.GS8368@mit.edu> <20080318143222.GF10722@ZenIV.linux.org.uk>
In-Reply-To: <20080318143222.GF10722@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803230535.40020.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008 15:32, Al Viro wrote:
> On Tue, Mar 18, 2008 at 08:54:45AM -0400, Theodore Tso wrote:
> 
> > The main issue is that at the moment, when you open /proc/self/fd/X,
> > what you get is a new struct file, since the inode is opened a second
> > time.  That is why you have to go through the access control checks a
> > second time, and why there are issues when you have /dev/stdin
> > pointing to a tty which was owned by user 1, and then when you su to
> > user 2, you get a "permission denied" error.
> > 
> > On other operating systems, opening /proc/self/fd/X gives you a
> > duplicate of the file descriptor.  That means that the seek pointer is
> > also duplicated.  This has been remarked upon before.  Linux 1.2 did
> > things "right" (as in, the same as Plan 9 and Solaris), but it was
> > changed in Linux 2.0.  Please see:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/9609.2/0371.html
> 
> The real issue is that it was not Plan 9 semantics to start with.
> 
> See 9/port/devproc.c and 9/port/devdup.c; the former is procfs and
> while it does have <pid>/fd, the sucker is not a directory - it's
> a text file containing (more or less) the pathnames of opened files
> of that process.  The latter is an entirely different thing - it's
> a separate filesystem (#d instead of #p, FWIW).  There you have
> per-descriptor files to open and yes, that'll give you dup().  What
> you do not have there is per-process part.

/me puts his admin hat on

This issue (that /proc/self/fd/0,1,2 don't always work)
is a real problem. I was bitten by it more than once, thrying to do
something like:

setuidgid http_user httpd --log-to-file /proc/self/fd/2

Doesn't work. Which is sort of stupid - I _already_
have fd 2 open, what's the point in prohibiting me from
opening it again?

(As to why: there are lots of software which insist of logging
either to syslog or the file, whereas I really prefer to log
to stdout/stderr.)

> We could implement Plan 9 style dupfs, but to do that without excessive
> ugliness we'd need to change prototype of ->open() - it must be able to
> return a reference to struct file different from anything it got from
> caller; probably the least painful way would be to make it return

I am not an expert, so my question might be stupid, but:
can open("/proc/PID/fd/N") be special-cased to always succeed
if PID = current process' PID and fd N is already open?
--
vda
