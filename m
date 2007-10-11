Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXJKPjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXJKPjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXJKPjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:39:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbXJKPjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:39:33 -0400
Date: Thu, 11 Oct 2007 08:31:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kevin <spaceman__spiff@cox.net>
cc: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
       Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Theodore Ts'o" <tytso@mit.edu>,
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
In-Reply-To: <200710102005.02184.spaceman__spiff@cox.net>
Message-ID: <alpine.LFD.0.999.0710110818580.20690@woody.linux-foundation.org>
References: <20071008180406.052382073@mini.kroah.org>
 <200710092359.47144.spaceman__spiff@cox.net>
 <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org>
 <200710102005.02184.spaceman__spiff@cox.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Oct 2007, Kevin wrote:
> 
> The last kernel I used was 6.2.22 the "dmesg" the file is attached:
> 
> dmesg 2.6.22 line 158 >  apm: overridden by ACPI.
> 
> dmesg, APM on, has no line > apm: overridden by ACPI.

Ok, this is the real reason. 

The APM code does:

        if (PM_IS_ACTIVE()) {
                printk(KERN_NOTICE "apm: overridden by ACPI.\n");
                apm_info.disabled = 1;
                return -ENODEV;
        }

and in previous kernels that would notice that you have ACPI enabled, and 
APM gets shut out, and you never see your buggy APM BIOS.

In 2.6.23, this apparently doesn't happen for some reason.

And I think I see the problem: it's a config change. You don't have 
PM_LEGACY enabled. Your config file diff shows:

	-CONFIG_PM_LEGACY=y
	+# CONFIG_PM_LEGACY is not set

I suspect we should make CONFIG_APM either depend on, or select, 
PM_LEGACY. But as far as I can see, nothing has actually changed in this 
area in the kernel, and this bug has been there before - just your config 
change made it appear. 

Rafael? Stephen? Opinions? I'd think that making APM depend on 
CONFIG_PM_LEGACY is the right thing to do these days..

		Linus
