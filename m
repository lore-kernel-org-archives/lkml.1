Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZBBA1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZBBA1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 19:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZBBA12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 19:27:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:60012 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZBBA11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 19:27:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=pLpV/PBDcpSCwBf58NCfdlHqZF2NtVGLMIXRlJMjRrRciXrdo4idtKnvcQp1d9UQo
	WSCOoNn4PnASmiKjDK9lA==
Date: Sun, 1 Feb 2009 16:26:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sven Wegener <sven.wegener@stealer.net>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix dirty_bytes/dirty_background_bytes sysctls on
 64bit arches
In-Reply-To: <alpine.LNX.2.00.0902010218350.6140@titan.stealer.net>
Message-ID: <alpine.DEB.2.00.0902011618090.21172@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com> <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com> <alpine.LNX.2.00.0902010218350.6140@titan.stealer.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.77
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Sven Wegener wrote:

> We need to pass an unsigned long as the minimum, because it gets casted
> to an unsigned long in the sysctl handler. If we pass an int, we'll
> access four more bytes on 64bit arches, resulting in a random minimum
> value.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>

Acked-by: David Rientjes <rientjes@google.com>


You'll also need the following since vm_dirty_bytes is declared as an 
unsigned long.  Andrew, can you queue Sven's fix for rc4 with this folded 
into it?

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -209,7 +209,7 @@ int dirty_bytes_handler(struct ctl_table *table, int write,
 		struct file *filp, void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int old_bytes = vm_dirty_bytes;
+	unsigned long old_bytes = vm_dirty_bytes;
 	int ret;
 
 	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
