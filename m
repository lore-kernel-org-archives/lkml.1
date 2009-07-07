Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZGGVJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZGGVJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbZGGVIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:08:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42097 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZGGVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:08:54 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v10 0/2] ioeventfd (formerly iosignalfd)
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com
Date: Tue, 07 Jul 2009 17:08:38 -0400
Message-ID: <20090707210023.21953.22087.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:3abaf217)

This is v10 of the series.  For more details, please see the header to
patch 2/2.

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

(Note: unit test has been updated to accomodate new feature-set)

Please consider for inclusion to kvm.git

[
   Changelog:

      v10:
           *) Numerous fixes from Michael's review comments
	       *) collapsed some whitespace
	       *) comment cleanup (spelling fixes, clarifications, etc)
	       *) structure member optimizations (s/size_t/int, etc)
	       *) unified data-match name to be consistent throughout
	       *) Single line comments are truely single-line
	       *) Clean up superfluous bracketing
	       *) Check for math overflow
	       *) More explicit deassign match checking
	       *) Return an error on deassign if no match found
	       *) Eliminated multiple-match feature
	       *) Validate args->flags
	   *) s/iosignalfd/ioeventfd
	   *) Rebased to kvm.git/master:3abaf217

      v9:
           *) Rebased onto Michael's new iodev locking scheme
	   *) Removed group+item nesting in favor of using iodev facility
	   *) Removed iodev-limit patch since we no longer create
	      our own devices.  The limit feature itself may be useful
              but it is now out of scope from iosignalfd and thus should
 	      be addressed separately.
	   *) Rebased to kvm.git/master:c5b13264e

      v8:
           *) Addressed Avi's review comments:
                 *) Simplified the unregister_dev logic in patch 1/3
	         *) Implemented a per-vm io-device limit (patch 2/3)
		 *) Removed spurious whitespace hunk
		 *) changed the data-match from a void* to a u64
		 *) check group-length violations before wildcarding

      v7:
           *) Implemented a resource limit (CONFIG_KVM_MAX_IOSIGNALFD_ITEMS)
              to limit malicious/broken userspace from consuming arbitrary
	      kernel memory.
	   *) Rebased to kvm.git/master:c27b64a0, which already includes
	      Marcelo's irq-lock rework.

      v6:
           *) Removed "FIXME?" comment on choice over RCU vs SRCU after
              discussion/numbers from Paul.  I think RCU is fine to use for
              now based on the conversation.  We can always convert it later
              if need be.
           *) Fixed the "group" free path to eliminate an RCU related race
           *) Fixed a memory/eventfd leak on shutdown for any iosignalfd's
              which were still active at the time the guest shuts down.
           *) Beefed up comments
           *) Rebased to kvm.git/master:0281e88f + irq locking rework and
              verified that kvm-eventfd unit test still passes.

      v5:
           *) Removed "cookie" field, which was a misunderstanding on my
              part on what Avi wanted for a data-match feature
	   *) Added a new "trigger" data-match feature which I think is
              much closer to what we need.
	   *) We retain the dev_count field in the io_bus infrastructure
	      and instead back-fill the array on removal.
	   *) Various minor cleanups
	   *) Rebased to kvm.git/master:25deed73

      v4:
           *) Fixed a bug in the original 2/4 where the PIT failure case
              would potentially leave the io_bus components registered.
           *) Condensed the v3 2/4 and 3/4 into one patch (2/2) since
              the patches became interdependent with the fix described above
           *) Rebased to kvm.git/master:74dfca0a

      v3:
           *) fixed patch 2/4 to handle error cases instead of BUG_ON
           *) implemented same HAVE_EVENTFD protection mechanism as
              irqfd to prevent compilation errors on unsupported arches
           *) completed testing
           *) rebased to kvm.git/master:7391a6d5

      v2:
           *) added optional data-matching capability (via cookie field)
           *) changed name from iofd to iosignalfd
           *) added io_bus unregister function
           *) implemented deassign feature

      v1:
           *) original release (integrated into irqfd v7 series as "iofd")
]

---

Gregory Haskins (2):
      KVM: add ioeventfd support
      KVM: make io_bus interface more robust


 arch/x86/kvm/i8254.c      |   20 +++-
 arch/x86/kvm/i8259.c      |    9 +-
 arch/x86/kvm/x86.c        |    1 
 include/linux/kvm.h       |   24 ++++
 include/linux/kvm_host.h  |   20 +++-
 virt/kvm/coalesced_mmio.c |    8 +
 virt/kvm/eventfd.c        |  252 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c         |    8 +
 virt/kvm/kvm_main.c       |   50 ++++++++-
 9 files changed, 373 insertions(+), 19 deletions(-)

-- 
Signature
