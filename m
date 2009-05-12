Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZELS1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZELS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZELS1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:27:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50659 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZELS1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:27:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v7 0/3] kvm: eventfd interfaces (formerly irqfd)
To: kvm@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Date: Tue, 12 May 2009 14:26:45 -0400
Message-ID: <20090512181134.26131.10023.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git:b5e725fa)

This is v7 of the series.  We have generalized the name of the series (as well
as some of the hunks in the series) to reflect the fact that we have multiple
eventfd based components.

This series has been tested and appears to be working as intended.  You can
download the unit-test used to verify this here:

ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz

This will also serve as an example on how to use the new interfaces.

[ Changelog:

   v7:
        *) Added "iofd" to allow PIO/MMIO writes to generate an eventfd
           signal.  This was previously discussed as "hypercallfd", but
           since explicit hypercalls are not looking to be very popular,
           and based on the fact that they were not going to carry payload
           anyway, I named them "iofd".
        *) Generalized some of the code so that irqfd and iofd could be
           logically grouped together.  For instance
           s/KVM_CAP_IRQFD/KVM_CAP_EVENTFD and
           virt/kvm/irqfd.c becomes virt/kvm/eventfd.c
        *) Added support for "deassign" operations to ensure we can properly
           support hot-unplug.
	*) Reinstated the eventfd EXPORT_SYMBOL patch since we need it again
           for supporting iofd.
        *) Rebased to kvm.git:b5e725fa 

   v6:
        *) Moved eventfd creation back to userspace, per Avi's request
        *) Dropped no longer necessary supporting patches from series
        *) Rebased to kvm.git:833367b57

   v5:
        *) Added padding to the ioctl structure
        *) Added proper ref-count increment to the file before returning
           success. (Needs review by Al Viro, Davide Libenzi)
        *) Cleaned up error-handling path to make sure we remove ourself
           from the waitq if necessary.
        *) Make sure we only add ourselves to kvm->irqfds if successful
           creating the irqfd in the first place.
        *) Rebased to kvm.git:66b0aed4 

   v4:
        *) Changed allocation model to create the new fd last, after
           we get past the last potential error point by using Davide's
           new eventfd_file_create interface (Al Viro, Davide Libenzi)
	*) We no longer export sys_eventfd2() since it is replaced
           functionally with eventfd_file_create();
        *) Rebased to kvm.git:7da2e3ba

   v3:
        *) The kernel now allocates the eventfd (need to export sys_eventfd2)
        *) Added a flags field for future expansion to kvm_irqfd()
        *) We properly toggle the irq level 1+0.
        *) We re-use the USERSPACE_SRC_ID instead of creating our own
        *) Properly check for failures establishing a poll-table with eventfd
	*) Fixed fd/file leaks on failure
	*) Rebased to lateste kvm.git::41b76d8d04

   v2:
	*) Dropped notifier_chain based callbacks in favor of
	   wait_queue_t::func and file::poll based callbacks (Thanks to
	   Davide for the suggestion)

   v1:
        *) Initial release

]

[ Todo:
        *) Implement the bus_io_unregister() function so the iofd hot-unplug
           path may be completed
        *) Test the hot-unplug path
]


---

Gregory Haskins (3):
      kvm: add iofd support
      kvm: add support for irqfd via eventfd-notification interface
      eventfd: export eventfd interfaces for module use


 arch/x86/kvm/Makefile    |    2 
 arch/x86/kvm/x86.c       |    1 
 fs/eventfd.c             |    3 
 include/linux/kvm.h      |   22 +++
 include/linux/kvm_host.h |    7 +
 virt/kvm/eventfd.c       |  294 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   33 +++++
 7 files changed, 361 insertions(+), 1 deletions(-)
 create mode 100644 virt/kvm/eventfd.c

-- 
Signature
