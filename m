Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZAUOpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZAUOpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbZAUOov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:44:51 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:43904 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760854AbZAUOou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:44:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kHsEVKFEQmiiXnuu2A5fswZmxXk7i7KulajuabB3AMuRzSm3uZXtYuzj8FO/J7jos7
         Tq0uJV10qDXZhgfFMTscLbFs+4+D+v/CpLOjavMYBRRZH0BHzE5q9aOm7Jbxzpn5MOGb
         dccL/jSGhc0z5s2v4Z8s8zddkV0ia6uOz2K4k=
Message-ID: <4977352B.1040303@gmail.com>
Date: Wed, 21 Jan 2009 15:46:03 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: astarikovskiy@suse.de, len.brown@intel.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [ACPI] GPE storm detected on FS Amilo Pro
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,


I've got that ,,GPE storm detected'' issue on my Fujitsu Siemens Amilo Pro
notebook.  I was using 2.6.25.20 (which was fine) for a long while and recently
started testing some latest git versions starting from 2.6.29-rc2 where I've
discovered that issue. So I've made some back kernels and it shows up from
2.6.26 kernel. Bisection between 2.6.25 and 2.6.26 shows that patch:

fa95ba04e6ba11d71e1b87becd054b38faf546c8 is first bad commit
commit fa95ba04e6ba11d71e1b87becd054b38faf546c8
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Mar 21 19:36:02 2008 +0300

    ACPI: EC: Detect irq storm

    Problem seems to be that hw fails to clear GPE after we service it and write 1
    into corresponding bit. Thus, as soon as we get interrupts enabled again, we
    receive a new one. Google gives too many results for "acer interrupt storm" for
    this being one-broken-machine case.

    Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9998

    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

The bug[1] (reopened recently) seems to be quite different than the one in my
case. I've got no ,,side effects'' of that GPE storm. Notebook works fine and I
didn't discovered any interrupts problems. Up to 2.6.28 GPE storm information is
printed early[2]:

Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE storm detected, disabling EC GPE
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)

While recent git[3] which I'm now running, shows it after setting-up AC adapter[4]:

ACPI: AC Adapter [ADP1] (on-line)
ACPI: EC: GPE storm detected, transactions will use polling mode
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
ACPI: EC: missing confirmations, switch off interrupt mode.
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]

I'm not sure if the origin of that GPE storm is the same in both cases. Will try
to do bisection here later if needed.

NOTE: In git kernel I've noticed that after boot and obtaining IP from DHCP I've
got such message:

Jan 21 14:44:32 difrost kernel: sky2 eth0: enabling interface
Jan 21 14:44:33 difrost kernel: sky2 eth0: Link is up at 100 Mbps, full duplex,
flow control rx
Jan 21 14:45:36 difrost kernel: ACPI: EC: missing confirmations, switch off
interrupt mode.

This is not fully reproducible, didn't shown on [4].

Regards,
-Jacek

-----
	[1] http://bugzilla.kernel.org/show_bug.cgi?id=9998
	[2] Full 2.6.26.8 dmesg:
http://pin.if.uz.zgora.pl/~difrost/linux-next/ACPI/storm_dmesg.log
	[3] Kernel version: 2.6.29-rc2-12097-gf3b8436-dirty (marked dirty, due to fix
for XFS bug found here)
	[4] Full git kernel dmesg:
http://pin.if.uz.zgora.pl/~difrost/linux-next/ACPI/storm_dmesg_29.log
	[5] /proc/interrupts from git kernel:
http://pin.if.uz.zgora.pl/~difrost/linux-next/ACPI/interrupts.log
