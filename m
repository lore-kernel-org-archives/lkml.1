Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXKZPpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXKZPpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXKZPpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:45:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:51561 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279AbXKZPpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:45:07 -0500
Date: Mon, 26 Nov 2007 16:45:04 +0100
From: Jan Kara <jack@suse.cz>
To: paulo.nogueira@ist.utl.pt
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/inode.c
Message-ID: <20071126154504.GF16773@duck.suse.cz>
References: <200711221820.lAMIKFkQ005124@cfif3.ist.utl.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711221820.lAMIKFkQ005124@cfif3.ist.utl.pt>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-11-07 18:20:15, paulo@cfif3.ist.utl.pt wrote:
>   Hi,
> 
> >  Thanks for report. It looks like a problem in UDF. Actually I think
> > I've already seen a similar report. Are there any IO errors in the logs
> > or anything else suspitious?
> 
> 
>  At the risk of reporting further bugs :-) here it goes:
> 
> =======================================================================
> 
>  1)
> 
>  Something I've recently reported to the e-mail address listed
>  on the mkudffs manpage:
> 
>  ...a small problem with mkudffs, as obtained from
>  udftools-1.0.0b3-7.fc6.
> 
>  The problem is as follows: if I take a new DVD-RAM, create (say)
>  an ext3 filesystem, and some time later I run mkudffs over it,
>  then when I try to mount it the disk still seems to remember
>  about having had a previous filesystem.
>  What I mean is that mount may succeed if one specifies the newer
>  filesystem, at least if no files have been copied yet, and also
>  succeed with the older filesystem.
> 
>  Here is an example, for the same disk(!) without any formatting
>  nor copying in between (note also the dates)
> 
> # mount /dev/scd0 /mnt/dvd -t udf
> # ll /mnt/dvd/
> total 4
> drwxr-xr-x  3 root root   92 2007-11-21 18:34 ./
> drwxr-xr-x 13 root root 4096 2007-09-03 17:27 ../
> drwxr-xr-x  2 root root   40 2007-11-21 18:34 lost+found/
> 
> # umount /mnt/dvd
> # mount /dev/scd0 /mnt/dvd -t ext3
> # ll /mnt/dvd/
> total 24
> drwxr-xr-x  3 root root  4096 2007-11-21 19:29 ./
> drwxr-xr-x 13 root root  4096 2007-09-03 17:27 ../
> drwx------  2 root root 16384 2007-11-21 19:29 lost+found/
> 
> 
>  Eventually I found that I could erase the (or at least part of the)
>  information that remained from ext3 by using fdisk to set a filesystem
>  of type "0" ("empty") and then running mkudffs over.
> 
>  That is not very practical of course, and I am also not completely
>  sure that no other outdated info remains on the disk.
  Well, this is a problem of mkudffs. As you write, it should erase few
blocks in the beginning of the filesystem so that it's not detected as some
other filesystem. If you actually mount it as the older filesystem, nasty
things can happen to the new one.
  If you got no answer so far, try reporting the problem here:
http://sourceforge.net/projects/linux-udf/

> =======================================================================
> 
>  2)
> 
>  With 2.6.24-rc1-git10 (did not see it with other kernels yet)
> 
>  # find /proc -name cdrom
>  /proc/sys/dev/cdrom
>  find: WARNING: Hard link count is wrong for /proc/net: this may be
>  a bug in your filesystem driver.  Automatically turning on find's
>  -noleaf option.  Earlier results may have failed to include
>  directories that should have been searched.
  Definitely unconnected to your UDF problems :) /proc is a bit special
filesystem and find(1) is sometimes confused by that fact. Using -noleaf
for it is always a good idea.

> =======================================================================
> 
>  3)
> 
>  While I am at it, here's a suggestion. One of my DVD-RAM disks
>  had apparently some (likely minor) problems, because I've just
>  found the following notice in /var/log/messages :
> 
>  ... kernel: EXT3-fs warning: mounting fs with errors, running
>  e2fsck is recommended
> 
>  This message appears 11 times in that file. I've never seen it
>  displayed on an xterm, although I always mount the disks "by hand",
>  on the command line!
> 
>  The request/suggestion is (obviously) please send that message to
>  syserror too!!
  And this depends on the configuration of your syslogd. Message is written
to console (probably tty10 or so on your system) and sent to syslog which
handles it further. So if it should be written somewhere else, syslog
should do it...

>  Which other logs should I look at?
  If there was some problem, it would be written to /var/log/messages. It
seems you haven't found anything there... Umm, can you reproduce the
problem if you try to do the same?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
