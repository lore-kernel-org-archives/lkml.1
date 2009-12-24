Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZLXBuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZLXBuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 20:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZLXBuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 20:50:01 -0500
Received: from ns2.allidaho.com ([66.232.90.194]:52673 "EHLO mail.allidaho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZLXBuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 20:50:00 -0500
X-Greylist: delayed 2824 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Dec 2009 20:49:59 EST
From: "Dialup Jon Norstog" <thursday@allidaho.com>
To: john stultz <johnstul@us.ibm.com>, Paul Mundt <lethal@linux-sh.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       "David S. Miller" <davem@davemloft.net>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC][PATCH 0/14] Convert remaining arches to read/update_persistent_clock
Date: Wed, 23 Dec 2009 17:27:10 -0700
Message-Id: <20091224002442.M6627@allidaho.com>
In-Reply-To: <1261605899.4163.107.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain> <20091223050810.GA25791@linux-sh.org> <1261605899.4163.107.camel@localhost.localdomain>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 68.228.37.62 (thursday)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john,

IMO the biggest clock problem on Alpha is that dual booting Tru64 and Linux 
whacks the clock every time you go from one OS to the other.  Allowing Linux 
to decouple from SRM's TOY clock would be a signal advance.

jon norstog


---------- Original Message -----------
From: john stultz <johnstul@us.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Richard Henderson 
<rth@twiddle.net>, linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org, 
Russell King <linux@arm.linux.org.uk>, Haavard Skinnemoen 
<hskinnemoen@atmel.com>, Mike Frysinger <vapier@gentoo.org>, Mikael Starvik 
<starvik@axis.com>, David Howells <dhowells@redhat.com>, Yoshinori Sato 
<ysato@users.sourceforge.jp>, Tony Luck <tony.luck@intel.com>, Hirokazu 
Takata <takata@linux-m32r.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
Koichi Yasutake <yasutake.koichi@jp.panasonic.com>, Kyle McMartin 
<kyle@mcmartin.ca>, "David S. Miller" <davem@davemloft.net>, David Brownell 
<dbrownell@users.sourceforge.net>
Sent: Wed, 23 Dec 2009 14:04:59 -0800
Subject: Re: [RFC][PATCH 0/14] Convert remaining arches to 
read/update_persistent_clock

> On Wed, 2009-12-23 at 14:08 +0900, Paul Mundt wrote:
> > On Tue, Dec 22, 2009 at 07:59:22PM -0800, john stultz wrote:
> > > In this case the generic read_persistent_clock() and
> > > update_persistent_clock() methods have been provided to allow the
> > > generic timekeeping code to initialize xtime and set the persistent
> > > clock when NTP is synced. However many arches haven't converted, so the
> > > generic code has to handle the case where the arch is doing this
> > > management itself.
> > > 
> > > This patch series tries to convert the following 14 architectures over
> > > to use read_persistent_clock() and update_persistent_clock() as
> > > applicable, killing off about 200 lines of arch specific code.
> > > 
> > While I think that this is a good goal, many of the underlying
> > architectures have veered pretty far away from having meaningful
> > persistent clock interfaces after having moved entirely to generic
> > timekeeping and the RTC subsystem.
> > 
> > In the case of SH at least that interface along with the generic CMOS
> > stuff is largely a stop-gap for antiquated platforms that don't have
> > proper RTC drivers and likely never will, while the default for all of
> > the rest of the platforms effectively returns a fixed dummy value. I
> > copied this approach from MIPS originally, so there are at least a few
> > architectures that this will apply to.
> > 
> > In any event, I wonder if it might make more sense to take something like
> > the SPARC implementation that is simply a wrapper around the RTC, move
> > that out in to a more generic place, and permit architectures to select
> > an RTC class backed persistent clock instead (it seems to be only
> > platforms that haven't caught up yet in terms of generic time and RTC
> > migration that would want to define this interface on their own at all at
> > this point)?
> 
> Yea, there's some additional complications with the RTC interface via
> read_persistent_clock, as some RTC clocks require irqs enabled to be
> able to read. This keeps them from being used via
> read_persistent_clock() as it is used prior to irqs being enabled, 
> and then again with irqs disabled in the suspend and resume path.
> 
> This has a bit of a trade-off, as we can better handle timekeeping
> around a suspend/resume with read_persistent_clock(), but for some
> hardware we just can't use the RTC for that.
> 
> Anyway, if we can improve the timekeeping/RTC interface used for
> initialization and suspend/resume, I'm all for it (maybe having the RTC
> code to tell the timekeeping code if it can be accessed with irqs 
> off?). But for hardware that needs irqs, i'm not sure how we can 
> handle resumes correctly there. So suggestions would be welcome.
> 
> Anyway, the main point of this patch set is to remove the direct access
> to timekeeping internals (xtime, wall_to_monotonic). Those need to go
> soon, as they're limiting changes in the timekeeping code.
> read_persistent_clock() is the current way to avoid it, but if 
> systems are fine doing a settimeofday() at init that's ok too 
> (although some oddities may be seen wrt boot time with the direct 
> settimeofday, I need to refresh my head on how the varying default 
> boot times between arches may be effected).
> 
> thanks
> -john
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> alpha" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
------- End of Original Message -------

