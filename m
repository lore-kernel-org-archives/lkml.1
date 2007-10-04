Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXJDItU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXJDItU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXJDItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:49:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbXJDItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:49:11 -0400
Date: Thu, 4 Oct 2007 01:48:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: 2.6.23-rc8 build failure: __you_cannot_kmalloc_that_much in
 dmi_id_init
Message-Id: <20071004014828.1bc971c8.akpm@linux-foundation.org>
In-Reply-To: <20071002232642.568ea660@hyperion.delvare>
References: <20071001225447.20f989aa@hyperion.delvare>
	<20071001235412.0737de78@hyperion.delvare>
	<20071002232642.568ea660@hyperion.delvare>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 23:26:42 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> On Mon, 1 Oct 2007 23:54:12 +0200, Jean Delvare wrote:
> > On Mon, 1 Oct 2007 22:54:47 +0200, Jean Delvare wrote:
> > > 2.6.23-rc8 and 2.6.23-rc8-git4 fail to build on one of my test
> > > machines, with:
> > > 
> > > drivers/built-in.o(.init.text+0x780e): In function `dmi_id_init':
> > > : undefined reference to `__you_cannot_kmalloc_that_much'
> > > 
> > > The code is allocating sizeof(struct device) so it really shouldn't be
> > > a problem. I have no idea what's wrong. That's on i386, very old
> > > machine (Pentium 166MMX / Intel TX chipset), with gcc 3.2.3 and
> > > binutils 2.14.90.0.6. 2.6.22.9 compiles fine on the same system (but it
> > > doesn't include dmi-id so it's not very surprising).
> > > 
> > > .config attached.
> > 
> > More information: building the same config on a much more recent system
> > works fine. This seems to point at a toolchain issue.
> 
> More information:
> * No improvement in 2.6.23-rc9.
> * Building the same config on a different system with the same
>   toolchain, fails the same. So it's not just one system acting weirdly,
>   the bug can be reproduced.
> * I tried arbitrary values for the kzalloc() in dmi-id.c, the bottom line
>   is that anything above 64 bytes triggers the bug.
> * The same kzalloc() in a different driver doesn't trigger the bug.
> 
> I'm puzzled, no idea what to try next.
> 

Yeah, the tricks we play in there do fool some versions of gcc, and you see
the result.

Roland came up with this:

--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -145,7 +145,7 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 	 * testing it here shouldn't be needed.  But some versions of gcc need
 	 * help.
 	 */
-	if (__builtin_constant_p(size) && index < 0) {
+	if (__builtin_constant_p(index) && index < 0) {
 		/*
 		 * Generate a link failure. Would be great if we could
 		 * do something to stop the compile here.



Does it fix things for you?
