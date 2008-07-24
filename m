Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYGXMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYGXMNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYGXMNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:13:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYGXMNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:13:06 -0400
Date: Thu, 24 Jul 2008 05:11:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 22bb1be4d27... breaks hal (and NM)
Message-Id: <20080724051113.fa14f7ec.akpm@linux-foundation.org>
In-Reply-To: <1216900631.7257.321.camel@twins>
References: <20080724115805.5466c217@mjolnir.drzeus.cx>
	<1216899520.13587.49.camel@johannes.berg>
	<1216900631.7257.321.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 13:57:11 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2008-07-24 at 13:38 +0200, Johannes Berg wrote:
> > On Thu, 2008-07-24 at 11:58 +0200, Pierre Ossman wrote:
> > > From commit 22bb1be4d27...:
> > > 
> > > "The /sys/class/net/*/wireless/ direcory is, as far as I know, not used
> > > by anyone."
> > > 
> > > Can't have been much of an investigation as HAL uses these to determine
> > > if a card is a wireless one. Without this option, you cannot get
> > > wireless support in NetworkManager, stranding most laptops.
> > 
> > Bzzzzt. You suck. Go check again. Hint: try hal's git tree.

err,

a) don't be rude

b) what's in various git trees is unuseful for making decisions
   about production kernel features.

otoh the patch seems reasonable.

> So you're not considering HAL as shipped by most (if not all) distros as
> anyone?
>
> If everybody would act like that, the next kernel wouldn't even manage
> to get rudimentary user-space up and running. Like we already changed
> all those systemcalls in glibc-head, who needs this kernel to boot on
> your old stuff anyway..
> 
> Common,.. this is rediculous.

I think you'd have needed to try pretty hard to let this break stuff.

: commit 22bb1be4d271961846cd0889b0f8d671db773080
: Author: Johannes Berg <johannes@sipsolutions.net>
: Date:   Thu Jul 10 11:16:47 2008 +0200
: 
:     wext: make sysfs bits optional and deprecate them
:     
:     The /sys/class/net/*/wireless/ direcory is, as far as I know, not
:     used by anyone. Additionally, the same data is available via wext
:     ioctls. Hence the sysfs files are pretty much useless. This patch
:     makes them optional and schedules them for removal.
:     
:     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
:     Cc: Jean Tourrilhes <jt@hpl.hp.com>
:     Signed-off-by: John W. Linville <linville@tuxdriver.com>
: 
: diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
: index 8319c46..db300e0 100644
: --- a/Documentation/feature-removal-schedule.txt
: +++ b/Documentation/feature-removal-schedule.txt
: @@ -333,3 +333,13 @@ Why:	This option was introduced just to allow older lm-sensors userspace
:  	to keep working over the upgrade to 2.6.26. At the scheduled time of
:  	removal fixed lm-sensors (2.x or 3.x) should be readily available.
:  Who:	Rene Herman <rene.herman@gmail.com>
: +
: +---------------------------
: +
: +What:	Code that is now under CONFIG_WIRELESS_EXT_SYSFS
: +	(in net/core/net-sysfs.c)
: +When:	After the only user (hal) has seen a release with the patches
: +	for enough time, probably some time in 2010.
: +Why:	Over 1K .text/.data size reduction, data is available in other
: +	ways (ioctls)
: +Who:	Johannes Berg <johannes@sipsolutions.net>
: diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
: index 3f79413..c1f4e0d 100644
: --- a/net/core/net-sysfs.c
: +++ b/net/core/net-sysfs.c
: @@ -318,7 +318,7 @@ static struct attribute_group netstat_group = {
:  	.attrs  = netstat_attrs,
:  };
:  
: -#ifdef CONFIG_WIRELESS_EXT
: +#ifdef CONFIG_WIRELESS_EXT_SYSFS
:  /* helper function that does all the locking etc for wireless stats */
:  static ssize_t wireless_show(struct device *d, char *buf,
:  			     ssize_t (*format)(const struct iw_statistics *,
: @@ -459,7 +459,7 @@ int netdev_register_kobject(struct net_device *net)
:  #ifdef CONFIG_SYSFS
:  	*groups++ = &netstat_group;
:  
: -#ifdef CONFIG_WIRELESS_EXT
: +#ifdef CONFIG_WIRELESS_EXT_SYSFS
:  	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
:  		*groups++ = &wireless_group;
:  #endif
: diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
: index 7927090..ab015c6 100644
: --- a/net/wireless/Kconfig
: +++ b/net/wireless/Kconfig
: @@ -29,3 +29,14 @@ config WIRELESS_EXT
:  
:  	  Say N (if you can) unless you know you need wireless
:  	  extensions for external modules.
: +
: +config WIRELESS_EXT_SYSFS
: +	bool "Wireless extensions sysfs files"
: +	default y
: +	depends on WIRELESS_EXT && SYSFS
: +	help
: +	  This option enables the deprecated wireless statistics
: +	  files in /sys/class/net/*/wireless/. The same information
: +	  is available via the ioctls as well.
: +
: +	  Say Y if you have programs using it (we don't know of any).
: 

So if you've enabled CONFIG_WIRELESS_EXT_SYSFS (and it correctly has
default y) then things should continue to work OK.  And the deprecation
date of 2010 sounds reasonable.  In fact generous, for us...

So where's the problem?
