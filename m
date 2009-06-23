Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbZFWXXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbZFWXXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbZFWXWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:22:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38625
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbZFWXWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:22:51 -0400
Date: Tue, 23 Jun 2009 16:22:56 -0700 (PDT)
Message-Id: <20090623.162256.190152758.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the
 IRQ context
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906232329.11648.bzolnier@gmail.com>
References: <200906232329.11648.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 23 Jun 2009 23:29:11 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: allow ide_dev_read_id() to be called from the IRQ context
> 
> * Un-static __ide_wait_stat().
> 
> * Allow ide_dev_read_id() helper to be called from the IRQ context by
>   adding irq_ctx flag and using mdelay()/__ide_wait_stat() when needed.
> 
> * Switch ide_driveid_update() to set irq_ctx flag.
> 
> This change is needed for the consecutive patch which fixes races in
> handling of user-space SET XFER commands but for improved bisectability
> and clarity it is better to do it in a separate patch.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> I'm not completely happy with this version of patch since I originally
> intended to unify ide_busy_sleep() with __ide_wait_stat() first..

This and patch #5 seems way overkill for the problem being solved.

All requests programmed into the device get synchronized through the
block request queue, even these raw taskfile commands.

It seems to me that it should be possible to use the block request
layer facilities to plug the queue, wait all executing commands to
complete and for the device to quiesce, then push this single RAW
command from the user to the device, and finally unplug the queue.

Alternatively, if the block request layer can't help, we can put a
mutex around submissions, and have this user RAW command submission
take that mutex.

Anything other than moving code that does significant delays into
interrupt context.
