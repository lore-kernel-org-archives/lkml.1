Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbXEJOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbXEJOeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXEJOdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:33:53 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:50001 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756090AbXEJOdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:33:52 -0400
Date: Thu, 10 May 2007 16:33:48 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Message-ID: <20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
In-Reply-To: <46432212.9070008@drzeus.cx>
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	<46430A49.9090803@drzeus.cx>
	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>
	<46432212.9070008@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 15:45:54 +0200
Pierre Ossman <drzeus@drzeus.cx> wrote:

> Haavard Skinnemoen wrote:
> > 
> > What exactly makes this unreliable? This is done almost exactly the
> > same way for SCSI. See drivers/scsi/scsi_wait_scan.c.
> > 
> 
> I am not against the function of waiting for an initial scan, what I oppose is
> using side effects to achieve that function. I do not want to take
> responsibility for something that easily breaks because we use a kernel
> subsystem for something it wasn't meant for.

Ok, is there any better way to achieve the same this? As far as I
can tell, mmc_remove_host() uses mmc_flush_scheduled_work() for the
same purpose -- it ensures that scans that have already been started
will have completed before the function continues.

> That said, if there is a precedent for achieving this function a certain way, I
> might be convinced to let it in. I'll have a look at that scsi example.

Thanks.

> > I don't know about USB, but root=/dev/mmcblk0p1 used to work before
> > 2.6.20 and it doesn't work anymore. Doesn't that make this a regression?
> > 
> 
> Yes and no. It depends on if it was an official function, or just an effect of
> how things currently were implemented. As far as I can see, it's the latter. The
> MMC layer goes through several steps that could very well get delayed or happen
> in parallel. So the fact that it happened to work the way you wanted it to was
> sheer luck.

I wouldn't call it luck. The way mmc_rescan() is implemented, any scans
that are started before late_initcall time are completed before
mmc_finish_detect() returns. The steps are all done synchronously in
the workqueue function.

And I never realized that using a block device as a parameter to the
root= parameter could possibly be "unofficial" functionality...?

Haavard
