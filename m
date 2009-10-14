Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbZJNT3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbZJNT3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932668AbZJNT3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:29:48 -0400
Received: from claw.goop.org ([74.207.240.146]:55285 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbZJNT3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:17 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/12] kvm/pvclock: add monotonicity check
Date: Wed, 14 Oct 2009 12:28:28 -0700
Message-Id: <1255548516-15260-5-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other tsc-based clocksources add a monotonicity test to make sure there's
no regression in the returned cycles.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/kvmclock.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 223af43..46cb77f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -77,9 +77,14 @@ static cycle_t kvm_clock_read(void)
 	return ret;
 }
 
+static struct clocksource kvm_clock;
+
 static cycle_t kvm_clock_get_cycles(struct clocksource *cs)
 {
-	return kvm_clock_read();
+	cycle_t ret = kvm_clock_read();
+
+	return ret >= kvm_clock.cycle_last ?
+		ret : kvm_clock.cycle_last;
 }
 
 /*
-- 
1.6.2.5

