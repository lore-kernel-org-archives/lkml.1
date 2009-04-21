Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZDUVUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZDUVUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZDUVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:19:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59360 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZDUVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:19:52 -0400
Date: Tue, 21 Apr 2009 22:10:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       torvalds@linux-foundation.org, greg@kroah.com
Subject: Re: driver synchronization: make scsi_wait_scan more advanced
Message-ID: <20090421211040.GA27557@flint.arm.linux.org.uk>
References: <20090421134206.07b8ee7e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421134206.07b8ee7e@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 01:42:06PM -0700, Arjan van de Ven wrote:
> (CC'ing linux-scsi as well since this touches a file in drivers/scsi)
> 
> 
> From 546fdda8b4124a7473f32decf4a2981984f287db Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Tue, 21 Apr 2009 13:32:54 -0700
> Subject: [PATCH] driver synchronization: make scsi_wait_scan more advanced
> 
> 
> There is currently only one way for userspace to say "wait for my storage
> device to get ready for the modules I just loaded": to load the
> scsi_wait_scan module. Expectations of userspace are that once this
> module is loaded, all the (storage) devices for which the drivers
> were loaded before the module load are present.
> 
> Now, there are some issues with the implementation, and the async
> stuff got caught in the middle of this: The existing code only
> waits for the scsy async probing to finish, but it did not take
> into account at all that probing might not have begun yet.
> (Russell ran into this problem on his computer and the fix works for him)

Indeed yes.  With CONFIG_SCSI_SCAN_ASYNC unset, but with the scsi host
driver built as a module, the behaviour without this patch causes
problems.  The machine would load the pata_pcmcia driver, which would
then detect and register the interface:

  ata1: PATA max PIO0 cmd 0xd0880000 ctl 0xd088000e irq 135

At this point, the insmod process returns, and the init script continued,
loading scsi_wait_scan which did nothing, and we'd continue the init
script, which would try to detect and mount the storage attached to this
interface - and fail because the device probes haven't completed.  The
only workaround I found was to add a 'sleep 1' to the script to give the
various layers in the kernel time to sort themselves out.

With this patch, the loading of scsi_wait_scan waits for the device to
finish probing, and we can properly detect and mount the attached storage
(which in this case is the rootfs) and the 'sleep 1' hack isn't required.

So, for everything but the scsi_scan.c hunk:

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
