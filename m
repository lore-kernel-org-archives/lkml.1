Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbZFPOYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbZFPOYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZFPOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:23:58 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:45638 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZFPOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=AzgR3xSXFUDUaDu4cHhNVPddgUFnyX8uSItqfzCPFxRbv30GULuz77FQx7QewlH0IW
         KInSW7Hk4y2hXEO+h088h95a0a6rD1D/qpPMEcXX7qhO/Qa4H2dquIkKKWGDbj7FkKl8
         fFmJxIBugeToTWhCQkn63DkNWDLRHliD9aJQo=
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 10:23:59 -0400
Message-ID: <deaa866a0906160723k78c3c54bv35e2e2406e3d13d1@mail.gmail.com>
Subject: Scheduler fails to allow for "niceness" with new/fast processes
From: Robert Bradbury <robert.bradbury@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I primarily use my system (Gentoo) for 3 tasks: (a) Browsing the web
related to biomedical research (I may often have dozens of windows and
hundreds of tabs open in several browsers); (b) Running fairly CPU &
Disk I/O intensive genetics programs; (c) Performing low priority
rebuilds of various packages (Gentoo packages, firefox/chrome
releases, etc.

Now (a) is my top priority -- I want my active browser to get all of
the CPU if it requires it (fast window/tab opens, quick page reloads &
redraws, etc.);  (b) is of lesser priority and (c) is lowest priority.
 This is on a 2.8 GHz Pentium IV (Prescott) with 3GB of RAM and 12GB
of swap on two drives.

Now I normally run (c) processes at nice -n 19 to (in theory) get the
least CPU allocation.  But it would appear that this does not work.  I
often experience extremely poor user (esp. browser) performance when
running package builds.  In monitoring the package builds I find that
they seem to be stopping at nothing, presumably because the build
tools, directories, etc. are all cached in memory as are most of the
header files (Gentoo ebuilds have a cache for this).  If the package
source files are small or disk read-ahead is working or the source
files are entirely cached (many packages which have just been unpacked
during the build preparation process are presumably still in the
system buffer cache) -- there is no I/O required for them to build.

I believe I glanced at an IBM technical report a number of months ago
that suggested something to the effect that ongoing "handoffs" to
newly started processes could be a way to bypass the regulation of
process priorities by the kernel.  This being due to some bias in how
the scheduler works in that one has to accumulate some minimum amount
of CPU time in order for process "niceness" to have any effect.  (One
could imagine setting up a shared memory region to retain any data in
memory and continually execing new processes which attach to the
memory and avoid any sysadmin imposed CPU use restrictions).

So my questions are:
1) Are people aware of this problem (CPU intensive cached programs
severely impact User Interface program performance and nicing the CPU
intensive programs (if they execute quickly) fails to correct the
problem)?
2) Can this be resolved in any way by altering the scheduler or its
parameters in Linux configuration?
3) Is there any quick "hack" to the kernel (sched.c?) which forces it
to more strongly favor UI programs over niced background tasks (to the
extent that if the UI programs, e.g. firefox-bin, X, bash, etc. *want*
the CPU or disk (or network even) then they immediately get it by
preempting niced processes.  I.e. UI programs always preferentially go
to the head of various queues?

The trend seems to be to migrate towards multi-core CPU's rather than
fix the scheduler so that "nice" *really* means "only run this if you
have nothing else to do".
