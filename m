Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbXDCQy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbXDCQy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbXDCQy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:54:29 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37881 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbXDCQy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:54:28 -0400
X-AuditID: d80ac287-92925bb000000c42-6d-461286c33849 
Date: Tue, 3 Apr 2007 17:54:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SCSI_WAIT_SCAN=m
In-Reply-To: <1175013257.3737.21.camel@mulgrave.il.steeleye.com>
Message-ID: <Pine.LNX.4.64.0704031736380.9029@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
 <1175013257.3737.21.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 03 Apr 2007 16:54:27.0314 (UTC) FILETIME=[BD700D20:01C77610]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007, James Bottomley wrote:
> On Tue, 2007-03-27 at 17:25 +0100, Hugh Dickins wrote:
> > I'm not using an initrd, most of my kernel is builtin,
> > just a few modules for occasional filesystems.
> > 
> > CONFIG_MODULES=y
> > CONFIG_SCSI=y
> > CONFIG_SCSI_SCAN_ASYNC=y
> > CONFIG_SCSI_WAIT_SCAN=m
> > 
> > 2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2,
> > but boots okay if I change drivers/scsi/Kconfig to "default y"
> > instead of "default m" for SCSI_WAIT_SCAN.
> 
> Hmm ... it sounds like there's a missing scsi_complete_async_scans() in
> your environment?

Situation unchanged in 2.6.21-rc5-mm4.  By what route do you expect
scsi_complete_async_scans() to get called usually, in a monolithic
kernel?  Before you made scsi_wait_scan a separate loadable module,
it was called via that late_initcall(wait_scan_init), so perhaps now
we need...


Make sure there's a late_initcall to scsi_complete_async_scans when
it's built in, so a monolithic SCSI_SCAN_ASYNC kernel can rely on the
scans being completed before trying to mount root, even if they're slow.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.21-rc5-mm4/drivers/scsi/scsi_scan.c	2007-04-03 15:29:21.000000000 +0100
+++ linux/drivers/scsi/scsi_scan.c	2007-04-03 17:24:24.000000000 +0100
@@ -183,6 +183,7 @@ int scsi_complete_async_scans(void)
 
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
+late_initcall(scsi_complete_async_scans);
 
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
