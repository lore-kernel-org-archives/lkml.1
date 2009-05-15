Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZEOPRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZEOPRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZEOPQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:16:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbZEOPQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:16:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: hibernate vs. WoL
Date: Fri, 15 May 2009 17:15:53 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <1242396160.5799.92.camel@johannes.local>
In-Reply-To: <1242396160.5799.92.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151715.54123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, Johannes Berg wrote:
> Hi,

Hi,

> According to pm.h one should enable wakup events in the suspend() and
> poweroff() callbacks.
> 
> However, poweroff is not called for the 'shutdown' or 'restart'
> hibernate methods. This seems problematic, since then with proper
> drivers platforms that have no 'platform' suspend method then cannot WoL
> or anything like that (well, for 'restart' that isn't very relevant).

I think the solution for these platforms is to define hibernation operations
(struct platform_hibernation_ops) that do nothing and use the 'platform' mode.

WoL is not really supported in the 'shutdown' mode due to drivers that
don't have a ->shutdown() method setting up WoL.  Also, on ACPI systems we
often need to do some ACPI magic for the WoL to really work and this is not
done in the 'platform' mode.

> The only way to hack around that seems to be to implement the
> dev->driver->shutdown method, but I don't think that is intended? On the
> other hand calling both ->shutdown and ->poweroff seems problematic.
> 
> Right now what I'm trying to do is preserve a wireless connection across
> hibernate. This is possible by telling the AP that we're asleep, in
> which case it will buffer frames for us (it may eventually kick us off
> anyway, but that's ok, without telling it we're asleep I don't even
> survive a 'reboot' method cycle).
> 
> Also, shouldn't it be possible to WoL while your machine is shut down?
> How do you program that?

Set up WoL in ->shutdown(), like e1000 for example.

In fact I don't like it too, because IMO we clearly seem to need to split
the current ->shutdown() into non-PM and PM parts, but that's how it goes
at the moment.

Thanks,
Rafael

