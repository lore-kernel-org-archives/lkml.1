Return-Path: <linux-kernel-owner+w=401wt.eu-S2992809AbXDDKGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992809AbXDDKGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992821AbXDDKGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:06:08 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:36331 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992809AbXDDKGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:06:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=YboU9SRYxU/moktfaokJqJn0PblPJgt2cTp+DBSU3ls5DfZVj0No/+lNfmCJA9MsHFRLOUwHQ7AkyuRWlCrZNKrkKN4bnfro/Slsf2Lc3RwaFp3UhGNV7X43oP8TyzpuPqjlqQ2Vp+DwMtbvu68cLf9R1w++GLX4OY254UQEuKU=  ;
X-YMail-OSG: 2LAx7qcVM1maGurun7CSwdGWT1XNb5GkcN2E0lLMTabf.j09PvM2PDDotfmI6ESBEx7hpcx1RA--
Message-ID: <46137882.6050708@yahoo.com.au>
Date: Wed, 04 Apr 2007 20:05:54 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com>	<20070403144948.fe8eede6.akpm@linux-foundation.org>	<4612DCC6.7000504@cosmosbay.com>	<46130BC8.9050905@yahoo.com.au>	<1175675146.6483.26.camel@twins>	<461367F6.10705@yahoo.com.au> <20070404113447.17ccbefa.dada1@cosmosbay.com>
In-Reply-To: <20070404113447.17ccbefa.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> Well, I believe this one is too expensive. I was thinking of a light one :

This one seems worse. Passing your vm_area_cache around everywhere, which
is just intrusive and dangerous because ot becomes decoupled from the mm
struct you are passing around. Watch this:


> @@ -1638,7 +1652,7 @@ find_extend_vma(struct mm_struct * mm, u
>  	unsigned long start;
>  
>  	addr &= PAGE_MASK;
> -	vma = find_vma(mm,addr);
> +	vma = find_vma(mm,addr,&current->vmacache);
>  	if (!vma)
>  		return NULL;
>  	if (vma->vm_start <= addr)

So now you can have current calling find_extend_vma on someone else's mm
but using their cache. So you're going to return current's vma, or current
is going to get one of mm's vmas in its cache :P

-- 
SUSE Labs, Novell Inc.
