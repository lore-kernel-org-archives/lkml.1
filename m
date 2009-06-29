Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbZF2S30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbZF2S30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZF2S3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:29:13 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43416 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZF2S3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:29:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v7 0/5] irqfd fixes and enhancements
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Mon, 29 Jun 2009 14:28:59 -0400
Message-ID: <20090629181954.1886.20225.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:4631e094)

The following is the latest attempt to fix the races in irqfd/eventfd, as
well as restore DEASSIGN support.  For more details, please read the patch
headers.  I've restored the slow-work variant of the logic as a separate
patch (5/5) so we can get a better idea of the true difference between
the workqueue approach and the slow-work style.  I am personally in favor
of the slow-work approach since it doesnt require a mostly-idle+dedicated
thread to hang around.  But that is just me.  5/5 can be ignored, folded
in to 3/5+4/5 as appropriate, or merged as is per the whim of Avi et. al.

As always, this series has been tested against the kvm-eventfd unit test
with both 5/5 applied and unapplied, and everything appears to be
functioning properly. You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

I've included version 4 of Davide's eventfd patch (ported to kvm.git) so
that its a complete reviewable series.  Note, however, that there may be
later versions of his patch to consider for merging, so we should
coordinate with him.

-Greg


[Changelog:

	v7:
	   *) Addressed minor-nit feedback from Michael
	   *) Cleaned up patch headers
	   *) Re-added separate slow-work feature patch to end for comparison

	v6:
	   *) Removed slow-work in favor of using a dedicated single-thread
              workqueue.
	   *) Condensed cleanup path to always use deferred shutdown
	   *) Saved about 56 lines over v5, with the following diffstat:

 	   include/linux/kvm_host.h |    2 
 	   virt/kvm/eventfd.c       |  248 ++++++++++++++++++-----------------------------
 	   2 files changed, 97 insertions(+), 153 deletions(-)
	v5:
           Untracked..
]

---

Davide Libenzi (1):
      eventfd - revised interface and cleanups (4th rev)

Gregory Haskins (4):
      KVM: Make irqfd use slow-work for shutdown
      KVM: add irqfd DEASSIGN feature
      KVM: Fix races in irqfd using new eventfd_kref_get interface
      kvm: prepare irqfd for having interrupts disabled during eventfd->release


 drivers/lguest/lg.h          |    2 
 drivers/lguest/lguest_user.c |    4 -
 fs/aio.c                     |   24 +---
 fs/eventfd.c                 |  126 ++++++++++++++++++----
 include/linux/aio.h          |    4 -
 include/linux/eventfd.h      |   35 +++++-
 include/linux/kvm.h          |    2 
 include/linux/kvm_host.h     |    7 +
 virt/kvm/Kconfig             |    1 
 virt/kvm/eventfd.c           |  246 ++++++++++++++++++++++++++++++++----------
 10 files changed, 343 insertions(+), 108 deletions(-)

-- 
Signature
