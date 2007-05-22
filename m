Return-Path: <linux-kernel-owner+w=401wt.eu-S934722AbXEVPOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722AbXEVPOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbXEVPNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:13:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:53803 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbXEVPNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aAxgzh/ntQZe7mmN2E62swzRcLWvWAXwZZ8CrjrXNzAaKzn0mslCXz6TRqWS/3HNNBc4NxOtpNIHLzkFRjPdD5ZlUXV31AZjL+BEA4cHBYxB9fAv5NIKPlS9ozPWXzG6+uZsGVx6GKPB4apku/pVhvUamW1XPUm4xYhLVYby86Q=
Message-ID: <9e4733910705220813i479a68faxf365697962317c60@mail.gmail.com>
Date: Tue, 22 May 2007 11:13:52 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <21d7e9970705220735j37bc8eeck87db7193c08c4c24@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Dave Airlie <airlied@gmail.com> wrote:
> On 5/22/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> > On 5/21/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > Jon, that's why I'm posting this stuff in the first place! :)  Again, if
> > > you have specific problems with the proposed interfaces (problems that
> > > would preclude your wishlist from being fully implementable), please let
> > > me know (preferably with specifics).
> >
> > A simple place to start is OOPS display while in graphics mode. If we
> > going to tear up the kernel graphics system this is something that
> > needs to be fixed.
> >
> > I don't think it is safe for the OOPS code to attempt a mode change to
> > text mode when the OOPS happens. The OOPS could have happened in a 3D
> > driver and left the GPU messed up. The safest thing to do is to
> > display the OOPS using the mode that is already set.
> >
> > This implies that the kernel driver needs to track the dimensions and
> > location of the framebuffer and whether it is in text/graphics mode
> > (this hasn't been possible before because X never tells the kernel
> > what mode it is setting). You also need to bring in the bitmap copy
> > code and fonts over from fbdev. When the OOPS happens you use this
> > info to paint the OOPS onto the screen. The code from fbdev will let
> > you display text in graphics mode entirely in kernel context. The
> > driver should also attempt to stop the GPU to try and make sure it
> > doesn't erase the OOPS display.
>
> What does this have to do with Jesse's patches? this is a totally
> orthogonal issue..
>
> We will fix this once we have the basic modesetting code working,

These are not isolated problems. Linux needs a properly designed
graphics subsystem. One way to achieve that is to design it all on
paper first so that we can try and locate the interactions between
modules. For example the current mode setting design is definitely
broken for multi-seat support, that's because you didn't take that
feature into account when writing the code.

Putting a small module into the kernel first with a random API, then
try and build the next module is not a good development path. It is
better to design all of the modules on paper and then work backwards
to the API the first module needs.  Even better would be to get the
whole subsystem working before including it in the kernel. Once these
exposed APIs go it, it is impossible to get them out. We need to try
and make sure that they are correct to begin with.

You need to take into account that you are proposing the replacement
of an existing subsystem, not the initial inclusion of a virgin
system. Putting your code in as is does make the X server happy, but
it is not solving all of the known problems with the existing graphics
subsystem. If you just want to make to X server happy it would be
better to extend the existing fbdev API and not try and replace the
subsystem.

-- 
Jon Smirl
jonsmirl@gmail.com
