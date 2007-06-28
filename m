Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbXF1NcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbXF1NcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXF1NcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:32:06 -0400
Received: from ozlabs.org ([203.10.76.45]:45435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbXF1NcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:32:05 -0400
Subject: [PATCH] Fix lguest w/ lockdep
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
In-Reply-To: <20070628001425.GR11115@waste.org>
References: <20070628001425.GR11115@waste.org>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 23:31:59 +1000
Message-Id: <1183037519.6211.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 19:14 -0500, Matt Mackall wrote:
> lguest: unhandled trap 14 at 0xc01362f7 (0x0)
> Dump of assembler code for function __lock_acquire:

Thanks for the bug report Matt!  I wonder if other
paravirt_disable_iospace users have the same issue...
===

Fix "lguest: unhandled trap 14 at 0xc013630f (0x0)" with CONFIG_LOCKDEP=y

paravirt_disable_iospace -> request_resource -> write_lock -> __lock_acquire()

lockdep_init() is already idempotent: simply call it before
paravirt_disable_iospace().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r bea2b8147985 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Thu Jun 07 22:50:36 2007 +1000
+++ b/drivers/lguest/lguest.c	Thu Jun 28 23:21:26 2007 +1000
@@ -593,6 +593,8 @@ __init void lguest_init(void *boot)
 
 	reserve_top_address(lguest_data.reserve_mem);
 
+	lockdep_init();
+
 	paravirt_disable_iospace();
 
 	cpu_detect(&new_cpu_data);


