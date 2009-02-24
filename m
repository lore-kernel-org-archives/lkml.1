Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZBXKOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZBXKOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 05:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZBXKOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 05:14:06 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:49320 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZBXKOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 05:14:02 -0500
Date: Tue, 24 Feb 2009 11:13:02 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Message-ID: <20090224101302.GC7894@enneenne.com>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Stultz <johnstul@us.ibm.com>
References: <1234274752-29847-1-git-send-email-giometti@linux.it> <1234274752-29847-2-git-send-email-giometti@linux.it> <20090222203933.GA18914@elte.hu> <49A1BC28.9020402@zytor.com> <20090223065801.GA16621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223065801.GA16621@elte.hu>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 07:58:01AM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Ingo Molnar wrote:
> > >>
> > >> Common use is the combination of the NTPD as userland program 
> > >> with a GPS receiver as PPS source to obtain a wallclock-time 
> > >> with sub-millisecond synchronisation to UTC.
> > > 
> > > Hm. I was looking at this stuff with the prospect of adding it 
> > > to the timer tree, but i'm really struggling with a few 
> > > fundamental questions.
> > > 
> > > The most basic one is: why do we need this?
> > > 
> > > The main purpose of your current patchset seems to be to deliver 
> > > interrupt timestamps to user-space, where it will in essence be 
> > > used to feed new adjtimex adjustments via ntpd.
> > > 
> > > I.e. the whole thing comes around in a circle in the end, but 
> > > via user-space, where jitter will only increase.
> > > 
> > > Why not cut out the jittery middle man and add some intelligent 
> > > API to register PPS interrupt sources straight with the NTP 
> > > code, and let those IRQ timestamps be fed _directly_ into our 
> > > time adjustment code?
> > > 
> > 
> > Well, let's be fair here... the kernel-user space time model 
> > involving ntpd has been very carefully developed over a period 
> > of over a decade. It's known to work.  The userspace 
> > involvement isn't just about feeding the data to the local 
> > clock, but also -- or perhaps primarily so -- to keep the 
> > timing inside ntpd calibrated, as that is the time that will 
> > be provided to the outside world.
> 
> Sure thing, the policy bits should still be done by user-space - 
> something does have to know that there's a PPS device on the 
> serial, parallel or any other port, and has to configure set up 
> the actual parameters as well, etc.
> 
> What i'm pointing out is that there's no technical benefit from 
> passing the _timestamps_ through user-space and from not 
> coupling the NTP code with the PPS edges.
> 
> Nor has it really been designed into NTP that way. We already 
> have all the traditional PPS parameters in the NTP syscall 
> interface:
> 
> include/linux/timex.h:
> 
> struct timex {
> [...]
>         long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
>         long jitter;            /* pps jitter (us) (ro) */
>         int shift;              /* interval duration (s) (shift) (ro) */
>         long stabil;            /* pps stability (scaled ppm) (ro) */
>         long jitcnt;            /* jitter limit exceeded (ro) */
>         long calcnt;            /* calibration intervals (ro) */
>         long errcnt;            /* calibration errors (ro) */
>         long stbcnt;            /* stability limit exceeded (ro) */
> 
> (these are the bits to query the state of kernel-side PPS 
> support.)
> 
> and we have the bits to enable a PPS line disciple, etc., etc. 
> We might need some extensions, but since the PPS device will be 
> handled by the kernel anyway and the NTP adjustments are done in 
> the kernel too, there's no strong reason to route the actual 
> timestamps via user-space. In fact, doing so obviously increases 
> jitter and slows down NTP convergence.

Precise time settings can be done in both kernel and user
spaces. RFC2783 specifies an API that can be used to fetch PPS
timestamps from a PPS source, then these timestamps can be processed
by an userland consumer (NTPD in most cases) to set up system time.

Again the RFC2783 specifies a way to manage some kernel consumers
which can do the same jobs in kernel land, but all these stuff are
declared as "optional".

I agree with you that passing timestamps to userland may increase
jitter and slow down NTP convergence but LinuxPPS is a way to have at
least one "precise" time setting tool! :) However, as far as I know,
the NTPD algorith should take in account such jitters (I'm sorry but I
cannot be more precise since I'm not a NTPD guru), in fact if these
timestamps are taken "as soon as" possible inside the IRQ handling
chain the NTP convergence speed up several times.

In any case, if we wish adding a more performance tool in kernel space
we can just do it as RFC2783 says and (maybe) managing it with the
struct above.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
