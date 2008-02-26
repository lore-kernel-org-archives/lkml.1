Return-Path: <linux-kernel-owner+w=401wt.eu-S1765589AbYBZV4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765589AbYBZV4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762312AbYBZV4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:56:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45532 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761540AbYBZV4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:56:15 -0500
Date: Tue, 26 Feb 2008 22:56:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080226215641.GE10280@elf.ucw.cz>
References: <20080225145347.a61f6c61.akpm@linux-foundation.org> <20080225225820.GP2659@elf.ucw.cz> <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz> <20080226101117.GA26671@atrey.karlin.mff.cuni.cz> <20080226174613.GA26259@codemonkey.org.uk> <20080226175954.GA5707@elf.ucw.cz> <20080226181001.GA7714@codemonkey.org.uk> <20080226181611.GB6030@elf.ucw.cz> <20080226182241.GB7714@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226182241.GB7714@codemonkey.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-26 13:22:41, Dave Jones wrote:
> On Tue, Feb 26, 2008 at 07:16:11PM +0100, Pavel Machek wrote:
>  > On Tue 2008-02-26 13:10:01, Dave Jones wrote:
>  > > On Tue, Feb 26, 2008 at 06:59:54PM +0100, Pavel Machek wrote:
>  > >  
>  > >  > > if by 'custom' you mean the solution everyone agreed to work
>  > >  > > toward at the power management summit several years ago
>  > >  > > (hal/pm-utils) then, yes.
>  > >  > 
>  > >  > I must have been on different summit... I believe it is bad to tie
>  > >  > s2ram to hal, because it makes testing on minimal system hard.
>  > >  > 
>  > >  > Anyway, what is the "default" way to trigger s2ram for Andrew? Perhaps
>  > >  > Fedora already has his machine whitelisted...
>  > > 
>  > > There is no s2ram. pm-suspend uses the white/black-lists in pm-utils.
>  > > Remember that? The cross-distro package everyone agreed was a good idea
>  > > so that every distro didn't have their own magic utility ?
>  > 
>  > Well, we have cross-distro package, it is at suspend.sf.net , and it
>  > can bring up video - which is kind of important. (It is single binary,
>  > so it can be pagelocked -- which is important for s2disk).
>  > 
>  > Plus it does not depend on HAL.
> 
> Neither does pm-utils.  Once again for the hard of thinking..
> 
> The mechanism belongs in pm-utils.  HAL is just a fancy wrapper around that.
> Don't want/like hal? fine, a smaller wrapper around pm-suspend and friends
> is trivial (or even unnecessary if you're happy with running pm-suspend by hand)

Seems like pm-utils is just a thin wrapper around s2ram, at least in
version debian ships. It does not seem to have its own whitelist.

Now, take a look at 

/usr/lib/pm-utils/functions

... 

        if [ -x /usr/sbin/s2ram ]; then
                if [ -n "$S2RAM_OPTS" ]; then
                        # Trust HAL or the user to pass the correct
options
                        /usr/sbin/s2ram $S2RAM_OPTS
                elif /usr/sbin/s2ram --test > /dev/null ; then
                        # Trust s2ram's internal whitelist
                        /usr/sbin/s2ram
                else
                        # Unknown machine
                        echo "This machine is unkown, please try to
find out how to suspend this machine. See s2ram(8)."
                fi
        else
                echo -n "mem" > /sys/power/state
        fi

...so it is ready to use s2ram, but will fall back to
echo. Unfortunately, that will mean no video resume on _many_
machines.

To give some numbers: according to s2ram whitelist, we can restore
video on 410 machines. On 74 of them, s2ram is not needed. So
approximately 80% of machines need s2ram (at least in configuration
without X running)....

Pretty please, can we get s2ram for Fedora, so that video is restored
there?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
