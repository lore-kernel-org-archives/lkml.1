Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYLLOnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYLLOnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYLLOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:42:51 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48021 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYLLOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:42:51 -0500
Date: Fri, 12 Dec 2008 09:40:41 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [mmotm-2008-12-11-15-20] __unsafe() not defined.
Message-ID: <20081212144040.GC2402@hmsreliant.think-freely.org>
References: <200812120209.mBC29Qx5064845@www262.sakura.ne.jp> <20081211181733.7031df32.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211181733.7031df32.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 06:17:33PM -0800, Andrew Morton wrote:
> On Fri, 12 Dec 2008 11:09:26 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> 
> > I got this compilation error using gcc (GCC) 3.3.5 (Debian 1:3.3.5-13).
> > 
> >   drivers/pci/hotplug/ibmphp_core.c: In function `ibmphp_init':
> >   drivers/pci/hotplug/ibmphp_core.c:1409: error: implicit declaration of function `__unsafe'
> >   make[3]: *** [drivers/pci/hotplug/ibmphp_core.o] Error 1
> >   make[2]: *** [drivers/pci/hotplug] Error 2
> >   make[1]: *** [drivers/pci] Error 2
> >   make: *** [drivers] Error 2
> > 
> > "grep -Fr __unsafe ." shows only one line.
> > 
> >   ./drivers/pci/hotplug/ibmphp_core.c:    __unsafe(THIS_MODULE);
> > 
> > Where is __unsafe defined?
> > 
> 
> hm, I wonder what that was all about.
> 
> I'll drop ibmphp-fix-module-ref-count-underflow.patch, thanks.
> 


Apologies, I was working with an old tree.  __unsafe has been deprecated.  To
accomplish the functionality of unsafe, we simply need to not register an exit
routine, as per Adrian Bunks commit when __unsafe was removed.  I'm leaving the
ibmphp_exit function in place though, just in case the author decides later that
it is in fact safe to remove.

New patch attached.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 ibmphp_core.c |    5 -----
 1 file changed, 5 deletions(-)


diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index c892daa..633e743 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -1402,10 +1402,6 @@ static int __init ibmphp_init(void)
 		goto error;
 	}
 
-	/* lock ourselves into memory with a module 
-	 * count of -1 so that no one can unload us. */
-	module_put(THIS_MODULE);
-
 exit:
 	return rc;
 
@@ -1423,4 +1419,3 @@ static void __exit ibmphp_exit(void)
 }
 
 module_init(ibmphp_init);
-module_exit(ibmphp_exit);
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
