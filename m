Return-Path: <linux-kernel-owner+w=401wt.eu-S1763911AbYBZTlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763911AbYBZTlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761243AbYBZTl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:41:28 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51108 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761092AbYBZTl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:41:26 -0500
Date: Tue, 26 Feb 2008 20:40:58 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Kconfig configuration restore bug [Was: x86: vSMP selection in config]
Message-ID: <20080226194058.GA31438@uranus.ravnborg.org>
References: <200802210258.45011.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com> <200802242136.28744.yinghai.lu@sun.com> <200802242243.49576.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802242243.49576.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman.

We discovered a situation where we could set a
choice value in menuconfig but later when we either was
running menuconfig or oldconfig the value were changed.

I have created a minimal config that exhibit the error.
It was created in a pure mechanical trial-and-error fashion.

First the minimal Kconfig file:
# x86 configuration

choice
	prompt "Subarchitecture Type"

config X86_PC
	bool "PC-compatible"

config X86_VOYAGER
	bool "Voyager (NCR)"

config X86_VSMP
	bool "Support for ScaleMP vSMP"
	depends on PCI

endchoice

config PCI
	bool "PCI support" if !X86_VISWS
	depends on !X86_VOYAGER
	default y
	

config USB_ARCH_HAS_HCD
	bool
	default PCI

config USB
	bool "Support for Host-side USB"
	depends on USB_ARCH_HAS_HCD

config USB_PHIDGET
	bool "USB Phidgets drivers"
	depends on USB

config USB_PHIDGETMOTORCONTROL
	bool "USB PhidgetMotorControl support"
	depends on USB_PHIDGET



Next the saved .config that is used:
#
# Automatically generated make config: don't edit
# Linux kernel version: KERNELVERSION
# Tue Feb 26 20:27:09 2008
#
# CONFIG_X86_PC is not set
# CONFIG_X86_VOYAGER is not set
CONFIG_X86_VSMP=y
CONFIG_PCI=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_PHIDGET is not set

When we enter menuconfig or are running oldconfig then we can see
that CONFIG_X86_PC is set to 'y' and CONFIG_X86_VSMP is set to 'n'.

If I in menuconfig select VSMP this setting is saved but then
oldconfig kicks in and we loose the setting again.

If I delete any of the config variables in the sample above then
we no longer change the values and we keep the VSMP equals 'y'.


Can you please take a look at this.

Thanks,
	Sam
