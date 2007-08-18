Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXHRVch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXHRVch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 17:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbXHRVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 17:32:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39177 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbXHRVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 17:32:25 -0400
Date: Sat, 18 Aug 2007 14:31:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
	issue
Message-ID: <20070818213141.GW3672@sequoia.sous-sol.org>
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org> <200708181149.48217.ak@suse.de> <20070818203230.GV3672@sequoia.sous-sol.org> <alpine.LFD.0.999.0708181355280.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708181355280.30176@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Sat, 18 Aug 2007, Chris Wright wrote:
> > > 
> > > Check the latest git head. Does it still break?
> > 
> > Yeah, this is the latest git.  The broken commit is Rusty's patch which,
> > after Linus reverted the write-protected remap changes, is no longer
> > necessary.  AFAICT patching is writing garbage into the insn stream.
> > I suspect it's copying an uninitialized temp buffer.
> 
> Can you send me the revert patch that is verified to work?

Now that I understand the problem, I do have a very simple (slightly
overkill) fix for paravirt patching.  This can be cleaned up to avoid
the copies when they aren't needed, but that will take a little more
auditing of the various patchers.  If you still prefer a revert I've
got one handy, and we can re-visit this all post .23.

thanks,
-chris
--

Subject: [PATCH] x86: properly initialize temp insn buffer for paravirt patching 
From: Chris Wright <chrisw@sous-sol.org>

With commit ab144f5ec64c42218a555ec1dbde6b60cf2982d6 the patching code
now collects the complete new instruction stream into a temp buffer
before finally patching in the new insns.  In some cases the paravirt
patchers will choose to leave the patch site unpatched (length mismatch,
clobbers mismatch, etc).  This causes the new patching code to copy an
uninitialized temp buffer, i.e. garbage, to the callsite.  Simply make
sure to always initialize the buffer with the original instruction stream.
A better fix is to audit all the patchers and return proper length so that
apply_paravirt() can skip copies when we leave the patch site untouched.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/i386/kernel/alternative.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
index 1b66d5c..9f4ac8b 100644
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -366,6 +366,8 @@ void apply_paravirt(struct paravirt_patch_site *start,
 		unsigned int used;
 
 		BUG_ON(p->len > MAX_PATCH_LEN);
+		/* prep the buffer with the original instructions */
+		memcpy(insnbuf, p->instr, p->len);
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, insnbuf,
 					  (unsigned long)p->instr, p->len);
 
