Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382Ab0AINpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0AINpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160Ab0AINpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:45:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:65455 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0AINpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:45:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,247,1262592000"; 
   d="scan'208";a="585754584"
Date: Sat, 9 Jan 2010 21:44:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
Message-ID: <20100109134456.GC20015@localhost>
References: <20100106065526.GB11368@localhost> <adahbqzvhgn.fsf@roland-alpha.cisco.com> <20100106162004.GA11773@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106162004.GA11773@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 12:20:04AM +0800, Jamie Lokier wrote:
> Roland Dreier wrote:
> > 
> >  > +	/* please add new bits here to ensure allocation uniqueness */
> >  > +	BUG_ON(20 != hweight32(
> >  > +		O_RDONLY	| O_WRONLY	| O_RDWR	|
> > 
> > I wonder if there's a way to make this BUILD_BUG_ON(), so the problem is
> > caught at compile time (a change like adding an O_ flag is often compile
> > tested only for obscure archs).  One could create a compile-time
> > macro-ized version of hweight32() and use that, I guess, although I'm
> > not sure it's worth the ugliness.
> 
> Not ugly at all:
> 
> #define hweight32(x) __builtin_popcount(x)
> 
> Checked GCC 3.4.3 / 4.1 / 4.4: It expands as a compile-time constant
> if the argument is a compile-time constant, so can be used in
> BUILD_BUG_ON() and even for array sizes etc.
> 
> If GCC's __builtin_popcount() isn't good enough for non-constant
> values, the macro would be more involved:
> 
> #define hweight32(x) (__builtin_constant_p(x) ? __builtin_popcount(x) \
>                       : hweight32_nonconstant(x))

Jamie, Thanks for the hint!  Would you sign this patch?

---
bitops: compile time optimization for hweight_long(CONSTANT)

This allows use of hweight_long() in BUILD_BUG_ON().
Suggested by Jamie.

CC: Jamie Lokier <jamie@shareable.org>
CC: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/bitops.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- linux.orig/include/linux/bitops.h	2010-01-09 12:13:00.000000000 +0800
+++ linux/include/linux/bitops.h	2010-01-09 12:21:50.000000000 +0800
@@ -40,10 +40,14 @@ static __inline__ int get_count_order(un
 	return order;
 }
 
-static inline unsigned long hweight_long(unsigned long w)
-{
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
-}
+#define hweight_long(x)				\
+(						\
+	__builtin_constant_p(x) ?		\
+		__builtin_popcountl(x) :	\
+		(sizeof(x) <= 4 ?		\
+			 hweight32(x) :		\
+			 hweight64(x))		\
+)
 
 /**
  * rol32 - rotate a 32-bit value left
