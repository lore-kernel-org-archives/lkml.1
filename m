Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZBZQln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZBZQln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZBZQld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:41:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbZBZQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:41:32 -0500
Date: Thu, 26 Feb 2009 08:40:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>
Subject: Re: [git pull] DVB + ieee1394: firedtv driver
In-Reply-To: <49A6BC72.5050206@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.2.00.0902260824470.3111@localhost.localdomain>
References: <tkrat.847a062a8a488f0d@s5r6.in-berlin.de> <20090226013708.GA16892@elte.hu> <49A6BC72.5050206@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Stefan Richter wrote:
> 
> Alas I have no Linux box at hand before Saturday.  I wonder, was
> ieee1394_bus_type not yet registered (i.e. ieee1394's ieee1394_init() not yet
> called) at the moment when fdtv_init is executed?
> 
> Or what else could have been the NULL pointer dereference in driver_find?

Afaik, the only way that NULL pointer dereference can happen is if

	struct kobject *k = kset_find_obj(bus->p->drivers_kset, name);

gets a NULL pointer exception either because of a NULL "bus" pointer as 
the argument, or if "bus->p" is NULL.

And in this case, it's the latter. The Code: decode shows the whole 
function in this case:

  1c:	55                   	push   %rbp
  1d:	89 e5                	mov    %esp,%ebp
  1f:	e8 34 5f c8 ff       	callq  0xffffffffffc85f58
  24:	89 c1                	mov    %eax,%ecx
  26:	8b 42 38             	mov    0x38(%rdx),%eax
  29:	89 ca                	mov    %ecx,%edx
  2b:*	8b 40 54             	mov    0x54(%rax),%eax     <-- trapping instruction
  2e:	e8 6c 48 f9 ff       	callq  0xfffffffffff9489f
  33:	31 d2                	xor    %edx,%edx
  35:	85 c0                	test   %eax,%eax
  37:	74 03                	je     0x3c
  39:	8b 50 6c             	mov    0x6c(%rax),%edx
  3c:	5d                   	pop    %rbp
  3d:	89 d0                	mov    %edx,%eax
  3f:	c3                   	retq   

and that first "callq" seems to be due to Ingo having function tracing on, 
while the second callq would have been that 'kset_find_obj()' thing.

So it does look like "&ieee1394_bus_type" has simply not been initialized 
yet. It looks like ieee1394_init() is called too late.

Two choices that I can see:

 - do the ieee1394_init() as a fs_initcall(), earlier

 - move drivers/ieee1394 linking up to before drivers/media

but I suspect that drivers/media wants to be early, in order to do the 
_media_ layer initialization early.

Does this work?

		Linus

---
 drivers/ieee1394/ieee1394_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index 1028e72..8723380 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -1275,7 +1275,7 @@ static void __exit ieee1394_cleanup(void)
 	unregister_chrdev_region(IEEE1394_CORE_DEV, 256);
 }
 
-module_init(ieee1394_init);
+fs_initcall(ieee1394_init);
 module_exit(ieee1394_cleanup);
 
 /* Exported symbols */
