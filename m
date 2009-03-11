Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbZCKPqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbZCKPqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZCKPqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:46:09 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:58728 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZCKPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:46:08 -0400
Date: Wed, 11 Mar 2009 15:46:05 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Message-ID: <20090311154605.GD1475@console-pimps.org>
References: <20090311140219.GA1475@console-pimps.org> <200903111555.00982.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903111555.00982.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:55:00PM +0100, Wolfgang Mües wrote:
> 
> My patch 6 in mmc_spi_skip() is doing a busy-wait for a short while ( less 
> than 1 jiffie), and starts to call schedule() inside the loop if the card is 
> slower.
> 

OK, but if my machine runs at 100 HZ then a jiffie is 10ms. Previously
(without your patch) we waited for 300ms in the write case and 100ms in
the read case. So, it's not unreasonable to think that a response is
going to take more than 10ms. With your patch we're almost always going
to schedule() with no indication of exactly when we're going to come
back.

> My goal was to avoid the long-lasting busy waiting. I have measured times up 
> to 900ms! With my patch, the longest busy waiting will be 1 jiffie. 
> 

I agree that busy-waiting for 900ms would be a bit mad. Is there a
reason that you didn't implement this with msleep() as was noted in the
comment above the timeout?


                /* REVISIT investigate msleep() to avoid busy-wait I/O
                 * in at least some cases.
                 */


> And yes, if the SD card is sending its response after 5 jiffies, it is 
> recognized only after the scheduler schedules this process, which will incure 
> a delay to the data transfer. The amount of delay is determined by the number 
> of running processes and the number of HZ.
> 

Have you benchmarked this case? Do you know approximately how long it
is before we return from the schedule() under various workloads?
