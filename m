Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbYJCK6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbYJCK6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYJCK6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:58:02 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:56529 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYJCK6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:58:01 -0400
Message-Id: <20081003105632.357231142@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Oct 2008 12:56:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au, jens.axboe@oracle.com, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to stop_machine infrastructrue.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series would allow to convert s390 to the generic IPI interface.
We can't to that currently since our etr/stp code relies on the old semantics
of smp_call_function that guarantee that the function only returns after all
receiving cpus have acknowledged the IPI. That way it is known that all other
cpus are running in an interrupt handler with interrupts disabled.
This is not true anymore with the generic IPI infrastructure.

So one idea was to use stop_machine in order to synchronize all cpus. Rusty
was kind enough to extend it so that it is now possible to run a function
on several cpus, instead of just one.
However we need to be able to do that without allocating any memory. That's
what this patch set is about. It introduces two new interfaces which allow
to create the kstop threads in advance so that a subsequent stop_machine call
will be able to run without the need to create any threads and therefore
avoids the need to allocate any memory.

The two interfaces (see patch 2) are:

stop_machine_get_threads() - create all needed kstop threads in advance.
If it is called multiple times it will just increase an internal usecount.

stop_machine_put_threads() - kill all previously created kstop threads,
if the internal usecount drops to zero.

Patch 1 is a stop_machine bugfix and is independent of the rest
Patch 2 introduces the new proposed interface
Patch 3 converts the s390 etr and stp code to the new API
Patch 4 converts s390 to the generic IPI interface

Thanks,
Heiko
