Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZFSAau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZFSAau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFSAaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:30:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36925 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZFSAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:30:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v8 0/3] iosignalfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Date: Thu, 18 Jun 2009 20:30:30 -0400
Message-ID: <20090619002224.15859.97977.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:c27b64a0)

This is v8 of the series.  For more details, please see the header to
patch 3/3.

This series has been tested against the kvm-eventfd unit test, and
appears to be functioning properly.  You can download this test here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2

Please consider for inclusion to kvm.git

An updated userspace for qemu-kvm.git is forthcoming.

[
   Changelog:

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

Gregory Haskins (3):
      KVM: add iosignalfd support
      KVM: add per-vm limit on the maximum number of io-devices supported
      KVM: make io_bus interface more robust


 arch/x86/kvm/Kconfig      |    8 +
 arch/x86/kvm/i8254.c      |   23 ++
 arch/x86/kvm/i8259.c      |    9 +
 arch/x86/kvm/x86.c        |    1 
 include/linux/kvm.h       |   15 ++
 include/linux/kvm_host.h  |   19 ++
 virt/kvm/coalesced_mmio.c |    8 +
 virt/kvm/eventfd.c        |  426 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c         |    9 +
 virt/kvm/kvm_main.c       |   42 ++++
 10 files changed, 545 insertions(+), 15 deletions(-)

-- 
Signature
