Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbXETSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbXETSiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbXETSiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:38:17 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:28738 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757881AbXETSiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:38:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lIlG4dics+6fLfIycsiRdqXpoBauWAYTDs1PttcqrS56OeOJJfCL1FpvGOt1b2xaCwEwS+RROulwH+09OZOj8rryEd5pQnNN1nMdEM22xEyzOe7tA7nV4GXC71+I4u6scETAu8PHeWVAthctuMfhTRyTBd4Qrs6u53kTLPeRZjw=  ;
X-YMail-OSG: AwqYZIAVM1nkY4NOH5cw6NMsGTRs9Q9rIA8YuLDLsE80Vrp0sQOI9QGdbp6fXioRENov36TjMb70nimvlA6MxAst.wCtm_l1U2MH4y04dHVlSwU.tNM-
From: David Brownell <david-b@pacbell.net>
To: Mattia Dongili <malattia@linux.it>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR
Date: Sun, 20 May 2007 11:38:04 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>
References: <20070518071523.GA3195@inferi.kami.home> <20070519000413.75badb6f.akpm@linux-foundation.org> <20070520061408.GA3325@inferi.kami.home>
In-Reply-To: <20070520061408.GA3325@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201138.05146.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2007, Mattia Dongili wrote:
> On Sat, May 19, 2007 at 12:04:13AM -0700, Andrew Morton wrote:
> > On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > 
> > > On Fri, May 18, 2007 at 12:22:40AM -0700, Andrew Morton wrote:
> > > > On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > > > 
> > > > > Hello,
> > > > > 
> > > > > After finally catching fw-{ohci,core} to be problematic during resume,
> > > > > I'm now experiencing an immediate resume after suspending.
> > > > > 
> > > > > 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> > > > > kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> > > > > 2.6.21-rc6-mm* after the cpuidle fixes).
> > > > > 
> > > > > my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> > > > > and a str cycle with PM_DEBUG=y:
> > > > > http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt

Can you also provide /proc/acpi/wakeup and /proc/bus/usb/devices?
Plus "ethool eth0" and "ethtool -i eth0"?

And, for a bit more info, the output of the appended script.

(That's all *with* the patch listed below -- not reverted.)


> > > ...
> > > 
> 
> but very very close:
> acpi-driver-model-flags-and-platform_enable_wake.patch

Which only affects PCI devices at this time, FWIW ...

This is a symptom of a device or driver misbehaving.  You can
work around that; update the relevant /sys/devices/.../power/wakeup
value(s) to "disabled", pending a driver bugfix (or workaround).

In fact, you could turn them all off (see appended diagnostic
script) then turn them on one at a time to highlight problems

Reverting that patch just papers over the problem...


My suspicion, based on the dmesg and seeing what drivers actually
try to enable wakeup, would be the 'sky2' driver.  The other two
obvious candidates are EHCI (which behaves for me on non-Intel
hardware) and UHCI ... but USB has had a fair amount of testing
in terms of wakeup mechanisms, so that seems a bit less likely
to me (assuming no hardware bugs).

However, since after reverting the patch above you still saw
other problems (immediate re-suspend) I'm suspecting this isn't
a single simple problem you're finding.

- Dave


==========	CUT HERE
#!/bin/bash

# show the wakeup-capable devices and what's enabled/disabled

# class_label *:* ==> $type
class_label ()
{
	case $1 in
	# recognize common types of wakeup-capable devices
	i2c-dev:*)	type="smbus     "; return 0;;
	input:*)	type="input     "; return 0;;
	mmc_host:*)	type="mmc_host  "; return 0;;
	net:eth*)	type="lan       "; return 0;;
	net:*)		type="net       "; return 0;;
	pcmcia_socket:*)type="pcmcia    "; return 0;;
	rtc:*)		type="rtc       "; return 0;;
	sound:*)	type="modem     "; return 0;;
	tty:*)		type="tty       "; return 0;;
	usb_host:*)	type="usb_host  "; return 0;;
	esac
	return 1
}

# interface_label $PATH ==> $type
interface_label ()
{
	for F in $(cd $1 >/dev/null 2>&1 ; echo *:*)
	do
		class_label $F && return
	done
}

# devtype $PATH ==> $type
devtype ()
{
	local F T

	# fixed length, currently ten spaces
	type=""

	for F in $(cd $1 >/dev/null 2>&1 ; echo *:*)
	do
		if [ ! -d "$1/$F" ]
		then
			break;
		fi

		# is this a usb interface?
		if [ -f $1/$F/bInterfaceClass ]
		then
			interface_label $1/$F && return
		fi

		case $F in
		# use interface's label if possible, else generic
		usb_device:*)
			read T < $1/maxchild
			if [ 0 -lt $T ]
			then
				type="hub       "
				return
			fi
			type="(usb)     "
			continue;;
		*:*)	class_label $F && return ;;
		esac

	done

	if [ "$type" = "" ]
	then
		for T in $(cd $1 >/dev/null 2>&1 ; echo fw-host*/ieee1394_host:*)
		do
			if [ ! -L "$1/$T" ]
			then
				break;
			fi
			type="firewire  "
			return
		done
	fi

	if [ "$type" = "" ]
		then
		type="          "
	fi
}

cd /sys/devices
for F in $(find * -name 'wakeup')
do
	# F=.../power/wakeup
	read value < $F
	if [ "$value" = "" ]
	then
		continue
	fi

	# F=...
	F=$(dirname $(dirname $F))
	devtype $F

	# for each entry that actually supports wakeup, one line with:
	#  - device type (if recognized)
	#  - wake on/OFF
	#  - /sys/devices/... path
	case "$value" in
	"disabled")	echo "$type OFF $F" ;;
	"enabled")	echo "$type on  $F" ;;
	esac
done
