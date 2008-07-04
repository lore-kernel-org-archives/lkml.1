Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYGDMUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYGDMUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYGDMUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:20:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:14034 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYGDMUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mJ2QQozpUNWrlmwp2B3JkRd2TPgj9ExnuYNCJxJlwWJh44DrDO0VbO4CNCsoRAqOe7
         pw4d+rbR38gEFFciD1TUGR7GCT1lBJivkIRRYHixwCK8W0OxLKhPA8rHMdTHJLt5wFtx
         ui5dzXvq3zUODAwghBy0941jxzJ8x93JW6dIs=
Message-ID: <a4423d670807040520v7604782crd209d64aad9343ff@mail.gmail.com>
Date: Fri, 4 Jul 2008 16:20:32 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, sparclinux@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: next-0704: sparc64: build failure at arch/sparc64/kernel/sysfs.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

cc1: warnings being treated as errors
arch/sparc64/kernel/sysfs.c:160: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:160: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:205: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:206: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:207: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:208: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:209: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:210: error: initialization from
incompatible pointer type
arch/sparc64/kernel/sysfs.c:211: error: initialization from
incompatible pointer type

I think it is connected to

commit 5b01a6a61c48d8e6ab4679d6e6208f5962d07b85
Author: Andi Kleen <andi@firstfloor.org>
Date:   Tue Jul 1 18:48:41 2008 +0200

    sysdev: Pass the attribute to the low level sysdev show/store function

    This allow to dynamically generate attributes and share show/store
    functions between attributes. Right now most attributes are generated
    by special macros and lots of duplicated code. With the attribute
    passed it's instead possible to attach some data to the attribute
    and then use that in shared low level functions to do different things.

    I need this for the dynamically generated bank attributes in the x86
    machine check code, but it'll allow some further cleanups.

    I converted all users in tree to the new show/store prototype. It's a single
    huge patch to avoid unbisectable sections.

    Runtime tested: x86-32, x86-64
    Compiled only: ia64, powerpc
    Not compile tested/only grep converted: sh, arm, avr32

    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/arch/sparc64/kernel/sysfs.c b/arch/sparc64/kernel/sysfs.c
index e885034..b057bc1 100644
--- a/arch/sparc64/kernel/sysfs.c
+++ b/arch/sparc64/kernel/sysfs.c
@@ -14,7 +14,8 @@
 static DEFINE_PER_CPU(struct hv_mmu_statistics, mmu_stats)
__attribute__((aligned(64)));

 #define SHOW_MMUSTAT_ULONG(NAME) \
-static ssize_t show_##NAME(struct sys_device *dev, char *buf) \
+static ssize_t show_##NAME(struct sys_device *dev, \
+                       struct sysdev_attribute *attr, char *buf) \
 { \
        struct hv_mmu_statistics *p = &per_cpu(mmu_stats, dev->id); \
        return sprintf(buf, "%lu\n", p->NAME); \
