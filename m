Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXFLMwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXFLMwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXFLMwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:52:00 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:18800 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755604AbXFLMv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:51:59 -0400
Date: Tue, 12 Jun 2007 14:51:56 +0200
From: Carlo Wood <carlo@alinoe.com>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ide0=noprobe, hda=noprobe, hda=none ignored?
Message-ID: <20070612125156.GA31703@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	"Alexander E. Patrakov" <patrakov@ums.usu.ru>,
	linux-kernel@vger.kernel.org
References: <20070610185439.GA12202@alinoe.com> <466D2E52.4000904@ums.usu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466D2E52.4000904@ums.usu.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

keyword: =noprobe, =none, IRQ probe failed, initrd, ide_core, solved,
solution, howto.

On Mon, Jun 11, 2007 at 05:13:22PM +0600, Alexander E. Patrakov wrote:
> If your kernel uses modular IDE drivers and an initrd/initramfs that loads 
> them, your result is the expected one (i.e.: not a bug). One should add the 
> following or similar options into /etc/modprobe.conf in the initrd in order 
> to get the result:
> 
> options ide_core options="ide0=noprobe hda=noprobe hdb=noprobe"
> 
> If you don't use initrd, or have a non-modular IDE driver, please ignore 
> this message.

Thanks! I have indeed an initrd and a modular IDE driver, this was
the solution :) Thanks, I really learned from this :)

For the sake of archiving, so people can find this solution back with
Google and use it too, I've added keywords as first line and will add below all
relevant information (this can be ignored by people from the linux-kernel.)

1) If you suffer from this problem and want to know if this solution is for
you, use the command 'lsmod' and check if you have ide_core loaded as module:

lsmod | grep ide_core

2) Check if you have an initrd in /boot:

ls /boot/initrd*`uname -r`

3) Check if you use /etc/modprobe.conf, or /etc/modprobe.d

ls -ld /etc/modprobe.conf /etc/modprobe.d

if only /etc/modprobe.d exists, it will be what is used, and add a file
(I used 'noprobe') to this directory. Otherwise add the line given by
Alexander to /etc/modprobe.conf. Thus,

echo 'options ide_core options="ide0=noprobe hda=noprobe hdb=noprobe"' >/etc/modprobe.d/noprobe

or add that line to your existing /etc/modprobe.conf
obviously, replace hda/hdb with the drive ids that you need to be
ignored, and ide0 with the corresponding ide# (dmesg | grep hdX,
directly after booting, should tell you).  I did not test if using
only 'ide0=noprobe' or only 'hda=noprobe hdb=noprobe' is sufficient.

4) Regenerate your initrd image (this might depend on the distribution
   you are using. On debian you'd execute:

update-initramfs -u

which is part of the initramfs-tools package.

5) If you want to be sure that the option is now in your initrd image,
   you can do the following:

cd /boot
mkdir initrd-VERSION-extract
cd initrd-VERSION-extract
gzip -dc ../initrd.img-VERSION | cpio -i
ls etc/

and check if the options line is where you added it in your real root.
Ie, if you added it to /etc/modprobe.d/noprobe:

cat /boot/initrd-VERSION-extract/etc/modprobe.d/noprobe

after that you can rm /boot/initrd-VERSION-extract again, of course.

6) reboot - and enjoy the no probing!

Thanks to Alexander E. Patrakov for this solution.

-- 
Carlo Wood <carlo@alinoe.com>
