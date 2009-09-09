Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZIITia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZIITia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZIITi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:38:29 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45445 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752349AbZIITi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:38:28 -0400
Date: Wed, 9 Sep 2009 14:38:30 -0500
From: Jack Steiner <steiner@sgi.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Daniel Walker <dwalker@fifo99.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset registers
Message-ID: <20090909193829.GB10530@sgi.com>
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop> <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop> <4AA7F9E5.4070506@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA7F9E5.4070506@nortel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 12:54:29PM -0600, Chris Friesen wrote:
> On 09/09/2009 12:11 PM, Daniel Walker wrote:
> > On Wed, 2009-09-09 at 13:01 -0500, Jack Steiner wrote:
> >> Volatile is being added to the accessor functions that are used to
> >> read/write memory-mapped I/O registers located within the UV chipset.
> >> The use of volatile is hidden within the functions and is not exposed
> >> to the users of the functions.
> >>
> >> Note that the use is limited to the accessor functions in the header
> >> file. No .c files are changed or need to know about volatile.
> >>
> >>
> >> This seems to be consistent with other uses of volatile within the kernel.
> > 
> > The document that I cited specifically addresses memory accessors as not
> > needing the volatile keyword .. So your still not addressing exactly why
> > your code needs it .. Are your accessors special in some way? Is there
> > some defect your seeing without the volatile keyword?
> 
> 
> >From that document:
> 
> "There are still a few rare situations where volatile makes sense in the
> kernel:
> 
>   - The above-mentioned accessor functions might use volatile on
>     architectures where direct I/O memory access does work.
>     Essentially, each accessor call becomes a little critical section
>     on its own and ensures that the access happens as expected by the
>     programmer."
> 
> 
> However, the fact that these functions are returning volatile pointers
> is a bit sketchy.  Normally accesses to such memory would be wrapped
> entirely in a read/write function which would handle the volatility
> internally to the function.
> 
> In this case there's no point in the function returning a "volatile
> unsigned long *" if it's going to be cast to a volatile pointer before
> being dereferenced.

make sense.

How is this..... Avoids adding volatile to any return types.
--------------------------------------------------------


Add "volatile" to the SGI UV read/write macros that are used to access chipset
memory mapped registers.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/include/asm/uv/uv_hub.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-09-09 01:34:02.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-09-09 14:36:23.000000000 -0500
@@ -258,13 +258,13 @@ static inline unsigned long *uv_global_m
 static inline void uv_write_global_mmr32(int pnode, unsigned long offset,
 				 unsigned long val)
 {
-	*uv_global_mmr32_address(pnode, offset) = val;
+	*(volatile unsigned long *)uv_global_mmr32_address(pnode, offset) = val;
 }
 
 static inline unsigned long uv_read_global_mmr32(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr32_address(pnode, offset);
+	return *(volatile unsigned long *)uv_global_mmr32_address(pnode, offset);
 }
 
 /*
@@ -281,13 +281,13 @@ static inline unsigned long *uv_global_m
 static inline void uv_write_global_mmr64(int pnode, unsigned long offset,
 				unsigned long val)
 {
-	*uv_global_mmr64_address(pnode, offset) = val;
+	*(volatile unsigned long *)uv_global_mmr64_address(pnode, offset) = val;
 }
 
 static inline unsigned long uv_read_global_mmr64(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr64_address(pnode, offset);
+	return *(volatile unsigned long *)uv_global_mmr64_address(pnode, offset);
 }
 
 /*
@@ -301,22 +301,22 @@ static inline unsigned long *uv_local_mm
 
 static inline unsigned long uv_read_local_mmr(unsigned long offset)
 {
-	return *uv_local_mmr_address(offset);
+	return *(volatile unsigned char *)uv_local_mmr_address(offset);
 }
 
 static inline void uv_write_local_mmr(unsigned long offset, unsigned long val)
 {
-	*uv_local_mmr_address(offset) = val;
+	*(volatile unsigned char *)uv_local_mmr_address(offset) = val;
 }
 
 static inline unsigned char uv_read_local_mmr8(unsigned long offset)
 {
-	return *((unsigned char *)uv_local_mmr_address(offset));
+	return *((volatile unsigned char *)uv_local_mmr_address(offset));
 }
 
 static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
 {
-	*((unsigned char *)uv_local_mmr_address(offset)) = val;
+	*((volatile unsigned char *)uv_local_mmr_address(offset)) = val;
 }
 
 /*
