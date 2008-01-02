Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYABRyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYABRyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYABRyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:54:06 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46100 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752184AbYABRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:54:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=dUnxCK8M6ERV5NxS1N9WUbiQ4FP3/8nbc5Bl5jCbMTZctGlk64Lcy0cuU8VQm1QDTCJBHUwtzw9M+NUjkvzggQupbesB+SokYW5beOE/irFpjilrehe79F4tWJc4lfzNpS07L+me6oN9JdCgdxh0drQyKFV3idSwB3ZplE5MlLE=  ;
X-YMail-OSG: hxE5xlcVM1nezXGJqmr0kT675EvJj7Kez_RjbEwK3_ycKbLsxOn8gHnD0qQSpo1FiX975iSWY.ZEz1pFaiEEWny13NbRiDIRx_iJp2Z2.Hatmbw1UA--
Date: Wed, 02 Jan 2008 09:54:00 -0800
From: David Brownell <david-b@pacbell.net>
To: mingo@elte.hu, kay.sievers@vrfy.org
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended 
 (rev. 2)
Cc: a.zummo@towertech.it, stern@rowland.harvard.edu, rjw@sisk.pl,
       pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, gregkh@suse.de, akpm@linux-foundation.org
References: <200801020032.45529.rjw@sisk.pl>
 <20080102105217.GA14731@elte.hu> <200801021356.59865.rjw@sisk.pl>
 <20080102131529.GA32160@elte.hu>
 <3ae72650801020655h6ec31ce8n5cd9014c00c9f6ad@mail.gmail.com>
 <20080102160137.GA21046@elte.hu>
In-Reply-To: <20080102160137.GA21046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080102175400.3C2E0EF588@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > shouldnt we provide a Kconfig way of replacing dev 10:135 with the 
> > > new driver's 254:0 device? (while keeping all the current modes of 
> > > operation as well, of course.) It's all supposed to be 100% ioctl 
> > > ABI compatible with the old driver, right?
> > 
> > It's not compatible enough to "fake" only the old major/minor. Userspace
> > must be fixed not to depend on stuff like:  /proc/sys/dev/rtc/max-user-freq:
> >   http://lkml.org/lkml/2007/8/4/183
>
> i think that should be fixed by providing a compatible 
> /proc/sys/dev/rtc/max-user-freq implementation in the new driver too.

I see /sys/class/rtc/rtc0/max_user_freq, fwiw ...


> > > That way distros could start migrating to it
> > > as well, without depending on any udev hackery.
> > 
> > It's in the default udev setup:
> >   KERNEL=="rtc|rtc0",             MODE="0644"
> >   KERNEL=="rtc0",                 SYMLINK+="rtc"
>
> but if it breaks max-user-freq (which is needed by qemu for example) 
> then distros would likely disable it, right?
>
> or this rule might be broken in some way. For example my Fedora 8 box 
> has this in /etc/udev/rules.d/50-udev-default.rules:
>
>  # miscellaneous
>  KERNEL=="fuse",                 MODE="0666"
>  KERNEL=="rtc|rtc0",             MODE="0644"
>  KERNEL=="rtc0",                 SYMLINK+="rtc"
>
> still i've got:
>
>  crw------- 1 root root  10, 135 Dec 28 08:13 /dev/rtc
>  crw-r--r-- 1 root root 254,   0 Dec 28 08:13 /dev/rtc0

I suspect the /dev/rtc node was provided by the distro, so those
udev rules won't trigger.


> _and_ my distro kernel doesnt even have CONFIG_RTC enabled - i run the 
> Fedora 9 devel/rawhide kernel on this box:
>
>  # CONFIG_RTC is not set
>  # CONFIG_GEN_RTC is not set
>  # CONFIG_HPET_RTC_IRQ is not set
>  CONFIG_RTC_LIB=y
>  CONFIG_RTC_CLASS=y
>  # CONFIG_RTC_HCTOSYS is not set
>  # CONFIG_RTC_DEBUG is not set
>  # RTC interfaces
>  CONFIG_RTC_INTF_SYSFS=y
>  CONFIG_RTC_INTF_PROC=y
>  CONFIG_RTC_INTF_DEV=y
>  # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
>  # CONFIG_RTC_DRV_TEST is not set
>
> udev-116-3.fc8.

I run my x86 systems like that (also with RTC_DRV_CMOS), but
the ARM systems usually have RTC_HCTOSYS set too (plus some
RTC driver other than rtc-cmos).  The x86 system init code
pokes directly at the legacy RTC hardware in several cases.


>	Maybe i just misunderstood what the grand plan was here 
> - i assumed it was to smoothly convert from old driver to new driver, 
> without forcing any changes on user-space.

If there was a Grand Plan, I never heard of it. :)

It'd need to have some NTP sync solution for RTC_LIB devices, but
ISTR the gentime stuff still assumes an update_persistent_clock()
that doesn't sleep ... and hence can't be used with I2C based RTCs.


I've been trying to make sure the x86 world could realistically
switch to the RTC framework used by other Linux platforms, hence
e.g. the util-unix-ng updates, but never assumed there would be
no userspace changes.  After all, userspace was using a mishmash
of tools that were far from platform-agnostic, and moving away
from x86-dependency implies such things will change.

However I *do* think that symlinking rtc to /dev/rtc0 should
make it practical to use most older binaries.

- Dave

