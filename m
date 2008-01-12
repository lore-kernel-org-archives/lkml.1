Return-Path: <linux-kernel-owner+w=401wt.eu-S1763358AbYALArS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763358AbYALArS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 19:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762656AbYALArG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 19:47:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762641AbYALArE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 19:47:04 -0500
Date: Fri, 11 Jan 2008 16:46:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       stern@rowland.harvard.edu, lenb@kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, mingo@elte.hu,
       gregkh@suse.de, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
 (rev. 2)
Message-Id: <20080111164613.7791bb94.akpm@linux-foundation.org>
In-Reply-To: <200801020032.45529.rjw@sisk.pl>
References: <200801020032.45529.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008 00:32:44 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Some device drivers register CPU hotplug notifiers and use them to destroy
> device objects when removing the corresponding CPUs and to create these objects
> when adding the CPUs back.
> 
> Unfortunately, this is not the right thing to do during suspend/hibernation,
> since in that cases the CPU hotplug notifiers are called after suspending
> devices and before resuming them, so the operations in question are carried
> out on the objects representing suspended devices which shouldn't be
> unregistered behing the PM core's back. __Although right now it usually doesn't
> lead to any practical complications, it will predictably deadlock if
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch is applied.
> 
> The solution is to prevent drivers from removing/adding devices from within
> CPU hotplug notifiers during suspend/hibernation using the FROZEN bit
> in the notifier's action argument.  However, this has to be done with care,
> since the devices objects related to the nonboot CPUs that failed to go online
> during resume should not be present in the system.  For this reason, it seems
> reasonable to introduce a mechanism allowing drivers to ask the PM core to
> remove device objects corresponding to suspended devices on their behalf.
> 
> The first patch in the series introduces such a mechanism.  The remaining three
> patches modify the MSR, x86-64 MCE and cpuid drivers in accordance with the
> above approach.

These patches are a preresuisite to
gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch and its
later fixed-up versions.

So what I have now is

revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
pm-introduce-destroy_suspended_device.patch
pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2.patch
pm-do-not-destroy-create-devices-while-suspended-in-mce_64c.patch
pm-do-not-destroy-create-devices-while-suspended-in-cpuidc.patch
pm-acquire-device-locks-on-suspend-rev-3.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch

So what needs to happen in Greg's tree is

a) drop the old gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch

b) apply these four patches

c) apply the new pm-acquire-device-locks-on-suspend-rev-3.patch (and its fixups)


