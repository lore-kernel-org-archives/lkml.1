Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYCJJuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYCJJuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 05:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYCJJun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 05:50:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36705 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967AbYCJJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 05:50:43 -0400
Date: Mon, 10 Mar 2008 09:37:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080310093737.3c1e938a@core>
In-Reply-To: <200803100123.51395.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<Pine.LNX.4.63.0803100847000.3335@alpha>
	<200803100123.51395.phillips@phunq.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Usual block device semantics are preserved so long as UPS power does
> not run out before emergency writeback completes.  It is not possible
> to order writes to the backing store and still deliver ramdisk level
> write latency to the application.

Why - your chunks simply become a linked list in write barrier order.
Solve your bitmap sweep cost as well. As you are already making a copy
before going to backing store you don't have the internal consistency
problems of further writes during the I/O.

Yes you may need to throttle in the specific case of having too many
copies of pages sitting in the queue - but surely that would be the set of
pages that are written but not yet committed from a previous store
barrier ?

BTW: I'm also curious why you made it a block device. What does that
offer over say ramfs + dnotify and a userspace daemon or perhaps for big
files to work smoothly a ramfs variant that keeps dirty bitmaps on file
pages. That way write back would be file level and while you might lose
changesets that have not been fsync()'d your underlying disk fs would
always be coherent.

Alan
