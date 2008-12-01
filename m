Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbYLAFeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbYLAFeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 00:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAFeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 00:34:11 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40182 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750709AbYLAFeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 00:34:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c+7jEIi1dIOmxxK5dbPYmGbNAHZF7h2yMP6ylA0Qdms8WVayX7Bk6R238mPYJcEuaolztSeeU1rprUAHexBdHReD32hOtvkPoSRp1Ind1YeQw4doFL9DCWYJFivYTyp9Wy6IXjEQ7kGl/bW+vTIYKNibAfrsQNAfqaqrxezXJ1M=  ;
X-YMail-OSG: fJi.XPwVM1mptuifPi4tET00bDLkEl1u398NkhUVKh4Id3d7hin5MXZCRDcTRz.erDTwoFXXGEVgPRvLsVsd95lP6.fCIq6RzIKZQ5a2xHDIw.7uca0wPNTd0Gd80TgfnMwvDFewQikgVl8IdLwU8VfJVMeWWGF7pIab8VpXAzQ0SvwLZFNulJaorexM
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Hans Verkuil <hverkuil@xs4all.nl>, Andy Walls <awalls@radix.net>
Subject: Re: [PATCH v2] v4l2_device/v4l2_subdev: final (?) version
Date: Sun, 30 Nov 2008 21:34:06 -0800
User-Agent: KMail/1.9.10
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
References: <200811291852.41794.hverkuil@xs4all.nl> <1228013385.4615.143.camel@palomino.walls.org> <200811301152.50971.hverkuil@xs4all.nl>
In-Reply-To: <200811301152.50971.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811302134.07166.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 November 2008, Hans Verkuil wrote:
> > On a more philosophical note is GPIO really a single subdev or a
> > collection of independent serial & discrete buses to a collection of
> > subdevs?  In cx18 depending on the board, GPIO can reset chips,
> > change audio mux paths, change the state of LED's, and in the future
> > be used as a serial line (if I ever get that soft-UART to the IR
> > blaster implemented).
> 
> Definitely a collection of subdevs. Usually each chip driven by GPIO 
> would have its own subdev. So ivtv implements an audio muxer subdev, 
> but it might also have additional subdevs for other chips connected to 
> the GPIO lines. I haven't explored all the possibilities yet, but I 
> suspect that this can be a quite powerful solution.

Right.  GPIO is basically a glue tech ... the focus should be what's
being glued (the various subdevs, and their parents), not on the glue.
I think a standardized set of GPIO calls, and gpiolib, makes that a
lot easier nowadays; though maybe not always painless.

Keeping to the V4L2 topic:  I figure there will be some issues there
to sort out.  For example, it might be important to collect key
resources like GPIOs and regulators before setting up the various I2C
clients that rely on those for proper operation, or other parts of a
complex V4L2 "assembly" (to coin a term).  I understand that in some
cases those GPIOs are provided through I2C-based expanders... such
sequencing issues will become clearer as the $SUBJECT work matures.
(I'd expect the v4l2_device would manage such stuff.)

One widely accessible OMAP example:  the beagleboard.org hardware uses
a GPIO to enable its DVI output, and a regulator that must be enabled
for S-Video output.  Both should be disabled when their output channel
is not in use -- software doesn't handle that yet though! -- and I'd
expect an OMAP3 v4l2_device would understand such board-specific setup
issues.  (Support for that isn't yet in mainline though.)

- Dave
