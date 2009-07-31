Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZGaKp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZGaKp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZGaKpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:45:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51351 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZGaKpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:45:55 -0400
Date: Fri, 31 Jul 2009 11:45:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Fertser <fercerpav@gmail.com>, sameo@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcf50633: use a dedicated workqueue for irq processing
Message-ID: <20090731104550.GB17091@sirena.org.uk>
References: <200907281845.n6SIjIlf025081@home.pavel.comp> <20090730153425.9a3fc5ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730153425.9a3fc5ac.akpm@linux-foundation.org>
X-Cookie: hipatitis:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 03:34:25PM -0700, Andrew Morton wrote:

> The patch looks reasonable, but creating yet another kernel thread is a
> bit sad.  And I suspect that other MFD drivers are doing the same thing
> as pcf50633-core.c, in which case we should change those as well?

It's just pcf50633 that's immediately affected from the looks of it.
What's going wrong for it is that it's using interrupts from the device
to determine when an ADC conversion is complete and since it's an I2C
device it's doing interrupt handling in the standard work queue.  Other
MFDs that might be affected appear to be already using a separate work
queue or thread for their interrupts which would allow them to push any
work that needs to wait for interrupts from the device into the standard
workqueue.

The issue shouldn't need so much handling by drivers when these I2C/SPI
driven devices can use genirq (which looks likely soon although it's not
possible currently) since then the interrupt handling will occur within
IRQ threads.  Devices that can interact with the device from interrupt
context aren't affected since they don't need to defer interrupt
handling to a work queue.
