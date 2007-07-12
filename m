Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbXGLGoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbXGLGoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXGLGof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:44:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:46715 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXGLGoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,530,1175497200"; 
   d="scan'208";a="105434858"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <20070711172243.ab44c4d4.akpm@linux-foundation.org>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <20070711172243.ab44c4d4.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Jul 2007 14:43:43 +0000
Message-Id: <1184251423.9346.55.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 12 Jul 2007 06:44:30.0226 (UTC) FILETIME=[192E9720:01C7C450]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 17:22 -0700, Andrew Morton wrote:
> This sounds awesome.  Am I correct in expecting that ultimately the
> existing hibernation implementation just goes away and we reuse (and hence
> strengthen) the existing kexec (and kdump?) infrastructure?
> And that we get hibernation support almost for free on all kexec (and
> relocatable-kernel?) capable architectures?
> And that all the management of hibernation and resume happens in userspace?

Yes. Ultimately, most of the hibernation code such as process freezer,
memory shrinking, memory snapshot (atomic copy), image reading/writing
can go away, because kexec based hibernation doesn't depend on them.
Just the device/CPU state quiescent/save/restore is necessary to remain.
And, the management of hibernation and resume will happen in userspace.

> 
> I didn't understand the ACPI problem.  Does this mean that CONFIG_ACPI must
> be disabled in the to-be-hibernated kernel, or in the little transient
> kexec kernel?

Under current implementation of device state quiescent/save/restore, the
CONFIG_ACPI must be turned off both in to-be-hibernated kernel and
transient kexec kernel.

But the hibernation people are going to separate the device suspend from
device hibernate. The device hibernate will put device in quiescent
state but not in low power state. When this is done, it is not necessary
to disable CONFIG_ACPI at all. It is just a workaround for current
implementation that disabling CONFIG_ACPI.

> How close do you think all this is to being a viable thing?

The kexec jump is the first step, maybe the simplest step. There are
many other issues to be resolved, at least the following ones.

1. Separate device suspend from device hibernate.
2. Do not reserve memory for kexec kernel. That is, backup needed memory
before kexec and restore them after kexec.
3. Support the in-place kexec? The relocatable kernel is not necessary
if this can be implemented.
4. Image writing/reading. (Only user space application is needed).
5. A smooth resume process. Maybe it is not needed to kexec a new kernel
for resume. For example, in the first stage of kernel boot, just first
16M (or a little more) RAM is used, if the resume image is found, the
saved kernel image is resumed; if the resume image is not found, turn on
the remaining RAM. This will depends on 3.
6. Reduce the boot-up time of kexec kernel. Maybe the kexec kernel can
be hibernate/resume by the normal kernel too. This way, a real
kexec/boot-up is only needed for the first time.

Best Regards,
Huang, Ying
