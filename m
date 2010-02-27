Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589Ab0B0LAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 06:00:06 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:38976 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544Ab0B0LAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 06:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c4lBzznOMnQTal+pTiOc4KdAkIklKIWaECA1BPVRmeXg+ve06s2AVgRvp0UPZJ6XFR
         W6YGksSlN6pM429oY0sz7W+m4F94bLrvuSbZ4pyyhZIH5kxkY/VrWDrc8EsOwkG+Iyq1
         wA4oUsYg97Xu03Qh2H/UpZtiC2Nv2MkK31ptw=
MIME-Version: 1.0
In-Reply-To: <20100227054808.GA32225@kroah.com>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
	 <20100227035639.GA11680@kroah.com>
	 <d9def9db1002262005t6d63b902s673fb01dac228e4d@mail.gmail.com>
	 <20100227041815.GA12956@kroah.com>
	 <alpine.LFD.2.00.1002262022090.4513@localhost.localdomain>
	 <d9def9db1002262034p55cd569n6c423741c276798d@mail.gmail.com>
	 <20100227051737.GA14976@kroah.com> <20100227052648.GA31418@kroah.com>
	 <d9def9db1002262138q63c410b7ga7c04f35b6f154ff@mail.gmail.com>
	 <20100227054808.GA32225@kroah.com>
Date: Sat, 27 Feb 2010 12:00:02 +0100
Message-ID: <d9def9db1002270300g7e256fc6n6fbb4fd08d951fb8@mail.gmail.com>
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-usb@vger.kernel.org,
       werner@guyane.dyn-o-saur.com, Marcus Meissner <meissner@suse.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 6:48 AM, Greg KH <greg@kroah.com> wrote:
> On Sat, Feb 27, 2010 at 06:38:09AM +0100, Markus Rechberger wrote:
>> On Sat, Feb 27, 2010 at 6:26 AM, Greg KH <greg@kroah.com> wrote:
>> > On Fri, Feb 26, 2010 at 09:17:37PM -0800, Greg KH wrote:
>> >> On Sat, Feb 27, 2010 at 05:34:27AM +0100, Markus Rechberger wrote:
>> >> > On Sat, Feb 27, 2010 at 5:29 AM, Linus Torvalds
>> >> > <torvalds@linux-foundation.org> wrote:
>> >> > >
>> >> > >
>> >> > > On Fri, 26 Feb 2010, Greg KH wrote:
>> >> > >>
>> >> > >> Yes, and that patch didn't touch the iso frames. ?That happens later on
>> >> > >> in the functions that were modified. ?The patch should not have had any
>> >> > >> affect on iso transfers. ?Unless I'm missing something?
>> >> > >
>> >> > > Hmm. What seems to happen is that for an isochronous transfer, the buffer
>> >> > > is split for each microframe. No?
>> >> > >
>> >> >
>> >> > exactly. and each microframe has its own buffer length identifier.
>> >> >
>> >> > the current behaviour breaks VMware, QEMU and virtualbox .. probably
>> >> > other things too.
>> >> >
>> >> >
>> >> > > So the total length may be in 'urb->actual_length', but the actual data in
>> >> > > the buffer may not be contiguous, because it's created from multiple
>> >> > > smaller frames, some of which might not be full length?
>> >> > >
>> >> >
>> >> > yes, it's only contiguous for BULK.
>> >> >
>> >> > > I dunno. That would explain the problem - actual_length is correct, but
>> >> > > the 'copy_to_user()' still doesn't copy all the data, because it's
>> >> > > fragmented.
>> >> > >
>> >> >
>> >> > no you got it, but your patch does not work. The best way would be to
>> >> > revert it if someone wants to speed up BULK it should go down another
>> >> > path, leaving the old working implementation untouched.
>> >>
>> >> Hm, so it's back to the original idea of just doing a kzalloc of the
>> >> initial buffer, that should solve the problem that Marcus found.
>> >>
>> >> I'll go dig that back up and if you could test it, that would be most
>> >> appreciated.
>> >
>> > Here, can you try this on top of everything?
>> >
>>
>> just tested it, everything's back to normal again now!
>
> Thanks for testing, I'll queue it up for Linus and then add it back to
> .32-stable.
>
> Linus, I know you didn't want to do a kzalloc, but it looks like this is
> the easiest/simplest thing to do, unless you can think of something
> else?
>

do you have any idea what to cherrypick in order to get rid of that
flickering with the intel GM45?
The flickering itself occures randomly, it was not there with the
original Ubuntu kernel (2.6.31 with alot patches)
This is pretty much a standard graphicchip nowadays....

Xorg.0.log:
(II) intel(0): Integrated Graphics Chipset: Intel(R) GM45
(--) intel(0): Chipset: "GM45"
$ lspci
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07)
01:00.0 VGA compatible controller: nVidia Corporation Device 0a74 (rev a2)

Markus
