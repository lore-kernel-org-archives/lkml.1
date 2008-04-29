Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbYD2TM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbYD2TM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYD2TMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:12:44 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:31939 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756141AbYD2TMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:12:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iD2DnH6C4So58OzagY/OHQORXb4xU08DtPwVSU9n4x2NE326Nk3hq5ZLhNs6jbmERI74Y9bwIPovO3q4LXuS95XK7G/bHJUxoqFdJjKvNRB0Ij/TSdqnwa/UEobfWIJhe6tytxWcnCUeMGvdYqvWDqZ5xkq80geVsJYlmIaSxQI=  ;
X-YMail-OSG: wHFH9ssVM1l6HEQF7plv2_S7U5JY.FC5YAnof52i4qHbroR7Nxofnf2VyqIR1PoASo.3Fb3G6bzkuxRHJry7MlXKsjOqKBtC.9YUE.v0Lygz3GeHtHt8oyT_Ne82WVARxG4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: rtc: how should I handle an invalid state?
Date: Tue, 29 Apr 2008 12:12:40 -0700
User-Agent: KMail/1.9.6
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
References: <20080429121924.GA2137@digi.com>
In-Reply-To: <20080429121924.GA2137@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804291212.40638.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Uwe Kleine-König wrote:
> The problem is that hwclock tries to read the current time before
> setting the new one.  And if that fails, it doesn't update the rtc.

Which version of hwclock?  That does seem like a bug in that
particular version.  If it's in util-linux-ng or busybox,
please send in a patch.  I don't think anyone should be
deploying *new* systems using *old/unmaintained* util-linux.

I'll suspect this is on some util-linux version, since I'm
quite sure that I've had busybox based systems that don't
show this misbehavior.  Haven't had occasion to use non-PC
RTCs with a util-linux-ng version; I wouldn't call a bug in
such combinations a kernel regression, either...

I think the preferred solution never returns invalid times as
valid.  Some RTC drivers do this themselves:

        int my_rtc_read_time(struct device *dev, struct rtc_time *time)
	{
		... read the hardware into *time ...
		return rtc_valid_tm(time);
	}

Or rtc_valid_tm() might be checked in the RTC framework glue,
to provide more uniform behavior at the framework level.

Either way, it's not unknown that an un-initialized RTC have
undefined state, and thus return invalid times until they've
been set (using wall clock, NTP, or whatever).

- Dave
