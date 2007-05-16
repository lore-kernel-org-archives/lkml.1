Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbXEPInl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbXEPInl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762936AbXEPIjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:39:08 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2309 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763434AbXEPIjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:39:05 -0400
Date: Wed, 16 May 2007 09:38:55 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, kbuild-devel@lists.sourceforge.net
Subject: Re: [RFC] select and dependencies in Kconfig
Message-ID: <20070516083855.GC15071@flint.arm.linux.org.uk>
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	zippel@linux-m68k.org, kbuild-devel@lists.sourceforge.net
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk> <20070516033335.GH4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516033335.GH4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 04:33:35AM +0100, Al Viro wrote:
> On Tue, May 15, 2007 at 08:36:20PM +0100, Al Viro wrote:
> > 
> > stuff that does select USB should depend on USB_ARCH_HAS_HCD, or we'll
> > end up with unbuildable configs.
> 
> BTW, this kind of situation happens often enough, so how about doing
> the following: teach kconfig that if FOO selects BAR and BAR depends
> on <expr>, we should act as if FOO had explicit depends on <expr>.

We first need to ensure that we don't have any cases which explore the
current behaviour.  I wonder how the following will be interpreted with
the ARCH_IXP4XX=y and ARCH_IXP4XX=n cases:

arch/arm/common/Kconfig:config SA1111
arch/arm/common/Kconfig:        bool
arch/arm/common/Kconfig:        select DMABOUNCE
arch/arm/common/Kconfig:
arch/arm/common/Kconfig:config DMABOUNCE
arch/arm/common/Kconfig:        bool

arch/arm/mach-ixp4xx/Kconfig:if ARCH_IXP4XX
arch/arm/mach-ixp4xx/Kconfig:
...
arch/arm/mach-ixp4xx/Kconfig:config DMABOUNCE
arch/arm/mach-ixp4xx/Kconfig-   bool
arch/arm/mach-ixp4xx/Kconfig-   default y
arch/arm/mach-ixp4xx/Kconfig-   depends on PCI
...
arch/arm/mach-ixp4xx/Kconfig:endif


We also have:

arch/arm/mm/Kconfig:config CPU_32v6K
arch/arm/mm/Kconfig-    bool "Support ARM V6K processor extensions" if !SMP
arch/arm/mm/Kconfig-    depends on CPU_V6
arch/arm/mm/Kconfig-    default y if SMP

which gives: option available on V6 CPUs, user selectable on V6 UP, always
selected on V6 SMP.

and:

arch/arm/mm/Kconfig:config CPU_V7
arch/arm/mm/Kconfig:    bool "Support ARM V7 processor"
arch/arm/mm/Kconfig:    depends on ARCH_INTEGRATOR
arch/arm/mm/Kconfig:    select CPU_32v6K

It would be undesirable for CPU_V7 to depend on CPU_V6 being set.  (V7
always has V6K.)  I guess V6K would have to become:

config CPU_32v6K
	bool "Support ARM V6K processor extensions" if !SMP && !CPU_V7
	depends on CPU_V6 || CPU_V7
	default y if SMP || CPU_V7

and the select statement removed from CPU_V7.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
