Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXHTBo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXHTBo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXHTBot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:44:49 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:44941 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752174AbXHTBor convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:44:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4KgoPfkJANYSCYJ0J2Uqia93RE58AV9+n0oAoxRx6LH/OB3FqwvvKT6qF0Dzcz7KVtagd2UgwQDqP0MMYblsqPQH+fCJTHvZGEtbXScYs6SQj4LTNajChk/+R4C6BBfxmXkklmwpclUEwZfaZaxbe/lxg9py71+wLwnHUxalV+0=  ;
X-YMail-OSG: mCf4NG0VM1nbOGe9ZlesG1RTvVroXJXwEUYVi7ewtVbhALHMZAqTPdw8R8FIEeEReCsWO5AqbgNAK2wnF_ktWTB5cSM1n6aKyFCfm9dqyc35Bi._WMqfgEDloRrAr4WyVdgrCQ4XmY4Jp50-
From: David Brownell <david-b@pacbell.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: legacy platform drivers and hotplugging
Date: Sun, 19 Aug 2007 18:44:43 -0700
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>,
       David Zeuthen <david@fubar.dk>
References: <200708170823.15894.david-b@pacbell.net> <200708172106.52940.david-b@pacbell.net> <1187433939.4419.42.camel@lov.localdomain>
In-Reply-To: <1187433939.4419.42.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708191844.43947.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Notice I fixed $SUBJECT to not mention rtc-ds1742, which has
never been a platform device and thus is offtopic to your
specific complaints about platform bus hotplugging.


On Saturday 18 August 2007, Kay Sievers wrote:
> On Fri, 2007-08-17 at 21:06 -0700, David Brownell wrote:
> > On Friday 17 August 2007, Kay Sievers wrote:
> > > 
> > > > I'm not the one who's advocating a change here.  If you want to
> > > > first change/break and then fix things, all of that is up to you.
> > > 
> > > I'm happy to do that. Patch is attached.
> > 
> > NAK.  That wasn't even a serious attempt at the "fix" part,
> > though it does the "break" part well enough to cause severe
> > regressions.
> 
> You disabled uevents which breaks udev and HAL setups, because we can't
> track the existence of the devices.

Only certain code paths -- ones primarily used by legacy
drivers -- disable those events.

The basic problem with such legacy drivers is that they
violate core driver model assumptions ... notably, by
creating device nodes for non-existent hardware.

Which means that for these legacy drivers, userspace can't
track device existence in *that* way.

If said driver creates some other device node after it's
verified the hardware exists -- maybe one that's coupled
to a character device -- it'd be fine to track *those*
events.  ISTR that most such drivers *do* create such nodes,
since back in the prehistoric ooze from which they crawled,
that was the only way to be seen by userspace.


> You can't just disable device events 
> to disable module loading. Uevents have are by far not only about module
> loading.

Only for legacy drivers, because of the modprobe loop thing.

So your proposal for how to handle such broken/legacy drivers
is ... exactly what, then?

Near as I can tell, you propose that the platform bus never
support automatic module loading.  Which seems to me like a
nonstarting proposal:  a significant and needless regression,
inflicting harm on what for most platforms (by type, and also
maybe by number-in-the-field) is the primary system bus.


> > (As well as leaving all my technical points about your pushback
> > un-addressed.  As I noted before, the evident fact that you don't
> > have technical responses to them says to me that your pushback
> > has no real technical basis ...)
> 
> It has. Disabling uevents to control module loading is just the totally
> wrong thing to do. Uevents are there to let userspace know that a device
> exists.

See above.  By your definition, legacy drivers would be issuing
bogus events.  So one key issue here is how to handle them; the
patch you object to won't issue those buggy events.

>From you, I've not seen even a proposal for a viable workaround
to that looping bug.  Not even that udev configs should handle it,
for example, although that would appear to be the most natural
conclusion given your premises and the fact that ISTR you're
still maintaining it ...

