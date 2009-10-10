Return-Path: <linux-kernel-owner+w=401wt.eu-S934706AbZJJSiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706AbZJJSiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934616AbZJJSiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:38:07 -0400
Received: from www.tglx.de ([62.245.132.106]:58402 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934611AbZJJSiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:38:05 -0400
Date: Sat, 10 Oct 2009 20:37:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <rdreier@cisco.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: infiniband BKL leftovers
Message-ID: <alpine.LFD.2.00.0910102015400.9428@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

I'm looking into removing cycle_kernel_lock() from
drivers/infiniband/hw/ipath/ipath_file_ops.c .

cycle_kernel_lock() was pushed down into open functions to "emulate"
the previous BKL protected semantics by "serializing" the open
function against driver init in progress. Nobody knows how effective
this "serialization" was in reality. :)

This protection is not necessary when everything what might be needed
by write/aio_write/poll/mmap should be in place before
ipath_user_add() creates the device node.

But looking at the callsite ipath_init_one() I'm not so sure about that.

At the end of ipath_init_one() I see:

        ipath_device_create_group(&pdev->dev, dd);
        ipathfs_add_device(dd);
        ipath_user_add(dd);
        ipath_diag_add(dd);
        ipath_register_ib_device(dd);

ipath_user_add() is called before ipath_register_ib_device() which
registers the device with the infiniband core. That makes me wonder
whether the device node is really ready to use right after it is
created.

Aside of that I noticed that all the functions above have elaborate
error pathes, but non of the return values of these functions is ever
checked. Intersting approach :)

Thanks,

	tglx


