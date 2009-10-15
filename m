Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbZJOFdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbZJOFdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 01:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZJOFdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 01:33:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:41844 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZJOFdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 01:33:53 -0400
Subject: powerpc problem with .data.page_aligned -> __page_aligned_data
 conversion
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: tabbott@ksplice.com
Cc: sam@ravnborg.org, linuxppc-dev@lists.ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Oct 2009 16:32:52 +1100
Message-Id: <1255584772.2347.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

So I have a problem ... :-)

For some weird reason, our gcc until 4.3 (fixed in 4.3) had the weird
idea that the alignment attribute should not be allowed to force an
alignment greater than 32k. If attempted, it would warn -and- crop the
alignment to 32k.

As you can imagine, this doesn't play terribly well with 64K page size,
which is (sadly) our default on ppc64 on distros nowadays. I know it's
insane but that's what I have to live with...

And of course, our current distros (well, at least RHEL5 which is pretty
common) don't have a fixed gcc.

Until recently, we got away with it because very few people used
__page_aligned and those who did always did it on something that is
naturally a PAGE_SIZE multiple in size. So we just stick the thing into
the appropriate section and that's it.

The new generic macros __page_aligned_data/bss now always add the
alignment directive generically.

This has a few issues for us:

	- The patch that converted bits of powerpc to the new macro break since
it now hits that bug

	- We can't trivially change the macros to not to the align directive on
powerpc, but that's taking the risk that drivers or other pieces of
generic code now assume that they can use __page_aligned_* on a data
structure whose size isn't a multiple of _PAGE_SIZE, since that would
work on all architectures ... except powerpc where it would silently
break by shifting everybody else alignment in that section.

As of today, nothing seems to do that (unless I mis-grepped) though.

What do you recommend I do ? I can ban gcc < 4.3 but that's a bit
harsh :-) I know a few people that won't be happy to be unable to build
newer kernels with current distro gccs.

Or can do the above making the macro definition drop the alignment part
on powerpc. Will work for now, but will require great care to avoid
subtle and nasty breakage (basically same as before)

Or maybe I can do the above but only when using gcc < 4.3 so at least if
the breakage happen, that will only be with older gccs ...

Unless somebody has a better idea ?

Cheers,
Ben.


