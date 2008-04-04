Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYDDWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYDDWbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYDDWbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:31:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52671 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213AbYDDWbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:31:32 -0400
Message-Id: <20080404223048.374852899@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 15:30:48 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 00/10] [RFC] EMM Notifier V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2->V3:
- Fix rcu issues
- Fix emm_referenced handling
- Use Andrea's mm_lock/unlock to prevent registration races.
- Keep simple API since there does not seem to be a need to add additional
  callbacks (mm_lock does not require callbacks like emm_start/stop that
  I envisioned).
- Reduce CC list (the volume we are producing here must be annoying...).

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
also a prototype. It is known to run trivial sample programs included as the last
patch.


-- 
