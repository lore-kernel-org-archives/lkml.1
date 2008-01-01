Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYAAXlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYAAXlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYAAXk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:40:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbYAAXk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:40:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/4] PM: Do not destroy/create devices while suspended (rev. 2)
Date: Wed, 2 Jan 2008 00:32:44 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801020032.45529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some device drivers register CPU hotplug notifiers and use them to destroy
device objects when removing the corresponding CPUs and to create these objects
when adding the CPUs back.

Unfortunately, this is not the right thing to do during suspend/hibernation,
since in that cases the CPU hotplug notifiers are called after suspending
devices and before resuming them, so the operations in question are carried
out on the objects representing suspended devices which shouldn't be
unregistered behing the PM core's back.  Although right now it usually doesn't
lead to any practical complications, it will predictably deadlock if
gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch is applied.

The solution is to prevent drivers from removing/adding devices from within
CPU hotplug notifiers during suspend/hibernation using the FROZEN bit
in the notifier's action argument.  However, this has to be done with care,
since the devices objects related to the nonboot CPUs that failed to go online
during resume should not be present in the system.  For this reason, it seems
reasonable to introduce a mechanism allowing drivers to ask the PM core to
remove device objects corresponding to suspended devices on their behalf.

The first patch in the series introduces such a mechanism.  The remaining three
patches modify the MSR, x86-64 MCE and cpuid drivers in accordance with the
above approach.

Thanks,
Rafael

