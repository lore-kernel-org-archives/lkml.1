Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYABQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYABQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYABQCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:02:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbYABQCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:02:43 -0500
Date: Wed, 2 Jan 2008 17:01:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Greg KH <gregkh@suse.de>, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
	(rev. 2)
Message-ID: <20080102160137.GA21046@elte.hu>
References: <200801020032.45529.rjw@sisk.pl> <20080102105217.GA14731@elte.hu> <200801021356.59865.rjw@sisk.pl> <20080102131529.GA32160@elte.hu> <3ae72650801020655h6ec31ce8n5cd9014c00c9f6ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650801020655h6ec31ce8n5cd9014c00c9f6ad@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> > shouldnt we provide a Kconfig way of replacing dev 10:135 with the 
> > new driver's 254:0 device? (while keeping all the current modes of 
> > operation as well, of course.) It's all supposed to be 100% ioctl 
> > ABI compatible with the old driver, right?
> 
> It's not compatible enough to "fake" only the old major/minor. Userspace
> must be fixed not to depend on stuff like:  /proc/sys/dev/rtc/max-user-freq:
>   http://lkml.org/lkml/2007/8/4/183

i think that should be fixed by providing a compatible 
/proc/sys/dev/rtc/max-user-freq implementation in the new driver too.

> > That way distros could start migrating to it
> > as well, without depending on any udev hackery.
> 
> It's in the default udev setup:
>   KERNEL=="rtc|rtc0",             MODE="0644"
>   KERNEL=="rtc0",                 SYMLINK+="rtc"

but if it breaks max-user-freq (which is needed by qemu for example) 
then distros would likely disable it, right?

or this rule might be broken in some way. For example my Fedora 8 box 
has this in /etc/udev/rules.d/50-udev-default.rules:

 # miscellaneous
 KERNEL=="fuse",                 MODE="0666"
 KERNEL=="rtc|rtc0",             MODE="0644"
 KERNEL=="rtc0",                 SYMLINK+="rtc"

still i've got:

 crw------- 1 root root  10, 135 Dec 28 08:13 /dev/rtc
 crw-r--r-- 1 root root 254,   0 Dec 28 08:13 /dev/rtc0

_and_ my distro kernel doesnt even have CONFIG_RTC enabled - i run the 
Fedora 9 devel/rawhide kernel on this box:

 # CONFIG_RTC is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_HPET_RTC_IRQ is not set
 CONFIG_RTC_LIB=y
 CONFIG_RTC_CLASS=y
 # CONFIG_RTC_HCTOSYS is not set
 # CONFIG_RTC_DEBUG is not set
 # RTC interfaces
 CONFIG_RTC_INTF_SYSFS=y
 CONFIG_RTC_INTF_PROC=y
 CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
 # CONFIG_RTC_DRV_TEST is not set

udev-116-3.fc8. Maybe i just misunderstood what the grand plan was here 
- i assumed it was to smoothly convert from old driver to new driver, 
without forcing any changes on user-space.

	Ingo
