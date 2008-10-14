Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYJNGg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYJNGg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYJNGgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:36:51 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:43693 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753712AbYJNGgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:36:50 -0400
X-Greylist: delayed 4172 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 02:36:50 EDT
To: Greg KH <greg@kroah.com>
Cc: Nix <nix@esperi.org.uk>, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
References: <87vdvyngni.fsf@hades.wkstn.nix>
	<20081012181700.GA21072@kroah.com> <87prm4mbgy.fsf@hades.wkstn.nix>
	<20081013214747.GA15765@kroah.com>
From: Peter Osterlund <petero2@telia.com>
Date: Tue, 14 Oct 2008 07:27:07 +0200
In-Reply-To: <20081013214747.GA15765@kroah.com> (Greg KH's message of "Mon\, 13 Oct 2008 14\:47\:47 -0700")
Message-ID: <m34p3f926s.fsf@telia.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Mon, Oct 13, 2008 at 10:28:13PM +0100, Nix wrote:
>> On 12 Oct 2008, Greg KH uttered the following:
>> > Perhaps some other kernel code is registering with that same major/minor
>> > number, making it already present in sysfs.  Where does that sysfs file
>> > link to before you load your driver?
>> 
>> Exactly so. This is probably *not* a regression after all: the only
>> change I made to my 2.6.27 config (weeks before actually rebooting, so I
>> forgot) was to build in the CMOS RTC driver, in a hopeless attempt to
>> make hrtimers work on this old hardware (I knew it was hopeless but
>> tried anyway). (Unsurprisingly it didn't work:
>> <http://www.ussg.iu.edu/hypermail/linux/kernel/0810.1/1033.html> worked,
>> thank *you* Jeff, I have glitch-free pulseaudio and microsecond sleeps
>> and several of my programs are happier!)
>> 
>> And, looky here, a smoking gun:
>> 
>> hades:~# ls -l /sys/dev/char/254:0 /dev/rtc*
>> lrwxrwxrwx 1 root root 0 2008-10-13 22:16 /sys/dev/char/254:0 -> ../../devices/platform/rtc_cmos/rtc/rtc0
>> hades:~# ls -l 
>> lrwxrwxrwx 1 root root      4 2008-10-13 21:57 /dev/rtc -> rtc0
>> crw-r--r-- 1 root root 254, 0 2008-10-13 21:57 /dev/rtc0
>> 
>> hades:~# pktsetup cdrw /dev/cdrw
>> hades:~# ls -l /dev/pktcdvd/
>> total 0
>> brw-r----- 1 root root  254,  0 2008-10-13 22:23 cdrw
>> crw-r--r-- 1 root root   10, 63 2008-10-13 21:57 control
>> brw-rw---- 1 root cdrom 254,  0 2008-10-13 22:23 pktcdvd0
>> 
>> Am I right in assuming that this sort of isn't going to work? :)
>
> Yes, you are right :)

I don't think so. One is a character device and the other is a block
device. Block devices didn't use to collide with character devices.
Has that changed recently?

>> Major 254 is listed as LOCAL/EXPERIMENTAL USE in devices.txt. I don't
>> consider either pktcdvd or the rtc drivers as LOCAL/EXPERIMENTAL: the
>> former in particular has been in the kernel for years.
>
> Both of those should get "real" majors assigned to them.  It's not ok to
> randomly go grabbing major:minor numbers like this for code that is in
> mainline.

It's not about random grabbing. It's about getting a dynamically
assigned number. The pktcdvd driver once had static numbers, but at
the time when the driver was merged into the mainline kernel, dynamic
numbers were considered better. Therefore I changed the driver to use
dynamic numbers.

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
