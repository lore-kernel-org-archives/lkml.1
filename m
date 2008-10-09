Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYJIApv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYJIApv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbYJIApD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:45:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:2702 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547AbYJIApA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WIR0OKHIx7vwx4tlJ2W664Fxs3DmaiVy7Qnp5X/r8iqP0EIjnyFvnulS1uxcKM+ZY9
         z8jtGMcHTUe0XKsT9n8v+pU84Dx0bDFJzwVLHtCkUw57nv9KSbOxqVbUN/Ve8fqCdTVC
         0N2IZIpb77aQeDZcqzRHyy5HAa7cZvvyeSuRA=
Subject: Re: [patch] clean hex output of ftrace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
In-Reply-To: <Pine.LNX.4.30.0810081715520.2487-100000@perches.com>
References: <Pine.LNX.4.30.0810081715520.2487-100000@perches.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 17:44:55 -0700
Message-Id: <1223513095.8195.113.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 17:16 -0700, Joe Perches wrote:
> On Wed, 8 Oct 2008, Harvey Harrison wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > Subject: [PATCH] ftrace: Fix inversion of hex output and use common routines
> 
> You're quick...
> 
> >  	BUG_ON(len >= HEX_CHARS);
> 
> I think the BUG_ON is senseless.
> 

Agreed, it probably meant to say BUG_ON(len * 2 > HEX_CHARS -1)

But as this is only called from within a helper macro, it could be
changed to a build-time check instead of a runtime:

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] trace: add build-time check to avoid overrunning hex buffer

Remove the runtime BUG_ON and change to a compile-time check in
the macro that calls the hex format routine

[Noticed by Joe Perches]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 763f763..1ffbc24 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -395,7 +395,8 @@ trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
 	return len;
 }
 
-#define HEX_CHARS 17
+#define MAX_MEMHEX_BYTES	(8)
+#define HEX_CHARS		((MAX_MEMHEX_BYTES * 2) + 1)
 
 static int
 trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
@@ -404,8 +405,6 @@ trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 	unsigned char *data = mem;
 	int i, j;
 
-	BUG_ON(len >= HEX_CHARS);
-
 #ifdef __BIG_ENDIAN
 	for (i = 0, j = 0; i < len; i++) {
 #else
@@ -1706,6 +1705,7 @@ do {							\
 
 #define SEQ_PUT_HEX_FIELD_RET(s, x)			\
 do {							\
+	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
 	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
 		return 0;				\
 } while (0)
-- 
1.6.0.2.471.g47a76



