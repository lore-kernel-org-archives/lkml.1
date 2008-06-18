Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYFRR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYFRR40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYFRRz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:55:57 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51618 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbYFRRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:55:55 -0400
Subject: Re: 2.6.26-rc5-mm3
From: Daniel Walker <dwalker@mvista.com>
To: Byron Bradley <byron.bbradley@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Hua Zhong <hzhong@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.1.00.0806130006490.14928@gamma>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	 <alpine.DEB.1.00.0806130006490.14928@gamma>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 10:55:51 -0700
Message-Id: <1213811751.11203.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-13 at 00:32 +0100, Byron Bradley wrote:
> Looks like x86 and ARM both fail to boot if PROFILE_LIKELY, FTRACE and 
> DYNAMIC_FTRACE are selected. If any one of those three are disabled it 
> boots (or fails in some other way which I'm looking at now). The serial 
> console output from both machines when they fail to boot is below, let me 
> know if there is any other information I can provide.

I was able to reproduce a hang on x86 with those options. The patch
below is a potential fix. I think we don't want to trace
do_check_likely(), since the ftrace internals might use likely/unlikely
macro's which will just cause recursion back to do_check_likely()..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 lib/likely_prof.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.25/lib/likely_prof.c
===================================================================
--- linux-2.6.25.orig/lib/likely_prof.c
+++ linux-2.6.25/lib/likely_prof.c
@@ -22,7 +22,7 @@
 
 static struct likeliness *likeliness_head;
 
-int do_check_likely(struct likeliness *likeliness, unsigned int ret)
+int notrace do_check_likely(struct likeliness *likeliness, unsigned int ret)
 {
 	static unsigned long likely_lock;
 


