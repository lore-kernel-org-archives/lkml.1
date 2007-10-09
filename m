Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbXJIKrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbXJIKrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 06:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXJIKrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 06:47:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:45211 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbXJIKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 06:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=grChn9UljPveRIAWfhk8EuvCpAmQV+/WVEcMT8q24ooEN6oe3ziKvw8tCSBA9Fh0RdeCWzeWXLi1tt6ioiIyAUcyTiFAwaoVpJDvQFuNXjB3msFyFvIg3vbSSZzXrq9YeqKmWfqZahSdVpqVh6x/YtXh/noG+AjnteWQVPx3emU=
Date: Tue, 9 Oct 2007 19:43:21 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] fix wrong /proc/cpuinfo output
Message-ID: <20071009104321.GA32272@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the problem introduced by:
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch

The problem is that every processor line in /proc/cpuinfo displays zero
on x86_64.

$ grep processor /proc/cpuinfo
processor       : 0
processor       : 0

Because early_identify_cpu() overwrites c->cpu_index for every cpuinfo.
This patch removes that unnecessary initialization for c->cpu_index.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Index: 2.6-mm/arch/x86_64/kernel/setup.c
===================================================================
--- 2.6-mm.orig/arch/x86_64/kernel/setup.c
+++ 2.6-mm/arch/x86_64/kernel/setup.c
@@ -967,7 +967,6 @@ void __cpuinit early_identify_cpu(struct
 
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
-	c->cpu_index = 0;
 #endif
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
