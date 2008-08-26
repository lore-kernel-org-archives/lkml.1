Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYHZIxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYHZIxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYHZIwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:52:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYHZIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:52:20 -0400
From: Tejun Heo <tj@kernel.org>
To: ericvh@gmail.com, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCHSET] 9p: clean up a bit and use single poller for trans_fd
Date: Tue, 26 Aug 2008 17:50:50 +0900
Message-Id: <1219740656-26458-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 08:52:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset cleans up 9p and 9p-trans_fd a bit and convert trans_fd
to use single poller instead of poll of pollers and contains the
following six patches.

  0001-9p-implement-proper-trans-module-refcounting-and-un.patch
  0002-9p-trans_fd-fix-trans_fd-p9_conn_destroy.patch
  0003-9p-trans_fd-clean-up-p9_conn_create.patch
  0004-9p-trans_fd-don-t-do-fs-segment-mangling-in-p9_fd_p.patch
  0005-9p-trans_fd-fix-and-clean-up-module-init-exit-paths.patch
  0006-9p-trans_fd-use-single-poller.patch

0001 fixes trans module registration and unregistration.  0002-0005
fix a few bugs in and clean up trans_fd.  0006 converts trans_fd to
use single poller instead of pool of pollers.

Although this patchset fixes a few problem cases but there still are
other synchronization issues in trans_fd.  Most notably, a request
which is being flushed can be freed before r/w works are done with
them.  What's necessary is probably flushing r/w works before actually
destroying the request from flush.  Well, I guess that's for another
day.

This patchset is on top of the current linus#master (399d7f6b) and the
combined diffstat follows.

 include/net/9p/9p.h        |    1 
 include/net/9p/transport.h |    9 -
 net/9p/client.c            |   10 +
 net/9p/mod.c               |   92 ++++++++----
 net/9p/trans_fd.c          |  340 ++++++++++++++-------------------------------
 net/9p/trans_virtio.c      |    2 
 6 files changed, 198 insertions(+), 256 deletions(-)

Thanks.

--
tejun
