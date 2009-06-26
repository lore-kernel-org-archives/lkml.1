Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZFZI2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZFZI2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZFZI2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:28:23 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:59849 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbZFZI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=RRzBnoGk182XjA+gyu/w2RlGRQEqYDfoCEVXTplK9ZnEjVka3F855EXlmsKnxkFzLo
         HTQ4Q0ILTm1OYGfwkEYYe/4Njth36J4P1VNg+JxV8rL7x11a+zpUaPADGkulhi4t7lJ1
         SSFnuadEThjmqy2F7lJm7wI5a8mgCeezUg72k=
MIME-Version: 1.0
In-Reply-To: <20090625174703.GC25320@linux-sh.org>
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de>
	 <1245857425-25389-2-git-send-email-daniel@caiaq.de>
	 <20090624163414.GB26409@suse.de> <20090624184120.GA12953@linux-sh.org>
	 <aec7e5c30906250817t486e7d2cr1d3b6718cc345cc9@mail.gmail.com>
	 <20090625174703.GC25320@linux-sh.org>
Date: Fri, 26 Jun 2009 17:28:22 +0900
Message-ID: <aec7e5c30906260128q7c39648dg8b549bb322cf7d57@mail.gmail.com>
Subject: Re: [PATCH 1/2] UIO: add device clock support
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
       Greg KH <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>,
       linux-kernel@vger.kernel.org, hjk@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 2:47 AM, Paul Mundt<lethal@linux-sh.org> wrote:
> On Fri, Jun 26, 2009 at 12:17:03AM +0900, Magnus Damm wrote:
>> On Thu, Jun 25, 2009 at 3:41 AM, Paul Mundt<lethal@linux-sh.org> wrote:
>> > On Wed, Jun 24, 2009 at 09:34:14AM -0700, Greg KH wrote:
>> >> On Wed, Jun 24, 2009 at 05:30:24PM +0200, Daniel Mack wrote:
>> >> > Add a pointer to a 'struct clk' to uio_info. Drivers can set
>> >> > this pointer if a clock is needed, and the UIO core will care
>> >> > to enable and disable it upon device open and release.
>> >>
>> >> Do you have a UIO driver that needs this?
>> >>
>> >> If so, please submit it at the same time, otherwise adding
>> >> infrastructure for no driver that needs it, is pretty pointless.
>> >>
>> > We can use this for the uio_pdrv_genirq case on sh, but open/release is a
>> > bit coarse grained. Presently we default-enable clocks for devices that
>> > are handled through uio, so doing it at open/release is at least better
>> > than that. The other thing to consider is if we really want to add a
>> > HAVE_CLK depdendency outright, or just ifdef around it..
>>
>> Yeah, we export quite a few UIO devices on SuperH, and
>> stopping/starting clocks is on my TODO list.
>>
>> Like Paul says, open/release only is a bit coarse grained. I'd like to
>> be able to keep the device open in user space, having a bunch of
>> memory windows mmap()ed but still being able to power down the
>> hardware block somehow.
>>
>> The patch seems to be about enabling and disabling clocks, the actual
>> clock frequency is not really exposed to user space what I can tell. I
>> was more thinking along the lines of having an array of clocks per uio
>> device - pretty much like the memory windows - and just expose the
>> clocks and their frequencies to user space and letting user space
>> enable and disable using sysfs.
>>
> This is longer term work that still needs to be discussed and agreed
> upon, which is totally out of scope for this patch. Doing it at
> open/close time is already better than what we have today, so I am
> inclined to roll this patch in to a topic branch and convert the existing
> sh users over to it. Any improvement with regards to making it more fine
> grained, or deciding what to expose to userspace, is something to look at
> much later, particularly as the runtime pm code is going to be a
> prerequisite for a lot of it (ie, 2.6.33).

Performing clk_enable()/clk_disable() at open()/close() time sounds
good, but we probably also want to extend the uio_pdrv_genirq driver
to do clk_get()/clk_put() at probe()/remove() time well.

/ magnus
