Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbZDSCnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbZDSCnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZDSCng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:43:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41814 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZDSCnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:43:35 -0400
Date: Sat, 18 Apr 2009 19:09:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 900af0d breaks some embedded suspend/resume
Message-ID: <20090418180907.GD7148@flint.arm.linux.org.uk>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181626.10388.rjw@sisk.pl> <20090418144132.GC7148@flint.arm.linux.org.uk> <200904181709.47480.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904181709.47480.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 05:09:46PM +0200, Rafael J. Wysocki wrote:
> On Saturday 18 April 2009, Russell King wrote:
> > No, sysdevs are shut down after IRQs are turned off and the I2C driver
> > has been shut down.  The I2C driver needs IRQs to work in slave mode,
> > and we need slave mode to work.
> 
> Hm, but up to and including 2.6.29 we called the late suspend callbacks with
> interrupts off.

That's not related to the problem - since all that the I2C drivers
late suspend callback does is shut the I2C driver down.

It's what happens between the normal suspend callback (which occurs
with IRQs on) and the late suspend callback which I'm interested in,
which is when the platform's 'prepare' method is called.

> Hmm, what about redefining platform_suspend_ops in the following way:
> 
> struct platform_suspend_ops {
> 	int (*valid)(suspend_state_t state);
> 	int (*begin)(suspend_state_t state);
> 	int (*devices_suspended)(void);
> 	int (*prepare)(void);
> 	int (*enter)(suspend_state_t state);
> 	void (*wake)(void);
> 	int (*resume_devices)(void);
> 	void (*end)(void);
> 	void (*recover)(void);
> };
> 
> where:
> 
> * begin() will be called before suspending devices (no change)
> * devices_suspended() will be called after suspending devices (before
>   suspend_device_irqs())
> * prepare() will be callled after the late suspend callbacks
> * enter() will be called to enter the sleep state (no change)
> * wake() will be called before the early resume callbacks
> * resume_devices() will be called before resuming devices (after
>   resume_device_irqs()
> * end() will be called after resuming devices (no change)
> 
> I don't think we'll need more platform hooks than that.

I'd be happy with that.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
