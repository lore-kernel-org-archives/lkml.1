Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbYEIV3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbYEIV3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYEIV2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:28:54 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62787 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754612AbYEIV2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:28:53 -0400
Date: Fri, 9 May 2008 22:22:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Brownell <david-b@pacbell.net>
cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, ab@mycable.de, mgreer@mvista.com,
       i2c@lm-sensors.org, rtc-linux@googlegroups.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
In-Reply-To: <200805090218.52570.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.55.0805092202380.10552@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net> <200805071625.20430.david-b@pacbell.net>
 <Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
 <200805090218.52570.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> >  Please do not remove other lists cc-ed as there are people interested in 
> > this piece of hardware who are neither on i2c nor on rtc-linux (I am on 
> > neither of the lists too).
> 
> I didn't.  I responded to a message from list archives, and could

 I just asked not to remove from now on -- no implied double meaning and 
thanks for respecting my request. :-)

> not tell how many lists were copied ... "WAY too many", clearly.

 Just enough plus the usual LKML everyone is free to ignore if they 
cannot stand the volume.  And I got responses from linux-mips, which means 
my choice was right.

> No; as Jean also noted, since it makes some explicit calls,
> it should test for the functionality of those calls.  It should
> not call i2c_transfer() unless the underlying adapter accepts
> those calls.

 As mentioned elsewhere I misunderstood the semantics of the flags in the 
API.

> >  I misinterpreted the SMBus spec -- I have thought the receive part is
> > variable, sorry.  The controller implements a command which issues a write
> > byte transfer followed by a receive four bytes transfer.  Not quite a
> > process call although the idea is the same.
> 
> That is, no STOP in between, just a repeated START?  In which
> case that's a subset of i2c_smbus_read_i2c_block_data().

 There is the usual second START in between to turn around the direction.  
There is no STOP in the process call either, which is what makes it
different from an ordinary write transaction followed by a read
transaction.

> >  You can issue a block read of up to 5 bytes (6 if you add the PEC byte
> > which is not interpreted by the controller in any way).  And you can issue
> > a block write of up to 4 bytes (5 with PEC).  That's clearly not enough
> > for the m41t81 let alone a generic implementation.
> 
> Right.  Possibly worth updating i2c-sibyte to be able to perform
> those calls through the "smbus i2c_block" calls; but maybe not.
> (Those calls aren't true SMBus calls, but many otherwise-SMBus-only
> controllers can handle them, hence the i2c_smbus_* prefix.)

 I am not sure such a limited functionality is worth the hassle of making 
it available to clients in a reasonably clean way.  How common an 
extension of this kind is among SMBus controllers?  I would say if there 
are other controllers providing it (perhaps for a different range of 
transfer lengths) and clients benefitting from it, it might be worth 
adding it for this controller as well.  Otherwise perhaps let's wait till 
somebody complains about the lack of this functionality?

> If that second protocol sequence (many messages) happens to
> work for a given chip, it can be done *portably* too using
> pure SMBus "write byte" calls:  i2c_smbus_write_byte_data().
> 
> And that knowledge is very chip-specific, so it's IMO more
> appropriate to keep it out of infrastructure like i2c-core.
[...]
> I can't quite see the point though.  Any driver can write a loop
> that calls i2c_smbus_write_byte_data(), if that's an alternative
> way to achieve the task on that chip.

 Well, it seems generic enough we may provide wrappers around loops using
i2c_smbus_read_byte_data() and i2c_smbus_write_byte_data() to perform
transactions involving consecutive values of commands for clients to pick.  
You may be right it may be too trivial to bother though -- I am not sure.  
In any case, as suggested elsewhere, the core does not seem the right
place indeed, but a header file or drivers/i2c/lib/ should be appropriate.

> It can be rather annoying to try getting some I2C drivers to cope
> with a variety of broken I2C adapters.  But that's exactly why
> there's a way to ask adapters what they can do.  If they can't
> execute the I2C_FUNC_SMBUS_I2C_BLOCK protocols, then M41T80 code
> must provide less efficient substitutes ... like looping over
> byte-at-a-time calls, and coping with various time roll-over cases
> that such substitutes will surface.

 Of course.

  Maciej
