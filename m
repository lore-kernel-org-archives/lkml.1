Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbXHLKfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbXHLKfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbXHLKfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:35:03 -0400
Received: from [212.12.190.60] ([212.12.190.60]:33048 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570AbXHLKfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:35:00 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: [RFD] Layering: Use-Case Composers (was: DRBD - what is it, anyways? [compare with e.g. NBD + MD raid])
Date: Sun, 12 Aug 2007 13:35:17 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       linux-raid@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708121335.17267.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Ellenberg wrote:
> meanwhile, please, anyone interessted,
> the drbd paper for LinuxConf Eu 2007 is finalized.
> http://www.drbd.org/fileadmin/drbd/publications/
> drbd8.linux-conf.eu.2007.pdf
>
> it does not give too much implementation detail (would be inapropriate
> for conference proceedings, imo; some paper commenting on the source
> code should follow).
>
> but it does give a good overview about what DRBD actually is,
> what exact problems it tries to solve,
> and what developments to expect in the near future.
>
> so you can make up your mind about
>  "Do we need it?", and
>  "Why DRBD? Why not NBD + MD-RAID?"

Ok, conceptually your driver sounds really interresting, but when I read the 
pdf I got completely turned off.  The problem is that the concepts are not 
clearly implemented, when in fact the concepts are really simple:

  Allow shared access to remote block storage with fault tolerance.

The first thing to tackle here would be write serialization.  Then start 
thinking about fault tolerance.

Now, shared remote block access should theoretically be handled, as does 
DRBD, by a block layer driver, but realistically it may be more appropriate 
to let it be handled by the combining end user, like OCFS or GFS.

The idea here is to simplify lower layer implementations while removing any 
preconceived dependencies, and let upper layers reign free without incurring 
redundant overhead.

Look at ZFS; it illegally violates layering by combining md/dm/lvm with the 
fs, but it does this based on a realistic understanding of the problems 
involved, which enables it to improve performance, flexibility, and 
functionality specific to its use case.

This implies that there are two distinct forces at work here:

  1. Layer components
  2. Use-Case composers

Layer components should technically not implement any use case (other than 
providing a plumbing framework), as that would incur unnecessary 
dependencies, which could reduce its generality and thus reusability.

Use-Case composers can now leverage layer components from across the layering 
hierarchy, to yield a specific use case implementation.

DRBD is such a Use-Case composer, as is mdm / dm / lvm and any fs in general, 
whereas aoe / nbd / loop and the VFS / FUSE are examples of layer 
components.

It follows that Use-case composers, like DRBD, need common functionality that 
should be factored out into layer components, and then recompose to 
implement a specific use case.


Thanks!

--
Al

