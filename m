Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0CKRee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:34:34 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60996 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0CKRed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:34:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EYpKGba/AhKcKR17H557g18+0U4jZhoMHrNPeScy7BA9n136D6GCw44hrcwNfv9aj1
         LjM6x08s0Ng6QCE83IrkJkeqjqf3laKsh/w6fPtDyO8su5VJctYlGenSXZHZihSktyhW
         uvzwdztjsZlBmkeNdAdzgyZt7oScZDQeOvHL8=
Subject: [RFC] kmemleak: Is DMI supported ?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 18:34:28 +0100
Message-ID: <1268328868.2986.547.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin

On my i686 machine, I have
CONFIG_DMI=y

and 12 entries in /sys/firmware/memmap/ like first one named "0" :

$ grep . /sys/firmware/memmap/0/*
/sys/firmware/memmap/0/end:0x9f3ff
/sys/firmware/memmap/0/start:0x0
/sys/firmware/memmap/0/type:System RAM


All 12 kobjects are allocated in DMI zone between
c1001000 b .brk.dmi_alloc
c1011000 B __brk_limit)

see arch/x86/kernel/setup.c:124

#ifdef CONFIG_DMI
RESERVE_BRK(dmi_alloc, 65536);
#endif

Still kmemleak seems to thing their names are unreferenced objects.


unreferenced object 0xf6a4bcd8 (size 8):
  comm "swapper", pid 1, jiffies 4294669233 (age 2454.223s)
  hex dump (first 8 bytes):
    31 31 00 f6 00 00 00 00                          11......
  backtrace:
    [<c05a5bc5>] kmemleak_alloc+0x45/0x60
    [<c02dcfa2>] __kmalloc+0x122/0x1f0
    [<c039fe00>] kvasprintf+0x30/0x50
    [<c0397469>] kobject_set_name_vargs+0x49/0xa0
    [<c03974e1>] kobject_add_varg+0x21/0x50
    [<c039756c>] kobject_add+0x2c/0x60
    [<c04bed4c>] add_sysfs_fw_map_entry+0x4c/0x90
    [<c07ec523>] memmap_init+0x13/0x2d
    [<c0201038>] do_one_initcall+0x28/0x180
    [<c07c539d>] kernel_init+0x140/0x1df
    [<c02030fa>] kernel_thread_helper+0x6/0x10
    [<ffffffff>] 0xffffffff


Any idea how to include dmi_alloc zone in kmemleak logic ?

Thanks


