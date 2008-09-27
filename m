Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYI0Pos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYI0Pos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYI0Poj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:44:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33186 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYI0Poi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:44:38 -0400
From: Avi Kivity <avi@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3][RFC] ioctl dispatcher
Date: Sat, 27 Sep 2008 18:43:59 +0300
Message-Id: <1222530242-1272-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While ioctls are officially ugly, they are the best choice for some use
cases, not to mention compatibility issues.  Currently ioctl writers face
the following hurdles:

- if the ioctl uses a data buffer, the ioctl handler must allocate
  kernel memory for this buffer
  - the memory may be allocated on the heap or on the stack, depending on the
    buffer size
- handle any errors from the operation
- copy the data from userspace, if necessary
- handle any errors from the operation
- actually perform the operation
- copy the data back to userspace, if necessary
- handle any errors from the operation
- free the buffer, if allocated from the heap

The first patch automates these operations, only requiring the caller to
supply the ioctl number and a callback in a table.

The second patch addresses another problem with ioctls: they are brittle.
Once written, an ioctl cannot be extended, since the buffer sizes used for
transferring data are encoded in the ioctl number.  This is addressed by
allowing the user-supplied size and the kernel-visible size of the data
buffer to be different; the kernel will zero fill or truncate appropriately.
With the new mechanism, it is easy to write forward- and backward- compatible
ioctl handlers.

The third patch demonstrates the effectiveness of the first patch; it
converts some of kvm's ioctl handlers to the new mechanism, removing
around 90 lines in the process.

Comments welcome.

Avi Kivity (3):
  ioctl: generic ioctl dispatcher
  ioctl: extensible ioctl dispatch
  KVM: Convert x86 vcpu ioctls to use dispatch_ioctl_extensible()

 arch/x86/kvm/x86.c    |  241 ++++++++++++++++---------------------------------
 fs/ioctl.c            |  139 ++++++++++++++++++++++++++++
 include/linux/ioctl.h |   37 ++++++++
 3 files changed, 253 insertions(+), 164 deletions(-)

