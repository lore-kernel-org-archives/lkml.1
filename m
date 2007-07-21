Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbXGUGj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbXGUGj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXGUGjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:39:20 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:47759 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbXGUGjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cMRQ9XEqTkb8iWre3PpFbpv+Z3t6tDBQzSAtL7GS/Ds2ve6rIVa3Y9WV42z+K4aXXDS9Beg4pMQc0+0kuSlkTq1KBUTnJuw7r8Lq5BB+UK67/nTAuWKuiXjjGVgPpRKzeGOLMWAosuiM3UtCzdwF6daYGrbV2syNBSMQCqa1Xkg=
Message-ID: <a781481a0707202339s59b8a10bheb1e97773dcd027@mail.gmail.com>
Date: Sat, 21 Jul 2007 12:09:18 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: [BUG] Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       rdunlap@xenotime.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0707202300t781345afu1ca1154a1d14e5d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
	 <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com>
	 <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>
	 <20070721010257.GA9561@suse.de>
	 <20070720183733.c53b511b.akpm@linux-foundation.org>
	 <20070721014419.GA10761@suse.de>
	 <a781481a0707202021r977ae5fg9655dd2881836f13@mail.gmail.com>
	 <a781481a0707202057q23a0ea6by97ee9b40e9fc5a0b@mail.gmail.com>
	 <a781481a0707202300t781345afu1ca1154a1d14e5d8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> [...]
> %eax == ffffffea == -22 == -EINVAL.
>
> But:
>
> When I replace the BUG_ON() with Greg's (or my modified) patch,
> the kernel ignores that error as we wanted, but _still_ crashes before
> finding the root block device (because ATA is not in kernel and my
> system seems to require it). Unfortunately, lots of dmesg output
> has scrolled up by then, and our "printk" is lost. Because of no
> CONFIG_ATA, nothing gets written to disk either.


The following hack worked:

if (ret) {
        printk("~~~~~ .%s.%d.%s. ~~~~~\n", name, ret, kparam->name);
        for (;;)
                cpu_relax();
}

So I just hung my testbox at the point the info I wanted was printed out :-)

I hand-copied the following from the screen:


*****

The kobject at, or inside cpu_devices+0x10/0xe0 is not dynamically
allocated.
The kobject at, or inside cpu_devices+0x10/0xe0 is not dynamically
allocated. (printed twice)
WARNING: at lib/kobject.c:220 kobject_shadow_add()
...
show_trace
dump_stack
...
kobject_shadow_add+0x65/0x1b6
kobject_add
kernel_param_sysfs_setup
param_sysfs_init
...
...

~~~~~ ..-22.mtrr.show. ~~~~~

*****


Something wrong with "cpu_devices" and "mtrr.show" in 22-mm1 me thinks.
Wonder if latest -git is already fixed? Spent 4 hours on this, at least :-p


BTW "kobject at, or inside cpu_devices+0x10/0xe0 is not dynamically
allocated" sounds like something that could, and should, have been
caught at build time ...


Satyam
