Return-Path: <linux-kernel-owner+w=401wt.eu-S1763072AbXGRKh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763072AbXGRKh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXGRKhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:37:15 -0400
Received: from rudolph.anywherehost.net ([66.209.70.169]:46912 "EHLO
	rudolph.anywherehost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbXGRKhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:37:13 -0400
X-Greylist: delayed 2441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 06:37:13 EDT
X-ClientAddr: 82.166.9.18
From: "Or Sagi" <ors@tutis.com>
To: <linux-kernel@vger.kernel.org>
Cc: <kvm-devel@lists.sourceforge.net>
Subject: [RFC] Deferred interrupt handling.
Date: Wed, 18 Jul 2007 12:53:19 +0300
Message-ID: <005901c7c921$79c006c0$6d401440$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfJIXgYn8Wp1OB3QteUX4pEmWiFBg==
Content-Language: en-us
X-yoursite-MailScanner-Information: Please contact the ISP for more information
X-yoursite-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlepeople,

We're currently working on PCI device pass-through support for KVM. In this
model all physical hardware access to specific devices will be performed by
the VM, and not by the host.

In particular, this requires interrupt handling to be done by the guest --
The host shouldn't load the corresponding device driver or otherwise access
the device. Since the host kernel is not aware of the device semantics it
cannot acknowledge the interrupt at the device level.

As far as the host kernel is concerned the VM is a user level process. We
require the ability to forward interrupt handling to such entities. The
current kernel interrupt handling path doesn't allow deferring interrupt
handling _and_ acknowledgement.

We believe that this requires changing the current interrupt path in several
fashions:

0. Adding an IRQ_DEFERRED mechanism to the interrupt handling path. ISRs
returning IRQ_DEFERRED will keep the interrupt masked until future
acknowledge.
1. Deferred acknowledge mechanism which would acknowledge the APIC and
unmask
the interrupt.

An alternative idea was suggested at
http://lists.xensource.com/archives/html/xen-devel/2007-05/msg01148.html ---
which is based on reversing the polarity of the received interrupt. Once
the guest acknowledges the interrupt at the device level, the polarity is
reversed again by the host.

This may not be the best choice performance wise -- twice the interrupt
count.

Another issue we are aware of is the effect deferred handling will have on
other devices sharing the interrupt. This seems to be a problem regardless
of the solution.

We wouldn't like to assume VT-d availability right now.

Any ideas ? Thoughts ?

-- Ors


