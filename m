Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbZJFOqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbZJFOqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbZJFOqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:46:43 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46628 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853AbZJFOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:46:42 -0400
Date: Tue, 6 Oct 2009 10:37:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: wireless/kbuild tree build failure
Message-ID: <20091006143754.GB2911@tuxdriver.com>
References: <20091006161639.85e731bb.sfr@canb.auug.org.au> <20091006141057.GA2911@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006141057.GA2911@tuxdriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 10:10:58AM -0400, John W. Linville wrote:
> On Tue, Oct 06, 2009 at 04:16:39PM +1100, Stephen Rothwell wrote:
> > Hi John,
> > 
> > Today's linux-next build (i386 defconfig) failed like this:
> > 
> > net/wireless/ethtool.c:1:30: error: linux/utsrelease.h: No such file or directory
> > net/wireless/ethtool.c: In function 'cfg80211_get_drvinfo':
> > net/wireless/ethtool.c:13: error: 'UTS_RELEASE' undeclared (first use in this function)
> > 
> > Caused by commit fdd4b63be177e74b9346a557b75f4b48f3a42ee1 ("wireless:
> > implement basic ethtool support for cfg80211 devices").
> > 
> > utsrelease.h is now in include/generated after commit
> > bbae701f7f258b051ed199ef71c5e85e683c0fb8 ("kbuild: move utsrelease.h to
> > include/generated") from the kbuild tree.  (My other builds only worked
> > because utsrelease.h was left over in include/linux from previous builds.)
> > 
> > I have reverted the kbuild commit for today.  Sam, we need to come up
> > with a better solution ... maybe for one release we could have the old
> > files including the new files ... maybe remove the old files after
> > 2.6.33-rc2 ...
> 
> It looks like not much uses utsrelease.h -- should I be using something
> else to get a version identifier for the running kernel?

Looks like this would be better...forgive me for being way behind
the times!

diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index bec385c..ca4c825 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -1,4 +1,4 @@
-#include <linux/utsrelease.h>
+#include <linux/utsname.h>
 #include <net/cfg80211.h>
 #include "ethtool.h"
 
@@ -10,7 +10,7 @@ static void cfg80211_get_drvinfo(struct net_device *dev,
 	strlcpy(info->driver, wiphy_dev(wdev->wiphy)->driver->name,
 		sizeof(info->driver));
 
-	strlcpy(info->version, UTS_RELEASE, sizeof(info->version));
+	strlcpy(info->version, init_utsname()->release, sizeof(info->version));
 
 	if (wdev->wiphy->fw_version[0])
 		strncpy(info->fw_version, wdev->wiphy->fw_version,
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
