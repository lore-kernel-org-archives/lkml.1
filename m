Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXGRVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXGRVMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbXGRVMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:12:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:53567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbXGRVMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SIADFMS90eDGwI8XEffpssAmvS3YoeQkvW2bN+gQ79oLfIZ8ljl3GXfUTE4XkDtLo/wZF9D55ZHSFeqYkS3KdhgfTfOnq1Co9JEiNRSJbpRfL9EbwSpaAynUpfmw0J5J0avtq+IWB5zoFFTJbzZIxJlnveFqVFI4wRzBiAvz5Eo=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix a use after free bug in kernel->userspace relay file support
Date: Wed, 18 Jul 2007 23:11:10 +0200
User-Agent: KMail/1.9.7
Cc: Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul Mundt <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707182311.10538.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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

Warning: I don't know this code at all and I've only read through 
it quickly to try and work out what to do here, so I'd really 
apreciate it if someone who actually knows how this code should 
behave could ACK or NACK the patch before it gets merged anywhere 
since I did this pretty blind.

Patch has been compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
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


