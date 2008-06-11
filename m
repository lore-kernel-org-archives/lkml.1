Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYFKMTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYFKMTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYFKMTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:19:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:8926 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYFKMTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:19:22 -0400
Date: Wed, 11 Jun 2008 14:18:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080611141852.3ccd89ea@hyperion.delvare>
In-Reply-To: <485031D5.3020606@bluewatersys.com>
References: <200806091541.43899.u.luckas@road.de>
	<20080609135739.GE30971@flint.arm.linux.org.uk>
	<484D947D.1090900@bluewatersys.com>
	<200806091359.12791.david-b@pacbell.net>
	<484DA046.4010804@bluewatersys.com>
	<20080610085708.12c2d2a2@hyperion.delvare>
	<484F42AC.9030709@bluewatersys.com>
	<20080611094039.287ac136@hyperion.delvare>
	<485031D5.3020606@bluewatersys.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 08:13:09 +1200, Ryan Mallon wrote:
> Jean Delvare wrote:
> > Which problem are you trying to solve? Is there any actual drawback to
> > abusing subsys_initcall() for the handful of i2c bus drivers which may
> > need to come up early?
>
> On many embedded devices there is a need for i2c to be early since it is
> often used for core functionality. It seems at the moment, that the 
> answer to this is to juggle a few of the drivers which people need to
> get this to work. There are the drivers in drivers/i2c which use 
> subsys_initcall. It does work, but it feels a bit untidy. Some of the i2c
> IO expander drivers are now in drivers/gpio since that comes up early.
> This can lead to confusion (see drivers/gpio/pca953x.c and 
> drivers/i2c/chips/pca9539.c).

The GPIO drivers under drivers/i2c/chips are deprecated and tagged for
removal. We only need a user-space interface for the new GPIO drivers
(I think we do by now) and a way to instantiate these new GPIO devices
from user-space (not done yet) before the deprecated drivers can be
removed. The only remaining users for these deprecated drivers are
electronics enthusiasts controlling GPIO chips over the PC parallel
port. In the context of embedded platforms, there's no room for
confusion here.

>                               As David suggested, if i2c is needed early
> in enough cases, why not just move it early in the link order? My patch
> was just an alternative approach which mimics the current behaviour, but
> makes it possible to get any i2c driver early. Why not just mark all of
> the drivers/busses that get used on embedded devices as subsys_initcall,
> just in case somebody needs them early?

Because this is an abuse of subsys_initcall? I guess that was
acceptable when only a couple drivers were doing that, but making it
official sounds bad.

> (...)
> I just ran a sed script over the drivers/i2c directory. The intent was to
> mark the entire subsystem to come up early if CONFIG_I2C_EARLY is set,
> and use i2c_module_init every where since it makes it more consistent, and
> doesn't cost anything on setups where CONFIG_I2C_EARLY isn't defined.

It costs readability and build time.

> The idea was basically that a board could clearly say: I want i2c early,
> and have any busses and devices drivers it has configured as builtins
> automatically be present early on.

I get the idea, but I don't buy the implementation.

-- 
Jean Delvare
