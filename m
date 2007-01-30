Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbXA3K0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbXA3K0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXA3K0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:26:17 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39353 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXA3K0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:26:16 -0500
Message-Id: <20070130101143.296619000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 30 Jan 2007 11:11:43 +0100
From: Nadia.Derbey@bull.net
To: akpm@osdl.org, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] AKT - Automatic Kernel Tunables
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending the series of patches for the automatic kernel tunables feature:
have done some fixes after the remarks sent back by Andrew and Randy.

1) All the type independent macros have been removed, except for the automatic
tuning routine: it manages pointers to the tunable and to the value to be
checked against that tunable, so it should rmain type independent IMHO.
Now, I only left the auto-tuning routines for types int and size_t since these
are the types of the tunables the framework is applied to.
It will be easy to add the other types as needed in the future.
This makes the code much lighter.

2) CONFIG_AKT has been moved from the FS menu to the "general setup" one.

+ all the other minor changes.


--- Reminder

This is a series of patches that introduces a feature that makes the kernel
automatically change the tunables values as it sees resources running out.

The AKT framework is made of 2 parts:

1) Kernel part:
Interfaces are provided to the kernel subsystems, to (un)register the
tunables that might be automatically tuned in the future.

Registering a tunable consists in the following steps:
- a structure is declared and filled by the kernel subsystem for the
registered tunable
- that tunable structure is registered into sysfs

Registration should be done during the kernel subsystem initialization step.


Another interface is provided to the kernel subsystems, to activate the
automatic tuning for a registered tunable. It can be called during resource
allocation to tune up, and during resource freeing to tune down the registered
tunable. The automatic tuning routine is called only if the tunable has
been enabled to be automatically tuning in sysfs.

2) User part:

AKT uses sysfs to enable the tunables management from the user world (mainly
making them automatic or manual).

akt uses sysfs in the following way:
- a tunables subsystem (tunables_subsys) is declared and registered during akt
initialization.
- registering a tunable is equivalent to registering the corresponding kobject
within that subsystem.
- each tunable kobject has 3 associated attributes, all with a RW mode (i.e.
the show() and store() methods are provided for them):
        . autotune: enables to (de)activate automatic tuning for the tunable
        . max: enables to set a new maximum value for the tunable
        . min: enables to set a new minimum value for the tunable

The only way to activate automatic tuning is from user side:
- the directory /sys/tunables is created during the init phase.
- each time a tunable is registered by a kernel subsystem, a directory is
created for it under /sys/tunables.
- This directory contains 1 file for each tunable kobject attribute



These patches should be applied to 2.6.20-rc4, in the following order:

[PATCH 1/6]: tunables_registration.patch
[PATCH 2/6]: auto_tuning_activation.patch
[PATCH 3/6]: auto_tuning_kobjects.patch
[PATCH 4/6]: tunable_min_max_kobjects.patch
[PATCH 5/6]: per_namespace_tunables.patch
[PATCH 6/6]: auto_tune_applied.patch


--
