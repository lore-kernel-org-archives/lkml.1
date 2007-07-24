Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbXGXOa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbXGXOa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbXGXOaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:30:09 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39382 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbXGXOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:30:04 -0400
Date: Tue, 24 Jul 2007 16:31:47 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070724143147.GE4074@enneenne.com>
References: <20070717180550.GA24759@enneenne.com> <1185197716.14697.244.camel@pmac.infradead.org> <20070724080013.GA22171@gundam.enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185284942.14697.319.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS - definitive version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:49:02PM +0100, David Woodhouse wrote:
> 
> I think you still haven't quite got the 32-bit vs. 64-bit compatibility
> right. Remember that on i386, the alignment of a uint64_t is only 4
> bytes, while on most other architectures it's 8 bytes. On i386, there
> will be no padding between the two consecutive 'struct pps_ktime'
> members of struct pps_kinfo and struct pps_kparams. But on most
> platforms there will be padding to ensure correct alignment.
> 
> The simple fix is probably to make the 'nsec' member a 64-bit integer
> too. Then it'll be the same for i386 and x86_64 and you won't need a
> compatibility syscall routine.

By doing:

 struct pps_ktime {
        __u64 sec;
-       __u32 nsec;
+       __u64 nsec;
 };

I got:

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `sys_time_pps_fetch':
(.text+0x5f05e): undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1

I suppose the problem is here:

                ticks = to.sec * HZ;
                ticks += to.nsec / (NSEC_PER_SEC / HZ);

Suggestions? :)

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
