Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZDUNdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZDUNdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZDUNdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:33:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3950 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbZDUNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:33:16 -0400
Date: Tue, 21 Apr 2009 15:33:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] go7007: Convert to the new i2c device binding model
Message-ID: <20090421153307.10b24cea@hyperion.delvare>
In-Reply-To: <49ED781F.2000802@ladisch.de>
References: <20090420194237.52630423@hyperion.delvare>
	<49ED781F.2000802@ladisch.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Clemens,

On Tue, 21 Apr 2009 09:39:11 +0200, Clemens Ladisch wrote:
> Jean Delvare wrote:
> > I am puzzled by the s2250 I2C address, 0x86 really doesn't fit in
> > 7 bits, there must be something wrong.
> 
> > -				.addr	= 0x34,
> > +				.addr	= 0x86,	/* ?? */
> 
> > -#define S2250_VIDDEC        0x86
> 
> Many I2C controllers use an 8-bit address register, with the lowest bit
> being the read/write bit (because this is the order in which the bits
> are transmitted over the bus).  So it looks as if the actual address
> _is_ 0x34;

0x86 >> 1 is actually 0x43, not 0x34. 0x34 is the address for the audio
part of the device:

#define TLV320_ADDRESS	0x34

The original code was a little messy and used the same i2c_client for
both parts, changing the address on the fly.

That being said, I think you are probably right, the 7-bit device's
address is probably 0x43 for video. And now that we mention that,
probably 0x34 for audio is incorrect as well. "TLV320" suggests some
incarnation of the TI TLV320 series, many of which are already
supported in the kernel, and all I've seen had address 0x18, 0x19, 0x1a
or 0x1b. Given that 0x34 >> 1 is 0x1a... it's a good hint that 0x34
wasn't a 7-bit address value, right?

I'll change the addresses to 0x43 for video and 0x1a for audio. Updated
patch coming.

> the S2250_VIDDEC symbol is probably a relict of the old
> driver that programmed the I2C controller directly.

Could be. But then this means that the driver as it stands in the
kernel today, doesn't work. Which, in a way, is good news, as it means
I can push my changes immediately. Even if I got the conversion wrong,
it won't be more broken than it already was ;)

Thanks,
-- 
Jean Delvare
