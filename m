Return-Path: <linux-kernel-owner+w=401wt.eu-S935055AbZJOI7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055AbZJOI7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935030AbZJOI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:59:51 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:43978 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935024AbZJOI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hPUmtgC65mTBqC3U5Tb3WLP4OIzH60z247UZQ4ZFUp2VBPId0IkzsS/kRknwJRTsJi
         hhR67mVIly8md2EYU8NeuGl86HQMXcFQu5JdDoXtg4YhEGihPiccj1O8oZjABelaDywg
         e84SRt7YzCs4TAf827ob7rHlh/GNr+2hAqlCo=
MIME-Version: 1.0
Date: Thu, 15 Oct 2009 10:59:13 +0200
Message-ID: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
Subject: Leaks in trace reported by kmemleak
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: lizf@cn.fujitsu.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed your latest patch for memory leak in filter setting
(8ad807318fcd...) - but even with this patch - kmemleak seems to still
report  lots  (~900) of following leaks - note - they come only from
i915 and kvm module - so I'm not sure if these two modules are doing
something wrong or the problem is in trace code.

It looks like whole directory is somehow forgotten.

nreferenced object 0xffff880134b21268 (size 8):
  comm "modprobe", pid 1099, jiffies 4294881626
  hex dump (first 8 bytes):
    69 6e 74 00 01 88 ff ff                          int.....
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x60
    [<ffffffff81127943>] __kmalloc_track_caller+0x143/0x230
    [<ffffffff81104385>] kstrdup+0x45/0x80
    [<ffffffff810dd5c9>] trace_define_field+0x89/0x1b0
    [<ffffffff810dd7bc>] trace_define_common_fields+0xcc/0x110
    [<ffffffffa0370426>]
ftrace_define_fields_i915_ring_wait_end+0x16/0x50 [i915]
    [<ffffffff810dcc53>] event_create_dir+0x93/0x480
    [<ffffffff810dd13f>] trace_module_notify+0xff/0x500
    [<ffffffff814247e8>] notifier_call_chain+0x78/0xb0
    [<ffffffff8107f190>] __blocking_notifier_call_chain+0x60/0x90
    [<ffffffff8107f1d6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810a0bfa>] sys_init_module+0xaa/0x260
    [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

...

unreferenced object 0xffff880134b21a78 (size 8):
  comm "modprobe", pid 1106, jiffies 4294881716
  hex dump (first 8 bytes):
    5f 5f 75 33 32 00 ff ff                          __u32...
  backtrace:
    [<ffffffff8140e986>] kmemleak_alloc+0x26/0x60
    [<ffffffff81127943>] __kmalloc_track_caller+0x143/0x230
    [<ffffffff81104385>] kstrdup+0x45/0x80
    [<ffffffff810dd5c9>] trace_define_field+0x89/0x1b0
    [<ffffffffa03cf802>]
ftrace_define_fields_kvm_mmu_pagetable_walk+0x82/0x90 [kvm]
    [<ffffffff810dcc53>] event_create_dir+0x93/0x480
    [<ffffffff810dd13f>] trace_module_notify+0xff/0x500
    [<ffffffff814247e8>] notifier_call_chain+0x78/0xb0
    [<ffffffff8107f190>] __blocking_notifier_call_chain+0x60/0x90
    [<ffffffff8107f1d6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810a0bfa>] sys_init_module+0xaa/0x260
    [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
