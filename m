Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbXDTWmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbXDTWmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767299AbXDTWmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:42:44 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:47278 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbXDTWmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:42:20 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 18:42:20 EDT
X-IronPort-AV: i="4.14,434,1170662400"; 
   d="scan'208"; a="55280057:sNHT51443640"
Subject: [PATCH 0/6] [RFC]IB/mlx4: Mellanox ConnectX adapter driver
In-Reply-To: <adawt0k3lt1.fsf@cisco.com>
X-Mailer: Roland's Patchbomber
Date: Fri, 20 Apr 2007 15:32:36 -0700
Message-Id: <20074201532.4PiF0gUjC19I1fhy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
From: Roland Dreier <rolandd@cisco.com>
X-OriginalArrivalTime: 20 Apr 2007 22:32:36.0949 (UTC) FILETIME=[CC066850:01C7839B]
Authentication-Results: sj-dkim-5; header.From=rolandd@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As promised, here is a series of patches adding the mlx4_core and
mlx4_ib drivers for the new Mellanox ConnectX adapter.  These patches
are split up in an ad hoc way to avoid mailing list size limits, but
when this driver is finally merged, I will give it to Linus to pull in
a single changeset.  The full driver is also available via git from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git connectx

and it is also in my for-mm patch, so Andrew will pick it up for -mm
kernels automatically.

The driver is split into two kernel modules because the ConnectX
adapter can be used as an InfiniBand adapter, 1G/10G ethernet NIC, and
an fibre channel HBA at the same time, and so resource management and
basic tasks such as issuing commands to the firmware are handled in a
mlx4_core module, while everything InfiniBand-specific is in mlx4_ib.
In the not-to-distant future, an mlx4_eth module that handles ethernet
NIC stuff will be released.

My goal is to merge this for 2.6.22.  If you feel that would not be
appropriate, please do let me know and I will hold off.  And of course
all criticisms, suggestions, comments, etc. are very much appreciated.
My feeling is that the driver is fairly clean already (and I will do
some further cleanup before merging) and seems to be reasonably
usable, and I trust myself to continue cleaning things up, so there's
not much to be gained by waiting a release cycle.

The overall driver is not too huge -- 11371 insertions in the diffstat:

 drivers/infiniband/Kconfig            |    2 +
 drivers/infiniband/Makefile           |    1 +
 drivers/infiniband/hw/mlx4/Kconfig    |    9 +
 drivers/infiniband/hw/mlx4/Makefile   |    3 +
 drivers/infiniband/hw/mlx4/ah.c       |  100 +++
 drivers/infiniband/hw/mlx4/cq.c       |  525 ++++++++++++++
 drivers/infiniband/hw/mlx4/doorbell.c |  215 ++++++
 drivers/infiniband/hw/mlx4/mad.c      |  339 +++++++++
 drivers/infiniband/hw/mlx4/main.c     |  612 ++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |  285 ++++++++
 drivers/infiniband/hw/mlx4/mr.c       |  184 +++++
 drivers/infiniband/hw/mlx4/qp.c       | 1263 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/srq.c      |  334 +++++++++
 drivers/infiniband/hw/mlx4/user.h     |   91 +++
 drivers/net/Kconfig                   |   14 +
 drivers/net/Makefile                  |    1 +
 drivers/net/mlx4/Makefile             |    4 +
 drivers/net/mlx4/alloc.c              |  179 +++++
 drivers/net/mlx4/cmd.c                |  429 +++++++++++
 drivers/net/mlx4/cq.c                 |  254 +++++++
 drivers/net/mlx4/eq.c                 |  704 ++++++++++++++++++
 drivers/net/mlx4/fw.c                 |  758 ++++++++++++++++++++
 drivers/net/mlx4/fw.h                 |  165 +++++
 drivers/net/mlx4/icm.c                |  379 ++++++++++
 drivers/net/mlx4/icm.h                |  135 ++++
 drivers/net/mlx4/intf.c               |  142 ++++
 drivers/net/mlx4/main.c               |  939 ++++++++++++++++++++++++
 drivers/net/mlx4/mcg.c                |  370 ++++++++++
 drivers/net/mlx4/mlx4.h               |  334 +++++++++
 drivers/net/mlx4/mr.c                 |  482 +++++++++++++
 drivers/net/mlx4/pd.c                 |  102 +++
 drivers/net/mlx4/profile.c            |  238 +++++++
 drivers/net/mlx4/qp.c                 |  270 +++++++
 drivers/net/mlx4/reset.c              |  172 +++++
 drivers/net/mlx4/srq.c                |  227 ++++++
 include/linux/mlx4/cmd.h              |  178 +++++
 include/linux/mlx4/cq.h               |  123 ++++
 include/linux/mlx4/device.h           |  323 +++++++++
 include/linux/mlx4/doorbell.h         |   97 +++
 include/linux/mlx4/driver.h           |   59 ++
 include/linux/mlx4/qp.h               |  288 ++++++++
 include/linux/mlx4/srq.h              |   42 ++
 42 files changed, 11371 insertions(+), 0 deletions(-)
