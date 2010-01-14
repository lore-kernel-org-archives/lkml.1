Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369Ab0ANR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0ANR3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337Ab0ANR3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:29:17 -0500
Received: from GHC07.GHC.ANDREW.CMU.EDU ([128.2.100.140]:48239 "EHLO
	ghc07.ghc.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab0ANR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:29:16 -0500
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 12:29:16 EST
Date: Thu, 14 Jan 2010 12:20:06 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Ben Blum <bblum@andrew.cmu.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-13-12-17 uploaded (cgroup)
Message-ID: <20100114172006.GA8081@ghc07.ghc.andrew.cmu.edu>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
 <20100114080748.4eaf91d6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114080748.4eaf91d6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 08:07:48AM -0800, Randy Dunlap wrote:
> On Wed, 13 Jan 2010 12:17:36 -0800 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-01-13-12-17 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> 
> 
> patch:  cgroups-subsystem-module-unloading.patch
> 
> When CONFIG_MODULE_UNLOAD is not enabled:
> 
> kernel/cgroup.c:1013: error: implicit declaration of function 'module_refcount'
> 
> 
> 
> ---
> ~Randy
> 

Argh, my fault. try_module_get and module_put tricked me by not
depending on that config option while module_refcount did. Fix here:

From: Ben Blum <bblum@andrew.cmu.edu>
Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 391ff41..32e001e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -964,7 +964,9 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			 * drop the extra reference.
 			 */
 			module_put(ss->module);
+#ifdef CONFIG_MODULE_UNLOAD
 			BUG_ON(ss->module && !module_refcount(ss->module));
+#endif
 		} else {
 			/* Subsystem state shouldn't exist */
 			BUG_ON(cgrp->subsys[i]);
