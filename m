Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYKXBDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYKXBDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 20:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYKXBDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 20:03:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYKXBDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 20:03:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Regression: ACPI AC driver doesn't work on Toshiba Portege R500 (bisected)
Date: Mon, 24 Nov 2008 02:02:59 +0100
User-Agent: KMail/1.9.9
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       walken <walken@zoy.org>
References: <200811230053.14211.rjw@sisk.pl> <200811240037.15835.rjw@sisk.pl>
In-Reply-To: <200811240037.15835.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200811240202.59513.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of November 2008, Rafael J. Wysocki wrote:
> On Sunday, 23 of November 2008, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > With current mainline (2.6.28-rc6-git1 as of today) on Toshiba Portege R500 the
> > status of the AC adapter is not updated when the adapter is unplugged and
> > plugged in.  Evidently, /sys/class/power_supply/ADP1/online always contains the
> > same value.  Interestingly enough, though, if the box is suspended to RAM and
> > resumed, the status of the AC adapter is correctly updated, but the value read
> > at that time remains in /sys/class/power_supply/ADP1/online until the next
> > suspend/resume cycle regardless of what's going on with the AC adapter.
> > 
> > 2.6.27.7 works correctly on this box so the recent EC patches don't seem to
> > cause this regression to happen.
> > 
> > Any other ideas?
> 
> The problem was introduced by the following commit:
> 
> commit faee816b1502385dc9bc5abf2960d1cc645844d1
> Author: Zhang Rui <rui.zhang@intel.com>
> Date:   Fri Sep 12 11:12:25 2008 +0800
> 
>     ACPI: don't enable control method power button as wakeup device when Fixed Power button is used
> 
>     don't enable control method power button as wakeup device
>     when Fixed Power button is used.
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=10503
> 
>     Tested-by: walken@zoy.org <walken@zoy.org>
>     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> Reverting this commit on top of the current mainline makes the kernel behave
> correctly again.

Alas, after reverting the patch the box hangs on resume from suspend to RAM
when it is woken up by opening the lid.

I suspect that the GPE which is normally used for signalling the AC adapter
events is the same one associated with the fake power button and it is not
enabled if that button is not regarded as a wake-up device.  However, it causes
problems to happen during resume if the fake power button _is_ regarded as
a wake-up device.

The DSDT for the box is at:
http://www.sisk.pl/kernel/debug/ACPI/R500/DSDT.dsl

Thanks,
Rafael

