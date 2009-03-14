Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZCNLgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZCNLgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZCNLft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:35:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40231 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZCNLfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/11] PM: Rework suspend-resume ordering to avoid problems with shared interrupts (updated 2x)
Date: Sat, 14 Mar 2009 12:24:28 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902221837.49396.rjw@sisk.pl>
In-Reply-To: <200902221837.49396.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141224.29591.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an update of the patch series reworking the handling of interrupts
during suspend-resume, addressing some comments from Thomas and Ingo.

The following patches modifiy the way in which we handle disabling interrupts
during suspend and enabling them during resume.  They also change the ordering
of the core suspend and hibernation code to take advantage of the new approach
to the interrupts and modify the PCI PM core to avoid a few problems.

Namely, interrupts are currently disabled on the boot CPU as soon as the
nonboot CPUs have been disabled, which doesn't allow device drivers' "late"
suspend and "early" resume callbacks to sleep.  Among other things this means
they cannot execute ACPI AML routines, which leads to problems with
suspend-resume of PCI devices, as recently discussed.

1/11 introduces helper functions used by the subsequent patches.

2/11 modifies the [suspend|hibernation] and resume code, as well as the other
code using the device PM framework, so that device drivers will not receive
interrupts during the "late" suspend phase, although interrupts will only be
disabled on the CPU right before calling sysdev_suspend() (and analogously
during resume).

3/11 - 5/11 modify the suspend, hibernation and kexec jump code, respectively,
so that the "late" phase of suspending devices will happen before executing the
platform "prepare" callback and disabling nonboot CPUs (and analogously during
resume).

6/11 is a patch that's already in the PCI linux-next tree and I included it in
the series, because the next patches depend on it.

7/11 makes the PCI PM core use pci_set_power_state() to put devices into
D0 during early resume, which allows the platform-specific operations to be
carried out at that time, if necessary.

8/11 uses the opportunity to move pci_restore_standard_config() to pci-driver.c,
where it belongs IMO.

9/11 makes the PCI PM core code put devices into low power states during the
"late" phase of suspend which allows us to avoid a long-standing race related
to shared interrupts and to handle devices that require some platform-specific
operations to be put into low power states appropriately at the same time.
[The second rev of the patch retains the current behavior during the
"power-off" phase of hibernation, which is that the devices without drivers or
without PM support in the drivers are not power managed by the core.]

10/11 fixes pci_set_power_state() so that it doesn't return error code when
attempting to put a PCI device without PM support (either native or through the
platform) into D0 (such devices are always in D0).

11/11 makes the PCI PM core save and restore the configuration spaces of
devices that have no drivers or no PM support in the drivers during suspend and
resume, respectively.

There is a git tree containing these patches, for easier testing, at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git

(linux-next branch).  At the moment it has a merge conflict with the PCI
linux-next tree due to 6/11.

Thanks,
Rafael

