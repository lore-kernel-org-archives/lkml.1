Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbZLAHLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbZLAHLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZLAHLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:11:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZLAHLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:11:12 -0500
Message-ID: <4B14C217.90203@redhat.com>
Date: Tue, 01 Dec 2009 15:13:27 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] percpu: refactor the code in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home> <4B145CE9.1060608@kernel.org> <4B147918.3000503@redhat.com> <4B14A2E6.1070603@kernel.org> <4B14A51E.2090702@kernel.org> <4B14AC35.3020700@redhat.com> <4B14ADE0.3020007@kernel.org> <4B14B936.8080205@redhat.com> <4B14BEB6.5090105@kernel.org>
In-Reply-To: <4B14BEB6.5090105@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------060307030000030902080709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060307030000030902080709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> On 12/01/2009 03:35 PM, Cong Wang wrote:
>> What do you think about the patch below? Untested.
> 
> Oh, yeah, that's prettier.  Just one thing, can you please move rs
> initialization right above the pcpu_next_[un]pop() call?  The
> input/output parameters for those functions are already pretty
> confusing, let's make it at least a bit clearer.
> 

Sure, done.

------------->

Using break statement at the end of a for loop is confusing,
refactor it by replacing the for loop.

Signed-off-by: WANG Cong <amwang@redhat.com>

---


--------------060307030000030902080709
Content-Type: text/plain;
 name="mm-percpu_c-remove-two-useless-break.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-percpu_c-remove-two-useless-break.diff"

diff --git a/mm/percpu.c b/mm/percpu.c
index 5adfc26..2941ed9 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -914,11 +914,10 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	int rs, re;
 
 	/* quick path, check whether it's empty already */
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		if (rs == page_start && re == page_end)
-			return;
-		break;
-	}
+	rs = page_start;
+	pcpu_next_unpop(chunk, &rs, &re, page_end);
+	if (rs == page_start && re == page_end)
+		return;
 
 	/* immutable chunks can't be depopulated */
 	WARN_ON(chunk->immutable);
@@ -969,11 +968,10 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	int rs, re, rc;
 
 	/* quick path, check whether all pages are already there */
-	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end) {
-		if (rs == page_start && re == page_end)
-			goto clear;
-		break;
-	}
+	rs = page_start;
+	pcpu_next_pop(chunk, &rs, &re, page_end);
+	if (rs == page_start && re == page_end)
+		goto clear;
 
 	/* need to allocate and map pages, this chunk can't be immutable */
 	WARN_ON(chunk->immutable);

--------------060307030000030902080709--
