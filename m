Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbZDHOZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbZDHOZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZDHOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:25:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41739 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZDHOZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:25:00 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
	recently
From: Dan Williams <dcbw@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239108689.15015.3.camel@maxim-laptop>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 10:26:19 -0400
Message-Id: <1239200779.14879.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 15:51 +0300, Maxim Levitsky wrote:
> On Tue, 2009-04-07 at 10:18 +0200, Johannes Berg wrote:
> > On Tue, 2009-04-07 at 03:00 +0300, Maxim Levitsky wrote:
> > 
> > > I noticed that always first attempt at scan fails when NM asks for scan.
> > > I also noticed that this happens with quite recent kernels (I think
> > > 2,6.28) didn't have this behavior.
> > 
> > I'm pretty sure it did.
> I am sure that on older kernel there was no -EBUSY error returned to
> userspace. It probably just stalled the client.
> 
> 
> > 
> > > Looking a bit deeper I discovered that each time NM disconnects from a
> > > networks it sets random ssid/essid to the card (using wireless
> > > extensions)
> > 
> > This forces a scan
> > 
> > > After that scan fails for some time.
> > > 
> > > as a NM free example you can run 
> > > 
> > > iwconfig wlan0 essid dummy
> > > iwlist scan
> > 
> > and then this fails with EBUSY.
> Thanks for explanation.
> Since NM has its reasons to clear essid (to prevent unwanted
> association), then what can be  done to prevent this (and still use
> wireless extensions, since nl80211 support isn't yet mature)?

Honestly I think this should be handled by the driver or wpa_supplicant.
Recent supplicant versions will already send a bogus SSID and BSSID to
the driver when a forced disconnection happens, but that's not enough to
stop some drivers like 2.6.27's iwl3945 from continually attempting
reconnection to an SSID in other cases.

The problem is that wext has no mechanism for saying "stop doing
whatever you're doing dammit and wait for me to tell you what to do
next".  I guess that would really be !IFF_UP, but of course you can't
scan then on most parts.

In the end, I'm probably going to patch the supplicant to handle this
and remove that code from NM.  It's really old code and things have
moved on since then.

Dan


