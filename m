Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0CITaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:30:23 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:58526 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0CITaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:30:22 -0500
Date: Tue, 9 Mar 2010 12:30:21 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] PPC: Skip over OF_DT_NOP when unflattening the device tree
Message-ID: <20100309193021.GD30462@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOPs within the property section are skipped, but NOPs between
OF_DT_END_NODE and OF_DT_BEGIN_NODE were not. My firmware NOPs out
entire nodes depending on various environment parameters.

of_scan_flat_dt already handles NOP more generally..

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 arch/powerpc/kernel/prom.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 4ec3008..92137b2 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -408,8 +408,11 @@ static unsigned long __init unflatten_dt_node(unsigned long mem,
 		if (!np->type)
 			np->type = "<NULL>";
 	}
-	while (tag == OF_DT_BEGIN_NODE) {
-		mem = unflatten_dt_node(mem, p, np, allnextpp, fpsize);
+	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
+		if (tag == OF_DT_NOP)
+			*p += 4;
+		else
+			mem = unflatten_dt_node(mem, p, np, allnextpp, fpsize);
 		tag = *((u32 *)(*p));
 	}
 	if (tag != OF_DT_END_NODE) {
-- 
1.5.4.2

