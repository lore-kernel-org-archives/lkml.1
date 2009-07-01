Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZGAQJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZGAQJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZGAQJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:09:04 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34211 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZGAQJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:09:03 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v8 0/3] irqfd fixes and enhancements
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Wed, 01 Jul 2009 12:08:57 -0400
Message-ID: <20090701160208.3615.99153.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:beeaacd1)

The following is the latest attempt to fix the races in irqfd/eventfd, as
well as restore DEASSIGN support.  For more details, please read the patch
headers.

As always, this series has been tested against the kvm-eventfd unit test
and everything appears to be functioning properly. You can download this
test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

Kind Regards,
-Greg


[Changelog:

	v8:
	   *) Rebased to kvm.git/master:beeaacd1)
	   *) Dropped Davide's patch (2/5 in v7) since it's now upstream
	   *) Folded v7's 1/5 and 3/5 together, and added a single
	      eventfd hunk to convert wake_up_locked_polled to wake_up_polled
	   *) Dropped irqfd->active bit in favor of irqfd_is_active() function
	   *) Cleaned up comments in 1/3
	   *) Dropped v7's 5/5 (slow-work)
	   *) Added new patch (3/3) which makes the cleanup-wq's creation
	      dynamic so to avoid the resource penalty for guests that do
	      not use irqfd.

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

Gregory Haskins (3):
      KVM: create irqfd-cleanup-wq on demand
      KVM: add irqfd DEASSIGN feature
      KVM: Fix races in irqfd using new eventfd_kref_get interface


 fs/eventfd.c             |    7 -
 include/linux/kvm.h      |    2 
 include/linux/kvm_host.h |    6 +
 virt/kvm/eventfd.c       |  281 ++++++++++++++++++++++++++++++++++++----------
 4 files changed, 229 insertions(+), 67 deletions(-)

-- 
Signature
