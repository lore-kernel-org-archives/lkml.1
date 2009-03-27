Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZC0It1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZC0It1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZC0ItT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:49:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZC0ItS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:49:18 -0400
Subject: Re: Question about PRIVATE_FUTEX
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, lkml <linux-kernel@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Mar 2009 09:49:19 +0100
Message-Id: <1238143759.7808.2885.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 11:12 +0900, Minchan Kim wrote:
> Hi, Peter and Eric.
> 
> I am not expert about futex.
> I am sorry if this is dumb question.
> 
> If we use private futex, get_futex_key don't call get_user_pages_fast
> which pins page at page table.

But also drops that page ref at the end of get_futex_key(). The whole
and only purpose of using get_user_pages_fast() is to get at the mapping
data without having to obtain the mmap_sem.

> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
> pagefault_disable.
> 
> Who make sure the user page is mapped at app's page table ?

Nobody, all uses of get_futex_value_locked() have to deal with it
returning -EFAULT.

Most of this is legacy btw, from when futex ops were done under the
mmap_sem. Back then we couldn't fault because that would cause mmap_sem
recursion. Howver, now that we don't hold mmap_sem anymore we could use
a faulting user access like get_user().

Darren has been working on patches to clean that up, some of those are
already merged in the -tip tree.

HTH
