Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbYJSRj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbYJSRj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYJSRjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:39:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:42190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYJSRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gTDvKxIdfuW7cc9ghMox5D7kB58VFMKcmbVluV/Fw7EmJvi1AB8SilNnGnoXRYgdNn
         hf+YEbWli7t71OWtLqHiI6COPAjBAEkg0r14TKrIPSbKFq5XXGlIqHUNtO+sOY68KUmH
         N9GPktQZYbzGwMrmbUjR3QWvEWycc95M0RYVs=
Message-ID: <ce0170d90810191039i6c78bac1ue1e4b688d47740ff@mail.gmail.com>
Date: Sun, 19 Oct 2008 14:39:46 -0300
From: "Sergio Luis" <eeeesti@gmail.com>
To: "Alan Cox" <alan@redhat.com>
Subject: Re: tty: usb-serial krefs - bad magic number for tty struct (188:0)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ce0170d90810180915m10caa101ucc9e9a8a17cbb6cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ce0170d90810180915m10caa101ucc9e9a8a17cbb6cb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 1:15 PM, Sergio Luis <eeeesti@gmail.com> wrote:
> Hello,
>
> commit 4a90f09b20f4622dcbff1f0e1e6bae1704f8ad8c
>
> tty: usb-serial krefs
>
> Use kref in the USB serial drivers so that we don't free tty structures
> from under the URB receive handlers as has historically been the case if
> you were unlucky. This also gives us a framework for general tty drivers to
> use tty_port objects and refcount.
>
> Contains two err->dev_err changes merged together to fix clashes in the
> -next tree.
>
> Signed-off-by: Alan Cox <alan@redhat.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> ----
>
> causes problems with my usb hsdpa modem. when I try to connect pppd
> dies and I get these messages on dmesg:
>
> [...]
> usb-storage: device scan complete
> PPP generic driver version 2.4.2
> bad magic number for tty struct (188:0) in tty_ioctl
> bad magic number for tty struct (188:0) in tty_ioctl
> bad magic number for tty struct (188:0) in tty_release_dev
> bad magic number for tty struct (188:0) in tty_poll
> bad magic number for tty struct (188:0) in tty_poll
> bad magic number for tty struct (188:0) in tty_write
> bad magic number for tty struct (188:0) in tty_ioctl
> bad magic number for tty struct (188:0) in tty_ioctl
> bad magic number for tty struct (188:0) in tty_ioctl
> bad magic number for tty struct (188:0) in tty_release_dev
>
> ---
>
> drivers/usb/serial/ChangeLog.history has this:
>
> (03/26/2002) gkh
>        removed the port->tty check from port_paranoia_check() due to serial
>        consoles not having a tty device assigned to them.
>
> and this seems to be the problem here.
> something in this commit seems to make it reach the tty_paranoia_check
> in tty_ioctl() from drivers/char/tty_io.c, but I could be completely
> wrong.
>
> Sergio.
>
Hello,

one of the problems was the tty_kref_put(tty) in
usb_serial_port_work() [drivers/usb/serial/usb-serial.c], that was
releasing the tty device. I removed that line and it _almost_ worked.
well, it worked, but only _once_. If I stopped the daemon and tried to
start it again, it would give me I/O error and would not open
/dev/ttyUSB0 anymore.
I'd suggest to revert that commit and to review it more carefully.
What do you people think?

Thanks,
Sergio.
