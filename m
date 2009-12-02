Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZLBRGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZLBRGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZLBRGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:06:44 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:58255 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbZLBRGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:06:43 -0500
Message-ID: <37885b84bd22291f359459562a674222.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20091125200910.0377bc0c@lxorguk.ukuu.org.uk>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
    <20090818151427.GA6295@kroah.com>
    <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
    <20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
    <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
    <20090819191944.23e6e0ee@lxorguk.ukuu.org.uk>
    <3eb87686d834e14f35378d3c3c79fb02.squirrel@intranet.cs.nmsu.edu>
    <20090819193457.538aad95@lxorguk.ukuu.org.uk>
    <c53e47c966cc5f6c7b3616f9be83ad23.squirrel@intranet.cs.nmsu.edu>
    <20091125200910.0377bc0c@lxorguk.ukuu.org.uk>
Date: Wed, 2 Dec 2009 10:06:41 -0700
Subject: Re: Dynamically attaching fbcon to a framebuffer
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Greg KH" <greg@kroah.com>, "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I have the display as a framebuffer device now (based on fbdefio with
>> the
>> hid device as the parent).
>>
>> Do I really need a separate console device or can I just use fbcon?
>
> fbcon should do what you want.
>

I've been playing with fbcon, but can't get a fbcon console started.

I wrote a little app that uses the framebuffer ioctls to change fbcon's
map. Specifically, the G13 shows up as fb1, and the app basically does
this:

  int fd = open("/dev/fb1", O_RDWR);
  struct fb_con2fbmap con2fb;
  int ret;

  if ( fd < 0 ) { printf("Error opening %s\n", DEVICE); return -1; }

  con2fb.console = 5;

  ioctl(fd, FBIOGET_CON2FBMAP, &con2fb);
  printf("Console: %d  Framebuffer: %d\n", con2fb.console,
con2fb.framebuffer);

  con2fb.framebuffer = 1;
  ret = ioctl(fd, FBIOPUT_CON2FBMAP, &con2fb);
  printf("Succeeded: %d\n", ret);

  ioctl(fd, FBIOGET_CON2FBMAP, &con2fb);
  printf("Console: %d  Framebuffer: %d\n", con2fb.console,
con2fb.framebuffer);

This succeeds and I get:
Console: 5  Framebuffer: 0
Succeeded: 0
Console: 5  Framebuffer: 1

But, when I change to console 5 that's when things die. I never hit any of
my fb_ops callbacks.

The driver can be found here:
http://g13.svn.sourceforge.net/viewvc/g13/driver/trunk/hid-g13.h
http://g13.svn.sourceforge.net/viewvc/g13/driver/trunk/hid-g13.c

This doesn't actually do anything but do a printk (in hex) of the
framebuffer memory.

When I modify the framebuffer through a mmap I don't have any problems,
but when I switch to the console the kernel hangs.

I'm currently recompiling the kernel with FBCONDEBUG defined and I'll test
from there.

Any other suggestions on how to approach this?

Thanks,

---

Rick


