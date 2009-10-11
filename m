Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZJKRm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZJKRm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZJKRm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:42:58 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:24024 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZJKRm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:42:56 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJm10UqrR7Ht/2dsb2JhbAC+FZZNhC0E
X-IronPort-AV: E=Sophos;i="4.44,542,1249257600"; 
   d="scan'208";a="406821369"
From: Roland Dreier <rdreier@cisco.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
       Ralph Campbell <infinipath@qlogic.com>
Subject: Re: infiniband BKL leftovers
References: <alpine.LFD.2.00.0910102015400.9428@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 11 Oct 2009 10:42:19 -0700
In-Reply-To: <alpine.LFD.2.00.0910102015400.9428@localhost.localdomain>
	(Thomas Gleixner's message of "Sat, 10 Oct 2009 20:37:20 +0200
	(CEST)")
Message-ID: <adad44tj090.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Oct 2009 17:42:20.0277 (UTC) FILETIME=[2EB8EA50:01CA4A9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding a few CCs]

 > I'm looking into removing cycle_kernel_lock() from
 > drivers/infiniband/hw/ipath/ipath_file_ops.c .
 > 
 > cycle_kernel_lock() was pushed down into open functions to "emulate"
 > the previous BKL protected semantics by "serializing" the open
 > function against driver init in progress. Nobody knows how effective
 > this "serialization" was in reality. :)
 > 
 > This protection is not necessary when everything what might be needed
 > by write/aio_write/poll/mmap should be in place before
 > ipath_user_add() creates the device node.
 > 
 > But looking at the callsite ipath_init_one() I'm not so sure about that.
 > 
 > At the end of ipath_init_one() I see:
 > 
 >         ipath_device_create_group(&pdev->dev, dd);
 >         ipathfs_add_device(dd);
 >         ipath_user_add(dd);
 >         ipath_diag_add(dd);
 >         ipath_register_ib_device(dd);
 > 
 > ipath_user_add() is called before ipath_register_ib_device() which
 > registers the device with the infiniband core. That makes me wonder
 > whether the device node is really ready to use right after it is
 > created.
 > 
 > Aside of that I noticed that all the functions above have elaborate
 > error pathes, but non of the return values of these functions is ever
 > checked. Intersting approach :)

I guess you guys are getting serious about BKL removal.  I think I made
about as much progress on the ipath driver when the BKL pushdown first
happened: I looked at the code with an eye to getting rid of the BKL and
got too confused and scared to proceed.

I'm not sure what the best way to handle this is; as far as I know the
ipath code is abandoned by Qlogic (they have a new driver that also
supports newer hw that they have not tried to get upstream yet) and BKL
issues aside the code looks racy, eg

	if (atomic_inc_return(&user_count) == 1) {
		ret = user_init();

makes sure that only one thread does user_init() but it doesn't make
sure that user_init() finishes before another thread proceeds.

So I guess if the BKL stuff is blocking you in any way, we can just drop
it from ipath and leave it as yet another race condition in a rotting
old driver.

 - R.
