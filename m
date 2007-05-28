Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXE1VJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXE1VJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762511AbXE1VJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:09:05 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:42633 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760892AbXE1VJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:09:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=6lSWKkV1QM2PCel9lgnhBrcSU6A2qzWlJcPFkIMwTDpj9FC4QZDIxxBnpredXQ/m+wC3TsxsvGuyzZPcMLLLaF/X/nwtUNaA63RrUxi8ztMrbj+zdQaHBq64vjSX+VppudPOapirMEUc/0akO2dx1crF1MbfA+/2V9Rfst7R3sk=  ;
X-YMail-OSG: bEbBp_wVM1nsqwFK8_ceoSpKwvnBNxI_ofhbPoTDyPD3zGg3mA1PEFfa5cjIHIJJtRwWcR8MCQ--
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [patch 2.6.20-rc3 1/3] rtc-cmos driver
Date: Mon, 28 May 2007 14:07:04 -0700
User-Agent: KMail/1.9.6
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200701051001.58472.david-b@pacbell.net> <20070528183513.GA2815@srcf.ucam.org>
In-Reply-To: <20070528183513.GA2815@srcf.ucam.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705281407.05250.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007, Matthew Garrett wrote:
> On Fri, Jan 05, 2007 at 10:01:57AM -0800, David Brownell wrote:
> > This is an "RTC framework" driver for the "CMOS" RTCs which are standard
> > on PCs and some other platforms.  That's MC146818 compatible silicon.
> > ...
> > +static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
> 
> This is awkward. At the very least, year will be set to -1. This then 
> gets passed through to rtc_tm_to_time, which results in reading 
> wakealarm providing very odd feedback. I guess the "right" fix is for 
> rtc_tm_to_time to use the current values for anything that's -1?

Well ... legacy APIs allow "-1" there; /proc/driver/rtc certainly
interprets wildcards consistently too.  That is, historically it's
not been legit to call rtc_tm_to_time(&t->time).

A counter-argument could be made that rtc_read_alarm() should get
rid of wildcards.  It's got the right RTC in hand; rtc_tm_to_time()
doesn't.  Other RTCs can have this same type of "wildcard" issue.

Me, I'd prefer to make the API treat alarms as purely oneshot.
That whole "wildcard" model is, as you noted, awkward ... even
though it's got hardware support in cases like MC146818 and clones,
it's not very portable.  But I don't want to push that issue either
way just now.



> > +	rtc_control = CMOS_READ(RTC_CONTROL);
> > +	rtc_control &= ~(RTC_PIE | RTC_AIE | RTC_UIE);
> 
> Do you really want to clobber RTC_AIE on probe? If an alarm has been set 
> by the BIOS, it seems a little unfair to disable it on boot.

I was wondering about that in the context of a different RTC, which
happens to run on BIOS-less hardware.  Which, curiously, may be the
opposite of BIOS-impaired hardware ... :)

In general, I suspect the alarm should stay active ... unless its
time has already passed.  That was the original intent of that
tweak, but of course PCs don't actually *have* oneshot alarms, so
there's no way to tell if a given alarm is in the past.  Leading to
the conclusion that AIE should probably stay enabled.

- Dave

