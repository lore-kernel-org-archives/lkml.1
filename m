Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbYFZN7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbYFZN7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYFZN7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:59:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:28319 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYFZN7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cAfix3nZrtU9Ri9QycYeAVsI+Dz2gQoE2ec/xThwdLlqqjkNmZhKaDkyPHBjTgj581
         d12NbHbWIDC6jYg2i0BRQ0AXvHS1uWRLMB1xcs9EgF7isCEEzP+ZXYx4fA5l9kNvVqtl
         1iqVnvLk4/0dDz2fxdHiEpzQLJAONZImnzUzM=
Message-ID: <19f34abd0806260659u7e5d0968i18bef6ed423cb7a8@mail.gmail.com>
Date: Thu, 26 Jun 2008 15:59:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       "Gautham R Shenoy" <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <48638E38.5080605@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622125633.GA8166@damson.getinternet.no>
	 <200806231326.11328.rusty@rustcorp.com.au> <485FD644.80208@sgi.com>
	 <200806241136.52430.rusty@rustcorp.com.au>
	 <1214294783.25608.75.camel@ymzhang>
	 <1214441979.25608.86.camel@ymzhang>
	 <20080625191535.e6e60432.akpm@linux-foundation.org>
	 <19f34abd0806260200r40b46012q9bb4ba8783e8d935@mail.gmail.com>
	 <48638E38.5080605@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 2:40 PM, Jason Wessel
<jason.wessel@windriver.com> wrote:
>> 4. Page fault in I'm guessing configure_kgdbts() during boot. Never
>> seen this before either (screenshot #2).
>>
>
> How often does #4 occur?

Only this once yet.

>
> Perhaps you can email me directly the .config and kernel boot arguments
> you used?  It would be good to determine if the #4 is a victim or
> culprit of the crash.  If it is a culprit I would like to try and fix it.

I don't think this really has anything to do with the CPU hotplug
crashing. It seems to be completely spurious, as this was during boot
before userspace had even started. It's not even certain that it has
anything to do with kgdb at all. I mean, that stack trace is not very
reliable...

Command line was: kernel /vmlinuz-2.6.26-rc8-dirty ro
root=/dev/VolGroup00/LogVol00 rhgb debug 3

You can find vmlinux and config here:

http://www.kernel.org/pub/linux/kernel/people/vegard/kernels/20080626/

..but it probably takes a bit for the mirrors to pick up. In the
meantime, I can provide you with the relevant line numbers:

# configure_kgdbts
$ addr2line -e vmlinux.20080626 -i c030ab18 | sed 's/.*linux-2.6\///'
drivers/misc/kgdbts.c:911
drivers/misc/kgdbts.c:1015

# mtrr_del
$ addr2line -e vmlinux.20080626 -i c011007b | sed 's/.*linux-2.6\///'
arch/x86/kernel/cpu/mtrr/main.c:548

# loop_init
$ addr2line -e vmlinux.20080626 -i c078111a | sed 's/.*linux-2.6\///'
drivers/block/loop.c:1550

# init_kgdbts
$ addr2line -e vmlinux.20080626 -i c0781163 | sed 's/.*linux-2.6\///'
drivers/misc/kgdbts.c:1033

Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
