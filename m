Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbZJMWVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbZJMWVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761479AbZJMWVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:21:14 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41565 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755224AbZJMWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:21:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=czhVqLdTWhvR1urutgX9Ma6x7t5vtJeaeh1vMMczwUFspQImYSafiziCFA8q00eE54GbKU3yLZURhuEK3wb2X4Nwc+tNg2so4wKjfmDZD2Hn0k0OR/+dzmHaXWXLNOC6PyvOB2glVAQd190qXX4m2u8gbZSNLhVPAv2I6/Zes0I=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: xR.2tegVM1nz_p1IgWp8W27b98pToM6nL9EFd.HOZhDWgObiO4kCcijKqUU.0e4WJoWQpHOk60hv_ryby4DprxoXv8qDT0NJRLhFh.TdCYhdhgO9DgbAjv4vNICFdNwfQCPbG5wjEUjMWcYQnYBHIIsNsUzMEBB7.X4CtpAey2yC3SRHSJTg1v_yt2j1qmsXD7uwaxnaqNBfuvDVOaC.qeST1ylWb.VTdoaqsvqJQM0jQZ1z_UVwjWD67x60y.KEAbAMaPg_lNxHeA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Date: Tue, 13 Oct 2009 15:06:05 -0700
User-Agent: KMail/1.9.10
Cc: Ben Nizette <bn@niasdigital.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, dsilvers@simtec.co.uk
References: <20091010134814.0bac8624@bike.lwn.net> <1255327904.5347.79.camel@ben-desktop> <20091012092331.45d7e71b@bike.lwn.net>
In-Reply-To: <20091012092331.45d7e71b@bike.lwn.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910131506.05851.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Jonathan Corbet wrote:
> On Mon, 12 Oct 2009 17:11:44 +1100
> Ben Nizette <bn@niasdigital.com> wrote:
> 
> > Back to this patch though, the gpio names have to come from the platform
> > code via some platform_data for the gpio chip [1], the driver then looks
> > up that pre-defined name to find the gpio number.  Why not just pass the
> > gpio number straight to the end device driver through platform_data and
> > bypass the middle-man?
> 
> That's true in a situation where you've one One Platform to Bind Them
> All, yes.

What do you mean by "platform" though?  Clearly not what I mean!
You make it sound like an evil place, Barad-dûr hosting an assult
on the Forces Of Light!  :)

If you mean to imply that only statically assigned GPIO numbers
can work, I'll disagree.


> But if you have (say) GPIOs provided by a PCI-connected 
> peripheral which are needed in (say) a camera driver, there is no one
> platform which can manage all those GPIO numbers.

The basic trick is to have gpio chip drivers call back with enough
information to start hooking up the GPIO signals to consumers.  The
OS is only responsible for remembering things ... like how to connect
a phone number or IP address to the right destination.

See for example the pcf875x driver.  When it registers, it reports via
callback that the stage is setup() for performance.  Later it can report
that it's time to teardown() that part of the show.

Whatever sets up that PCI board has to know basically what's there, and
when it sets up the gpio chips it can provide the callbacks needed to
hook up e.g. "base + 19" as the "camera active" LED.  No lookup() needed.

Notice also how doing it that way provides clean ways to sequence the
startup and teardown of complex hardware stacks.  (Too many drivers tend
to ignore those issues, IMO, and for complex hardware modules that can
cause much trouble.)


> In particular, I've 
> done a driver for viafb-based GPIOs; these devices can show up in any
> of a number of x86-based systems.  I honestly don't know why it would
> make sense to try to hardware numbers to these GPIOs when using names
> and dynamic numbering is so much more flexible - and we are already
> tracking the names.

There are video drivers that solve this without needing name-to-ID
style lookups.  I recall discussing them well over a year ago... the
numbering is dynamic, yes.


> Perhaps it would make sense to implement a proper namespace layer for
> GPIOs

Today, that namespace is numeric.  And as far as I know, it's
sufficient ... although it's not intended for browsing, any more
than, say, phone numbers or IP address numbers.


> rather than continuing to grow something which evidently sneaked 
> in through the back door.  Until that's done, though, I think this
> patch is useful.  But it it's really unwanted I'll find some other way.

All *names* for GPIOs snuck through the back door ... except for
the labels in /sys/kernel/debug/gpio, which are diagnostic-only
and not unique.  And the gpio_export_link(), with sysfs names that
are unique within a clearly-defined driver context.

- Dave
