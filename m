Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZLMNY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZLMNY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZLMNY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:24:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45107 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750852AbZLMNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:24:26 -0500
Date: Sun, 13 Dec 2009 14:24:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org, Brian Swetland <swetland@google.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091213132413.GB1437@ucw.cz>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se> <20091204104930.GA28625@sirena.org.uk> <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se> <20091207114825.GA26965@rakim.wolfsonmicro.main> <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se> <20091207165628.GA24981@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207165628.GA24981@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If you browse down to line 275 you can see it parse the sysfs
> > attribute "capacity", then this propagates up to the battery
> > status indicator on *all* Android phones out there. So if
> > you want to run Android unmodified, this is what you need to
> > provide. They are effectively using the power sysfs as
> > their hardware abstraction layer in this case.
> 
> Oh dear.  Using the power sysfs as the hardware abstraction seems
> perfectly reasonable but assuming that a given battery driver is going
> to have this level of information doesn't match up with an awful lot of
> actual charger hardware.  My main concern here is that battery
> performance monitoring has no pressing need to be in kernel and that
> pushing it into the kernel creates a barrier to implementing more
> advanced schemes in userspace, which is especially serious given how
> involved this needs to be in order to be accurate.  

Well, kernel provides /proc/apm emulation and many systems still rely
on it. So it would be nice to provide something halfway-decent there.

Plus you need to shutdown/suspend machine on battery critical. That
has to be in kernel and already needs those tricky parts.

(Sharp got it wrong in collie kernel, and you get 5hours instead of 10
with old battery :-(().

> I'm not sure how familiar you are with the issues surrounding trying to
> do a voltage to charge mapping for a battery but it's much more complex
> than a simple table if you want to get it accurate.  There's a lot
> of

Well... current zaurus kernels use _huge_ table that maps voltage to
battery %... and that table is linear function :-(.

Do you have some papers on that?

> dependence on particular operating conditions and things do change as
> the batteries age.  There are systems out there that do the work
> required to gather the information in hardware and it's definitely good
> to report the information from them but that doesn't mean it's a good
> idea to try to synthesise the information for other systems.

So... on zaurus I plan to:

1) provide better voltage -- %age map

2) estimate current

3) estimate internal battery resistance as constant

4) estimate internal battery volltage using ohm's law and base %age
 estmate on that.

Now... I realize that internal resistance depends on charge left. Nasty
but probably can be ignored. Then it depends on temperature. Does
anyone have better idea how?

Then... I need a way to measure internal resistance. I know it is in
200mOhm to 400mOhm range, on my device. Is there easy way to measure
it more accurately?

									Pavel
#!/bin/bash
#
# Copyright 2009 Pavel Machek <pavel@ucw.cz>, GPLv2
#

getval() {
    SETTLETIME=5
    echo Run this on idle, unplugged system, with expansion cards
    echo removed and backlight enabled
    echo
    echo 1 > /sys/class/backlight/corgi?bl/brightness
    echo Backlight 1, waiting for power to settle
    sleep $SETTLETIME
    VBMIN=`cat /sys/class/power*/*battery/voltage_now`
    VBMIN=$[$VBMIN/1000]
    echo Voltage = $VBMIN mV

    echo
    echo 47 > /sys/class/backlight/corgi?bl/brightness
    echo Backlight 47, waiting for power to settle
    sleep $SETTLETIME
    VBMAX=`cat /sys/class/power*/*battery/voltage_now`
    VBMAX=$[$VBMAX/1000]
    echo Voltage = $VBMAX mV

    echo 1 > /sys/class/backlight/corgi?bl/brightness
}

fake1() {
    # Very old 1000mAh battery from collie: 703 mOhm
    VBMIN=3638
    VBMAX=3543
}


fake2() {
    # Old 2000mAh battery, nearly charged, 4C: 274 mOhm
    VBMIN=3732
    VBMAX=3695
}


fake3() {
    # Same old 2000mAh battery, nearly charged, 4C: 140 mOhm
    # temp: 155.
    VBMIN=3714
    VBMAX=3695
    # Next try: temp 151 -- little warmer: 422 mOhm.
    # Next try: temp 151 -- little warmer: 1266 mOhm.
    # Next try: temp 148 -- getting warmer: 281 mOhm.
    # Next try: temp 148 -- getting warmer, full load: 422 mOhm.
    # Next try: temp 148 -- getting warmer, full load: 140 mOhm.
    # Next try: temp 148 -- getting warmer, full load: 422 mOhm.
    # Next try: temp 138 -- getting warmer, full load: 422 mOhm.
    # Next try: temp 139 -- getting warmer, full load: 422 mOhm.
    # Next try: temp 136 -- getting warmer, full load: 562 mOhm.
    # Next try: temp 132 -- getting warmer, full load: 703 mOhm.
    # Next try: temp 132 -- getting warmer, full load: 281 mOhm.
    # Next try: temp 134 -- getting warmer, full load: 281 mOhm.
    # Next try: temp 134 -- getting warmer, full load: 562 mOhm.
    # Next try: temp 129 -- getting warmer, full load: 562 mOhm.
    # hugh, I''m getting n*140, wtf?
    # ...voltmeters have sensitivity limits...
    # temp 118 -- metro, venku zima -- full load: 281 mOhm.
    # temp 118 -- metro, venku zima, baterie poloprazdna -- full load: 281 mOhm.
    # temp 120 -- metro, venku zima, baterie poloprazdna -- full load: 281 mOhm.
    # temp 120 -- metro, venku zima, baterie poloprazdna -- full load: 281 mOhm.
    # temp 120 -- metro, venku zima, baterie poloprazdna -- full load: 414 mOhm.
    # temp 120 -- metro, venku zima, baterie poloprazdna -- full load: 555 mOhm.
    # temp 120 -- metro, venku zima, baterie poloprazdna -- full load: 422 mOhm.
    # temp 124 -- metro, venku zima, baterie poloprazdna -- full load: 422 mOhm.
    # temp 127 -- metro, venku zima, baterie poloprazdna -- full load: 422 mOhm.
    
}



getval
#fake1

BLDIFF=135
echo Assuming $BLDIFF mA difference

echo $VBMIN $VBMAX $BLDIFF

# With RESIST in mOhm
#	VINSIDE = VBMIN + RESIST * BASECURRENT / 1000
#	VINSIDE = VBMAX + RESIST * (BASECURRENT + BLDIFF) / 1000
# Therefore
#	RESIST = 1000*(VBMIN-VBMAX)/BLDIFF

RESIST=$[(1000*($VBMIN-$VBMAX))/$BLDIFF]
echo Resistance is $RESIST mOhm

BASECURRENT=280
echo This should be equal:
echo During  low backlight $[$VBMIN + ($RESIST * $BASECURRENT) / 1000] mV
echo During high backlight $[$VBMAX + ($RESIST * ($BASECURRENT + $BLDIFF)) / 1000] mV

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
