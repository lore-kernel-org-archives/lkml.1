Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbXJBMKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbXJBMKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXJBMKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:10:13 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:55755 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbXJBMKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:10:11 -0400
Date: Tue, 2 Oct 2007 08:10:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: Christoph Hellwig <hch@infradead.org>, Mike Mason <mmlnx@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Linux Kernel Markers - Alignment Fix
Message-ID: <20071002121008.GA20843@Krystal>
References: <20070928142845.795281397@polymtl.ca> <20070928143159.299956378@polymtl.ca> <1191116135.26950.54.camel@localhost.localdomain> <20070930140013.GB16981@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070930140013.GB16981@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:58:38 up 64 days, 12:17,  1 user,  load average: 1.10, 1.69, 1.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers - Alignment Fix

Fix the alignment of the struct marker declaration in the trace_mark() macro.
Otherwise, we run into problems on 64 bits architectures where the struct marker
structure is bigger than 32 bytes : gcc becomes alignment-happy and align these
structures on 32 bytes while the iteration on the markers is itself only aligned
on 8 bytes, as specified by the type attribute. Specifying the alignmentof the
type only is not enough to restrain gcc happiness; we must specify a variable
alignment attribute too.

This bug causes NULL pointer dereference at module load time on x86_64
when we load marker-example.ko.

Thanks to Mike Mason for reporting this.

It applies to 2.6.23-rc8-mm2, after the linux kernel markers coding style
fixes. This is an important bugfix that should be merged with the
markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
CC: Mike Mason <mmlnx@us.ibm.com>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 include/linux/marker.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-10-02 07:33:21.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-10-02 07:33:58.000000000 -0400
@@ -58,7 +58,7 @@ struct marker {
 		__attribute__((section("__markers_strings")))		\
 		= format;						\
 		static struct marker __mark_##name			\
-		__attribute__((section("__markers"))) =			\
+		__attribute__((section("__markers"), aligned(8))) =	\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
 		asm volatile ("" : : "i" (&__mark_##name));		\
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
