Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYCDNzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYCDNzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYCDNzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:55:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYCDNzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:55:42 -0500
Date: Tue, 4 Mar 2008 14:54:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080304135447.GD32383@elte.hu>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303224259.GA27008@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> On Mon, Mar 03, 2008 at 07:25:49AM +0800, Zhang, Rui wrote:
> > Hi, all,
> > 
> > kernel panic on boot when I try to run 2.6.25-rc1 and later, but 2.6.24-rc8 boots okay.
> > The result of git-bisect shows that
> > edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit.
> > 
> > The git-bisect-result and the dmesg log when the kernel panic are 
> > attached. Any help on this please? :)
> 
> Are you using LVM?  If so, please either upgrade your userspace/initrd 
> stuff, or enable CONFIG_SYSFS_DEPCRECATED

we _really_ must handle this differently and this _is_ a regression that 
multiple people have spent hours on bisecting already ...

So "enable CONFIG_SYSFS_DEPCRECATED" is _NOT_ the right answer, and this 
has been pointed out to you in the past.

the problem is that SYSFS_DEPRECATED changed its meaning mid-course. Now 
it means a different set of udev breakages. The correct way is to 
_RENAME_ that darn option to SYSFS_DEPRECATED_V2 (via the patch below), 
and to discontinue the user-configurability of the old SYSFS_DEPRECATED 
option. Viola, things work just fine - and the fact of SYSFS_DEPRECATED 
changing its meaning is documented as well.

this way any tester who comes over the 'make oldconfig' route is not hit 
in the head with a nasty regression ...

tested patch below. (and this is one of those rare cases where 'select' 
is the right thing to do in a Kconfig entry)

	Ingo

---------------------->
Subject: sysfs: CONFIG_SYSFS_DEPRECATED fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Mar 04 14:35:21 CET 2008

CONFIG_SYSFS_DEPRECATED=y changed its meaning recently and causes
regressions in working setups that had SYSFS_DEPRECATED disabled.

so rename it to SYSFS_DEPRECATED_V2 so that testers pick up the new
default via 'make oldconfig', even if their old .config's disabled
CONFIG_SYSFS_DEPRECATED ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -367,9 +367,13 @@ config RESOURCE_COUNTERS
 	depends on CGROUPS
 
 config SYSFS_DEPRECATED
+	bool
+
+config SYSFS_DEPRECATED_V2
 	bool "Create deprecated sysfs files"
 	depends on SYSFS
 	default y
+	select SYSFS_DEPRECATED
 	help
 	  This option creates deprecated symlinks such as the
 	  "device"-link, the <subsystem>:<name>-link, and the
