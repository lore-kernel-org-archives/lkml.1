Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYLPT6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYLPT6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYLPT6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:58:32 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34590 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbYLPT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:58:31 -0500
Date: Tue, 16 Dec 2008 14:56:20 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: greg@kroah.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] ibmphp: Fix module ref count underflow
Message-ID: <20081216195620.GA10231@hmsreliant.think-freely.org>
References: <20081210194334.GA25257@hmsreliant.think-freely.org> <200812161042.09345.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161042.09345.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 10:42:08AM -0800, Jesse Barnes wrote:
> On Wednesday, December 10, 2008 11:43 am Neil Horman wrote:
> > Hey-
> > 	I happened to notice that the ibmphp hotplug driver does something
> > rather silly in its init routine.  It purposely calls module_put so as to
> > underflow its module ref count to avoid being removed from the kernel. 
> > This is bad practice, and wrong, since it provides a window for subsequent
> > module_gets to reset the refcount to zero, allowing an unload to race in
> > and cause all sorts of mysterious panics.  If the module is unsafe to load,
> > it should inform the kernel as such with a call to __unsafe.  The patch
> > below does that.
> 
> Thanks Neil, applied this to my for-linus branch since it sounds potentially 
> serious (but also low risk since who uses ibmphp anymore? :)
> 
Dang it!  Sorry, Jesse.  Yes, youre absolutely right, it is low risk.  It really
just a bit of sillyness all around.

Unfortunately, I took part in the sillyness.  The problem was reported to me on
RHEL, and I tested there, without checking upstream too closely.  As  aresult,
the patch I gave you is a bit out of date, and won't compile.  I've tested the
new patch here much more closely.  apologies.  I informed akpm who was looking
at it, but neglected to copy you.

This patch corrects the same problem in that it prevents module unloads in a
sane fashion, by not registering an exit routine

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
> Jesse
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
