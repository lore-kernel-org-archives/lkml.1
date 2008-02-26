Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbYBZMuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbYBZMuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYBZMu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:50:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35344 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751473AbYBZMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:50:28 -0500
Date: Tue, 26 Feb 2008 12:39:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
Message-ID: <20080226123946.75dbe3d2@core>
In-Reply-To: <87skzgd1zk.fsf@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The general idea: A daemon running in user space monitors input data
> from an accelerometer. When the daemon detects a critical condition,

That sounds like a non starter. What if the box is busy, what if the
daemon or something you touch needs memory and causes paging ?

Given the accelerometer data should be very simple doesn't it actually
make sense in this specific case to put the logic (not thresholds) in
kernel space.

> state. To this end, the kernel has to issue an idle immediate command
> with unload feature and stop the block layer queue afterwards. Once the

Yep. Pity the worst case completion time for an IDE I/O is 60 seconds or
so.

> 1. Who is to be in charge for the shock protection application? Should
>    userspace speak to libata / ide directly (through sysfs) and the low

I think it has to be kernel side for speed, and because you will need to
issue idle immediate while a command sequence is active which is
*extremely* hairy as you have to recover from the mess and restart the
relevant I/O. Plus you may need controller specific knowledge on issuing
it (and changes to libata).

> 2. Depending on the answer to the previous question, by what mechanism
>    should block layer and lld interact? Special requests, queue hooks or
>    something in some way similar to power management functions (once
>    suggested by James Bottomley)?

Idle immediate seem to simply fit the queue model, it happens in
*parallel* to I/O events and is special in all sorts of ways.

> 3. What is the preferred way to pass device specific configuration
>    options to libata (preferrably at runtime, i.e., after module
>    loading)?

sysfs
