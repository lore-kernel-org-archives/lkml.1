Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYEIJVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYEIJVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYEIJV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:21:28 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35516 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752746AbYEIJV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:21:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=YEPc7+FLSmiwQKJceyR0A+ZTAJ52RPOt7VjJ/WHxIx0lYftB4rTDuQEyrgNTAKKJ1fhXlDZ+G4pPpLbRaXytZlGOcy9vvL3KHi3NZSEHRqfhLvsAtTZhrC5r6YiJzDNxFWuUuVrhs1GuSZP80CBHzQy5ujov6Q8mIkzxtTO/22o=  ;
X-YMail-OSG: skiNQTYVM1l5lRFHnFCOpDPTII9al93db0_GZ4I4XJepQJFm8Ojm1xVGEIEBx__7Qh67v2YvLhIpMTi9foLupCgXUjfFxSz8BbqIbk7BA6L.GyLATMH6OiWgVB3_MCMUTFo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
Date: Fri, 9 May 2008 02:18:51 -0700
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, ab@mycable.de, mgreer@mvista.com,
       i2c@lm-sensors.org, rtc-linux@googlegroups.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <200805070120.03821.david-b@pacbell.net> <200805071625.20430.david-b@pacbell.net> <Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805090218.52570.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008, Maciej W. Rozycki wrote:
> Hi David,
> 
>  Please do not remove other lists cc-ed as there are people interested in 
> this piece of hardware who are neither on i2c nor on rtc-linux (I am on 
> neither of the lists too).

I didn't.  I responded to a message from list archives, and could
not tell how many lists were copied ... "WAY too many", clearly.


> > >  Do you mean our generic I2C code emulates SMBus calls if the hardware
> > > does not support them directly?  Well, it looks to me it indeed does and
> > > you are right, but I have assumed, perhaps mistakenly, (but I generally
> > > trust if a piece of code is there, it is for a reason), that this driver
> > > checks for I2C_FUNC_SMBUS_BYTE_DATA for a purpose.
> > 
> > That purpose being:  it makes those SMBus calls explicitly.
> > (And it makes i2c_transfer calls explicitly too...)
> 
>  Then, given the emulation, the client should be satisfied with either of
> the flags instead of both at a time.  Exactly how I changed it.

No; as Jean also noted, since it makes some explicit calls,
it should test for the functionality of those calls.  It should
not call i2c_transfer() unless the underlying adapter accepts
those calls.

 
> > > The extensions are 16-bit commands 
> > > (required by another RTC chip used on some of these boards) and an obscure
> > > subset of the process call and block read/write commands (called an EEPROM
> > > read and an extended write/read, respectively).
> > 
> > Subset of process call??  That's send-three-bytes, receive-two-bytes.
> > Not possible to subset it ... anything else isn't a process call!!
> 
>  I misinterpreted the SMBus spec -- I have thought the receive part is
> variable, sorry.  The controller implements a command which issues a write
> byte transfer followed by a receive four bytes transfer.  Not quite a
> process call although the idea is the same.

That is, no STOP in between, just a repeated START?  In which
case that's a subset of i2c_smbus_read_i2c_block_data().

 
> > Presumably those block read/write commands aren't quite enough
> > for you to implement i2c_smbus_read_i2c_block_data() and friend?
> 
>  You can issue a block read of up to 5 bytes (6 if you add the PEC byte
> which is not interpreted by the controller in any way).  And you can issue
> a block write of up to 4 bytes (5 with PEC).  That's clearly not enough
> for the m41t81 let alone a generic implementation.

Right.  Possibly worth updating i2c-sibyte to be able to perform
those calls through the "smbus i2c_block" calls; but maybe not.
(Those calls aren't true SMBus calls, but many otherwise-SMBus-only
controllers can handle them, hence the i2c_smbus_* prefix.)

 
>  But as Atsushi-san pointed out, the block transfer transactions
> implemented by the M41T81 do not quite follow the rules of SMBus block
> transfers, so the call is out of question -- either i2c_transfer() or a
> sequence of byte transactions have to be used.

See above:  they sound like subsets of the Linux "smbus i2c block"
calls.  (Those calls allow up to 32 bytes, much more than what the
i2c-sibyte hardware allows.)


> > >  I feel a bit uneasy about unconditional emulation of SMBus block calls
> > > with a series of corresponding byte read/write calls.  The reason is it
> > > changes the semantics
> > 
> > No it doesn't.  The I2C signal transitions (SCL/SDA) will be
> > exactly the same.  It's IMO very misleading to call it "emulation"
> > since it's nothing more than a different software interface to
> > the same functionality.
> 
>  It is not the same.  Assuming a write for a block transfer you have:
> 
> start:address:ack:command:ack:data:ack:data:ack:data:ack...stop
> 
> on the wire

That's true using both native SMBus calls and the
SMBus "emulated" (by native I2C) implementation of
the i2c_smbus_write_i2c_block_data() interface.


You introduced something entirely different:

> while for a series of byte calls you have: 
> 
> start:address:ack:command:ack:data:ack:stop
> start:address:ack:command:ack:data:ack:stop
> start:address:ack:command:ack:data:ack...stop

(I broke each separate I2C message onto its own line for clarity.)

 
> This is what I mean here -- I gather you are thinking in the terms of raw 
> I2C block vs SMBus block transfer.

I was talking in terms of i2c_smbus_write_i2c_block_data()
and i2c_smbus_read_i2c_block_data() ... which m41t80 should
be happy with.  (But i2c-sibyte won't be.)

If that second protocol sequence (many messages) happens to
work for a given chip, it can be done *portably* too using
pure SMBus "write byte" calls:  i2c_smbus_write_byte_data().

And that knowledge is very chip-specific, so it's IMO more
appropriate to keep it out of infrastructure like i2c-core.


>  It could be useful enough for other drivers to have the emulated calls 
> available as a part of the API.  No need to rush adding that though 
> obviously -- we can wait till we have a user (now that this driver has 
> been ruled out).

I can't quite see the point though.  Any driver can write a loop
that calls i2c_smbus_write_byte_data(), if that's an alternative
way to achieve the task on that chip.

It can be rather annoying to try getting some I2C drivers to cope
with a variety of broken I2C adapters.  But that's exactly why
there's a way to ask adapters what they can do.  If they can't
execute the I2C_FUNC_SMBUS_I2C_BLOCK protocols, then M41T80 code
must provide less efficient substitutes ... like looping over
byte-at-a-time calls, and coping with various time roll-over cases
that such substitutes will surface.

- Dave
