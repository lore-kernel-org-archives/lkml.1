Return-Path: <linux-kernel-owner+w=401wt.eu-S1422716AbXCBJBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbXCBJBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422742AbXCBJBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:01:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50118 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422716AbXCBJBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:01:49 -0500
Date: Fri, 2 Mar 2007 00:58:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: kref refcounting breakage in mainline
Message-Id: <20070302005833.949be737.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-mm has a debugging patch which warns when atomic_dec_and_test() takes an
atomic_t negative
(ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/detect-atomic-counter-underflows.patch).


When it is applied to current mainline, a simple `rmmod ipw2200' gives:

[   75.825072] BUG: atomic counter underflow at:
[   75.825180]  [<c01c6eb4>] kref_put+0x66/0x82
[   75.825278]  [<c022e4d4>] bus_remove_driver+0x66/0x75
[   75.825383]  [<c022ee2c>] driver_unregister+0x8/0x13
[   75.825484]  [<c01d7add>] pci_unregister_driver+0xc/0x45
[   75.825593]  [<c0132147>] sys_delete_module+0x157/0x17c
[   75.825703]  [<c013c663>] audit_syscall_entry+0x10d/0x137
[   75.825818]  [<c0103b14>] syscall_call+0x7/0xb
[   75.825913]  [<c02d0000>] xfrm4_dst_destroy+0xe/0xd5

This didn't happen in 2.6.20-mm2, so this bug was introduced by a patch
which was not in the -mm lineup twelve days ago.

Presumably the effect of this is a memory leak or a use-after-free.
