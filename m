Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbXAXQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbXAXQ74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXAXQ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:59:55 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:41124 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752025AbXAXQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:59:54 -0500
Subject: Re: [patch] scsi: use lock per host instead of per device for
	shared queue tag host
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>,
       promise_linux <promise_linux@promise.com>
In-Reply-To: <NONAMEBDp7mvjkO22Zh0000056d@nonameb.ptu.promise.com>
References: <NONAMEBDp7mvjkO22Zh0000056d@nonameb.ptu.promise.com>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 08:59:49 -0800
Message-Id: <1169657989.3037.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 16:53 -0800, Ed Lin wrote:
> The block layer uses lock to protect request queue. Every scsi device
> has a unique request queue, and queue lock is the default lock in struct
> request_queue. This is good for normal cases. But for a  host with
> shared queue tag (e.g. stex controllers), a queue lock per device means
> the shared queue tag is not protected when multiple devices are accessed
> at a same time.  This patch is a simple fix for this situation by introducing
> a host queue lock to protect shared queue tag. Without this patch we will
> see various kernel panics (including the BUG() and kernel errors in
> blk_queue_start_tag and blk_queue_end_tag of ll_rw_blk.c) when accessing
> different devices simultaneously (e.g. copying big file from one device to
> another in smp kernels).

This patch looks OK in principle.

However, are you sure you're not using a sledgehammer to crack a nut?
If the only reason you're doing this is because of the shared tag map,
then probably that should be the area you protect with a per-tag-map
lock.   The net effect of what you've done will be to serialise all
accesses to your storage devices.  For a small number of devices, this
probably won't matter than much, but for large numbers of devices,
you're probably going to introduce artificial performance degredation in
the I/O scheduler.

James


