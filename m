Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbXHTKac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbXHTKac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 06:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXHTKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 06:30:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:30336 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXHTKaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 06:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ukfbz6Frb9AYL6p4Q+bWvbvWAQbEhTU2nVD3U4TEJPS5zs0F9B+aT2ct/tcyZbIeueJSqpSaO9e5gYGXXdlygwoHOMJ54M0ZwzZk03d/kzl2VKapUnnYk6QiCfqeoRzh0m3FzWS+PrelhobMCbuGTSu4YxXSkE5/D2ukIcIOsmU=
Message-ID: <3ae72650708200330k3d6f4151x60d97e2444ea6dc4@mail.gmail.com>
Date: Mon, 20 Aug 2007 12:30:20 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: Alemao <xcarandiru@gmail.com>
Subject: Re: usb & udev
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d970ff420708192306gfe0628dn192f01e8301f2b39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d970ff420708192306gfe0628dn192f01e8301f2b39@mail.gmail.com>
X-Google-Sender-Auth: a0b740780602faec
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/07, Alemao <xcarandiru@gmail.com> wrote:
> When I plug my board with the FT232R chip from FTDI (USB to serial) a
> module named usbserial.ko and ftdi_sio.ko is inserted automatically.
>
> I saw in udev rules that this is the line responsible for doing that:
>
> # Load drivers that match kernel-supplied alias
> ENV{MODALIAS}=="?*",                    RUN+="/sbin/modprobe -Q $env{MODALIAS}"
>
> What I want to know is who send this for udev? usbcore module?

The driver core. In this case it's the USB core, which enumerates the
devices on the USB bus. When the USB core discovers a new device, it
requests a new object from the driver core, which sends the event.

> The variable $env{MODALIAS} is something like this:
>
>                  usb:v0403p6001d0600dc00dsc00dp00icFFiscFFipFF
>
> v0403 is the vendor ID, p6001 is the product ID, but the others? I
> didnt find anything about this in modprobe or udev docs....

MODALIAS strings are specific to every subsystem. They start with
"<subsystem>:" and append all sorts of values depending on the
individual properties of the subsystem.

For USB these are the values of:
  idVendor, idProduct, bcdDevice, bDeviceClass, bDeviceSubClass,
  bDeviceProtocol, bInterfaceClass, bInterfaceSubClass, bInterfaceProtocol.

They are not defined outside the kernel, they are just used for
wildcard matches with MODULE_ALIAS() strings in the modules itself:
  $ modinfo ftdi_sio.ko
  ...
  alias:          usb:v15BAp0003d*dc*dsc*dp*ic*isc*ip*
  alias:          usb:v0403pEE18d*dc*dsc*dp*ic*isc*ip*
  ...

The called modprobe matches the kernel supplied MODALIAS with the
entries contained in the module itself, and loads all matching
modules.

Kay
