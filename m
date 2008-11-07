Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYKGTup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYKGTup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYKGTuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:50:35 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:10930 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYKGTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a2s8vNrwPDP98fbklfjIzZOAWRdoCN9QNsWLIllhMGB9R4zCiEOeepDSs18y4/1xvP
         GijX9GKU2JOpZXZIAIdp40W/LUARdRrlC2v26VK8SgIm4ISRr//nIoUByERABSxAJHuV
         Qck7P44VAi1FEPL0ZGVFihxW7FkiXj6nqntdI=
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Eduard Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081107193823.GA32761@Krystal>
References: <1226084321.11596.37.camel@brick>
	 <20081107192029.GA4001@x200.localdomain> <1226085759.11596.43.camel@brick>
	 <20081107193823.GA32761@Krystal>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 11:50:29 -0800
Message-Id: <1226087429.11596.53.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 14:38 -0500, Mathieu Desnoyers wrote:
> I think a cast
> 
> (__force unsigned) could be required for checker ?

No, that's not the way bitwise works.  Printk will treat it as an
unsigned it just fine.  bitwise will only warn if you treat the value
as anything other than a bitmask (| & ^) will be fine as long as it
is done with another gfp_t....all the arithmatic operators +-* etc
will warn.

The following looks like the correct way to fix this.

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] kmemtrace: gfp_t is an unsigned int, not an unsigned long

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kmemtrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
index 5bea8ea..80e9a7a 100644
--- a/include/linux/kmemtrace.h
+++ b/include/linux/kmemtrace.h
@@ -31,10 +31,10 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
 					     int node)
 {
 	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
-		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
+		   "bytes_req %lu bytes_alloc %lu gfp_flags %u node %d",
 		   type_id, call_site, (unsigned long) ptr,
 		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
-		   (unsigned long) gfp_flags, node);
+		   gfp_flags, node);
 }
 
 static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-- 
1.6.0.3.756.gb776d



