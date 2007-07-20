Return-Path: <linux-kernel-owner+w=401wt.eu-S934751AbXGTBJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751AbXGTBJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbXGTBJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:09:13 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:56302 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758206AbXGTBJM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:09:12 -0400
Date: Thu, 19 Jul 2007 21:09:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Tom Zanussi <zanussi@us.ibm.com>,
       Karim Yaghmour <karim@opersys.com>, Jesper Juhl <jesper.juhl@gmail.com>,
       "David J. Wilder" <wilder@us.ibm.com>
Subject: [PATCH] Fix a use after free bug in kernel->userspace relay file support
Message-ID: <20070720010909.GA4298@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:04:17 up 2 days, 19:38,  2 users,  load average: 0.16, 0.88, 0.68
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity spotted what looks like a real possible case of using a 
variable after it has been freed.
The problem is in kernel/relay.c::relay_open_buf()

If the code hits "goto free_buf;" it ends up in this code :

  free_buf:
    	relay_destroy_buf(buf);	<--- calls kfree() on 'buf'.
  free_name:
   	kfree(tmpname);
  end:
  	return buf;		<-- use after free of 'buf'.

I read through the callers and they all handle a NULL return 
from this function as an error (and hitting the 'free_buf' label 
only happens on failure to chan->cb->create_buf_file(), so that 
looks like a clear error to me). 

The patch simply sets 'buf' to NULL after the call to 
relay_destroy_buf(buf); - as far as I can see that should take 
care of the problem.

The patch also corrects a reference to a documentation file while 
I was at it.

Note from Mathieu: the documentation reference change should have been
done in a separate patch, but I guess no one will really care.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: "David J. Wilder" <wilder@us.ibm.com>
Tested-by: "David J. Wilder" <wilder@us.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

diff --git a/kernel/relay.c b/kernel/relay.c
index a615a8f..c55e399 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1,7 +1,7 @@
 /*
  * Public API and common code for kernel->userspace relay file support.
  *
- * See Documentation/filesystems/relayfs.txt for an overview of relayfs.
+ * See Documentation/filesystems/relay.txt for an overview.
  *
  * Copyright (C) 2002-2005 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
  * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
@@ -427,6 +427,7 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
 
 free_buf:
  	relay_destroy_buf(buf);
+ 	buf = NULL;
 free_name:
  	kfree(tmpname);
 end:
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
