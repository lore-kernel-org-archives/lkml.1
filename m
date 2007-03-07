Return-Path: <linux-kernel-owner+w=401wt.eu-S2992538AbXCGWzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992538AbXCGWzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992536AbXCGWzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:55:19 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:15429 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992700AbXCGWzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:55:17 -0500
Subject: Re: [PATCH] remove_arg_zero() rewrite
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr =?ISO-8859-1?Q?Tesa=5F=5F=EDk?= <ptesarik@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20070307144101.f97cfa53.akpm@linux-foundation.org>
References: <1171978145.22720.21.camel@golias.tesarici.cz>
	 <20070221154159.d316d526.akpm@linux-foundation.org>
	 <1173305397.4868.4.camel@lappy>
	 <20070307144101.f97cfa53.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 23:55:12 +0100
Message-Id: <1173308113.4868.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 14:41 -0800, Andrew Morton wrote:
> On Wed, 07 Mar 2007 23:09:57 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2007-02-21 at 15:41 -0800, Andrew Morton wrote:
> > 
> > > I mean.... what the hell?
> > > 
> > > As you appear to have managed to work out what the sorry thing is trying to
> > > do, would you have time to simply rip it out and completely rewrite it,
> > > including a nice comment telling the world what this function's function is?
> > > 
> > > Because what we have there is beyond repairing.
> > 
> > Something like so?
> > Boots uml seemingly without errors.
> > 
> > ---
> > Rewrite remove_arg_zero() to be more parseable by untwisted minds.
> > 
> 
> Sorry, Nick already had a go at this:

Darn, must've fell off of lkml... or I missed it catching up my 4000+
email backlog.

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm2/broken-out/exec-fix-remove_arg_zero.patch
> 
> But your patch has a nice comment and has to be better ;)

Ah, but now I finally see the initial problem.

My patch is bug compatible and doesn't free the head page when that
becomes unused.

This should do on top:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2007-03-07 23:51:31.000000000 +0100
+++ linux-2.6/fs/exec.c	2007-03-07 23:50:41.000000000 +0100
@@ -1011,6 +1011,11 @@ void remove_arg_zero(struct linux_binprm
 			;
 
 		kunmap_atomic(kaddr, KM_USER0);
+
+		if (offset == PAGE_SIZE) {
+			__free_page(page);
+			bprm->page[(bprm->p >> PAGE_SHIFT) - 1] = NULL;
+		}
 	} while (offset == PAGE_SIZE);
 
 	bprm->p++;




