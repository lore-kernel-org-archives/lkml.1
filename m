Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752Ab0A2VpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0A2VpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326Ab0A2VpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:45:16 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:3574 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab0A2VpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:45:14 -0500
Subject: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 14:44:57 -0700
Message-ID: <20100129214039.17745.38679.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Chen discovered that Linux "only" supports 32 IB cards in
a single system when testing a larger system with 40 cards and
discovered that OFED only reported 32 HCAs.

This patchset doubles the number of HCAs allowed per system in a
backwards-compatible manner.

Why only double? Well, it keeps the implementation very simple while
also keeping the memory increase at a minimum. If the future
requires even more HCAs per system, we can do a more complicated
implementation then.

I tested this by inserting 4 IB cards into a system, and then
changing IB_UVERBS_MAX_DEVICES = 2.

	dl585g2:~ # modprobe ib_uverbs
	dl585g2:~ # ls -l /dev/uverbs*
	crw-rw---- 1 root root 231, 192 Jan 28 06:59 /dev/uverbs0
	crw-rw---- 1 root root 231, 193 Jan 28 06:59 /dev/uverbs1
	crw-rw---- 1 root root 249,   0 Jan 28 06:59 /dev/uverbs2
	crw-rw---- 1 root root 249,   1 Jan 28 06:59 /dev/uverbs3

You can see that the uverbs devices are numbered in order, as one
would expect, and that devices 2 and 3 have different major numbers
while devices 0 and 1 retain the legacy, allocated major number.

I don't have access to a huge system to really test what
happens at device 33, but it should just work, right? :)

I am also unaware of any OFED changes required (if that's even
necessary), but then again, I'm just a simple kernel guy.

The final two patches are just something I discovered while using
pahole to verify my changes in converting the *cdev pointer to an
embedded struct. They don't save all that much, but they also don't
change very much code either, so why not?

Thanks,
/ac

---

Alex Chiang (7):
      IB/uverbs: convert *cdev to cdev in struct ib_uverbs_device
      IB/uverbs: remove dev_table
      IB/uverbs: use stack variable 'devnum' in ib_uverbs_add_one
      IB/uverbs: use stack variable 'base' in ib_uverbs_add_one
      IB/uverbs: increase maximum devices supported
      IB/uverbs: pack struct ib_uverbs_event_file tighter
      IB/core: pack struct ib_device a little tighter


 drivers/infiniband/core/uverbs.h      |   11 ++-
 drivers/infiniband/core/uverbs_main.c |  106 +++++++++++++++++++++------------
 include/rdma/ib_verbs.h               |    4 +
 3 files changed, 76 insertions(+), 45 deletions(-)

