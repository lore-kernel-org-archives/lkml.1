Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYKZI1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYKZI1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYKZI1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:27:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:31633 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKZI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HwQPIBh0PcszH346YF/5a5uT1MbmEpv3JNaEDbuwfV3KceNF0EKQ0eXha5HaEdysXK
         99xAH1rj2YLwHEynGQ2vLPqdyrBssv9cF0CIYVfg0UuLUwe+4TYp8q8LDr48i+iEOGqj
         45B49ALJaFsCjLzfd3yLZn47yuhzVNHfnC9Q0=
Subject: Re: [PATCH 2/5] ftrace: use code patching for ftrace graph tracer
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20081126000430.5c19e189.akpm@linux-foundation.org>
References: <20081126051622.134970943@goodmis.org>
	 <20081126051709.774546196@goodmis.org>
	 <20081125213546.ff4eddf4.akpm@linux-foundation.org>
	 <1227682349.5511.47.camel@brick>
	 <20081126000430.5c19e189.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 00:27:04 -0800
Message-Id: <1227688024.5511.56.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 00:04 -0800, Andrew Morton wrote:
> On Tue, 25 Nov 2008 22:52:29 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > > > +	if (code[0] != 0xe9 || old_offset != *(int *)(&code[1]))
> > > 
> > > erk.  I suspect that there's a nicer way of doing this amongst our
> > > forest of get_unaligned_foo() interfaces.  Harvey will know.
> > > 
> > 
> > if (code[0] != 0xe9 || old_offset != get_unaligned((int *)(&code[1])))
> 
> urgh, OK, that didn't really improve anything except to document
> something which was already rather obvious.
> 

Yeah, it really isn't that great.  It could be somewhat nicer if we had
the API for host-endian taking void and being explicit about the size:

if (code[0] != 0xe9 || old_offset != load32_noalign(&code[1]))

This is similar to the new API in -mm load_le32_noalign, but I
don't think it would be worth load_u32_noalign...load32 should
be enough.

> > > > +		return -EINVAL;
> > > > +
> > > > +	*(int *)(&code[1]) = new_offset;
> > > 
> > > Might be able to use put_unaligned_foo() here.
> > > 
> > 
> > 	put_unaligned(new_offset, (int *)(&code[1]));
> > 

In a similar vein to above, this becomes:

	store32_noalign(&code[1], new_offset);

I rather like this as it would allow most (if not all) of the figure
out what size based on pointer type versions to be chucked.

Turns out all the pieces are there in -mm that the patch is pretty
trivial (not for application, just a heads-up):

 include/asm-generic/unaligned.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index d2f3998..5a055f7 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -343,9 +343,23 @@ extern void __bad_unaligned_access_size(void);
 #ifdef __LITTLE_ENDIAN
 # define get_unaligned __get_unaligned_le
 # define put_unaligned __put_unaligned_le
+
+# define load16_noalign(p) load_le16_noalign((void *)(p))
+# define load32_noalign(p) load_le32_noalign((void *)(p))
+# define load64_noalign(p) load_le64_noalign((void *)(p))
+# define store16_noalign(p, val) store_le16_noalign((void *)(p), (val))
+# define store32_noalign(p, val) store_le32_noalign((void *)(p), (val))
+# define store64_noalign(p, val) store_le64_noalign((void *)(p), (val))
 #else
 # define get_unaligned __get_unaligned_be
 # define put_unaligned __put_unaligned_be
+
+# define load16_noalign(p) load_be16_noalign((void *)(p))
+# define load32_noalign(p) load_be32_noalign((void *)(p))
+# define load64_noalign(p) load_be64_noalign((void *)(p))
+# define store16_noalign(p, val) store_be16_noalign((void *)(p), (val))
+# define store32_noalign(p, val) store_be32_noalign((void *)(p), (val))
+# define store64_noalign(p, val) store_be64_noalign((void *)(p), (val))
 #endif
 
 #endif /* _ASM_GENERIC_UNALIGNED_H */
-- 
1.6.0.4.1044.g77718



