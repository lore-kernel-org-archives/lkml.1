Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbXHFUyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbXHFUyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXHFUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:54:47 -0400
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:42483 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751447AbXHFUyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:54:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PcfK2+FqYBf8Hl7xwuUB0OrmW1ioY3MlbBszT1q4sGa4EsGi0PCPpNrnIY0EBlioOQ8ralhq+hJVZwJKPI0YCCIuAHyndNmxuK1PUrGQviig6wl5dwpCYL1v9rZ62iA5cm85j0mzcfsswpCb78eqxcHKIBhpH7nKnld6ECjuGsc=  ;
X-YMail-OSG: AjuGSGcVM1kzbx4hbxJTXe1wf.98xc6HBPW7evp_Vn46Mmi4W6o5_soK46uwCjLIjoeuE2zQJu1SiM9eFlinH3mhQkrwr.fzSoRqFMRVysQ27xhrKx1FwRTdaeeeN.gAevwOh05k5NM_fOk-
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH] kexec: fix pci device initialization fail after kexec (2.6.23-rc2). (Related to e1000 doesn't resume properly from standby)
Date: Mon, 6 Aug 2007 13:54:35 -0700
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Joonwoo Park" <joonwpark81@gmail.com>,
       Simon Arlott <simon@fire.lp0.eu>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com> <b25c3fa70708060850p26b7b3e6yb8a523a479c714c0@mail.gmail.com> <200708062048.37160.rjw@sisk.pl>
In-Reply-To: <200708062048.37160.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708061354.35648.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007, Rafael J. Wysocki wrote:
> Section 5.4.1 of PCI PM 1.1. spec is about D3_hot.  Specifically, it says
> that if a device in D3_hot is programmed to D0, it performs the equivalent of
> a warm reset.  IOW, this is supposed to happen if the current state is D3_hot
> and the targed state is D0, which is covered by the code snippet above.

Actually, it's *allowed* to do a warm reset.  Not required.
And not all PCI devices will do such a reset.   Some of them
will return to D0_initialized ... not D0_uninitialized (where
uninitialized means "did the reset").

It's D3_cold where a (powerup) reset is *required*.

A common example would be a USB host controller.  If one of
those did a warm reset it'd trash all the connection state
which was carefully retained during sleep ... and there'd be
no point to supporting D3_hot rather than D3_cold.

As a rule of thumb, it's probably safe to assume that if
a device can generate wakeup events, it probably doesn't
trash all of its state when it resumes from D3_hot.

Of course, if it can generate wakeup events from D3_cold,
the difference between Vaux and Vcc power wells comes into
play.  The Vaux powered bits will retain state, while the
stuff powered by Vcc gets a powerup reset.

If it can't generate wakeup events, a PCI device has no
particular need to retain state after D3.  Implementors
can choose whichever is most convenient.

- Dave
