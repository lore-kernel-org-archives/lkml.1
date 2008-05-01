Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYEACNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYEACNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYEACM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:12:58 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:22970 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753882AbYEACM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:12:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JIS+Ai3TSoa9JksOy2v6GvIYxb4A1fETghPcjPK9fbHHIYfKdQLMdqSlhf7Uopqiig5xlpxKgBws1hXdDX2w9TCum8JI6pRlPm1cTTuAxCwhOc8QXNzdNw9WKx/uKJUq+MpUh+f7oXdQKQrZzPEyRk55l+mlPk/b2iMIwoCx4SA=  ;
X-YMail-OSG: tWRj958VM1kpBHkFupW0M1jJw38fb1S.o02PQPRwAFwD4x6HPCP3UWHNqc70nivD3cqaSJ090mg2BUDVdsA81G.WVz10LzcVepAQiNPX7k1ezhjUy4ugJSYKnkFrNglTaao-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
Date: Wed, 30 Apr 2008 19:08:31 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Ben Nizette <bn@niasdigital.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804301434.25211.david-b@pacbell.net> <Pine.LNX.4.64.0804301511120.1537@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0804301511120.1537@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804301908.32346.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008, Trent Piepho wrote:
> On Wed, 30 Apr 2008, David Brownell wrote:
> > Simple sysfs interface for GPIOs.
> >
> >    /sys/class/gpio
> >    	...
> 
> "simple"?  What I had was a lot simpler.

But it had some "must fix" problems, which I told you when you
posted your first patch.  You didn't fix them.  And since then,
your pushback seems to rely very heavily on ignoring issues I
pointed out are "must fix" or "can't/doesn't work that way".

It's easy to be simple if you don't have to be correct or safe.


> So, I want to set gpio 5 on a pcf9557 extender.

Which isn't exactly where most folk start.  If it's something
done routinely, they'll likely have a script to run; either
the native language type, or something for bash or Python.

If it's a one-off, they probably start from schematics and
are fully capable of adding 5 to the base number associated
with the particular pcf chip in question (say, the third one
on this card stack) ... and doing the same for other pins
they need to diddle.  Note taking is always a good practice
when sorting out such issues, but adding five is in your head
is far from rocket science.


> cat 1 > /sys/class/gpio/pcf9557-0:0
> 
> But now I can't do this anymore,

"Any more"?  You never *could* do that before.  The original
patch you sent didn't do that, and the last code snippet I
saw from you didn't either.


> it has to be harder.  So how do I do it?  It 
> doesn't seem very considerate to ignore the real use cases

I didn't ignore *use cases* at all.  You can certainly set
the value of such a GPIO with the $SUBJECT interface.

Just ... not using that syntax.  Use cases are several steps
above solution details, such as a particular syntax.


> of the person who wrote the code to begin with.

I've seen at least half a dozen different userspace models for
how to work with GPIOs.  You didn't write all of them.  Nor
were yours the only use cases.


> 	 What's the point of allowing
> one to label gpio lines if it's not going to be easy to see?

You can "cat /sys/kernel/debug/gpio" to see them...


> >  echo "23" > /sys/class/gpio/control
> > 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> 
> So if a driver is already using gpio 23, then there is no way to see it in
> sysfs, since the gpio_request() will fail?

Right.  If that driver wanted to cope with userspace mucking
around with its internal state (GPIOs) it would have explicitly
enabled it by calling gpio_export().  If it's not prepared to
cope with the various flavors of breakage that would facilitate,
it doesn't call gpio_export() ... and is safe.


> > 	/sys/class/gpio/gpio-23/direction to configure it.
> >  echo "-23" > /sys/class/gpio/control
> > 	... will gpio_free(23)
> 
> So if a driver was already using gpio 23 and you wanted to look at it from
> userspace, you'll free it from both sysfs and the driver that was using it
> when you're done?

No, that was the one-line summary.  It's only freed if it was
originally requested from userspace (by "echo 23 > control").
As you can see in the code...

- Dave


