Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbXEVO2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbXEVO2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbXEVO1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:27:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:22555 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbXEVO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JTDUbZaGlicSNX/FpNE3Hg7tnsa6shkgUv+19+bMkS+l1W4OzJj0F7BbXws/sK5NYhLH+0EKOOvKb4kU9JchqEX046/SXE/T2MrTpGLP5bASGKUQUwXcuYbl68gQ7QhvD9F43v+opOdi9N4GjxGaweTK25Xy2Okjw8FFjKoBezY=
Message-ID: <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com>
Date: Tue, 22 May 2007 10:27:51 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jeff Garzik" <jeff@garzik.org>, "Jesse Barnes" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <200705211856.56228.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <465228E2.1030405@garzik.org>
	 <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
	 <200705211856.56228.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> Jon, that's why I'm posting this stuff in the first place! :)  Again, if
> you have specific problems with the proposed interfaces (problems that
> would preclude your wishlist from being fully implementable), please let
> me know (preferably with specifics).

A simple place to start is OOPS display while in graphics mode. If we
going to tear up the kernel graphics system this is something that
needs to be fixed.

I don't think it is safe for the OOPS code to attempt a mode change to
text mode when the OOPS happens. The OOPS could have happened in a 3D
driver and left the GPU messed up. The safest thing to do is to
display the OOPS using the mode that is already set.

This implies that the kernel driver needs to track the dimensions and
location of the framebuffer and whether it is in text/graphics mode
(this hasn't been possible before because X never tells the kernel
what mode it is setting). You also need to bring in the bitmap copy
code and fonts over from fbdev. When the OOPS happens you use this
info to paint the OOPS onto the screen. The code from fbdev will let
you display text in graphics mode entirely in kernel context. The
driver should also attempt to stop the GPU to try and make sure it
doesn't erase the OOPS display.

Another simple thing that needs to be built is a mechanism to run the
VBIOS in x86 mode when the driver is first loaded. This can be
achieved by using call_usermode helper to trigger an external app. You
also need to get the x86 emulator working so that this will work on
non-x86 platforms (benh has already done this). I've aput the hooks
into place to give you access to the VBIOS from sysfs. This app is a
prime candidate for klibc. This app is strongly coupled to the problem
of VGA arbitration.

Could we try and work out a solution to these two problems? If we can
solve these they will provide a foundation for fixing the harder ones.

-- 
Jon Smirl
jonsmirl@gmail.com
