Return-Path: <linux-kernel-owner+w=401wt.eu-S1764655AbXE2UYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764655AbXE2UYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXE2UYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:24:11 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:37737 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750832AbXE2UYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:24:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Y0MKj+w4g2E7CvvBgSOkLvzzyeX+rtAs30fH62kDEUgYzjQOh0xG+KSExONtsvrXK2snCBfHkPMHy6r+Cxfu9wF/7YgiJeUdIq1woDyQGCfQQocZvTqDknE5VMErldw+aXKtnQAxoZ5Y8Y0pjTfLQFqbAmvG3bPfCpm9Md7b9EA=  ;
X-YMail-OSG: 9j7xv.QVM1mq.F2XT_oXYbSzg7gj6YoIHg0NcZ7QC1pdS4UDPSDCdDAVd9ue5uVJNtzfF.dOhw--
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Tue, 29 May 2007 13:09:47 -0700
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0705281719200.10323-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705281719200.10323-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291309.47559.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007, Alan Stern wrote:

> This is a matter of one's philosophy.  In suspend-to-RAM, should tasks
> be frozen or should I/O queues be frozen?
> 
> With the USB subsystem I have followed the approach taken by the PM
> core, which is that tasks are frozen.  But one can -- and Linus has on
> at least one occasion -- make a good case that tasks should be left
> running while only I/O is frozen. 

In fact that makes a heck of a lot more sense to me from the
conceptual point of view.  From the hardware perspective, the
task of preparing to enter true suspend states (STR, or suspend
for ACPI; embedded systems have more options) focusses on what
I/O signals are disabled.

Once the relevant I/O signals are first idled, then disabled,
the CPU can do whatever it likes.  Whether it runs or not is
purely a workload decision...

Remember too that not all systems suffer from the constraints
that ACPI decrees.  In particular, it's not uncommon that some
parts of the system be active in certain suspend states.  The
whole point is to turn off as much of the system as possible,
especially the high power portions, while letting work proceed.

Turning off some clocks and peripherals doesn't need to imply
turning them all off, or disabling DMA ... and should not need
to be triggered by a user (or userspace tool) explicitly saying
"go into STR".


> This would require the subsystem to 
> distinguish between a selective device suspend and a system-wide
> suspend-to-RAM, so that selective resume could be enabled on demand in
> one case but not the other.

Exactly.  "Selective suspend" of parts of the system is a far
more general model.  It fits well with runtime power management,
degrades smoothly to states where memory goes into self-refresh
(maybe the system idle loop when NO_HZ is being effective) or
even hibernation (as discussed elsewhere).

- Dave

> It's quite doable in principle -- it's just not the technique I used.
> 
> Alan Stern
> 
>
