Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXLEHz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXLEHz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXLEHzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:47 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/18] remove nopage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes the 'nopage' from the tree.

I've gone through all the drivers and converted them to use fault as best
I can. When using fault, I've also tried to use vmf->pgoff rather than the
virtual address to index the content (which is preferred). Mostly it has
been OK, but DRM is a bit difficult, as it seems to use vma->vm_pgoff as
a 2nd dimension of addressing, so it remains unconverted.

I've also done some other things while going through at the code...

Converted incorrect OOM returns to SIGBUS.  OOM should only be returned as a
result of a memory allocation failure. We will actually want the fault path OOM
handling to be unified with the normal OOM killing path in future, and so
OOMing when we should be SIGBUSing means the box will panic if panic_on_oom is
set, or it will oom-kill random processes before retrying the fault, etc.
SIGBUS means something like "physical address (ie. after translation) does not
exist", which is appropriate AFAIKS in all cases I've converted.

Got rid of some bogus looking "disallow mremap" checks that just check for
address > vma->vm_end. Presumably this is supposed to prevent an mremap
expanding the mapping outside the limit of the underlying resource, but
actually mremap will update vma->vm_end, and anyway this condition is already
checked in the page fault code. Others seem to get this right by checking the
underlying resource itself. Others don't seem to even care.

There looks like a fair number of corruption / security problems with mremap,
so I've done an audit of the tree and tried to plug them.

-- 


