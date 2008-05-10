Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYEJHIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYEJHIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 03:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYEJHIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 03:08:21 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40037 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYEJHIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 03:08:20 -0400
Date: Sat, 10 May 2008 09:08:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>, linux-mips@linux-mips.org,
       mgreer@mvista.com, rtc-linux@googlegroups.com,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, ab@mycable.de
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
Message-ID: <20080510090801.74da049d@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805092202380.10552@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net>
	<200805071625.20430.david-b@pacbell.net>
	<Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
	<200805090218.52570.david-b@pacbell.net>
	<Pine.LNX.4.55.0805092202380.10552@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 22:22:11 +0100 (BST), Maciej W. Rozycki wrote:
> > >  You can issue a block read of up to 5 bytes (6 if you add the PEC byte
> > > which is not interpreted by the controller in any way).  And you can issue
> > > a block write of up to 4 bytes (5 with PEC).  That's clearly not enough
> > > for the m41t81 let alone a generic implementation.
> > 
> > Right.  Possibly worth updating i2c-sibyte to be able to perform
> > those calls through the "smbus i2c_block" calls; but maybe not.
> > (Those calls aren't true SMBus calls, but many otherwise-SMBus-only
> > controllers can handle them, hence the i2c_smbus_* prefix.)
> 
>  I am not sure such a limited functionality is worth the hassle of making 
> it available to clients in a reasonably clean way.  How common an 
> extension of this kind is among SMBus controllers?  I would say if there 
> are other controllers providing it (perhaps for a different range of 
> transfer lengths) and clients benefitting from it, it might be worth 
> adding it for this controller as well.  Otherwise perhaps let's wait till 
> somebody complains about the lack of this functionality?

The problem is that the interface for client drivers to query the
adapters capabilities is rather limited. There's just one bit for I2C
block read, so if an adapter has limitations in the size of requests it
can accept (beyond the traditional 32-byte limit that comes from SMBus)
it can't express it. This means that client drivers should expect
transaction requests to fail even if they checked that the transaction
type in question was supported. Most client drivers don't actually
expect that.

My advice would be to only bother implementing restricted support for a
transaction type if there's a big benefit in doing so. And then, double
check that all the client drivers that are likely to be used with the
adapter in question, are robust enough to deal with the restrictions
gracefully.

-- 
Jean Delvare
