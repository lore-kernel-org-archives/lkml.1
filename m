Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZCYEQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZCYEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZCYEQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:16:49 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15584 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZCYEQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:16:49 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 0/3] sysfs: allow suicide
To: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 22:16:46 -0600
Message-ID: <20090325035707.15921.42150.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a refreshed version of the patch series Tejun posted quite a while
ago that allowed sysfs attributes to commit suicide directly:

	http://thread.gmane.org/gmane.linux.kernel/582130/

I'm dusting this off (with Tejun's approval) because of recent changes
I introduced into the PCI core, which allow for logical hotplug of any
device in the system (via sysfs):

	http://thread.gmane.org/gmane.linux.kernel.pci/3713/

My removal mechanism uses the much-hated sysfs_schedule_callback()
mechanism, and indeed, even some light testing has already shown some
drawbacks, namely we produce at least one false positive in lockdep.

I'm taking a two-prong approch here. The first step is to modify
sysfs_schedule_callback() and get it off the global work queue. This
will eliminate false positives in lockdep, and also stop us from
hogging the shared work queue with a long-running ->remove event,
such as removing a PCI bridge near the root of the hierarchy with
lots of devices underneath. I'm having Kenji test this patch right
now, since I'd like to get it fixed for the current merge window:

	http://thread.gmane.org/gmane.linux.kernel.pci/3713/focus=3756

[note: Greg, if Kenji's testing is successful, I plan on sending
that patch as another .30 change]

The other prong is getting discussion going on this patch series again.

The most contentious part is patch 1/3, wherein sysfs abuses the
module notifier call chain, and basically prevents all module unloads
until suicidal sysfs attributes have completed.

This is poison of a different flavor from last time. The earlier version
of this series modified the module API and created an interface that
allowed anyone to inhibit module unload.

This time, only sysfs is allowed to be so... special. Which is a slight
improvement, but the question as to whether sysfs should be allowed to
do something like this is unresolved.

I'd like to get Rusty's opinion on this approach; I didn't see anything
in the archives from previous threads.

A secondary minor concern is the impurity that I've introduced into
sysfs, but I think most of the folks copied here would agree that it's
a worthwhile tradeoff if we can eliminate the callback mechanism.

Finally, please note that I didn't refresh the 4th patch in the original
series, the good one that actually removes all the cruft. I figured
we could discuss the module unload inhibition first, and in the meantime,
I could let some of the merge activity settle out before touching
the callsites.

Comments appreciated.

Thanks.

/ac

---

Alex Chiang (1):
      sysfs: add blocking notifier to prohibit module unload

Tejun Heo (2):
      sysfs: care-free suicide for sysfs files
      sysfs: make the sysfs_addrm_cxt->removed list FIFO


 fs/sysfs/dir.c   |    9 +++-
 fs/sysfs/file.c  |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/mount.c |    8 +++
 fs/sysfs/sysfs.h |    6 ++
 4 files changed, 152 insertions(+), 6 deletions(-)

