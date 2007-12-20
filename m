Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbXLTAHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbXLTAHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXLTAHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:07:47 -0500
Received: from namei.org ([69.55.235.186]:38144 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753819AbXLTAHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:07:46 -0500
Date: Thu, 20 Dec 2007 11:07:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Chinner <dgc@sgi.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>
Subject: Re: [patch, rfc] mm.h, security.h, key.h and preventing namespace
 poisoning
In-Reply-To: <20071219093834.GW4396912@sgi.com>
Message-ID: <Xine.LNX.4.64.0712201052110.1736@us.intercode.com.au>
References: <20071219093834.GW4396912@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, David Chinner wrote:

> Folks,
> 
> I just updated a git tree and started getting errors on a
> "copy_keys" macro warning.
> 
> The code I've been working on uses a ->copy_keys() method for
> copying the keys in a btree block from one place to another. I've
> been working on this code for a while
> (http://oss.sgi.com/archives/xfs/2007-11/msg00046.html) and keep the
> tree I'm working in reletively up to date (lags linus by a couple of
> weeks at most). The update I did this afternoon gave a conflict
> warning with the macro in include/linux/key.h.
> 
> Given that I'm not directly including key.h anywhere in the XFS
> code, I'm getting the namespace polluted indirectly from some other
> include that is necessary.
> 
> As it turns out, this commit from 13 days ago:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7cd94146cd504016315608e297219f9fb7b1413b
> 
> included security.h in mm.h and that is how I'm seeing the namespace
> poisoning coming from key.h when !CONFIG_KEY.
> 
> Including security.h in mm.h means much wider includes for pretty
> much the entire kernel, and it opens up namespace issues like this
> that never previously existed.
> 
> The patch below (only tested for !CONFIG_KEYS && !CONFIG_SECURITY)
> moves security.h into the mmap.c and nommu.c files that need it so
> it doesn't end up with kernel wide scope.
> 
> Comments?

The idea with this placement was to keep memory management code with other 
similar code, rather than pushing it into security.h, where it does not 
functionally belong.

Something to not also is that you can't "depend" on security.h not being 
included all over the place, as LSM does touch a lot of the kernel.  
Unecessarily including it is bad, of course.

I'm not sure I understand your namespace pollution issue, either.

In any case, I think the right solution is not to include security.h at 
all in mm.h, as it is only being done to get a declaration for 
mmap_min_addr.

How about this, instead ?

Signed-off-by: James Morris <jmorris@namei.org>
---

 mm.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b7b95c..02fbac7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -12,7 +12,6 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
-#include <linux/security.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -34,6 +33,10 @@ extern int sysctl_legacy_va_layout;
 #define sysctl_legacy_va_layout 0
 #endif
 
+#ifdef CONFIG_SECURITY
+extern unsigned long mmap_min_addr;
+#endif
+
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>


-- 
James Morris
<jmorris@namei.org>
