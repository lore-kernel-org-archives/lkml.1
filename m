Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYCHODJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYCHODJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 09:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYCHOC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 09:02:57 -0500
Received: from ausxipps301.us.dell.com ([143.166.148.223]:60659 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYCHOC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 09:02:56 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Mar 2008 09:02:56 EST
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-IronPort-AV:Date:From:To:Cc:Subject:Message-ID:
   References:Mime-Version:Content-Type:Content-Disposition:
   In-Reply-To:User-Agent:User-Agent;
  b=ANRsU0z0Mez0UHbhWBXVwJrPmIH6ZEPR+eSCmOh/cc4Nsv9VnGTH9aax
   Qw4H8C25TjylH6/NhwEOJ85A1JqL7liWEfwltNreJnLXx4xJCjrEVbgo8
   Fd3JiNC2Een6Frt;
X-IronPort-AV: E=Sophos;i="4.25,466,1199685600"; 
   d="scan'208";a="7379184"
Date: Sat, 8 Mar 2008 07:53:18 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Frank Sorenson <frank@tuxrocks.com>
Cc: Ingo Molnar <mingo@elte.hu>, kay.sievers@vrfy.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jcm@redhat.com
Subject: Re: 2.6.25-rc4 OOMs itself dead on bootup (modprobe bug?)
Message-ID: <20080308135318.GA8036@auslistsprd01.us.dell.com>
References: <47D02940.1030707@tuxrocks.com> <20080306184954.GA15492@elte.hu> <47D1971A.7070500@tuxrocks.com> <47D23B7E.3020505@tuxrocks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D23B7E.3020505@tuxrocks.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 01:08:46AM -0600, Frank Sorenson wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Frank Sorenson wrote:
> > I did some additional debugging, and I believe you're correct about it
> > being specific to my system.  The system seems to run fine until some
> > time during the boot.  I booted with "init=/bin/sh" (that's how the
> > system stayed up for 9 minutes), then it died when I tried starting
> > things up.  I've further narrowed the OOM down to udev (though it's not
> > entirely udev's fault, since 2.6.24 runs fine).
> > 
> > I ran your debug info tool before killing the box by running
> > /sbin/start_udev.  The output of the tool is at
> > http://tuxrocks.com/tmp/cfs-debug-info-2008.03.06-14.11.24
> > 
> > Something is apparently happening between 2.6.24 and 2.6.25-rc[34] which
> > causes udev (or something it calls) to behave very badly.
> 
> Found it.  The culprit is 8f47f0b688bba7642dac4e979896e4692177670b
>     dcdbas: add DMI-based module autloading
> 
>     DMI autoload dcdbas on all Dell systems.
> 
>     This looks for BIOS Vendor or System Vendor == Dell, so this should
>     work for systems both Dell-branded and those Dell builds but brands
>     for others.  It causes udev to load the dcdbas module at startup,
>     which is used by tools called by HAL for wireless control and
>     backlight control, among other uses.
> 
> What actually happens is that when udev loads the dcdbas module at
> startup, modprobe apparently calls "modprobe dcdbas" itself, repeating
> until the system runs out of resources (in this case, it OOMs).
> 
> # ps axf
> ...
>   506 ?        S      0:00 /bin/bash /sbin/start_udev
>   590 ?        S      0:00  \_ /sbin/udevsettle
>   533 ?        S<s    0:00 /sbin/udevd -d
>   629 ?        S<     0:00  \_ /sbin/udevd -d
>   630 ?        S<     0:00  |   \_ /sbin/modprobe
> dmi:bvnDellInc.:bvrA08:bd04/02/2007:svnDellInc.:pnMP061:pvr:rvnDellInc.:rn0YD479:rvr:cvnDellInc.:ct8:cvr:
>   949 ?        S<     0:00  |       \_ /sbin/modprobe dcdbas
>   950 ?        S<     0:00  |           \_ /sbin/modprobe dcdbas
>   951 ?        S<     0:00  |               \_ /sbin/modprobe dcdbas
>   953 ?        S<     0:00  |                   \_ /sbin/modprobe dcdbas
>   955 ?        S<     0:00  |                       \_ /sbin/modprobe dcdbas
>   958 ?        S<     0:00  |                           \_
> /sbin/modprobe dcdbas
> ...repeat...
> 
> When the system crashed, there were at least 11,600 instances of
> "/sbin/modprobe dcdbas", each calling the next.
> 
> Reverting 8f47f0b lets the system boot up just fine again.  Note that a
> manual "modprobe dcdbas" also causes this recursive behavior, it's just
> not forced on the system by udev.
> 
> So dcdbas is a regression from 2.6.24, as well as being broken in other
> ways.
> 
> Frank
> - --
> Frank Sorenson - KD7TZK
> Linux Systems Engineer, DSS Engineering, UBS AG
> frank@tuxrocks.com


Frank, what version of module-init-tools do you have?  This has been
in use in Fedora 8 for a few months, and this is the first failure
report I've seen.

I'm fine with reverting the patch for now, but really do want to get
to root cause, because module autoloading is a really good idea, and
it would be a shame if we couldn't keep that feature enabled because
some systems have incompatible module-init-tools, and the kernel can't
know that...  (Perhaps udev could know and not invoke modprobe in
those instances?)

-Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
