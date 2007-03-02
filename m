Return-Path: <linux-kernel-owner+w=401wt.eu-S1422998AbXCBKWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422998AbXCBKWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 05:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423004AbXCBKWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 05:22:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52371 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422998AbXCBKWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 05:22:15 -0500
Date: Fri, 2 Mar 2007 02:18:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, andreas.friedrich@fujitsu-siemens.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -mm] clocksource init adjustments (fix bug #7426)
Message-Id: <20070302021827.7edc1a23.akpm@linux-foundation.org>
In-Reply-To: <1172189582.5422.26.camel@localhost.localdomain>
References: <1172189582.5422.26.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 16:13:02 -0800 john stultz <johnstul@us.ibm.com> wrote:

> This patch resolves the issue found here:
> http://bugme.osdl.org/show_bug.cgi?id=7426
> 
> The basic summary is:
> Currently we register most of i386/x86_64 clocksources at module_init
> time. Then we enable clocksource selection at late_initcall time. This
> causes some problems for drivers that use gettimeofday for init
> calibration routines (specifically the es1968 driver in this case),
> where durring module_init, the only clocksource available is the low-res
> jiffies clocksource. This may cause slight calibration errors, due to
> the small sampling time used.
> 
> It should be noted that drivers that require fine grained time may not
> function on architectures that do not have better then jiffies
> resolution timekeeping (there are a few). However, this does not
> discount the reasonable need for such fine-grained timekeeping at init
> time.
> 
> Thus the solution here is to register clocksources earlier (ideally when
> the hardware is being initialized), and then we enable clocksource
> selection at fs_initcall (before device_initcall).
> 
> This patch should probably get some testing time in -mm, since
> clocksource selection is one of the most important issues for correct
> timekeeping, and I've only been able to test this on a few of my own
> boxes.

This doornails my Nocona box early in boot:
http://userweb.kernel.org/~akpm/s5000431.jpg

Slab isn't ready yet - time_init()->hpet_arch_init() is called before
start_kernel() has run kmem_cache_init().


