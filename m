Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXKDFU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXKDFU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 01:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXKDFUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 01:20:19 -0400
Received: from mxsf04.insightbb.com ([74.128.0.74]:51864 "EHLO
	mxsf04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXKDFUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 01:20:17 -0400
X-IronPort-AV: E=Sophos;i="4.21,368,1188792000"; 
   d="scan'208";a="100944880"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJvzLEdKjlCP/2dsb2JhbACBWw
X-IronPort-AV: E=Sophos;i="4.21,368,1188792000"; 
   d="scan'208";a="154324607"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Bill Nottingham <notting@redhat.com>
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
Date: Sun, 4 Nov 2007 01:20:11 -0400
User-Agent: KMail/1.9.3
Cc: Kay Sievers <kay.sievers@vrfy.org>, Chuck Ebbert <cebbert@redhat.com>,
       Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46B8C8FA.9020100@redhat.com> <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com> <20070808193220.GB5001@nostromo.devel.redhat.com>
In-Reply-To: <20070808193220.GB5001@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711040120.12640.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 08 August 2007 15:32, Bill Nottingham wrote:
> Kay Sievers (kay.sievers@vrfy.org) said: 
> > It doesn't have any aliases, so seems it was never autoloaded.
> 
> It was - prior kernels loaded it via the uevent generated from 
> /devices/platform/pcspkr. Newer kernels seem to never actually
> trigger a uevent from that (tested with a combination of
> udevmonitor and 'udevtrigger --subsystem-match=platform'.)
> 

The patch below should restore generation of uevents for pcspkr devices.
Since devices are not created in pcspkr module but rather in arch setup
code it is right (and safe) thing to do.

-- 
Dmitry


pcspkr: restore uevent generation

Make sure that we generate uevents when creating pcspkr devices
so that userspace will load pcspkr driver.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 arch/alpha/kernel/setup.c          |    2 ++
 arch/mips/kernel/pcspeaker.c       |    2 ++
 arch/powerpc/kernel/setup-common.c |    2 ++
 arch/x86/kernel/pcspeaker.c        |    2 ++
 4 files changed, 8 insertions(+)

Index: work/arch/alpha/kernel/setup.c
===================================================================
--- work.orig/arch/alpha/kernel/setup.c
+++ work/arch/alpha/kernel/setup.c
@@ -1501,6 +1501,8 @@ static __init int add_pcspkr(void)
 	if (!pd)
 		return -ENOMEM;
 
+	pd->dev.uevent_suppress = 0;
+
 	ret = platform_device_add(pd);
 	if (ret)
 		platform_device_put(pd);
Index: work/arch/mips/kernel/pcspeaker.c
===================================================================
--- work.orig/arch/mips/kernel/pcspeaker.c
+++ work/arch/mips/kernel/pcspeaker.c
@@ -19,6 +19,8 @@ static __init int add_pcspkr(void)
 	if (!pd)
 		return -ENOMEM;
 
+	pd->dev.uevent_suppress = 0;
+
 	ret = platform_device_add(pd);
 	if (ret)
 		platform_device_put(pd);
Index: work/arch/powerpc/kernel/setup-common.c
===================================================================
--- work.orig/arch/powerpc/kernel/setup-common.c
+++ work/arch/powerpc/kernel/setup-common.c
@@ -454,6 +454,8 @@ static __init int add_pcspkr(void)
 	if (!pd)
 		return -ENOMEM;
 
+	pd->dev.uevent_suppress = 0;
+
 	ret = platform_device_add(pd);
 	if (ret)
 		platform_device_put(pd);
Index: work/arch/x86/kernel/pcspeaker.c
===================================================================
--- work.orig/arch/x86/kernel/pcspeaker.c
+++ work/arch/x86/kernel/pcspeaker.c
@@ -11,6 +11,8 @@ static __init int add_pcspkr(void)
 	if (!pd)
 		return -ENOMEM;
 
+	pd->dev.uevent_suppress = 0;
+
 	ret = platform_device_add(pd);
 	if (ret)
 		platform_device_put(pd);
