Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZJQAeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZJQAeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZJQAeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:34:10 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:18098
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbZJQAeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:34:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8BAE+u2Ep8qM+u/2dsb2JhbAAI2E6EMQQ
X-IronPort-AV: E=Sophos;i="4.44,576,1249228800"; 
   d="scan'208";a="512395663"
Subject: Re: Kernel driver with multiple SPI sources
From: Ben Nizette <bn@niasdigital.com>
To: Bertrand Roussel <bertrand.roussel@cor-net.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a5b9b4700910160150o146a8f21n1c76c14755d64da8@mail.gmail.com>
References: <a5b9b4700910160150o146a8f21n1c76c14755d64da8@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 17 Oct 2009 11:34:43 +1100
Message-Id: <1255739684.9801.5.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 21:50 +1300, Bertrand Roussel wrote:

>  _____      ______
> |     | <> |  ADC |
> |     |    |______|
> | IMU |     ______  <> Bus SPI
> |     | <> |  MAG |
> |_____|    |______|
> 
> Each block correspond to a driver:
> * IMU is a basic char driver, depending on both ADC and MAG driver,
> and that register new spi_device to the spi_master
> * ADC and MAG are instances of an spi_driver, with a char driver as an interface
> 

Why is the IMU part a kernel driver?  Surely the kernel only needs to
know about the ADC and the MAG unit, expose interfaces for them to the
outside world and have all the IMU maths in userspace?

The ADC and MAG drivers there fit exactly in to the model of the new IIO
subsystem (industrial I/O).  This subsystem is in staging/ at the moment
rather than being a first-class citizen but don't let that stop you
using it.  IIO gives each device registered through it a number of sysfs
knobs to control things like sample rate etc and then a time-stamped
ring buffer holding the actual data.  Your IMU then just sits in
userspace consuming that buffer, matching ADC and MAG entries with the
same (similar) timestamps and doing the maths.

And no, you certainly should not spin-wait on the data to become
available.  Just set up an interrupt handler for the pin change, from
the interrupt start an spi_async transfer or spawn a workqueue to get
the data out.  The async callback or workqueue then can submit the data
to IIO for buffering for userspace.

	--Ben.


