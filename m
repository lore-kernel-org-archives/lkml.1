Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYJMVvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYJMVvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYJMVvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:51:10 -0400
Received: from kroah.org ([198.145.64.141]:57043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752953AbYJMVvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:51:09 -0400
Date: Mon, 13 Oct 2008 14:47:47 -0700
From: Greg KH <greg@kroah.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       a.zummo@towertech.it
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
Message-ID: <20081013214747.GA15765@kroah.com>
References: <87vdvyngni.fsf@hades.wkstn.nix> <20081012181700.GA21072@kroah.com> <87prm4mbgy.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prm4mbgy.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 10:28:13PM +0100, Nix wrote:
> On 12 Oct 2008, Greg KH uttered the following:
> > Perhaps some other kernel code is registering with that same major/minor
> > number, making it already present in sysfs.  Where does that sysfs file
> > link to before you load your driver?
> 
> Exactly so. This is probably *not* a regression after all: the only
> change I made to my 2.6.27 config (weeks before actually rebooting, so I
> forgot) was to build in the CMOS RTC driver, in a hopeless attempt to
> make hrtimers work on this old hardware (I knew it was hopeless but
> tried anyway). (Unsurprisingly it didn't work:
> <http://www.ussg.iu.edu/hypermail/linux/kernel/0810.1/1033.html> worked,
> thank *you* Jeff, I have glitch-free pulseaudio and microsecond sleeps
> and several of my programs are happier!)
> 
> And, looky here, a smoking gun:
> 
> hades:~# ls -l /sys/dev/char/254:0 /dev/rtc*
> lrwxrwxrwx 1 root root 0 2008-10-13 22:16 /sys/dev/char/254:0 -> ../../devices/platform/rtc_cmos/rtc/rtc0
> hades:~# ls -l 
> lrwxrwxrwx 1 root root      4 2008-10-13 21:57 /dev/rtc -> rtc0
> crw-r--r-- 1 root root 254, 0 2008-10-13 21:57 /dev/rtc0
> 
> hades:~# pktsetup cdrw /dev/cdrw
> hades:~# ls -l /dev/pktcdvd/
> total 0
> brw-r----- 1 root root  254,  0 2008-10-13 22:23 cdrw
> crw-r--r-- 1 root root   10, 63 2008-10-13 21:57 control
> brw-rw---- 1 root cdrom 254,  0 2008-10-13 22:23 pktcdvd0
> 
> Am I right in assuming that this sort of isn't going to work? :)

Yes, you are right :)

> Major 254 is listed as LOCAL/EXPERIMENTAL USE in devices.txt. I don't
> consider either pktcdvd or the rtc drivers as LOCAL/EXPERIMENTAL: the
> former in particular has been in the kernel for years.

Both of those should get "real" majors assigned to them.  It's not ok to
randomly go grabbing major:minor numbers like this for code that is in
mainline.

> They could do with proper device numbers. No matter what this is going
> to break some non-udev setups :(

It's going to break all setups, no matter if udev is involved here or
not...

thanks,

greg k-h
