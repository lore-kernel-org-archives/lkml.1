Return-Path: <linux-kernel-owner+w=401wt.eu-S1765508AbYEIToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765508AbYEIToT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbYEIToI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:44:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37324 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754345AbYEIToH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:44:07 -0400
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20080509043708.GG4961@prithivi.gnumonks.org>
References: <1209742841.12502.40.camel@odin>
	 <20080508063538.GC6105@prithivi.gnumonks.org>
	 <1210279887.20475.79.camel@odin>
	 <20080509043708.GG4961@prithivi.gnumonks.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 09 May 2008 20:44:04 +0100
Message-Id: <1210362244.20475.125.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 06:37 +0200, Harald Welte wrote:
> On Thu, May 08, 2008 at 09:51:27PM +0100, Liam Girdwood wrote:
> > > Do you think it would be worth to export something like this in the
> > > generic API, too?  It's probably quite hard, since there are devices
> > > that actually use the PCF506xx STANDBY state during suspend-to-ram, but
> > > other devices leave the PCF506xx in the ON state and just disable the
> > > individual regulators using I2C register writes.
> > 
> > Yes I think it would be worthwhile adding this sort of functionality. I
> > had considered this earlier on in development but it was lower priority
> > for me then.
> 
> ok. I also believe it is much lower priority. No disagreement here :)
> 
> > This would mean some additions to the regulator machine interface (to be
> > used during machine regulator setup) and regulator driver interface (to
> > set the values). I could add some 'standby_uV' and 'standby_mode' fields
> > (one for each standby state) to struct regulation_constraints. This
> > would define the desired voltage and regulator operating mode to be used
> > during the regulators STANDBY/HIBERNATE states. Hence the correct
> > regulator output state would be selected when the PMIC enters it's
> > STANDBY/HIBERNATE state (via either a I2C write or hardware signal). 
> > 
> > Would this suffice for your PMIC (sorry I don't have the datasheet) ?
> 
> basically the pcf506xx cannot support a different voltage in standby
> mode than in active mode.  They just simply have something like a
> bitmaks where you define which regulator is still running in standby,
> and which don't.
> 

﻿Ok, I've created a new struct ﻿regulator_state in machine.h to describe
a regulators suspended state for a given system suspend state :-

struct regulator_state {
        int uV; /* suspend voltage */
        unsigned int mode; /* suspend regulator operating mode */
        int enabled; /* is regulator enabled in this suspend state */
};

'uV' and 'mode' are optional 'enabled' is mandatory. This should also
cover other PMICs where voltage and operating mode may be configurable.

I've also added the following fields to struct regulation_constraints in
machine.h :-

/* regulator suspend states for global PMIC STANDBY/HIBERNATE */
struct regulator_state state_disk;
struct regulator_state state_mem;
struct regulator_state state_standby;
suspend_state_t initial_state; /* suspend state to set at init */

This should define all the regulator's supported system suspend states
and be registered with the other constraints.

In order to switch PMIC suspend configurations, I've added :-

int regulator_suspend_prepare(suspend_state_t state);

This will configure each PMIC regulator (if required) with the correct
suspend setup prior to entering the new suspend state (and could be
called by machine suspend code to prepare the pc506xx).

Liam


