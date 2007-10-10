Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXJJKI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXJJKI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXJJKIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:08:49 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3134 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXJJKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:08:48 -0400
Date: Wed, 10 Oct 2007 05:08:44 -0500 (CDT)
Message-Id: <200710101008.l9AA8hIG084068@sullivan.realtime.net>
From: Milton Miller <miltonm@bga.com>
To: Olof Johansson <olof@lixom.net>, Paul Mackerras <paulus@samba.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] powerpc: don't enable cpu hotplug on mpic-based pseries
In-Reply-To: <20071010003824.GA8477@lixom.net>
References: <20071008180406.052382073@mini.kroah.org>,
	<20071008180633.GJ7627@kroah.com>,
	<20071009151702.GA19209@lixom.net>,
	<20071009222003.GA21228@kroah.com>,
	<alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain>,
	<alpine.LFD.0.999.0710091625520.3838@woody.linux%foundation.org>,
	<20071010000815.GB7875@lixom.net>,
	<20071010101826.186f1f24.sfr@canb.auug.org.au>,
	<20071010003824.GA8477@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Don't allow cpu hotplug on pSeries systems lacking XICS interrupt controller,
since current code is hardcoded to call xics routines.

Signed-off-by: Milton Miller <miltonm@bga.com>
--

Olof's patch searched the device-tree again, looking for an mpic.   This
code instead checks that we found an xics the first time by checking the
init function.

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 9711eb0..20f010a 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -262,6 +262,12 @@ static int __init pseries_cpu_hotplug_init(void)
 		return 0;
 	}
 
+	if (ppc_md.init_IRQ != xics_init_IRQ) {
+		printk(KERN_INFO "pSeries CPU Hotplug only supported on xics "
+				"interrupt controllers - disabling");
+		return 0;
+	}
+
 	ppc_md.cpu_die = pseries_mach_cpu_die;
 	smp_ops->cpu_disable = pseries_cpu_disable;
 	smp_ops->cpu_die = pseries_cpu_die;
