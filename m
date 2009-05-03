Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZECMY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZECMY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 08:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZECMYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 08:24:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59097 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbZECMYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 08:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=g4ZXSvGe9NvaFt0Wr4jBkiYQuh+iGISHdKtQw6JygGeXpA9+HEQDuycDMI9c/XUYu9
         EFsmyH/VZt/nxWm5h20lh/uJKZREONcdF/B/cI/HIwChwmzVwmcy5WM9LX5j46O0MV6H
         d5LiQYcakNo5gZduf/n2Qq/Tx9NFamjLNEVF4=
Date: Sun, 3 May 2009 16:12:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
	uv_system_init
Message-ID: <20090503121228.GC4615@lenovo>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu> <20090501200937.GD4633@lenovo> <20090501202511.GE4633@lenovo> <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu> <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com> <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Sun, May 03, 2009 at 12:59:13PM +0300]
| Hi David,
| 
| On Sun, May 3, 2009 at 12:09 PM, David Rientjes <rientjes@google.com> wrote:
| > SLUB stores two new slab allocation orders: the cache's adjustable order
| > which is calculated at kmem_cache_create(), and the smallest order that
| > can accommodate at least one object allocation.  The latter is used as a
| > fallback when the former fails in the page allocator.
| >
| > So for __GFP_PANIC to work in this case, it could not be implemented in
| > the page allocator (SLUB also passes __GFP_NORETRY for new slabs) but
| > rather above it in allocate_slab().  It would then be a no-op for
| > alloc_pages().
| 
| It's probably better to implement __GFP_PANIC in alloc_pages() because
| of kmalloc_large(). You can easily mask the __GFP_PANIC from the first
| call to alloc_slab_page() where we use __GFP_NOWARN to suppress
| out-of-memory warnings.
| 
| But anyway, enough talk, show me the patch! :-)
| 
|                                           Pekka
| 

I was thinking about the approach showed below.

Note even if we will agree on this idea a number
of questions remain opened -- like where is a better
place to define kmalloc_panic in slub/slab_def.h
or rather in slab.h. Should we include kernel.h
to have panic and pr_ properly defined?

I don't dare start/introduce handling of __GFP_PANIC
flag since it would require more efforts to be done
correctly and what is more important -- for most
cases we would just don't need it.

	-- Cyrill

---
 include/linux/slab_def.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6.git/include/linux/slab_def.h
=====================================================================
--- linux-2.6.git.orig/include/linux/slab_def.h
+++ linux-2.6.git/include/linux/slab_def.h
@@ -220,4 +220,16 @@ found:
 
 #endif	/* CONFIG_NUMA */
 
+static inline void *kmalloc_panic(size_t size, gfp_t flags)
+{
+	void *p = kmalloc(size, flags);
+
+	if (size && ZERO_OR_NULL_PTR(p)) {
+		pr_emerg("Failed to allocate: %z bytes\n", size);
+		panic("Out of memory\n");
+	}
+
+	return p;
+}
+
 #endif	/* _LINUX_SLAB_DEF_H */
