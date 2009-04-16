Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZDPU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZDPU5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZDPU5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:57:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44270 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbZDPU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:57:20 -0400
Date: Thu, 16 Apr 2009 21:55:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, arjan@linux.intel.com,
       gregkh@suse.de, alan@lxorguk.ukuu.org.uk, viro@ZenIV.linux.org.uk,
       jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Please revert kobject_uevent UMH_NO_WAIT
In-Reply-To: <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp>
Message-ID: <Pine.LNX.4.64.0904162145130.645@blonde.anvils>
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp>
 <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk>
 <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
 <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk>
 <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
 <200904150328.n3F3S0F9083222@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904152036150.27354@blonde.anvils>
 <200904160046.n3G0ki9o028612@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904160551080.28048@blonde.anvils>
 <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please revert commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
"kobject: don't block for each kobject_uevent".

Tetsuo Handa, running a kernel with CONFIG_DEBUG_PAGEALLOC=y
and CONFIG_UEVENT_HELPER_PATH=/sbin/hotplug, has been hitting RCU
detected CPU stalls: it's been spinning in the loop where do_execve()
counts up the args (but why wasn't fixup_exception working? dunno).

The recent change, switching kobject_uevent_env() from UMH_WAIT_EXEC
to UMH_NO_WAIT, is broken: the exec uses args on the local stack here,
and an env which is kfreed as soon as call_usermodehelper() returns.
It very much needs to wait for the exec to be done.

Or keep the UMH_NO_WAIT, and complicate the code to allocate and free
these resources correctly?  No, as GregKH pointed out when making the
commit, CONFIG_UEVENT_HELPER_PATH="" is a much better optimization -
though some distros are still saying /sbin/hotplug in their .config,
yet with no such binary in their initrd or their root.

Or...

[PATCH] revert kobject_uevent UMH_NO_WAIT

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 lib/kobject_uevent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.30-rc2/lib/kobject_uevent.c	2009-04-08 18:20:24.000000000 +0100
+++ linux/lib/kobject_uevent.c	2009-04-16 20:31:17.000000000 +0100
@@ -258,7 +258,7 @@ int kobject_uevent_env(struct kobject *k
 			goto exit;
 
 		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_NO_WAIT);
+					     env->envp, UMH_WAIT_EXEC);
 	}
 
 exit:
