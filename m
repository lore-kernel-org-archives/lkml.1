Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbYF3EKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbYF3EKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYF3EK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:10:28 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:22574 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750777AbYF3EK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:10:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ErFR7dDWkIvZi8qcFyJWw+xVoP7+e8vtLYBIak10V1lS4QuWS5w6GqPBFpSOsDTYTibhTrFcGTR02G6PJozVMMNDtYT75nFsRcGmQN5rMN5mjYRS6lrxgmO7gMtchSbWKzHLGqD/MOGcu5OOu8oh1BwrkKFpOe1yE8c+3JszmIY=  ;
X-YMail-OSG: U5toHSgVM1ko8ZWByK.7AnbeJ9t0a3v_3mEDiSuCQqPzeVexZciQzL.lh6ZgF4dYlCH0xznwu8La9VGSDbJtjUAP3cVEivr6CJ6A4721ZAZfJsG9PLg5NydsGBucD7kAK1g-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] spi: split up spi_new_device() to allow two stage registration.
Date: Sun, 29 Jun 2008 21:10:25 -0700
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, fabrizio.garetto@gmail.com,
       jonsmirl@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <fa686aa40805232343x20031560j5659d203e25f494@mail.gmail.com> <fa686aa40806170028t2ccb679k22d2d3cea793ebc1@mail.gmail.com>
In-Reply-To: <fa686aa40806170028t2ccb679k22d2d3cea793ebc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806292110.25793.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2008, Grant Likely wrote:
> >>> This patch splits the allocation and registration portions of code out
> >>> of spi_new_device() and creates three new functions; spi_alloc_device(),
> >>> spi_register_device(), and spi_device_release().
> >>
> >> I have no problem with the first two, but why the last?
> >>
> >> If the devices are always allocated by spi_alloc_device() as
> >> they should be -- probably through an intermediary -- the
> >> only public function necessary for that cleanup should be
> >> the existing spi_dev_put().
> >
> > Ah, okay.  I'm still a bit fuzzy on the device model conventions.
> > I'll remove that then.
> 
> I've dug into this some more.  spi_alloc_device only allocates the
> memory.  It doesn't call device_initialize() to initialize the kref.

Well, the driver model idiom is initialize() then add(), with
register() calls combining the two.  An alloc() is just a bit
outside those core idioms ...

But one alloc() example is platform_device_alloc(), which does
the device_initialize() call ... followed by platform_device_add().

The spi_new_device() call does a bunch of stuff beyond a register(),
but it also calls device_register().


> All of that behaviour is handled within device_register().  Therefore
> if a driver uses spi_alloc_device() and then if a later part of the
> initialization fails before spi_register_device() is called, then the
> alloc'd memory needs to be freed, but spi_dev_put() won't work because
> the kobj isn't set up so I need another function to handle freeing it
> in on a failure path.

I see ...

 
> Should I switch things around to do device_initialize() in the alloc
> function 

Yes.


> and call device_add() instead of device_register() in the 
> spi_register_device() function?

You should also rename it to spi_add_device(), since register()
calls always do the initialize() rather than having it done for
them in advance.  People rely on those names supporting that
pattern (as they should).


> Is that sufficient to make put_device() work?

Looks like it to me.  Calling device_initialize() will
do a kobject_init(), which is documented as requiring
a kobject_put() to clean up ... that's all put_device()
will ever do.

- Dave


