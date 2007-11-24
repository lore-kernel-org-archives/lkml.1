Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXKXE2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXKXE2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 23:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXKXE2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 23:28:42 -0500
Received: from mga05.intel.com ([192.55.52.89]:48036 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbXKXE2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 23:28:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,459,1188802800"; 
   d="scan'208";a="400041153"
Message-ID: <2097.172.16.96.111.1195878521.squirrel@linux.intel.com>
Date: Fri, 23 Nov 2007 20:28:41 -0800 (PST)
Subject: ipmi_watchdog can not reset the kernel panic machine 
From: youquan_song@linux.intel.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.centos
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Build kernel-2.6.24-rc3.  pmi_watchdog can not reset the kernel panic
machine.  The watchdog can never to record panic information to IPMI SEL.

1. I disable auto reset when kernel panic by echo "0" >
/proc/sys/kernel/panic

2.  modprobe ipmi_watchdog timeout=120 action=reset

3.  Load a driver, the driver will call panic() when  ioctl to call into
the driver.

4.  By ioctl call into the driver,  panic the system.

in wdog_panic_handler, I printk "ipmi_watchdog_state=WDOG_TIMEOUT_NONE"
so, the watchdog can never to record panic information to IPMI SEL.


static int wdog_panic_handler(struct notifier_block *this,
			      unsigned long         event,
			      void                  *unused)
{
	static int panic_event_handled = 0;

	/* On a panic, if we have a panic timeout, make sure to extend
	   the watchdog timer to a reasonable value to complete the
	   panic, if the watchdog timer is running.  Plus the
	   pretimeout is meaningless at panic time. */
	if (watchdog_user && !panic_event_handled &&
	    ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
		/* Make sure we do this only once. */
		panic_event_handled = 1;

		timeout = 255;
		pretimeout = 0;
		panic_halt_ipmi_set_timeout();
	}

	return NOTIFY_OK;
}
