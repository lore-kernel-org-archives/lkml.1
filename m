Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbXFAWRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbXFAWRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXFAWRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:17:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbXFAWRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:17:01 -0400
Date: Fri, 1 Jun 2007 15:16:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601151649.bb23c6f9.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<466081DE.70205@goop.org>
	<Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
	<20070601135900.ec44b1aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 14:45:27 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 1 Jun 2007, Andrew Morton wrote:
> 
> > Poisoning and redzoning could have caught that.
> 
> Redzoning would not have caught it. This was a kmalloc allocation and 
> SLAB always gave them 32 bytes to play with. Only writes more than 32 
> bytes behind would have been caught.
> 
> Poisoning is only applicable to unallocated objects and these were 
> allocated.

Nope and nope.

This is a special case where the user asked for zero bytes and the kernel
gave him 8 (or 32) bytes instead.

If slab was smart enough, it would have poisoned those 8 bytes to some
known pattern, and then checked that they still had that pattern when the
memory got freed again.

But it isn't smart enough, so the bug went undetected.

As I said, it's specific to the kmalloc(0) problem, and we're fixing that
by other means anyway.

