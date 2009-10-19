Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbZJSSTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbZJSSTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZJSSTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:19:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56056 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZJSSTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:19:44 -0400
Subject: Re: linux-next: tree build failure
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
       linuxppc-dev@lists.ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <4AD6EB17020000780001A050@vpn.id2.novell.com>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	 <1254267572.15622.1621.camel@slab.beaverton.ibm.com>
	 <4AC318450200007800017355@vpn.id2.novell.com>
	 <1254498517.3839.17.camel@slab.beaverton.ibm.com>
	 <4AC9B5310200007800017EA1@vpn.id2.novell.com>
	 <1255115648.2546.71.camel@slab.beaverton.ibm.com>
	 <1255561026.29192.0.camel@slab.beaverton.ibm.com>
	 <4AD6EB17020000780001A050@vpn.id2.novell.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 19 Oct 2009 11:19:29 -0700
Message-Id: <1255976369.13995.98.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 08:27 +0100, Jan Beulich wrote:
> >>> Hollis Blanchard <hollisb@us.ibm.com> 15.10.09 00:57 >>>
> >On Fri, 2009-10-09 at 12:14 -0700, Hollis Blanchard wrote:
> >> Rusty's version of BUILD_BUG_ON() does indeed fix the build break, and
> >> also exposes the bug in kvmppc_account_exit_stat(). So to recap:
> >> 
> >> original: built but didn't work
> >> Jan's: doesn't build
> >> Rusty's: builds and works
> >> 
> >> Where do you want to go from here?
> >
> >Jan, what are your thoughts? Your BUILD_BUG_ON patch has broken the
> >build, and we still need to fix it.
> 
> My perspective is that it just uncovered already existing brokenness. And
> honestly, I won't be able to get to look into this within the next days. (And
> btw., when I run into issues with other people's code changes, quite
> frequently I'm told to propose a patch, so I'm also having some
> philosophical problem understanding why I can't simply expect the same
> when people run into issues with changes I made, especially in cases like
> this where it wasn't me introducing the broken code.) So, if this can wait
> for a couple of days, I can try to find time to look into this. Otherwise, I'd
> rely on someone running into the actual issue to implement a solution.

Sorry, I thought it was clear, but to be more explicit: I propose the
following patch, which replaces the current BUILD_BUG_ON implementation
with Rusty's version.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -677,18 +677,19 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
-
-/* Force a compilation error if condition is constant and true */
-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+/* If it's a constant, catch it at compile time, otherwise at link time. */
+extern int __build_bug_on_failed;
+#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+#define BUILD_BUG_ON(condition) \
+		do {                                                            \
+				((void)sizeof(char[1 - 2*!!(condition)]));              \
+				if (condition) __build_bug_on_failed = 1;               \
+		} while(0)
+#define MAYBE_BUILD_BUG_ON(condition) BUILD_BUG_ON(condition)
+#endif
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)


-- 
Hollis Blanchard
IBM Linux Technology Center

