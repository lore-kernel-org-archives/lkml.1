Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZBVRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZBVRkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZBVRkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:40:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbZBVRkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:40:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/2] Rework disabling of interrupts during suspend-resume
Date: Sun, 22 Feb 2009 18:37:48 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221837.49396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches modify the way in which we handle disabling
interrupts during suspend and enabling them during resume.  Namely, currently
interrupts are disabled on the boot CPU as soon as the nonboot CPUs have been
disabled, which doesn't allow device drivers' "late" suspend and "early" resume
callbacks to sleep.  Among other things this means they cannot execute ACPI
AML routines, which leads to problems with suspend-resume of PCI devices,
as recently discussed on this list.

1/2 is based on an earlier patch from Linus and it only splits up
sysdev_[suspend|resume] from the ["late suspend|"early" resume'] of devices.

2/2 actually modifies the [suspend|hibernation] and resume code, as well as the
other code using the device PM framework.

The patches have been initially tested and they don't appear to break suspend
on my boxes, but this is the first approximation only.  In particular, I'm not sure
if I did the XEN, kexec and APM parts right, so people with experience in these
areas are gently requested to have a look and tell me if there's anything to
fix in there.

Moreover, the real purpose of these changes is to be able to execute the
"late" suspend and "early" resume device callbacks with timer interrupts
enabled, so that they can use mutexes etc.  However, x86 currently doesn't set
the IRQF_TIMER flag and I need to make it do so before going further in this
direction and changing the PCI PM framework to take advantage of the $subject
changes, for example.  So, I need to know how to modify x86 timer code so that
the IRQF_TIMER flag is set by it.

Comments welcome.

Thanks,
Rafael

