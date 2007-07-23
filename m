Return-Path: <linux-kernel-owner+w=401wt.eu-S934930AbXGWUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934930AbXGWUcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762318AbXGWUcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:32:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48081 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759535AbXGWUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:32:07 -0400
Date: Mon, 23 Jul 2007 13:32:06 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] fix slub krealloc()
Message-ID: <20070723133206.2220db7e@schroedinger.engr.sgi.com>
In-Reply-To: <1184773331.4002.4.camel@johannes.berg>
References: <1184773331.4002.4.camel@johannes.berg>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 17:42:11 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Commit ef2ad80c7d255ed0449eda947c2d700635b7e0f5 breaks
> krealloc(NULL, ...) badly, it BUG_ON()s.
> 
> This patch fixes it but the fix should probably be in mm/util.c
> because the documentation says that krealloc(NULL, x, gfp) is
> equivalent to kmalloc(x, gfp) and that's not true any more even after
> this patch when you do krealloc(NULL, 0, gfp)

Right. We need to fix util.c. ksize should not be called with a NULL
parameter.
Index: linux-2.6/mm/util.c
===================================================================
--- linux-2.6.orig/mm/util.c	2007-07-23 13:29:42.000000000 -0700
+++ linux-2.6/mm/util.c	2007-07-23 13:31:28.000000000 -0700
@@ -88,7 +88,11 @@ void *krealloc(const void *p, size_t new
 		return ZERO_SIZE_PTR;
 	}
 
-	ks = ksize(p);
+	if (p)
+		ks = ksize(p);
+	else
+		ks = 0;
+
 	if (ks >= new_size)
 		return (void *)p;
 
