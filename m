Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbYDYIBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbYDYIBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbYDYIBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:01:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYDYIA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:00:58 -0400
Date: Fri, 25 Apr 2008 10:00:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, tomas.winkler@intel.com,
       linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       mabbas@linux.intel.com, ischram@telenet.be, rjw@sisk.pl,
       ivdoorn@gmail.com
Subject: Re: [build bug] drivers/built-in.o: In function
	`rt2x00leds_resume': : undefined reference to `led_classdev_resume'
Message-ID: <20080425080033.GA14121@elte.hu>
References: <20080420081302.GA11954@elte.hu> <20080420.020557.231970202.davem@davemloft.net> <20080425073504.GA12549@elte.hu> <20080425.003947.72853787.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425.003947.72853787.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> This was reported elsewhere as well.
> 
> I was sure that the patch below fixed it.
> 
> I don't understand how it can still fail, unless the problem is that 
> selecting "FOO" does not take care to enable any dependencies of 
> "FOO".

yeah, i think that's a fundamental property of select: it does _not_ 
select the sub-dependencies. randconfig found that combination rather 
well it seems:

 # CONFIG_IWLWIFI_LEDS is not set
 # CONFIG_IWL4965_LEDS is not set
 # CONFIG_IWL3945_LEDS is not set
 CONFIG_RT2X00_LIB_LEDS=y
 # CONFIG_RT61PCI_LEDS is not set
 CONFIG_RT73USB_LEDS=y
 # CONFIG_NEW_LEDS is not set
 CONFIG_LEDS_CLASS=y

this weakness of select is the major reason why "select is evil" has 
been propagated.

personally i always considered this a Kconfig bug - although it's 
probably not an easy issue to solve. (what if there are conflicts? What 
if a driver's select choice disables another driver, without the user 
being openly aware of this side-effect?)

the patch below fixes it here but it's still kind of a band-aid - what 
if the Kconfig structure of LEDS get modified - does that have to be 
propagated to all LEDS using drivers? I dont think this necessity of 
open-coded dependency resolution is maintainable in the long run.

	Ingo

----------------->
Subject: rt2x00: leds fix
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 09:41:26 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/wireless/rt2x00/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/net/wireless/rt2x00/Kconfig
===================================================================
--- linux.orig/drivers/net/wireless/rt2x00/Kconfig
+++ linux/drivers/net/wireless/rt2x00/Kconfig
@@ -62,6 +62,7 @@ config RT2400PCI_LEDS
 	bool "RT2400 leds support"
 	depends on RT2400PCI
 	select LEDS_CLASS
+	select NEW_LEDS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -89,6 +90,7 @@ config RT2500PCI_LEDS
 	bool "RT2500 leds support"
 	depends on RT2500PCI
 	select LEDS_CLASS
+	select NEW_LEDS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -118,6 +120,7 @@ config RT61PCI_LEDS
 	bool "RT61 leds support"
 	depends on RT61PCI
 	select LEDS_CLASS
+	select NEW_LEDS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -135,6 +138,7 @@ config RT2500USB_LEDS
 	bool "RT2500 leds support"
 	depends on RT2500USB
 	select LEDS_CLASS
+	select NEW_LEDS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
@@ -154,6 +158,7 @@ config RT73USB_LEDS
 	bool "RT73 leds support"
 	depends on RT73USB
 	select LEDS_CLASS
+	select NEW_LEDS
 	select RT2X00_LIB_LEDS
 	---help---
 	  This adds support for led triggers provided my mac80211.
