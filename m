Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYGKDaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYGKDaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 23:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYGKDaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 23:30:09 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:42477 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752369AbYGKDaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 23:30:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tql3oytqVMvnvWN6BGV8fozwKXiZsqIv3CZdm/DVJeZqzGpKUDJKPpUlf4l5pueEv6TItEF6t3gVgEATPXQSe1Kvm8woi2TK0pFZpfqxZhRC+Qmp36LukDjty9lEF+h7mAA5HHRVRz8JfE/fCbPEvK21HUwyjf/o4cFjVeBG5Tk=  ;
X-YMail-OSG: HL1LlEMVM1mHybJRqlrsttSHrKNeyy77sx8nNBN7wqG3PixFE7eeDHgc4MsIk_p0qW6JP.NFdOW5pWi6EDihWley4RGJvCew4e9RHdxEJlN8xLv5DO.7.WO.4qXpAfPpjO4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jack Steiner <steiner@sgi.com>
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Date: Fri, 11 Jul 2008 13:30:01 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Hellwig <hch@infradead.org>,
       cl@linux-foundation.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       linux-mm@kvack.org
References: <20080703213348.489120321@attica.americas.sgi.com> <200807110252.00887.nickpiggin@yahoo.com.au> <20080710172036.GB5972@sgi.com>
In-Reply-To: <20080710172036.GB5972@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111330.02090.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 03:20, Jack Steiner wrote:
> On Fri, Jul 11, 2008 at 02:52:00AM +1000, Nick Piggin wrote:

> > lockless gup checks for struct page by checking a bit in the pte.
> > This should be enough to guarantee  it is cacheable memory (unless
> > another driver has done something tricky like set the the page's
> > cache attributes to UC or WC -- I don't know if there is a way to
> > completely avoid all corner cases).
>
> The GRU itself has no need to reference the page struct.
> However, it WILL reference valid ptes that represent pages imported from
> other SSIs via xpmem. These will have cacheable ptes but no page structs.

Oh, I'm sorry Jack, I misread the patch and thought you still had
the page_to_phys thing in there... OK, then it probably isn't
broken. And in which case you would have to add a little code to
gup.c...


> Maybe checking the pte attributes is the best way to do the check.
>
> If we take this approach, what is a good API for the gup.c walker?
> Return the pte attributes?
>
> 	int get_user_pte(struct mm_struct *mm, unsigned long address,
> 	        int write, unsigned long *paddr, int *pageshift, pgprot_t *prot)
>
> The GRU would enforce the check for cacheable access.

Yeah that wouldn't be a bad API, although being a lockless, may-fail,
not available on all archs kind of thing, I would prefer a different
name, maybe get_user_pte_fast() to match?

Thanks,
Nick
