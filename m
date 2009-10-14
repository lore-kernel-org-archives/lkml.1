Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbZJNT37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbZJNT37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbZJNT36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:29:58 -0400
Received: from claw.goop.org ([74.207.240.146]:55335 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZJNT35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:57 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/12] xen/pvclock: add monotonicity check
Date: Wed, 14 Oct 2009 12:28:29 -0700
Message-Id: <1255548516-15260-6-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other tsc-based clocksources add a monotonicity test to make sure there's
no regression in the returned cycles.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/time.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0a5aa44..00f06cc 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -213,9 +213,14 @@ cycle_t xen_clocksource_read(void)
 	return ret;
 }
 
+static struct clocksource xen_clocksource;
+
 static cycle_t xen_clocksource_get_cycles(struct clocksource *cs)
 {
-	return xen_clocksource_read();
+	cycle_t ret = xen_clocksource_read();
+
+	return ret >= xen_clocksource.cycle_last ?
+		ret : xen_clocksource.cycle_last;
 }
 
 static void xen_read_wallclock(struct timespec *ts)
-- 
1.6.2.5

