Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZI0Ql1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZI0Ql1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZI0Ql1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:41:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44200 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZI0Ql0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:41:26 -0400
Date: Sun, 27 Sep 2009 17:41:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Solving section mismatches
Message-ID: <20090927164115.GB20093@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

Any idea how to solve this:

WARNING: arch/arm/kernel/built-in.o(.text+0x1ebc): Section mismatch in reference from the function cpu_idle() to the function .cpuexit.text:cpu_die()
The function cpu_idle() references a function in an exit section.
Often the function cpu_die() has valid usage outside the exit section
and the fix is to remove the __cpuexit annotation of cpu_die.

WARNING: arch/arm/kernel/built-in.o(.cpuexit.text+0x3c): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
The function __cpuexit cpu_die() references
a function __cpuinit secondary_start_kernel().
This is often seen when error handling in the exit function
uses functionality in the init path.
The fix is often to remove the __cpuinit annotation of
secondary_start_kernel() so it may be used outside an init section.

Logically, the annotations are correct - in the first case, cpu_die()
will only ever be called if hotplug CPU is enabled, since you can't
offline a CPU without hotplug CPU enabled.  In that case, the __cpuexit.*
sections are not discarded.

In the second case, this is platform code to restart the CPU, and
again the anotations are entirely correct - cpuexit code only exists
if hotplug CPU is enabled, in which case the cpuinit code must also
be kept around.  Therefore, it is entirely legal for cpuexit code to
call cpuinit code - unlike __init vs __exit or __devinit vs __devexit.

Therefore, I believe both of these warnings to be incorrect.
