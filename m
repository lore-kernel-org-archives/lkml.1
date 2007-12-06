Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbXLFCCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbXLFCCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXLFCCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:02:05 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:42588 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXLFCCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:02:03 -0500
Message-ID: <475757DD.8000009@ak.jp.nec.com>
Date: Thu, 06 Dec 2007 11:01:01 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: serge@hallyn.com
CC: Andrew Morgan <morgan@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability	bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com> <4754F053.8060303@kernel.org> <4755701C.7070407@ak.jp.nec.com> <20071204201709.GA9915@vino.hallyn.com>
In-Reply-To: <20071204201709.GA9915@vino.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> (Thus, the correct check says no 'new' pI bits can be outside cap_bset.)
>> If this condition intends to dominate 'new' pI bits by 'old' pI bits masked
>> with bounding set, we should not apply cap_combine() here.
>> I think applying cap_intersect() is correct for the purpose.
> 
> That would have been my first inclination, but Andrew actually
> wanted to be able to keep a pI with bits not in the capability
> bounding set.  And it's really not a big problem, since
> 
> 	1. you can never grow cap_bset
> 	2. the capbound.c program just makes sure to call capset
> 	   to take the bit being removed from cap_bset out of
> 	   pI'
> 	3. It could be advantageous for some daemon to keep a bit
> 	   in pI which can never be gained through fP but can be
> 	   gained by a child through (fI&pI).
> 
> Does that seem reasonable to you?

OK, I got understood the intention of the condition.
It seems to me reasonable policy.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>


This patch fixes incorrect condition added by per-process capability
bounding set patch.
It intends to limit no new pI capabilities outside bounding set.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>

  commoncap.c |    6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc3/security/commoncap.c.old	2007-12-06 10:51:48.000000000 +0900
+++ linux-2.6.24-rc3/security/commoncap.c	2007-12-06 10:52:15.000000000 +0900
@@ -119,9 +119,9 @@ int cap_capset_check (struct task_struct
  		/* incapable of using this inheritable set */
  		return -EPERM;
  	}
-	if (!!cap_issubset(*inheritable,
-			   cap_combine(target->cap_inheritable,
-				       current->cap_bset))) {
+	if (!cap_issubset(*inheritable,
+			  cap_combine(target->cap_inheritable,
+				      current->cap_bset))) {
  		/* no new pI capabilities outside bounding set */
  		return -EPERM;
  	}

