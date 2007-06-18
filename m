Return-Path: <linux-kernel-owner+w=401wt.eu-S1763867AbXFROui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763867AbXFROui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXFROu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:50:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38278 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752752AbXFROu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:50:28 -0400
Date: Tue, 19 Jun 2007 00:50:07 +1000
From: David Chinner <dgc@sgi.com>
To: David Greaves <david@dgreaves.com>
Cc: David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070618145007.GE85884050@sgi.com>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4676390E.6010202@dgreaves.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:49:34AM +0100, David Greaves wrote:
> David Greaves wrote:
> >OK, that gave me an idea.
> >
> >Freeze the filesystem
> >md5sum the lvm
> >hibernate
> >resume
> >md5sum the lvm
> <snip>
> >So the lvm and below looks OK...
> >
> >I'll see how it behaves now the filesystem has been frozen/thawed over 
> >the hibernate...
> 
> 
> And it appears to behave well. (A few hours compile/clean cycling kernel 
> builds on that filesystem were OK).
> 
> 
> Historically I've done:
> sync
> echo platform > /sys/power/disk
> echo disk > /sys/power/state
> # resume
> 
> and had filesystem corruption (only on this machine, my other hibernating 
> xfs machines don't have this problem)
> 
> So doing:
> xfs_freeze -f /scratch
> sync
> echo platform > /sys/power/disk
> echo disk > /sys/power/state
> # resume
> xfs_freeze -u /scratch
>
> Works (for now - more usage testing tonight)

Verrry interesting.

What you were seeing was an XFS shutdown occurring because the free space
btree was corrupted. IOWs, the process of suspend/resume has resulted
in either bad data being written to disk, the correct data not being
written to disk or the cached block being corrupted in memory.

If you run xfs_check on the filesystem after it has shut down after a resume,
can you tell us if it reports on-disk corruption? Note: do not run xfs_repair
to check this - it does not check the free space btrees; instead it simply
rebuilds them from scratch. If xfs_check reports an error, then run xfs_repair
to fix it up.

FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
filesystem for a suspend/resume to work safely and have argued that the only
safe thing to do is freeze the filesystem before suspend and thaw it after
resume. This is why I originally asked you to test that with the other problem
that you reported. Up until this point in time, there's been no evidence to
prove either side of the argument......

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
