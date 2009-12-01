Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZLAGdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZLAGdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZLAGds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:33:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZLAGdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:33:47 -0500
Message-ID: <4B14B936.8080205@redhat.com>
Date: Tue, 01 Dec 2009 14:35:34 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] percpu: explain quick paths in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home> <4B145CE9.1060608@kernel.org> <4B147918.3000503@redhat.com> <4B14A2E6.1070603@kernel.org> <4B14A51E.2090702@kernel.org> <4B14AC35.3020700@redhat.com> <4B14ADE0.3020007@kernel.org>
In-Reply-To: <4B14ADE0.3020007@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------080900060102000006050609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080900060102000006050609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Hello,
> 
> On 12/01/2009 02:40 PM, Cong Wang wrote:
>>> So, I don't know.  The first iteration only loop looks a bit unusual
>>> for sure but it isn't something conceptually convoluted.
>> Now this seems to be better. So with this change, we can do:
>>
>> pcpu_first_pop_region(chunk, rs, re, start, end);
>> if (rs < re && ...)
>>    return;
>>
>> Right?
> 
> Yeap, but is that any better?  Passing lvalue loop parameters to loop
> constructs is customary.  For almost all other cases, it's not, so
> 
>  pcpu_first_pop_region(chunk, &rs, &re, start, end)
> 
> would be better but then we have two similar looking interfaces which
> take different types of parameters.  Also, you probably can drop rs <
> re test there but for me it just seems easier to simply check the
> first iteration.  If you think it's something worth changing and it
> looks better afterwards, please send a patch.
> 

What do you think about the patch below? Untested.

-----------

Signed-off-by: WANG Cong <amwang@redhat.com>


--------------080900060102000006050609
Content-Type: text/plain;
 name="mm-percpu_c-remove-two-useless-break.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-percpu_c-remove-two-useless-break.diff"

diff --git a/mm/percpu.c b/mm/percpu.c
index 5adfc26..d1da616 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -911,14 +911,12 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	int page_end = PFN_UP(off + size);
 	struct page **pages;
 	unsigned long *populated;
-	int rs, re;
+	int rs = page_start, re;
 
 	/* quick path, check whether it's empty already */
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		if (rs == page_start && re == page_end)
-			return;
-		break;
-	}
+	pcpu_next_unpop(chunk, &rs, &re, page_end);
+	if (rs == page_start && re == page_end)
+		return;
 
 	/* immutable chunks can't be depopulated */
 	WARN_ON(chunk->immutable);
@@ -966,14 +964,12 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	struct page **pages;
 	unsigned long *populated;
 	unsigned int cpu;
-	int rs, re, rc;
+	int rs = page_start, re, rc;
 
 	/* quick path, check whether all pages are already there */
-	pcpu_for_each_pop_region(chunk, rs, re, page_start, page_end) {
-		if (rs == page_start && re == page_end)
-			goto clear;
-		break;
-	}
+	pcpu_next_pop(chunk, &rs, &re, page_end);
+	if (rs == page_start && re == page_end)
+		goto clear;
 
 	/* need to allocate and map pages, this chunk can't be immutable */
 	WARN_ON(chunk->immutable);

--------------080900060102000006050609--
