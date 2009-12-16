Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbZLPL2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbZLPL2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbZLPL2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:28:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43995 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZLPL2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:28:48 -0500
Date: Wed, 16 Dec 2009 12:28:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: ebiederm@xmission.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SYSCTL: Fix sysctl breakage on systems with older glibc
Message-ID: <20091216112844.GA31705@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSCTL: Fix breakage on systems with older glibc

As predicted during code review, the sysctl(2) changes made systems
with old glibc nearly unusable. About every command gives a:

warning: process `ls' used the deprecated sysctl s ystem call with 1.4

warning in the log.

I see this on a SUSE 10.0 system with glibc 2.3.5.
Don't warn for this common case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff -u linux-2.6.32-git12/kernel/sysctl_binary.c-o linux-2.6.32-git12/kernel/sysctl_binary.c
--- linux-2.6.32-git12/kernel/sysctl_binary.c-o	2009-12-16 12:15:52.000000000 +0100
+++ linux-2.6.32-git12/kernel/sysctl_binary.c	2009-12-16 12:14:58.000000000 +0100
@@ -1399,6 +1399,13 @@
 {
 	int i;
 
+	/* 
+	 * CTL_KERN/KERN_VERSION is used by older glibc and cannot 
+	 * ever go away.
+	 */
+	if (name[0] == CTL_KERN && name[1] == KERN_VERSION)
+		return;
+
 	if (printk_ratelimit()) {
 		printk(KERN_INFO
 			"warning: process `%s' used the deprecated sysctl "
