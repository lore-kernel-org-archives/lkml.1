Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbYIBPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbYIBPLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYIBPLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:11:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYIBPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:11:04 -0400
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
From: Dan Williams <dcbw@redhat.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Zhu Yi <yi.zhu@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       Jan-Espen Pettersen <sigsegv@radiotube.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080902145840.GE19172@google.com>
References: <20080901160658.GA11063@google.com>
	 <1220319536.28282.128.camel@debian.sh.intel.com>
	 <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net>
	 <20080902130429.GB19172@google.com>
	 <1220362201.3176.4.camel@borkbork.foobar.com>
	 <20080902145840.GE19172@google.com>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 11:10:38 -0400
Message-Id: <1220368238.8041.4.camel@borkbork.foobar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 17:58 +0300, Michael S. Tsirkin wrote:
> On Tue, Sep 02, 2008 at 09:30:01AM -0400, Dan Williams wrote:
> > On Tue, 2008-09-02 at 16:04 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Sep 02, 2008 at 08:10:09AM +0200, Johannes Berg wrote:
> > > > Zhu Yi wrote:
> > > > > On Mon, 2008-09-01 at 19:07 +0300, Michael S. Tsirkin wrote:
> > > > >> [16482.909453] eth1: associate with AP XX:XX:XX:XX:XX:XX
> > > > >> [16482.918553] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX
> > > > >> (capab=0x411 status=0 aid=1)
> > > > >> [16482.918564] eth1: associated
> > > > >> [16492.920224] eth1: disassociating by local choice (reason=3)
> > > > >> [16492.920986] eth1: disassociating by local choice (reason=3)
> > > > >
> > > > > It is exactly 10 seconds the local STA sends the deauth_leaving frame
> > > > > before associated everytime. I wonder if it is the timeout for some
> > > > > wireless config tools. NM?
> > > > 
> > > > "by local choice" means wext requested this, not a kernel bug.
> > > > 
> > > > johannes
> > > 
> > > Sure, it's wpa_supplicant in ubuntu gutsy doing it.
> > > 
> > > $wpa_supplicant -version
> > >  wpa_supplicant v0.5.8
> > >  Copyright (c) 2003-2007, Jouni Malinen <j@w1.fi> and contributors
> > > 
> > > But it happens to work fine without 8ab65b03b7893da4a49009e7e356e36e27b0c407.
> > 
> > That's really odd; that patch (the don't-send-empty-extended-rates-IE
> > patch) shouldn't have anything to do with this behavior, if it did you
> > wouldn't get associated to the AP in the first place I think.  You're
> > 100% sure that this patch is causing the problem?
> 
> No, not sure. But reverting it seems to have helped.
> And there does not seem to be anything else relevant between rc4 and
> rc5.
> 
> >  Can you post the
> > output of running wpa_supplicant with the "-dddt" flags
> 
> I put up a (sanitized) -dd output here
> http://bugzilla.kernel.org/show_bug.cgi?id=11476

Logs seem to indicate a normal failure of the 4 way handshake; are you
sure your PSK is correct?  It actually looks like the AP doesn't ever
get message #2 from your machine, and just retransmits message #1 of the
handshake.  I'm pretty sure that if
8ab65b03b7893da4a49009e7e356e36e27b0c407 had anything to do with it, you
wouldn't be getting this far and the AP would have denied association in
the first place.

To me this looks like the 4-way handshake is going wrong and either the
supplicant is killing the connection or the AP is terminating the
connection due to that.  This doesn't rule out driver problems but we'd
need better analysis of the wpa_supplicant logs (be smarter people than
I) to figure out whether I'm on the right track or not.

Dan

