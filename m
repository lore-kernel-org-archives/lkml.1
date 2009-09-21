Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZIUOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZIUOY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZIUOY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:24:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:32871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbZIUOY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:24:26 -0400
Message-ID: <4AB78C67.4060304@kernel.org>
Date: Mon, 21 Sep 2009 23:23:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix error handling in load_module()
References: <20090907141558.GA5456@linux.vnet.ibm.com> <20090910141430.a00dcc94.akpm@linux-foundation.org> <200909212030.03648.rusty@rustcorp.com.au>
In-Reply-To: <200909212030.03648.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 14:23:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
>> My reverse engineering of the secret, undocumented percpu_modfree()
>> indicates that its mad inventor intended that percpu_modfree(NULL) be a
>> valid thing to do.
> 
> Yes, percpu_modfree() should handle NULL.  If it doesn't, that's the bug.

Hmm... It seems the report was against pre-2.6.32-rcX window.  ppc is
still using the original percpu_modfree() and I don't think the it
ever supported NULL free.  In the current linus tree, the triggering
BUG() would be at line 500 which is inside percpu_modfree() which
checks @freeme matches any allocated address and if not triggers
BUG().

I think something like the following should fix it.

 kernel/module.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 05ce49c..eed1f9e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -490,6 +490,9 @@ static void percpu_modfree(void *freeme)
 	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
 	int cpu;

+	if (unlikely(!freeme))
+		return;
+
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
 		if (ptr == freeme) {

-- 
tejun
