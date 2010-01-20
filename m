Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224Ab0ATKfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0ATKfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881Ab0ATKfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:35:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46514 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751059Ab0ATKfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:35:04 -0500
Date: Wed, 20 Jan 2010 10:35:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: lrg@slimlogic.co.uk, kyungmin.park@samsung.com, mk7.kang@samsung.com,
       linux-kernel@vger.kernel.org
Subject: Re: The use_count problem of regulator
Message-ID: <20100120103500.GC2657@opensource.wolfsonmicro.com>
References: <4B56A300.7000907@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B56A300.7000907@samsung.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 03:30:24PM +0900, Joonyoung Shim wrote:

> In the regulator framework, if the regulator is enabled for example by 
> boot_on constraint, when regulator_get is called at the driver probe 
> function, the use_count of struct regulator_dev is zero. But if 
> regulator_has_full_constraints() is used, even though above the 
> regulator is using, it is disabled by regulator_init_complete() because
> the use_count is zero.

This is expected behaviour if the regulator is not marked as always_on.
The idea is that the regulators will have been claimed and enabled by a
regulator consumer during the init process, and if it hasn't then it's
not in active use at the current time and may therefore be powered off.

> Of course, we can use regulator_get_exclusive instead of regulator_get,
> but if the regulator can be shared, i think this will be a problem.

If the consumer is using the regulator then it should enable the
regulator without reference to the existing state of the regulator.
This is required to support sharing of supplies - if another consumer
enabled the regulator then it may later decide to turn it off when it's
done with it, which would have the same effect as you're seeing from the
full constraints code.

A consumer using regulator_get() should in general never need to check
if the regulator is enabled except possibly during startup in order to
gracefully handle the handover of the initial hardware state.  Normally
they should call enable() when they start using the device and disable() 
when they stop.
