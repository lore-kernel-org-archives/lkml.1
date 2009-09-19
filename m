Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZISEko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZISEko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 00:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZISEkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 00:40:42 -0400
Received: from mail-iw0-f179.google.com ([209.85.223.179]:50774 "EHLO
	mail-iw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZISEkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 00:40:41 -0400
X-Greylist: delayed 16636 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2009 00:40:41 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F2b/B0e+xqyBqSW49/KSWs69uqJAg7Ye6uAuehWPvo8gMwZtl4R/1eaQfpLA+hcCZ2
         sPJnrucZkHAxd+jSrUwbWGPnNVzqMJAB/DyA4yczwUpoa0d7kPJ/ku7xKseivlQYeI9p
         7iFuXv1np8zzSOkz/4PGe3/pqgDClbzVu/bbs=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901D41FBD@mi8nycmail19.Mi8.com>
References: <200907311027.06370.hartleys@visionengravers.com>
	 <200908041414.26112.david-b@pacbell.net>
	 <BD79186B4FD85F4B8E60E381CAEE190901B7783E@mi8nycmail19.Mi8.com>
	 <1249529480.16688.13.camel@ben-desktop>
	 <45a44e480909181703l7b1ef8a1lf00fdd53aebfb523@mail.gmail.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901D41FBD@mi8nycmail19.Mi8.com>
Date: Sat, 19 Sep 2009 12:40:44 +0800
Message-ID: <45a44e480909182140s6df2cc73td6e2fd0362fc49f9@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ben Nizette <bn@niasdigital.com>, David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 8:42 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Friday, September 18, 2009 5:03 PM, Jaya Kumar wrote:
>
> Hmm.. That patchset is a lot different than what I was thinking of.  Your
> patch allows a variable width to the number of gpio's in the "port".  But
> it also still gets/sets the "port" by individual bit accesses to the
> gpio_chip.  By doing this I don't see how you could get a performance
> increase.

It only does individual bit set/get if the specific arch does not
offer a multi bit set/get. See __gpio_set_batch_generic which calls
chip->set versus __gpio_set_batch which calls chip->set_batch so that
if the underlying architecture supports it then we do multi-bit
access. I provided one for pxa here:
http://marc.info/?l=linux-kernel&m=123287743104542&w=2 . So, the
following scenarios should all be optimized for:

a) if the user calls gpio_s/get_batch with a width that fits the
native register width and all those bits fit into the said register,
then it results in a call directly to the multibit register set/get
function/inline. For example, on pxa with above implementation,
gpio_set_batch(1, mask=0xFFFFFFF, value=0xc001f00d), at compile time,
that will result in a single GPSR/GPCR.
b) if the user calls gpio_s/get_batch with a width that more than one
register, the implementation walks the bits and splits it across the
registers as needed. This is done in __gpio_s/get_batch
c) if the user calls the gpio_s/get_batch with non-consecutive bits
using the 32-bit mask, then the implementation walks the bits and
splits it across the registers as needed.

So, it is fairly optimized. If I understood David's suggested design
correctly, it is one where the user does not need to worry about masks
or widths at all. Instead, you register with the library, a list of
bits you want to make a bus out of, and then the library is
responsible for taking that and optimizing that further as much as
possible. I agree that that would be a more elegant API. What I was
hoping for is that my implementation above could be a starting point
for that by first providing optimized multi-bit access that could be
used by the more elegant API.

Thanks,
jaya
