Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZGaXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZGaXol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 19:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZGaXok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 19:44:40 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42271 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbZGaXoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 19:44:38 -0400
Date: Fri, 31 Jul 2009 19:44:17 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Richard Henderson <rth@twiddle.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: use .data.init_task instead of
 .data.init_thread.
In-Reply-To: <4A736460.5070509@twiddle.net>
Message-ID: <alpine.DEB.1.10.0907311746020.2539@vinegar-pot.mit.edu>
References: <1249073786-29788-1-git-send-email-tabbott@ksplice.com> <4A7360C3.2060507@twiddle.net> <4A736460.5070509@twiddle.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Richard Henderson wrote:

> On 07/31/2009 02:23 PM, Richard Henderson wrote:
> > Similarly it is *not* a bug that the page_aligned sections were before
> > data, because we already knew we had 2 page alignment from the end of
> > init + 2 pages of init_thread.
> 
> Indeed, I'll go further and say that the common definition of RW_DATA_SECTION
> is buggy.
[...]
> Given that we align the entire .data section why have interior padding to
> re-align for page-aligned data?  Surely a better ordering would be
[...]

Agreed.  I actually commented on this issue in one of the drafts of 
RW_DATA_SECTION, but forgot to check again whether Sam had addressed it 
when reviewing the final version.  Fortunately we're talking about a small 
inefficiency, not something more serious.  Below is your proposed change 
in patch form; I hope Sam will take a look at it.

	-Tim Abbott

Optimize the ordering of sections in RW_DATA_SECTION.

The current RW_DATA_SECTION macro doesn't place the various 
PAGE_SIZE-aligned sections next to each other.  This could result in up to 
a page of memory being wasted realigning to PAGE_SIZE twice.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 include/asm-generic/vmlinux.lds.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6ad76bf..146815d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -706,12 +706,12 @@
 	. = ALIGN(PAGE_SIZE);						\
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
 		INIT_TASK_DATA(inittask)				\
+		NOSAVE_DATA						\
+		PAGE_ALIGNED_DATA(pagealigned)				\
 		CACHELINE_ALIGNED_DATA(cacheline)			\
 		READ_MOSTLY_DATA(cacheline)				\
 		DATA_DATA						\
 		CONSTRUCTORS						\
-		NOSAVE_DATA						\
-		PAGE_ALIGNED_DATA(pagealigned)				\
 	}
 
 #define INIT_TEXT_SECTION(inittext_align)				\
-- 
1.6.3.3

