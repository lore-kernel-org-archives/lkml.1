Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbYDAVAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbYDAVAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759831AbYDAU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:59:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50969 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756315AbYDAU7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:59:07 -0400
Message-Id: <20080401205531.986291575@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 13:55:31 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 0/9] [RFC] EMM Notifier V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note that I will be giving talks next week at the OpenFabrics Forum
and at the Linux Collab Summit in Austin on memory pinning etc. It would
be great if I could get some feedback on the approach then]

V1->V2:
- Additional optimizations in the VM
- Convert vm spinlocks to rw sems.
- Add XPMEM driver (requires sleeping in callbacks)
- Add XPMEM example

This patch implements a simple callback for device drivers that establish
their own references to pages (KVM, GRU, XPmem, RDMA/Infiniband, DMA engines
etc). These references are unknown to the VM (therefore external).

With these callbacks it is possible for the device driver to release external
references when the VM requests it. This enables swapping, page migration and
allows support of remapping, permission changes etc etc for the externally
mapped memory.

With this functionality it becomes also possible to avoid pinning or mlocking
pages (commonly done to stop the VM from unmapping device mapped pages).

A device driver must subscribe to a process using

        emm_register_notifier(struct emm_notifier *, struct mm_struct *)


The VM will then perform callbacks for operations that unmap or change
permissions of pages in that address space. When the process terminates
the callback function is called with emm_release.

Callbacks are performed before and after the unmapping action of the VM.

        emm_invalidate_start    before

        emm_invalidate_end      after

The device driver must hold off establishing new references to pages
in the range specified between a callback with emm_invalidate_start and
the subsequent call with emm_invalidate_end set. This allows the VM to
ensure that no concurrent driver actions are performed on an address
range while performing remapping or unmapping operations.


This patchset contains additional modifications needed to ensure
that the callbacks can sleep. For that purpose two key locks in the vm
need to be converted to rw_sems. These patches are brand new, invasive
and need extensive discussion and evaluation.

The first patch alone may be applied if callbacks in atomic context are
sufficient for a device driver (likely the case for KVM and GRU and simple
DMA drivers).

Following the VM modifications is the XPMEM device driver that allows sharing
of memory between processes running on different instances of Linux. This is
also a prototype. It is known to run trivial sample programs included as the
last patch.

-- 
