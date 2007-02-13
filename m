Return-Path: <linux-kernel-owner+w=401wt.eu-S1751377AbXBMWlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbXBMWlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXBMWlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:41:21 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:53542 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXBMWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:41:20 -0500
Message-ID: <45D23E87.2030805@nortel.com>
Date: Tue, 13 Feb 2007 16:41:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: whatever happened to down_timeout()?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2007 22:41:14.0831 (UTC) FILETIME=[11716DF0:01C74FC0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There has been some discussion on lkml about a function that would 
either down a semaphore or else abort if it couldn't get the semaphore 
in a certain amount of time.  Something along the lines of:

down_timeout(struct semaphore *sem, long timeout);


Does something like this exist?  Does anyone have a working 
implementation?  Does anyone see anything obviously wrong with the 
following version (that I loosely based on one by Rupert Eibauer)?



semaphore.h:

extern int __down_timeout(struct semaphore * sem, unsigned int timeout);


/* "timeout" is the number of jiffies to wait.
  * Returns -ETIME if timeout period expires.
  */
static inline int down_timeout(struct semaphore * sem, unsigned int timeout)
{
	int ret = down_trylock(sem);
	if (!ret)
		ret = __down_timeout(sem, timeout);
	return ret;
}




kernel/timer.c

int __down_timeout(struct semaphore * sem, int timeout)
{
	int ret;
	unsigned long expire;
	struct timer_list timer;

	expire = jiffies + timeout;
	init_timer(&timer);
	timer.expires = expire;
	timer.data = (unsigned long) current;
	timer.function = process_timeout;
	add_timer(&timer);

	ret = down_interruptible(sema);
	if (ret && (jiffies > expire))
		ret = -ETIME;
	 else
		del_timer_sync(&timer);

         return ret;
}


Thanks,
Chris
