Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXKZA0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXKZA0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 19:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbXKZA0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 19:26:34 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:51011 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbXKZA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 19:26:33 -0500
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2007 19:26:33 EST
Date: Sun, 25 Nov 2007 17:26:27 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: ipmi_watchdog can not reset the kernel panic machine
In-reply-to: <20071124223920.212b36e3.akpm@linux-foundation.org>
To: youquan_song@linux.intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
Message-id: <474A04A3.8030702@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <2097.172.16.96.111.1195878521.squirrel@linux.intel.com>
 <20071124223920.212b36e3.akpm@linux-foundation.org>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog is "off" by default, meaning that you have to have 
something actually start resetting the watchdog before it will start 
running.  That's why you are seeing this behavior.

There is a start_now option that will start the watchdog when it is 
loaded, but then it will reset the system unless something resets the 
watchdog periodically, and you have a limited time to start this operation.

On a panic, the IPMI driver attempts to preserve the state of the 
watchdog and (if running) increase the timeout time to allow a kdump or 
something like that to occur.  That's the purpose of the code you 
reference.  It is not to start a reset operation on any panic.  It used 
to start a reset on every panic, but that cause problems for many users.

-corey

Andrew Morton wrote:
> (cc's added)
>
> On Fri, 23 Nov 2007 20:28:41 -0800 (PST) youquan_song@linux.intel.com wrote:
>
>   
>> Build kernel-2.6.24-rc3.  pmi_watchdog can not reset the kernel panic
>> machine.  The watchdog can never to record panic information to IPMI SEL.
>>
>> 1. I disable auto reset when kernel panic by echo "0" >
>> /proc/sys/kernel/panic
>>
>> 2.  modprobe ipmi_watchdog timeout=120 action=reset
>>
>> 3.  Load a driver, the driver will call panic() when  ioctl to call into
>> the driver.
>>
>> 4.  By ioctl call into the driver,  panic the system.
>>
>> in wdog_panic_handler, I printk "ipmi_watchdog_state=WDOG_TIMEOUT_NONE"
>> so, the watchdog can never to record panic information to IPMI SEL.
>>
>>
>> static int wdog_panic_handler(struct notifier_block *this,
>> 			      unsigned long         event,
>> 			      void                  *unused)
>> {
>> 	static int panic_event_handled = 0;
>>
>> 	/* On a panic, if we have a panic timeout, make sure to extend
>> 	   the watchdog timer to a reasonable value to complete the
>> 	   panic, if the watchdog timer is running.  Plus the
>> 	   pretimeout is meaningless at panic time. */
>> 	if (watchdog_user && !panic_event_handled &&
>> 	    ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
>> 		/* Make sure we do this only once. */
>> 		panic_event_handled = 1;
>>
>> 		timeout = 255;
>> 		pretimeout = 0;
>> 		panic_halt_ipmi_set_timeout();
>> 	}
>>
>> 	return NOTIFY_OK;
>> }
>>     

