Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZCGK2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZCGK2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 05:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZCGK2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 05:28:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZCGK2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 05:28:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH][0/8] PM: Rework suspend-resume ordering to avoid problems with shared interrupts
Date: Sat, 7 Mar 2009 11:19:15 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl>
In-Reply-To: <200902221837.49396.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903071119.16651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches modifiy the way in which we handle disabling interrupts
during suspend and enabling them during resume.  They also change the ordering
of the core suspend and hibernation code to take advantage of the new approach
to the interrupts and modify the PCI PM core to avoid a few problems.

Namely, interrupts are currently disabled on the boot CPU as soon as the
nonboot CPUs have been disabled, which doesn't allow device drivers' "late"
suspend and "early" resume callbacks to sleep.  Among other things this means
they cannot execute ACPI AML routines, which leads to problems with
suspend-resume of PCI devices, as recently discussed.

1/8 modifies the [suspend|hibernation] and resume code, as well as the other
code using the device PM framework, so that device drivers will not receive
interrupts during the "late" suspend phase, although interrupts will only be
disabled on the CPU right before calling sysdev_suspend() (and analogously
during resume).

2/8 - 4/8 modify the suspend, hibernation and kexec jump code, respectively,
so that the "late" phase of suspending devices will happen before executing the
platform "prepare" callback and disabling nonboot CPUs (and analogously during
resume).

5/8 is a patch that's already in the PCI linux-next tree and I included it in
the series, because the next patches depend on it.

6/8 makes the PCI PM core use pci_set_power_state() to put devices into
D0 during early resume, which allows the platform-specific operations to be
carried out at that time, if necessary.

7/8 uses the opportunity to move pci_restore_standard_config() to pci-driver.c,
where it belongs IMO.

8/8 makes the PCI PM core code put devices into low power states during the
"late" phase of suspend which allows us to avoid a long-standing race related
to shared interrupts and to handle devices that require some platform-specific
operations to be put into low power states appropriately at the same time.

Comments welcome.

Thanks,
Rafael

