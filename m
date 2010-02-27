Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0B0HCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:02:21 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:39060 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753809Ab0B0HCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:02:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=C2IE8pXlnBfs8mFm+MFD5YS1kJxJcEAcedB6AuSiaUp1P78uU6c3o8RIQkaQFxg9iugNqecxG+fQ9MS3eOYf1baJ8XsqJ7gegS3E/aH6PKp4jDD89UF0Ors2Vv4OErLiGPXr7jB3GBEfX8LpJZH85iAxIWq1Oac72pdz+piIjfc=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: fU.ni_kVM1lZIU9A.oiHuzf7x3bg1q70jfe.hNBET0WcolSrR_ZnltR6o_LIXOvoWVfVvg81u9I7sHyVyeJSYo2kmMZXvQNaNu6kS3UBU2BvjSacpp4l.qxl2YU_WdxgY92Q8C2s4a9H3nuJ7L5CJYzosez6rmnpsdyAz7erynKBERiTi5jJt_TtIXhre7uVg9n8LNIsEv9XM5mUfpIcmJjl4BbbsOHCesVDnENW_ShrfswqUdNEuCctLE5K2Nmt4Uw_VBLeiTQiJbCcbn4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Gardner <gardner.ben@gmail.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
Date: Fri, 26 Feb 2010 23:02:18 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <cover.1267225701.git.gardner.ben@gmail.com> <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
In-Reply-To: <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002262302.18890.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 February 2010, Ben Gardner wrote:
> Combine gpio_direction_input() and gpio_direction_output() into
> gpio_set_direction().

NAK. 

When we discussed the programming interface originally, having the
direction be part of the function name was explicitly requested as
a way to reduce programming errors.

I recall that  a gpio_set_direction() was in the original proposal...
removing that was one of the handful of fixes that went into the final
set of calls in this programming interface.

And in fact  ... it *was* very easy to make errors with a few GPIO
interfaces which worked like that.  With even fewer parameters to
create confusion than in your proposal.

Let's have no retrograde motion...


> Add 'none' and 'inout' directions to the sysfs interface.

Both of those seem nonsensical:

 "none" ... since it's not even a GPIO, why would it show
	up through the GPIO subsystem???

 "inout" ... is not a direction.  But if you want to do this,
	you really ought to bite the bullet and come up with a
	way the implementation can pass up its capabilities.

	Did you read the definition of gpio_get_value()?  It says
	"When reading the value of an output pin, the value returned
	should be what's seen on the pin ... that won't always match
	the specified output value, because of issues including
	open-drain signaling and output latencies."  Also:  "note that
	not all platforms can read the value of output pins; those that
	can't should always return zero."

	Another way to say that is that "output" means 'inout" except
	when the platform can't do that.  So you'd need to address the
	case of hardware that's truly output-only ... instead of
	ignoring that, as done here.  (That is:  you'd need to have a
	way to reject "inout" mode ... or for that matter, "output-only".)


	Doing that well might be a Good Thing ... if for example it
	lets the initial mode of a GPIO show up properly ... there's
	currently an assumption in sysfs that they start up as "input",
	which of course makes sense for any power-sensitive system
	(you don't enable output drivers unless that power consumption
	is for some reason required).

	I've never, for example, seen GPIO hardware that would support
	the equivalent of that "open in <bitmask> mode".   It's either
	unidirectional (rarely), or (normally) the only real option is
	whether the output drivers are disabled.  So you always get the
	"inout" semantics described above, or input-only ones.  Asking
	for output-only would need to fail.  (Or in the less typical
	cases, it's asking for "inout" that would need to fail.)

