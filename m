Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYJHXwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYJHXwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYJHXvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:51:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:58690 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbYJHXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gNxRwIif93f4akp6I0T+xB7VwrFNed2HLEz51BThFG82m/zFV+R0Vla7fUzuq2jodx
         fJRCAz/NdaIw1zl/Np72mH9B4FgMerEdTxndbNk5o2Y6jROS2Dpsiorp7U0JOFe3ENWf
         1CyzhOvUHvaf3S6F8Uux3M2+vNlZQAxdZc4UY=
Subject: Re: [patch] clean hex output of ftrace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: trem <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.30.0810081515510.1836-100000@perches.com>
References: <Pine.LNX.4.30.0810081515510.1836-100000@perches.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 16:51:49 -0700
Message-Id: <1223509909.8195.101.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 15:22 -0700, Joe Perches wrote:
> I'm surprised Harvey Harrison hasn't changed it to pack_hex_byte
> and removed the static.
> 

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] ftrace: Fix inversion of hex output and use common routines

Fix the output of ftrace in hex mode as the hi/lo nibbles are output in
reverse order. Without this patch, the output of ftrace is:

raw mode : 6474 0 141531612444 0 140 + 6402 120 S
hex mode : 000091a4 00000000 000000023f1f50c1 00000000 c8 000000b2 00009120 87 ffff00c8 00000035

There is an inversion on ouput hex(6474) is 194a

[based on a patch by Philippe Reynes <tremyfr@yahoo.fr>]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/trace/trace.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8f3fb3d..763f763 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -396,14 +396,12 @@ trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
 }
 
 #define HEX_CHARS 17
-static const char hex2asc[] = "0123456789abcdef";
 
 static int
 trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 {
 	unsigned char hex[HEX_CHARS];
 	unsigned char *data = mem;
-	unsigned char byte;
 	int i, j;
 
 	BUG_ON(len >= HEX_CHARS);
@@ -413,10 +411,8 @@ trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 #else
 	for (i = len-1, j = 0; i >= 0; i--) {
 #endif
-		byte = data[i];
-
-		hex[j++] = hex2asc[byte & 0x0f];
-		hex[j++] = hex2asc[byte >> 4];
+		hex[j++] = hex_asc_hi(data[i]);
+		hex[j++] = hex_asc_lo(data[i]);
 	}
 	hex[j++] = ' ';
 
-- 
1.6.0.2.471.g47a76