Whatever happens, I believe that legacy drivers will necessarily
involve special casing to cope with the fact that they don't
follow the current set of rules for drivers (though some folk
seem to want to make them act as if they do).


> Only the existence of MODALIAS and the "modalias" file controls 
> module loading, not the enabling and disabling of uevents, which is a
> completely broken hack.

Well, ISTR my original patch for the "looping" bug only affected
those values, but you objected to that too...

Which is why the code now just uses a pre-existing "no uevents"
hook (on code paths used primarily by legacy drivers) instead of
only addressing the "this driver can't be hotplugged" issue.

It looks like you're maybe coming around to my original position,
at least that key part of it.


> My patch fixes tons of issues, and that is "technical basis" enough. It
> makes platform play nice with userspace, by behaving like the rest of 
> the kernel.

Yet as I noted: it causes a regression of just shy of 100% for
platform device hotplug.  Ergo a well-founded "NAK" ... two steps
forward versus hundreds of steps backward, rarely a good idea.

(You still haven't actually described any case where the current
code is a problem.  Handwaving "tons of issues" doesn't count.)


> Userspace udev/HAL relies entirely on uevents, for hot- and for
> coldplug. Coldplug is done by writing "add" to all "uevent" files during
> early boot, that does not work anymore with platform, and needs to be
> fixed.

Like I said:  "technical basis" enough not to merge your patch;
it breaks coldplug too, as well as hotplug.

 
> > Out of around 300 platform drivers in the tree (and many more
> > not yet merged upstream), this makes it so that only *THREE* of
> > them can hotplug ... versus in the current tree, essentially
> > everything that's not a legacy driver is hotplugging just fine.
> > 
> > That's one heck of a regression.  Just shy of 100% ...
> 
> So where are the 100's of drivers that send an uevent? I'll go and fix them.

Device creation sends those uevents, as you know, not drivers.
(Modulo the issue of broken/legacy platform drivers, which are
wrongly creating devices themselves.  When I counted before, I
recall thinking that only a few dozen drivers were broken in
that way.  I mentioned i82365, there are others.)

What you broke is the connection between the device "add" events
and the "modprobe" parameter which loads the relevant driver.  That
currently (i.e. without your patch) works for most platform drivers.

 
> > Plus it treats rtc-ds1742 as if it's a platform_driver not
> > an i2c_driver.
> 
> Wrong, the whole model is the other way around.

Please strike yourself repeatedly over the head with a clue-by-four.
I2C != platform, and ds1742 is an i2c device.  So your patch:

> > > +MODULE_ALIAS("platform:ds1742");

violates the (new/undocumented) rule *YOU* previously proposed
(which is violated by most MODULE_ALIAS declarations I found in
the source tree) whereby the syntax of those aliases requires
that they start with a subsystem prefix.

Wrong subsystem.  strcmp("i2c", "platform") != 0.



> Please stop doing adding weird hacks to the kernel to fit your personal
> taste and breaking all assumptions existing tools rely on.

The only "personal taste" I've observed here is yours: that
in regards to this issue, you've avoided constructive responses
to most issues I've raised ... more than once giving unfounded
ad hominem "responses" instead of providing a counter-argument
(such as evidence backing some of your assertions).


> Fix the stuff  
> you broke and enable uevent for _all_ devices again. And let userspace
> make the decision what to do with the event, like all other subsystems
> in the kernel do.

You know, all I was trying to do was fix a bug reported to me
with the legacy i82365 driver.  (The modprobe loop thing.)
That's what started your flamage.

Root cause was that it's a legacy driver, can't hotplug, and
shouldn't even try.  There are other legacy platform drivers
in that same boat.  So the fix couldn't apply to just that
one driver.

Now, if you had ever come up with a viable alternative fix to
that issue (patch or proposal) rather than just arguing against
actually fixing that nasty bug ... well, such "what-ifs" can't
matter a lot here.  Except that constructive discussions don't
feel like "talking to a brick wall" time-wastage.

- Dave

