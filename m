Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbXFTU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbXFTU5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXFTU5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:57:37 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXFTU5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:57:35 -0400
Message-ID: <467994BD.6000403@zytor.com>
Date: Wed, 20 Jun 2007 13:57:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Adding subroot information to /proc/mounts, or obtaining that through
 other means
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Right now it is actually impossible to conclusively determine a
filesystem-relative path in the presence of bind (and possibly move)
mounts.  This is highly desirable to be able to do in contexts that
involve non-Linux (or not-the-current-instance-of-Linux) accesses to the
filesystem, e.g. other filesystems or bootloaders.

Example:

Let's assume /dev/md6 is mounted on /export.  Then /export/users/foo and
/exports/users/bar are bind-mounted to /home/foo and /home/bar respectively.

/proc/mounts will show:

/dev/md6 /export ext3 rw,data=ordered 0 0
/dev/md6 /home/foo ext3 rw,data=ordered 0 0
/dev/md6 /home/bar ext3 rw,data=ordered 0 0

... with no indication that anything is amiss.  The latter two fields
are confusing, at best.

We could add a field to /proc/mounts to add this information:

/dev/md6 /export ext3 rw,data=ordered 0 0 /
/dev/md6 /home/foo ext3 rw,data=ordered 0 0 /users/foo
/dev/md6 /home/bar ext3 rw,data=ordered 0 0 /users/bar

... or, alternatively, add a subfield to the first field (which would
entail escaping whatever separator we choose):

/dev/md6 /export ext3 rw,data=ordered 0 0
/dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
/dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0

One could also consider providing a system call (or ioctl, ...) to get
this information, effectively as an augmentation to stat().  If that's
the case, it would probably be a good thing if this "stat-plus" system
call could in the future be expanded to contain additional information
without having to change a structure every time, perhaps using a method
similar to sendmsg/recvmsg, as ugly as those are.

I'm personally leaning toward the second option (/dev/md6:/users/foo).
Although that might confuse current utilities, those utilities are
*already* liable to get confused by the fact that the line doesn't mean
what they think it means.

	-hpa
