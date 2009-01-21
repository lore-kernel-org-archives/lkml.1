Return-Path: <linux-kernel-owner+w=401wt.eu-S1764754AbZAUL6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764754AbZAUL6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbZAUL6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:58:35 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:59568 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134AbZAUL6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:58:34 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 06:58:34 EST
Date: Wed, 21 Jan 2009 12:52:19 +0100
From: Peter Palfrader <weasel@debian.org>
To: linux-kernel@vger.kernel.org
Cc: DSA <debian-admin@lists.debian.org>, team@security.debian.org,
       libpam-modules@packages.debian.org
Subject: 2.6.28, rlimits, performance and debian etch
Message-ID: <20090121115219.GA2754@anguilla.noreply.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	DSA <debian-admin@lists.debian.org>, team@security.debian.org,
	libpam-modules@packages.debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I spent several hours trying to get to the bottom of a serious
performance issue that appeared on one of our servers after upgrading to
2.6.28.  In the end it's what could be considered a userspace bug that
was triggered by a change in 2.6.28.  Since this might also affect other
people I figured I'd at least document what I found here, and maybe we
can even do something about it:


So, I upgraded some of debian.org's machines to 2.6.28.1 and immediately
the team maintaining our ftp archive complained that one of their
scripts that previously ran in a few minutes still hadn't even come
close to being done after an hour or so.  Downgrading to 2.6.27 fixed
that.

Turns out that script is forking a lot and something in it or python or
whereever closes all the file descriptors it doesn't want to pass on.
That is, it starts at zero and goes up to ulimit -n/RLIMIT_NOFILE and
closes them all with a few exceptions.

Turns out that takes a long time when your limit -n is now 2^20 (1048576).

With 2.6.27.* the ulimit -n was the standard 1024, but with 2.6.28 it is
now a thousand times that.

2.6.28 included a patch titled "rlimit: permit setting RLIMIT_NOFILE to
RLIM_INFINITY" (0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f)[1] that
allows, as the title implies, to set the limit for number of files to
infinity.

Closer investigation showed that the broken default ulimit did not apply
to "system" processes (like stuff started from init).  In the end I
could establish that all processes that passed through pam_limit at one
point had the bad resource limit.

Apparently the pam library in Debian etch (4.0) initializes the limits
to some default values when it doesn't have any settings in limit.conf
to override them.  Turns out that for nofiles this is RLIM_INFINITY.
Commenting out "case RLIMIT_NOFILE" in pam_limit.c:267 of our pam
package version 0.79-5 fixes that - tho I'm not sure what side effects
that has.

Debian lenny (the upcoming 5.0 version) doesn't have this issue as it
uses a different pam (version).


I'm a bit unsure where to go from here.  Maybe the pam library in etch
should be fixed.  Maybe the patch should be reverted (but then it may be
more correct now and that's what the changelog entry suggests).
As a stopgap measure I could also just define nofile in limits.conf.

Thanks for listening.  Also thanks to Rik and Nocholas who helped track
some of this down.

Cheers,
Peter
1. http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
