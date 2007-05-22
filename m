Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbXEVT7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbXEVT7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXEVT7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:59:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:36484 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbXEVT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FsAdwMLuG+2iYuU+lbW2pQJjWdcpYD1lmD79kmUIEAFKKffnpRKtvj54aNdhe5knY761/Q5XH9KDZLpAtrukDhBKN6NI42RQ8viNzgEp7h/pwj7hrCj+f6T7sE0AaDAkp6xZr3XmD08r/zwEDdES7Cbm2ieuoxyH3kRxByAjWi4=
Message-ID: <9e4733910705221258v660d8f42j16cc596ca820e8b8@mail.gmail.com>
Date: Tue, 22 May 2007 15:58:57 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <21d7e9970705221025r2f798dc5x310947db040c6521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <465228E2.1030405@garzik.org>
	 <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
	 <200705211856.56228.jbarnes@virtuousgeek.org>
	 <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com>
	 <21d7e9970705220735j37bc8eeck87db7193c08c4c24@mail.gmail.com>
	 <9e4733910705220813i479a68faxf365697962317c60@mail.gmail.com>
	 <21d7e9970705221025r2f798dc5x310947db040c6521@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Dave Airlie <airlied@gmail.com> wrote:
> > These are not isolated problems. Linux needs a properly designed
> > graphics subsystem. One way to achieve that is to design it all on
> > paper first so that we can try and locate the interactions between
> > modules. For example the current mode setting design is definitely
> > broken for multi-seat support, that's because you didn't take that
> > feature into account when writing the code.
>
> No it isn't the code Jesse posted can handle multi-seat fine in the
> areas that it makes sense as we've pointed out to you you cannot just

The code doesn't create one device per CRTC. Missing that feature
means that we need a persistent root priv app around that owns the
single device and then listens for messages from each seat asking it
to do things. That root priv app is not necessary, it is a security
risk and it should be eliminated.

> divide a GPU up into two head and not have the users interfere with
> each other, reprogramming modes on multiple crtcs/outputs and setting
> up memory bandwidth calculations requires the driver to do things that
> will potentially disrupt the other user, in most cases setting a mode
> on a head requires turning off all devices on the card first and
> switching them back on in a certain order, this is usually due to
> clocking interactions,

All this doesn't mean that it is impossible. I'm not asking you to
write this today, I just want an API that will allow it in the future.
The last graphics API was with us 25 years, I would hope that the
replacement can make it at least six months without needing changes. I
believe this feature will be much easier to implement on DX10 hardware
which will be wide spread in a few years.

> We can provide two fb interfaces for users wanting to do what you
> want, we then need to fix the VT subsystem on top of that, however for
> most of our users (like 95% at least) we want to support X as best we
> can, and that is where the energy will be placed initially, reducing
> the number of mode changes on startup along with suspend/resume for
> users is a major goal of this work.

Everyone runs X because we have built an environment where it is
pretty much impossible to create an alternative graphics system. If
the low level graphics system is going to get rewritten it is a crime
to do it to only serve the needs of X. Linux is about choice; it's
time we fixed the low level graphics system to make choice possible.
If you haven't noticed the other two major OSes have switched to
graphics systems based on 3D hardware. It is pretty much impossible to
build a graphics system like that for Linux given the current state of
low level graphics support.

> > Putting a small module into the kernel first with a random API, then
> > try and build the next module is not a good development path. It is
> > better to design all of the modules on paper and then work backwards
> > to the API the first module needs.  Even better would be to get the
> > whole subsystem working before including it in the kernel. Once these
> > exposed APIs go it, it is impossible to get them out. We need to try
> > and make sure that they are correct to begin with.
>
> Fine, but nobody has succeeded at this, because the effort of doing it
> this way is not incrementally developed, we are not designing DX10, we
> are improving Linux graphics one step at a time.

And the right way to build a house is to build the kitchen first and
figure out the rest after the kitchen is finished.

> > You need to take into account that you are proposing the replacement
> > of an existing subsystem, not the initial inclusion of a virgin
> > system. Putting your code in as is does make the X server happy, but
> > it is not solving all of the known problems with the existing graphics
> > subsystem. If you just want to make to X server happy it would be
> > better to extend the existing fbdev API and not try and replace the
> > subsystem.
>
> The thing is we need integration with memory management, the memory
> management is in the drm as it is complicated and the work is done, I
> know you aren't even reading this sentence at this point.

A new memory manager for drm is a nice piece of work. It was something
that needed to get done. But right now it is being done in an X
specific manner without consideration of alternative graphics
environments.


>
> Dave.
>


-- 
Jon Smirl
jonsmirl@gmail.com
