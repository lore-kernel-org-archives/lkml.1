Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZFYPRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZFYPRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZFYPRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:17:02 -0400
Received: from mail-gx0-f222.google.com ([209.85.217.222]:54915 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZFYPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=dwEinXjm/jkVvhcWeCz6F/c1sfnUo7peHERU3lXLr5quV1s0V8jrBCZKBMnPiIfygN
         bn2k4+EZyjJkybk503ug/luoLybvBDdJNlWo0MxzxhngJRF02kkVhKPiAzIjoSaoVuCN
         tCB8c1Nj5nKt9AeBt0VUni5rs8BJ9htT8UpOM=
MIME-Version: 1.0
In-Reply-To: <20090624184120.GA12953@linux-sh.org>
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de>
	 <1245857425-25389-2-git-send-email-daniel@caiaq.de>
	 <20090624163414.GB26409@suse.de> <20090624184120.GA12953@linux-sh.org>
Date: Fri, 26 Jun 2009 00:17:03 +0900
Message-ID: <aec7e5c30906250817t486e7d2cr1d3b6718cc345cc9@mail.gmail.com>
Subject: Re: [PATCH 1/2] UIO: add device clock support
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Greg KH <gregkh@suse.de>,
       Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       hjk@linutronix.de, magnus.damm@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 3:41 AM, Paul Mundt<lethal@linux-sh.org> wrote:
> On Wed, Jun 24, 2009 at 09:34:14AM -0700, Greg KH wrote:
>> On Wed, Jun 24, 2009 at 05:30:24PM +0200, Daniel Mack wrote:
>> > Add a pointer to a 'struct clk' to uio_info. Drivers can set
>> > this pointer if a clock is needed, and the UIO core will care
>> > to enable and disable it upon device open and release.
>>
>> Do you have a UIO driver that needs this?
>>
>> If so, please submit it at the same time, otherwise adding
>> infrastructure for no driver that needs it, is pretty pointless.
>>
> We can use this for the uio_pdrv_genirq case on sh, but open/release is a
> bit coarse grained. Presently we default-enable clocks for devices that
> are handled through uio, so doing it at open/release is at least better
> than that. The other thing to consider is if we really want to add a
> HAVE_CLK depdendency outright, or just ifdef around it..

Yeah, we export quite a few UIO devices on SuperH, and
stopping/starting clocks is on my TODO list.

Like Paul says, open/release only is a bit coarse grained. I'd like to
be able to keep the device open in user space, having a bunch of
memory windows mmap()ed but still being able to power down the
hardware block somehow.

The patch seems to be about enabling and disabling clocks, the actual
clock frequency is not really exposed to user space what I can tell. I
was more thinking along the lines of having an array of clocks per uio
device - pretty much like the memory windows - and just expose the
clocks and their frequencies to user space and letting user space
enable and disable using sysfs.

I wonder if it would be possible to enable the clock in open() and
stop the clock automatically from the ISR and use writenotify and/or
some kind of trapping mechanism to restart the clock when page faults
are received. If this works or not will probably vary from device to
device so it's probably not a good idea either.

Also, there may be some overlap with the Runtime PM code since this
seems more to be about stopping clocks than exposing frequencies to
user space.

Cheers,

/ magnus
