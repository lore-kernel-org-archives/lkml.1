Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXCHPcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXCHPcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXCHPcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:32:24 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4401 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXCHPcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:32:23 -0500
Date: Thu, 8 Mar 2007 09:50:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
Message-ID: <20070308145043.GB5323@tuxdriver.com>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307201839.6f45735b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:18:39PM -0800, Andrew Morton wrote:

> - The wireless changes in here need a lot of testers, please.  It is major
>   rework.
> 
>   Of course the config files got all changed around so `make oldconfig'
>   breaks everything.  I was able to get ipw2200 working after some fumbling,
>   but perhaps John can tell people what has been changed in there?  What has
>   happened, from a big picture perspective?

Specifically regarding 'make oldconfig', it is mostly a clean-up
to make a distinction between 802.11 wireless LANs and pre-standard
wireless LANs.  Here is the commit message:

	commit 1a9e0dd0bd60474465e0b0f1bca774d8c042d879
	Author: Johannes Berg <johannes@sipsolutions.net>
	Date:   Sat Mar 3 13:06:15 2007 +0100
	
	    [PATCH] rework wireless Kconfig
	
	    This patch
	     * kills NET_RADIO
	     * adds a new "Wireless LAN" menu
	     * adds two new options WLAN_PRE80211 and WLAN_80211 that drivers
	       depend on
	     * makes WIRELESS_EXT visible (to avoid the arguments we had in
	       commit c1783454a31e05b94774951b0b5d1eb9075ebfb4)
	     * changes everything that depended on NET_RADIO to select WIRELESS_EXT
	       and to depend on WLAN_PRE80211 or WLAN_80211
	
	    By removing NET_RADIO, these changes pave the way to making wireless
	    extensions optional when cfg80211 can fully take over for some drivers
	    and you don't have any older drivers that still require wext.

Honestly, I'm tempted to add the pre-802.11 stuff to the features
removal list.  I wonder if any of it still actually works...

As to the larger question of "what is happening w/ wireless in -mm",
I'll add a few words for those who don't know.

As the commit referenced earlier suggests, work is underway on a
new configuration regime for wireless LANs.  This should result in
a cleaner API for driver and userland tool developers, and hopefully
better matches the expected semantics for wireless LAN configuration.
An optional sub-component of that is a compatibility layer for
existing WEXT-based tools, so there should be no need for a wireless
tools "flag day".  Still, hopefully this enables better wireless
configuration/management tools in the future.

In addition, we are adding a new component: mac80211.  This component
implements the higher-layer wireless MAC functionality for those
cards that don't do it in hardware or firmware, as is true for many
new cards.  Traditionally cards with this type of design needed
drivers to implement this functionality themselves.  This resulted
in wretched duplication of effort, varying use of kernel APIs,
and inconsistent support for features of the 802.11 standards.
Providing this infrastructure in the kernel should both reduce the
effort needed to support new hardware and homogenize the user interface
and feature support of the resulting drivers.

The existing ieee80211softmac component provides a small part of the
capabilities of mac80211.  But it is viewed as incomplete and crippled
by its ties to the ieee80211 component, which is really intended more
as a support library for the ipw2x00 drivers rather than a complete
802.11 stack.  Those drivers which depended on ieee80211softmac
have been ported to work w/ mac80211.  And several more drivers have
been added, including adm8211, prism54 (softmac versions, including
USB), and rtl8187, with iwlwifi (IPW3945), rtl-8180/8185, and others
"coming soon" -- stay tuned!

So, things are getting better: better hardware support, better
wireless capabilities, and better tool enablement.  But it is a big
hunk of changes.  So, please do give this code a try!

Thanks,

John

P.S.  If you are afraid of -mm and are a Fedora or RHEL5 user, please
try either the rawhide kernel or my test kernels here:

	http://people.redhat.com/linville/kernels/fc7/
	http://people.redhat.com/linville/kernels/fc6/
	http://people.redhat.com/linville/kernels/rhel5/

-- 
John W. Linville
linville@tuxdriver.com
