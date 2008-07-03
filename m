Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbYGCMqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbYGCMqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYGCMqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:46:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbYGCMqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:46:09 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: David Woodhouse <dwmw2@infradead.org>
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jonathan@jonmasters.org,
       Shaohua Li <shaohua.li@intel.com>, greg@kroah.com,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
Content-Type: multipart/mixed; boundary="=-A0xkdqZadf00WslWpfEu"
Date: Thu, 03 Jul 2008 10:23:48 +0100
Message-Id: <1215077028.10393.497.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A0xkdqZadf00WslWpfEu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 2008-07-03 at 07:44 +0100, Tigran Aivazian wrote:
> On Thu, 3 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Thu, 03 Jul 2008 07:17:16 BST, Tigran Aivazian said:
> >> Hi Valdis,
> >>
> >> On Wed, 2 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
> >>
> >>> I built the -rc8-mmotd kernel, and built it with 'CONFIG_FIRMWARE_IN_KERNEL
> > =n'.
> >>> Lo and behold, the microcode.ko was now doing a request_firmware for
> >>> 'intel-ucode/06-0f-06' (which makes sense, the Core2 Duo in this laptop is
> >>> family 6, model 15, stepping 6).  However, what I had in /lib/firmware was
> >>> the Intel-distributed 'microcode.dat' with updates for all the CPUs (which
> >>> used to work in times past).
> >>>
> >>> What's the magic incantation to take the microcode.dat and create something
> >>> that the firmware driver is willing to use, or is this all borked up and
> >>> I need to do a major rethink or fix my config?
> >>
> >> that's because it expects the Intel-supplied microcode data and you are
> >> using the old style microcode.dat data.
> >
> > I fed it the stuff I downloaded today from this URL:
> >
> > http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2643&OSFullName=Linux*〈=eng&strOSs=39&submit=Go!
> >
> > which gets me a microcode-20080401.dat that does the same thing.  Is there
> > some *other* Intel-supplied microcode data I should be getting instead?
> 
> Oh, sorry, I assumed that Intel distribute the data in the format that 
> driver expects.

I think the kernel _does_ manage to extract just the part it wants from
the data, but it expects the data in binary form. Drop the attached
files in /lib/udev/microcode.sh and /etc/udev/rules.d/51-microcode.rules
respectively. (There's probably a better way to handle this kind of
thing by putting hooks in firmware.sh rather than using a special rule
which overrides it?)

The recent firmware changes haven't modified this. The important change
seems to have been here (in 2006):

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a30a6a2c

-- 
dwmw2

--=-A0xkdqZadf00WslWpfEu
Content-Disposition: inline; filename=microcode.sh
Content-Type: application/x-shellscript; name=microcode.sh
Content-Transfer-Encoding: 7bit

#!/bin/sh -e

FIRMWARE_DIRS="/lib/firmware /usr/local/lib/firmware"

err() {
	echo "$@" >&2
	logger -t "${0##*/}[$$]" "$@" 2>/dev/null || true
}

if [ ! -e /sys$DEVPATH/loading ]; then
	err "udev firmware loader misses sysfs directory"
	exit 1
fi

for DIR in $FIRMWARE_DIRS; do
	[ -e "$DIR/microcode.dat" ] || continue
	echo 1 > /sys$DEVPATH/loading
	/sbin/microcode_ctl -f "$DIR/microcode.dat" -d /sys$DEVPATH/data
	echo 0 > /sys$DEVPATH/loading
	exit 0
done

echo -1 > /sys$DEVPATH/loading
err "Cannot find microcode file 'microcode.dat'"
exit 1

--=-A0xkdqZadf00WslWpfEu
Content-Disposition: inline; filename=51-microcode.rules
Content-Type: text/plain; name=51-microcode.rules; charset=UTF-8
Content-Transfer-Encoding: 7bit

# firmware requests for intel-ucode/* are satisfied by microcode_ctl
SUBSYSTEM=="firmware", ENV{FIRMWARE}=="intel-ucode/*", ACTION=="add", RUN="microcode.sh"

--=-A0xkdqZadf00WslWpfEu--

