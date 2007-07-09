Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbXGIA5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbXGIA5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 20:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbXGIA5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 20:57:36 -0400
Received: from smtpout.mac.com ([17.250.248.173]:65179 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXGIA5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 20:57:35 -0400
In-Reply-To: <1183941217.3388.324.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org> <1183929611.3388.303.camel@localhost.localdomain> <200707090006.32712.rjw@sisk.pl> <1183941217.3388.324.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FFA29D56-3400-4EA3-8CE8-C1EF75484510@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Sun, 8 Jul 2007 20:57:29 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 08, 2007, at 20:33:37, Benjamin Herrenschmidt wrote:
>>  	drivers_sysfs_write()
>> 		while(!suspend_trylock())
>> 			try_to_icebox() --> or even try_to_freeze(), what's the  
>> difference?
>>
>>  		hit hardware
>> 		unlock_suspend()
>>
>> where the PM core must wait for the suspend lock to get released  
>> (say with a timeout)?
>
> Somewhat. What I'd like is to have that a construct of that sort on  
> a per-driver basis though :-) Now the question is, in what way  
> would the above be different from a simple suspend mutex ? I've  
> been using mutexes in the past for a couple of drivers (iirc,  
> that's how I did it for dmasound_pmac, though that driver is long  
> past obsolescence now).

I agree completely.  It's a bit trickier if you want to do work in  
uninterruptable contexts:

driver_suspend_callback(...)
{
	dev_suspend_lock(dev);
	put_hardware_to_sleep(dev);
}

driver_resume_callback(...)
{
	wake_hardware_up(dev);
	dev_suspend_unlock(dev);
}

Then for sleep-capable contexts:
	dev_suspend_lock(dev);
	dev_suspend_unlock(dev);

And for no-sleep contexts like interrupts etc:
	if (!dev_suspend_trylock(dev))
		return postpone_work_for_later(dev, ...);
	do_stuff_with(dev);
	dev_suspend_unlock(dev);

You could do this with a straight mutex except for the  
dev_suspend_trylock/unlock bit in uninterruptable contexts, but I  
seem to recall somebody saying that could be made to work if there  
was a real need for it.  Alternatively you could just drive the  
"Generic Mutex" guys up the wall by inventing your own pseudo-mutex  
with a spinlock, a boolean value, and a waitqueue.

Then when you put your driver to sleep, things trying to do IO will  
automatically "freeze" themselves exactly until the device is woken  
again.

Assuming the driver model and subsystem get the ordering right for  
which devices to suspend/resume, then it's impossible to deadlock or  
cause hardware confusion.  And even further, if you manage to make  
the automagic mutex-debugging code work with the noninterruptable  
trylock it will yell at you when the driver model does nasty deadlock- 
y things.

On the other hand, if the driver model *doesn't* get the ordering  
right then it's fundamentally impossible to reliably suspend and resume.

Cheers,
Kyle Moffett

