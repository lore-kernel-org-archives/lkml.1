Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbZCRQtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbZCRQtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZCRQtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:49:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:34176 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZCRQtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:49:40 -0400
Subject: Re: oops in tracepoint_update_probe_range() (was: Re: [oops -tip]
 : x86 AMD 64)
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090318163531.GE21331@elte.hu>
References: <1237393396.3322.6.camel@localhost.localdomain>
	 <20090318163531.GE21331@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 22:18:56 +0530
Message-Id: <1237394936.3132.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 17:35 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Good: f4c3c4cdb1de232
> > Bad : 1e08816af0bc345
> > 
> > Config:
> > http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
> > 
> > oops:
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
> > 
> > <freeze>
> 
> Steve, Frederic - the crashes above are in:
> 
> 	tracepoint_update_probe_range()
> 
> in a modular kernel apparently.
> 

This fixed the oops for me, Is this looks OK to you:

Subject: [PATCH] x86: tracepoint.c fix oops

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff8107d4de>] tracepoint_update_probe_range+0x1f/0x9b
PGD 13d5fb067 PUD 13d688067 PMD 0
Oops: 0000 [#1] SMP

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 kernel/tracepoint.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 7960274..80d1353 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -280,6 +280,8 @@ void tracepoint_update_probe_range(struct tracepoint *begin,
 
 	mutex_lock(&tracepoints_mutex);
 	for (iter = begin; iter < end; iter++) {
+		if (!iter)
+			goto out;
 		mark_entry = get_tracepoint(iter->name);
 		if (mark_entry) {
 			set_tracepoint(&mark_entry, iter,
@@ -288,6 +290,7 @@ void tracepoint_update_probe_range(struct tracepoint *begin,
 			disable_tracepoint(iter);
 		}
 	}
+out:
 	mutex_unlock(&tracepoints_mutex);
 }
 
-- 
1.6.0.6



