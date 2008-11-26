Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYKZUgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYKZUgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYKZUgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:36:31 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:63152 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYKZUg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iiQZyZMQLFabTjjt8BQA3+e9LFOtefnukUZkC1/kybk8JD+Wx576q7hrSeIKpbZHrn
         x4AnqhX/pXcCE2w/P6v7A/BJHBoWKEfR+vbNswzRX4Yl+356L8pqT76yUbX7Xxf1v7Ok
         HxoMcHagPm3/rvDsudKIfg5PMjENzgWIjzjOY=
Message-ID: <c8b4dbe10811261236p28adc470x3d89699797f2fc4b@mail.gmail.com>
Date: Wed, 26 Nov 2008 20:36:27 +0000
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>, greg@kroah.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200811011459.17706.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <200811011459.17706.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/1/08, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Markus,
>
> As promised I've done a review of your empia driver and looked at what
> needs to be done to get it into the kernel.
>
> First of all, I've no doubt that your empia driver is better and
> supports more devices than the current em28xx driver. I also have no
> problem adding your driver separate from the current driver. It's been
> done before (certain networking drivers spring to mind) and while
> obviously not ideal I expect that the older em28xx driver can probably
> be removed after a year or something like that.
>
> In my opinion it's pretty much hopeless trying to convert the current
> em28xx driver into what you have. It's a huge amount of work that no
> one wants to do and (in this case) with very little benefit. Of course,
> Mauro has the final say in this.

The main reason no-one wants to do it is partly because it's a large
amount of work, and partly because Markus is the only one able to test
a decent subset of the available hardware and he has objections to the
idea. To be honest, the diffs look somewhat worse than they actually
are - there's a lot of noise and a lot of changes that will just be
dumped if this approach is used.

Incidentally, the new code has some odd quirks. For example, why does
opening an ALSA device switch the card from digital to radio mode,
even when the card doesn't support radio? In particular, unless I'm
missing something, this would mean that any app that opened the ALSA
device before the video device would get stuck in radio mode. (Also,
why is there tuner-specific code in the ALSA driver?) Why the bizarre
indirection through em28xx_cmd, which only has one possible value for
cmd?

> While there is some cleaning up to do in your code (coding style, some
> copyright/license clarifications), that is not a big deal. The coding
> style cleanups are a fair amount of work, but I think we can probably
> spread that out over several people and get that done quickly.
>
> What I definitely would recommend is to use video_ioctl2 rather than
> video_usercopy. The latter function will disappear in the future. I
> think the policy for new drivers is to use video_ioctl2, so this is
> probably a required task before it can be merged. Doing this will
> improve maintenance of the code as well, so it's useful to do this
> anyway. I think it's better if you do it, but I guess some volunteer
> can probably be found if needed. It's not a difficult task.
>
> Now the real problems are with three duplicate i2c drivers: cx25843,
> xc3028 and xc5000.
>
> To start with the easiest one: cx25843. There already is a driver for
> this (cx25840) and the empia driver should use that one. Since I
> maintain cx25840 the easiest approach for you is to see if you can get
> me hardware (em28xx + cx25843) so that I can test and update cx25843 to
> provide proper empia support. The alternative is that we work together
> on this, but that's probably more work for both of us. I most
> definitely do *not* want to duplicate this driver. Windows drivers
> duplicate this stuff all the time, but we're not Windows and having one
> driver ensures that fixes or new functionality become available to all
> bridge drivers that use it.
>
> The same reasoning is true for xc3028 and xc5000. In addition, the
> licensing of these sources is very vague. Is it even allowed to
> distribute them under a GPL license? There is no GPL license in the
> sources, yet in the module you specify GPL. This needs to be clarified
> first.
>
> I see two ways forward when it comes to these drivers:
>
> 1) The empia driver switches to the current xceive drivers that are
> already in the kernel. No doubt this means that xceive driver bugs will
> surface with certain devices, but those are bugs that the xceive driver
> maintainer will have to fix. Obviously assistance would be appreciated,
> but the bottom line is that a) your driver is finally in the kernel,
> and b) there is a lot more pressure to fix bugs in the xceive drivers
> than is the case otherwise. Yes, some devices will not work initially
> with the empia driver, but I expect that to be a temporary situation.

The trouble is, it looks like the core empia code is pretty tightly
integrated with the xc3028 driver - in particular, there's lots of
xc3028-specific code in empia/empia-cards.c. (This probably isn't a
good thing in itself.) Ideally, Markus would've used the in-kernel
driver for at least xc3028 - it was developed and mostly working at
that point - but I suppose that was fairly unlikely to happen.
(There's also a bunch of tuner-specific code in empia-dvb.c that
wouldn't be needed if the proper framework was used.)

Plus, there are (as usual) some direct writes to demodulators by
empia-dvb.c that need to be cleaned up.

> 2) Your xceive drivers replace the current drivers. This will require
> that a) the license situation is clarified, b) the drivers are modified
> to fit the current v4l-dvb tuner architecture. This option will mean a
> lot of work for you since you are the maintainer of these drivers. In
> addition, I forsee a lot of flaming if we go this way.

Of course, the same issue applies to this option - the empia and
xc3028 code appear to be fairly closely entangled.

In fact, since most of the work is, I suspect, going to be dealing
with this issue, just merging the required changes into the existing
em28xx driver starts to look like quite a plausible option. It
basically boils down to:

(a) audio changes, some of which are undesirable, and the rest of
which can be done by a (hopefully relatively simple) patch to the
current driver - I can just about see most of the changes in the diff.
(b) VBI, which can't all be ported directly but should be fairly easy
to add - plus, doing it that way is cleaner.
(c) some modifications to the card initialisation functions and glue
code, which ought to be simple to port but will require someone with
access to the hardware to test and debug them. (This means Markus,
basically).
(b) a bunch of formatting changes, noise and, now-redundant code with
the occasional useful change to trap the unwary.

(Interestingly, aside from VBI, the now-redundant buffer management
code, duplicate drivers, init/glue code for new cards, and misplaced
tuner-specific stuff, most of the significant changes seem to be code
that's in the existing driver but not the new. This is probably not a
good sign. Unfortunately, there's a lot of diff noise, partly due to
some of the functions being reordered at some point, partly due to
changes in stuff like indentation and format of register #defines, and
partly due to diff sucking, so it's a bit hard to see what exactly
changed in places.)

Of course, since Markus probably won't go for this, it's not really an
option. That's a shame, because it'd probably work out best.

Sorry about the rather late mail; I don't generally pay attention to
em28xx development anymore. I used to be more involved, but my card
died and I moved to hardware with a less messy driver situation.

Aidan Thornton
