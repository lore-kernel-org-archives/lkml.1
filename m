Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbXHQOv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbXHQOv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXHQOvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:51:49 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49198 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122AbXHQOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:51:48 -0400
Message-ID: <46C5B602.2060706@lwfinger.net>
Date: Fri, 17 Aug 2007 09:51:46 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: Need help with modules loading
References: <46C50902.4000502@lwfinger.net> <3ae72650708170055p51846c6dp8d8e5b22138f627a@mail.gmail.com>
In-Reply-To: <3ae72650708170055p51846c6dp8d8e5b22138f627a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On 8/17/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> A new driver for the Broadcom BCM43xx devices has been written that uses mac80211, rather than
>> softmac. The newest versions of the Broadcom firmware does not support all the BCM devices.
>> Accordingly, a separate driver is being prepared that will use an older version of the firmware and
>> support these legacy devices. Unfortunately, there is not a clean separation based on PCI id's;
>> however, the revision level of the 802.11 wireless core can be used to determine which driver should
>> be used. The scheme works on most systems, but not mine and I need some help to discover why.
> 
>> The 'MODALIAS=ssb:v4243id0812rev0A' line is correct for my device. In fact issuing a modprobe
>> "ssb:v4243id0812rev0A" command results in the loading of the module. For some reason, this does not
>> happen automatically.
>>
>> Initially, I suspected that my version of udev (103-13) was too old; however, upgrading to version
>> 114 did not help. My module-init-tools are V 3.2.2 and my distro is the x86_64 version of openSUSE 10.2.
> 
> openSUSE 10.2 used a whitelist of buses which trigger module loading.
> It's in the udev sysconfig. rules and /sbin/hwup.
> 
> The easiest is probably to add a rule for that bus:
>   ACTION=="add", SUBSYSTEM=="ssb", ENV{MODALIAS}=="?*",
> RUN+="/sbin/modprobe $env{MODALIAS}"
> 
> openSUSE 10.3 will call modprobe directly, the whitelist and the whole
> hwup logic is removed in the meantime.

Thanks for the help. A new rule in sysconfig.rules took care of the problem.

I added the bcm43xx developers mailing list to this reply. For their benefit, this is the patch that 
fixed my system:

Index: /etc/udev/rules.d/80-sysconfig.rules
===================================================================
--- /etc/udev/rules.d.orig/80-sysconfig.rules
+++ /etc/udev/rules.d/80-sysconfig.rules
@@ -15,5 +15,6 @@ SUBSYSTEM=="pnp", ACTION=="add", RUN+="/
  SUBSYSTEM=="ide", ACTION=="add", RUN+="/sbin/hwup ide-devpath-%p -o hotplug"
  SUBSYSTEM=="input", KERNEL=="input[0-9]*", ACTION=="add", RUN+="/sbin/hwup input-devpath-%p -o 
hotplug"
  SUBSYSTEM=="platform", ACTION=="add", RUN+="/sbin/hwup platform-devpath-%p -o hotplug"
+SUBSYSTEM=="ssb", ACTION=="add", ENV{MODALIAS}=="?*", RUN+="/sbin/modprobe $env{MODALIAS}"

  LABEL="sysconfig_end"


Larry
