Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbZGVPKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbZGVPKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZGVPKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:10:37 -0400
Received: from mx1.emlix.com ([193.175.82.87]:54689 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZGVPKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:10:36 -0400
Message-ID: <4A672B97.1070704@emlix.com>
Date: Wed, 22 Jul 2009 17:09:11 +0200
From: Simon Braunschmidt <sb@emlix.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: wim@iguana.be
Subject: Handling multiple watchdogs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have two watchdogs on my board that I both want to handle. What would 
be the proper approach in this case?

What I can see currently is that most (all?) watchdogs register as 
chardev 10:130, that breaks when registering more than one.

I work around this in my private tree by something like:

-------8<-----------------

#ifndef WATCHDOG_MINOR
	#define WATCHDOG_MINOR 130
#endif
#define WATCHDOG0_MINOR 212
#define WATCHDOG_NUMDEVS 2

static struct watchdog_dev_id watchdog_possible_devs[] = {
	[0] = {
		.minor = WATCHDOG_MINOR,
		.name = "watchdog",
	},
	[1] = {
		.minor = WATCHDOG0_MINOR,
		.name = "watchdog0",
	},
};

/* watchdogs can also use unusual minor numbers, try them when we fail*/
for (i = 0; i < WATCHDOG_NUMDEVS; i++) {
	wdt_miscdev.minor=watchdog_possible_devs[i].minor;
	wdt_miscdev.name=watchdog_possible_devs[i].name;
	ret = misc_register(&wdt_miscdev);
	if (ret == 0) break;
	printk(KERN_INFO PFX
		"failed to register miscdev on minor=%d (err=%d)\n",
				wdt_miscdev.minor, ret);
}
if (ret != 0) {
	goto unreg_reboot;
}

----------------->8---------

Which gives me an additional watchdog chardevice on 10:212.

This approach is probably not the best, so i am not asking for inclusion 
of such a change. One solution would be to expose the watchdogs 
individually like
/dev/watchdog0, /dev/watchdog1 and so on and to expose a combined 
interface under /dev/watchdog.

I have searched the list and found some related discussion like
http://article.gmane.org/gmane.linux.kernel/398831/match=watchdogs
other threads and
http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-experimental.git;a=summary

, yet it does not seem like this reached mainline so far.

Any sharing of thoughts on the subject would be welcome.

Best Regards
Simon Braunschmidt
