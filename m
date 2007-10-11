Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbXJKSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbXJKSm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 14:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXJKSmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 14:42:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56951 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXJKSmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 14:42:49 -0400
Message-ID: <470E6E79.6040908@pobox.com>
Date: Thu, 11 Oct 2007 14:42:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kevin <spaceman__spiff@cox.net>, Greg KH <greg@kroah.com>,
       Olof Johansson <olof@lixom.net>, Greg KH <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, BDFL <volkerdi@slackware.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: ARPM shutdown oops (Re: [stable] [patch 09/12] Fix SMP poweroff
 hangs)
References: <20071008180406.052382073@mini.kroah.org> <200710092359.47144.spaceman__spiff@cox.net> <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org> <200710102005.02184.spaceman__spiff@cox.net> <alpine.LFD.0.999.0710110818580.20690@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710110818580.20690@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 10 Oct 2007, Kevin wrote:
>> The last kernel I used was 6.2.22 the "dmesg" the file is attached:
>>
>> dmesg 2.6.22 line 158 >  apm: overridden by ACPI.
>>
>> dmesg, APM on, has no line > apm: overridden by ACPI.
> 
> Ok, this is the real reason. 
> 
> The APM code does:
> 
>         if (PM_IS_ACTIVE()) {
>                 printk(KERN_NOTICE "apm: overridden by ACPI.\n");
>                 apm_info.disabled = 1;
>                 return -ENODEV;
>         }
> 
> and in previous kernels that would notice that you have ACPI enabled, and 
> APM gets shut out, and you never see your buggy APM BIOS.
> 
> In 2.6.23, this apparently doesn't happen for some reason.
> 
> And I think I see the problem: it's a config change. You don't have 
> PM_LEGACY enabled. Your config file diff shows:
> 
> 	-CONFIG_PM_LEGACY=y
> 	+# CONFIG_PM_LEGACY is not set
> 
> I suspect we should make CONFIG_APM either depend on, or select, 
> PM_LEGACY. But as far as I can see, nothing has actually changed in this 
> area in the kernel, and this bug has been there before - just your config 
> change made it appear. 
> 
> Rafael? Stephen? Opinions? I'd think that making APM depend on 
> CONFIG_PM_LEGACY is the right thing to do these days..

Speaking as the author of

	[PATCH] move pm_register/etc. to CONFIG_PM_LEGACY, pm_legacy.h

I agree.  arch/i386/kernel/apm.c clearly requires 
include/linux/pm_legacy.h and the legacy PM API.

I would vote for a dependency rather than select, but don't have any 
strong feelings on the matter...

	Jeff


