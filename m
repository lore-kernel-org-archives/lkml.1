Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZJJKim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZJJKim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 06:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZJJKij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 06:38:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39557 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZJJKii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 06:38:38 -0400
Date: Sat, 10 Oct 2009 12:38:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] aoe: add barrier support
Message-ID: <20091010103801.GP9228@kernel.dk>
References: <4172194fb69fa7475c78e20ddce579fa@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4172194fb69fa7475c78e20ddce579fa@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09 2009, Ed Cashin wrote:
> This patch allows the aoe driver to support barrier bios by draining
> the current set of outstanding AoE commands and then issuing an ATA
> flush command.  If the barrier contains I/O, that I/O is then
> performed, followed by a final ATA flush command.

Good, that's exactly how libata/ide works as well.

> This aoe driver differs from most block device drivers in that it does
> not handle I/O requests but handles bios, providing a make_request_fn
> to the block layer.
> 
> The implementation makes the make_request_fn sleep to wait for any
> in-progress barrier to finish, and it sleeps waiting for the ATA flush
> to complete.  I expect the process using make_request_fn to be
> something like "cp", in which case sleeping will not interfere with
> the performance characteristics of any unrelated aoe devices in the
> system.  That hasn't been tested yet, though, and I'm concerned that
> putting pdflush to sleep could interfere with dirty data flushing on
> other aoe devices.  Any comments about this issue would be
> appreciated.

pdflush doesn't exist anymore, the per-bdi thread may block without
causing any problems.

> Some debugging code remains in this patch for testing purposes, marked
> with "XXXdebug".  This code allows barrier handling to be turned off
> and on and to be traced.  Turning barrier support on and off is only
> supported on module load.  This testing feature will not be a part of
> the final barrier support for aoe.

Sounds good.

> Jens Axboe suggests that code that we know can sleep should use
> spin_lock_irq instead of spin_lock_irqsave.  Even though the latter is
> harmless, it also adds no value.  This patch sneaks a few such lock
> changes in.  Please comment if you think the change from
> spin_lock_irqsave to spin_lock_irq should be split out of the final
> version of this patch.

While I (obviously) think that is a good idea, you should not include it
in this patch. Patches should generally only do just one thing.

-- 
Jens Axboe

