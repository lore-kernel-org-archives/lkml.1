Return-Path: <linux-kernel-owner+w=401wt.eu-S2992557AbXDDEeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992557AbXDDEeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992569AbXDDEeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:34:25 -0400
Received: from smtp.knology.net ([24.214.63.101]:49906 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992557AbXDDEeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:34:24 -0400
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
From: Dave Dillow <dave@thedillows.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org,
       Ingo Molnar <mingo@elte.hu>, amanda-hackers@amanda.org,
       amanda-users@amanda.org
In-Reply-To: <1175488272.3161.28.camel@obelisk.thedillows.org>
References: <200704010100.19016.gene.heskett@verizon.net>
	 <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
	 <200704011141.53105.gene.heskett@verizon.net>
	 <200704020021.02393.gene.heskett@gmail.com>
	 <1175488272.3161.28.camel@obelisk.thedillows.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Apr 2007 00:34:16 -0400
Message-Id: <1175661256.31439.23.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 00:31 -0400, Dave Dillow wrote:
> On Mon, 2007-04-02 at 00:20 -0400, Gene Heskett wrote:
[snipped for brevity]
> > [root@coyote music]# stat .
> > Device: fd00h/64768d    Inode: 10354963    Links: 39

> > Now rebooted to 2.6.21-rc5:
> > Device: ee00h/60928d    Inode: 10354963    Links: 39

> For those playing along at home, I believe the issue is that GNU tar
> sees a different device number for the directories than what is listed
> in the listed-incremental snapshot file, and thinks all of the
> directories are new. I've asked Gene to make a few back-to-back runs of
> the tar command under the same kernel to see if the subsequent runs
> figure out that there's nothing to do, as expected.

Gene has confirmed that GNU tar figures it out as expected.

> Then it is a matter of figuring out why the device number changed -- I'm
> thinking it is device-mapper, but will look closer tomorrow.

This commit is the one that changed it:

commit fdf892be32d84a1745fa0aee5fc60517421b8038
Author: Andrew Morton <akpm@osdl.org>
Date:   Mon Feb 12 00:51:44 2007 -0800

    [PATCH] register_blkdev(): don't hand out the LOCAL/EXPERIMENTAL majors
    
    As pointed out in http://bugzilla.kernel.org/show_bug.cgi?id=7922, dynamic
    blockdev major allocation can hand out majors which LANANA has defined as
    being for local/experimental use.


I'm not sure I could argue for that to be reverted, so here's a possible
workaround for Fedora -- completely untested.

Add the following to /etc/modprobe.conf:
options dm_mod major=253

And make a new initrd for the problematic kernel. This assumes that
you're using device mapper as a module.

If you're building it in, then either dm.major=253 or dm_mod.major=253
should work on the kernel command line, but I'm not sure which it is.

Dave
