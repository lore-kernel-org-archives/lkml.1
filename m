Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbZAUH46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbZAUH46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 02:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbZAUH4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 02:56:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55470 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZAUH4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 02:56:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4976D52F.5090109@s5r6.in-berlin.de>
Date: Wed, 21 Jan 2009 08:56:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: swiotlb default size (64 MB) too small?
References: <49762FC8.7000208@s5r6.in-berlin.de> <20090121074339N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090121074339N.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> The bug reporter said that copying stooped but it should not
> happen. It doesn't happen with SCSI (copying can continue a bit
> slowly). dma mapping errors are transient so SCSI retries.
...
> If the bug report is true, then the FireWire stack or the driver (or
> both) has problems. Make sure that FireWire can work even with dma
> mapping failures.

sbp2_scsi_queuecommand returns SCSI_MLQUEUE_HOST_BUSY if DMA mapping
failed.  Isn't this what should happen?

However, both usb-storage and firewire-sbp2 currently have a queudepth
of only 1; if there are no DMA resources to map just this one SCSI
request, how should the system be able to recover?  It can wait, but it
can't lower the part of the workload which is related to this particular
copying operation (which, as  the reporter wrote, ultimately stopped). I
suppose there is something else* on the reporter's system which tied up
too much swiotlb resources the whole time; and then just waiting a bit
until the next queucommand won't get things going.

*) The report does not sound like there was a DMA mappig leak caused by
copying between usb-storage and firewire-sbp2.  Else he would have hit
the problem again even with increased swiotlb default size.

> My dma mapping debug patchset might be useful:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git dmafault
> 
> You can inject dma mapping failures per device:
> 
> vine:/debug/pci/0000:00:1d.1# ls
> interval  probability  space  task-filter  times  verbose

This could be handy, thanks.
-- 
Stefan Richter
-=====-==--= ---= =-=-=
http://arcgraph.de/sr/
