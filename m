Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYJMV2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYJMV2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYJMV2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:28:32 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:59176 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbYJMV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:28:31 -0400
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       a.zummo@towertech.it
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
References: <87vdvyngni.fsf@hades.wkstn.nix>
	<20081012181700.GA21072@kroah.com>
From: Nix <nix@esperi.org.uk>
Emacs: don't cry -- it won't help.
Date: Mon, 13 Oct 2008 22:28:13 +0100
In-Reply-To: <20081012181700.GA21072@kroah.com> (Greg KH's message of "Sun, 12 Oct 2008 11:17:00 -0700")
Message-ID: <87prm4mbgy.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-Rhyolite-Metrics: hades 104; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Oct 2008, Greg KH uttered the following:
> Perhaps some other kernel code is registering with that same major/minor
> number, making it already present in sysfs.  Where does that sysfs file
> link to before you load your driver?

Exactly so. This is probably *not* a regression after all: the only
change I made to my 2.6.27 config (weeks before actually rebooting, so I
forgot) was to build in the CMOS RTC driver, in a hopeless attempt to
make hrtimers work on this old hardware (I knew it was hopeless but
tried anyway). (Unsurprisingly it didn't work:
<http://www.ussg.iu.edu/hypermail/linux/kernel/0810.1/1033.html> worked,
thank *you* Jeff, I have glitch-free pulseaudio and microsecond sleeps
and several of my programs are happier!)

And, looky here, a smoking gun:

hades:~# ls -l /sys/dev/char/254:0 /dev/rtc*
lrwxrwxrwx 1 root root 0 2008-10-13 22:16 /sys/dev/char/254:0 -> ../../devices/platform/rtc_cmos/rtc/rtc0
hades:~# ls -l 
lrwxrwxrwx 1 root root      4 2008-10-13 21:57 /dev/rtc -> rtc0
crw-r--r-- 1 root root 254, 0 2008-10-13 21:57 /dev/rtc0

hades:~# pktsetup cdrw /dev/cdrw
hades:~# ls -l /dev/pktcdvd/
total 0
brw-r----- 1 root root  254,  0 2008-10-13 22:23 cdrw
crw-r--r-- 1 root root   10, 63 2008-10-13 21:57 control
brw-rw---- 1 root cdrom 254,  0 2008-10-13 22:23 pktcdvd0

Am I right in assuming that this sort of isn't going to work? :)

Major 254 is listed as LOCAL/EXPERIMENTAL USE in devices.txt. I don't
consider either pktcdvd or the rtc drivers as LOCAL/EXPERIMENTAL: the
former in particular has been in the kernel for years.

They could do with proper device numbers. No matter what this is going
to break some non-udev setups :(
