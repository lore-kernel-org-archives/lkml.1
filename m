Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbZLAFKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbZLAFKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZLAFKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:10:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:45424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZLAFKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:10:21 -0500
Message-ID: <4B14A51E.2090702@kernel.org>
Date: Tue, 01 Dec 2009 14:09:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] percpu: explain quick paths in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home> <4B145CE9.1060608@kernel.org> <4B147918.3000503@redhat.com> <4B14A2E6.1070603@kernel.org>
In-Reply-To: <4B14A2E6.1070603@kernel.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 02:00 PM, Tejun Heo wrote:
> I thought about that but didn't want to open code the special and
> fairly complex loop construct used there.  To me, it seemed using the
> same loop construct would be much less error-prone than open coding
> the loop mostly because those two special cases are the only place
> where that is necessary.  Maybe we can add pcpu_first_[un]pop_region()
> macros and use them there but is the first iteration check that bad
> even with sufficient explanations?

So, something like the following.

#define pcpu_first_unpop_region(chunk, rs, re, start, end)	do {	\
	(rs) = (start);							\
	pcpu_next_unpop((chunk), &(rs), &(re), (end));			\
} while (0)

#define pcpu_for_each_unpop_region(chunk, rs, re, start, end)		\
	for (pcpu_first_unpop_region(chunk, rs, re, start, end);	\
	     (rs) < (re);						\
	     (rs) = (re) + 1, pcpu_next_unpop((chunk), &(rs), &(re), (end)))

#define pcpu_first_pop_region(chunk, rs, re, start, end)	do {	\
	(rs) = (start);							\
	pcpu_next_pop((chunk), &(rs), &(re), (end));			\
} while (0)

#define pcpu_for_each_pop_region(chunk, rs, re, start, end)		\
	for (pcpu_first_pop_region(chunk, rs, re, start, end);		\
	     (rs) < (re);						\
	     (rs) = (re) + 1, pcpu_next_pop((chunk), &(rs), &(re), (end)))

It might be better to make these proper functions which take pointers
but that makes the only two interfaces for region iterators disagree
about how they take parameters.

So, I don't know.  The first iteration only loop looks a bit unusual
for sure but it isn't something conceptually convoluted.

Thanks.

-- 
tejun
