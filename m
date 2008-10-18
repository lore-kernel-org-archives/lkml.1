Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbYJRQQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbYJRQQB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYJRQPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:15:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:4446 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYJRQPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=cGtpRPtTQ7if1YjUp0QWVluCvLGePiHlsyKpvdtkgwsv4yykwLCURi4OKOgrUUOfqO
         TeO4giv6tSDPLu4PIrMpcqaaP38G32zOyGZrUQuLGxyS8aihr6KpXJnoWGYbwDgRtbmY
         +EoH9Vj9zTw73DQNUFTTo/jaxUZd/LmM8rcwk=
Message-ID: <ce0170d90810180915m10caa101ucc9e9a8a17cbb6cb@mail.gmail.com>
Date: Sat, 18 Oct 2008 13:15:49 -0300
From: "Sergio Luis" <eeeesti@gmail.com>
To: "Alan Cox" <alan@redhat.com>
Subject: tty: usb-serial krefs - bad magic number for tty struct (188:0)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

commit 4a90f09b20f4622dcbff1f0e1e6bae1704f8ad8c

tty: usb-serial krefs

Use kref in the USB serial drivers so that we don't free tty structures
from under the URB receive handlers as has historically been the case if
you were unlucky. This also gives us a framework for general tty drivers to
use tty_port objects and refcount.

Contains two err->dev_err changes merged together to fix clashes in the
-next tree.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

----

causes problems with my usb hsdpa modem. when I try to connect pppd
dies and I get these messages on dmesg:

[...]
usb-storage: device scan complete
PPP generic driver version 2.4.2
bad magic number for tty struct (188:0) in tty_ioctl
bad magic number for tty struct (188:0) in tty_ioctl
bad magic number for tty struct (188:0) in tty_release_dev
bad magic number for tty struct (188:0) in tty_poll
bad magic number for tty struct (188:0) in tty_poll
bad magic number for tty struct (188:0) in tty_write
bad magic number for tty struct (188:0) in tty_ioctl
bad magic number for tty struct (188:0) in tty_ioctl
bad magic number for tty struct (188:0) in tty_ioctl
bad magic number for tty struct (188:0) in tty_release_dev

---

drivers/usb/serial/ChangeLog.history has this:

(03/26/2002) gkh
        removed the port->tty check from port_paranoia_check() due to serial
        consoles not having a tty device assigned to them.

and this seems to be the problem here.
something in this commit seems to make it reach the tty_paranoia_check
in tty_ioctl() from drivers/char/tty_io.c, but I could be completely
wrong.

Sergio.
