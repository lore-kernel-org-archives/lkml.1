Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZBFAAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZBFAAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZBEX74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:59:56 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:51553 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756004AbZBEX7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:59:54 -0500
Date: Thu, 5 Feb 2009 18:54:33 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Robin Holt <holt@sgi.com>
cc: linux-mm@kvack.org, aarcange@redhat.com, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] mmu_notifiers destroyed by __mmu_notifier_release()
 retain extra mm_count.
In-Reply-To: <20090205200214.GN8577@sgi.com>
Message-ID: <alpine.DEB.1.10.0902051844390.17441@qirst.com>
References: <20090205172303.GB8559@sgi.com> <alpine.DEB.1.10.0902051427280.13692@qirst.com> <20090205200214.GN8577@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Robin Holt wrote:

> On Thu, Feb 05, 2009 at 02:30:29PM -0500, Christoph Lameter wrote:
> > The drop of the refcount needs to occur  after the last use of
> > data in the mmstruct because mmdrop() may free the mmstruct.
>
> Not this time.  We are being called from process termination and the
> calling function is assured to hold one reference count.

Maybe add a comment that says that this is a requirement for the
caller? mmdrop() has logic to free the mmstruct.

One also needs to wonder why we acquire the refcount for the mmu
notifier on the mmstruct at all. Maybe remove the

	atomic_inc()

from mmu_notifier_register() instead? Looks strange there especially since
we have a BUG_ON there as well that verifies that the number of refcount
is already above 0.

How about this patch instead?


Subject: mmu_notifier: Remove superfluous increase of the mm refcount

The mm refcount is handled by the caller of mmu_notifier_register and
mmu_notifier_unregister(). There is no need to increase the refcount.
Increasing the refcount led to a memory leak.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/mm/mmu_notifier.c
===================================================================
--- linux-2.6.orig/mm/mmu_notifier.c	2009-02-05 17:55:27.000000000 -0600
+++ linux-2.6/mm/mmu_notifier.c	2009-02-05 17:55:31.000000000 -0600
@@ -167,7 +167,6 @@
 		mm->mmu_notifier_mm = mmu_notifier_mm;
 		mmu_notifier_mm = NULL;
 	}
-	atomic_inc(&mm->mm_count);

 	/*
 	 * Serialize the update against mmu_notifier_unregister. A



