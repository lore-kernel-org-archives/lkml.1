Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0CITmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:42:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:36607 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0CITmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:42:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=grB+yf4tRdg7eUNuo7bZ3cC8nOaDb5Ht9OA+r2Tspn7rDZ5P3sT0HTTlGKGWCalZT
	pkBG73TeyeQgC1KtfJbVw==
MIME-Version: 1.0
In-Reply-To: <4B931068.70900@cn.fujitsu.com>
References: <4B8E3F77.6070201@cn.fujitsu.com>
	 <6599ad831003050403v2e988723k1b6bf38d48707ab1@mail.gmail.com>
	 <4B931068.70900@cn.fujitsu.com>
Date: Tue, 9 Mar 2010 11:42:02 -0800
Message-ID: <6599ad831003091142t38c9ffc9rea7d351742ecbd98@mail.gmail.com>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy and 
	mems_allowed
From: Paul Menage <menage@google.com>
To: miaox@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 6:33 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>
> Before applying this patch, cpuset updates task->mems_allowed just like
> what you said. But the allocator is still likely to see an empty nodemask.
> This problem have been pointed out by Nick Piggin.
>
> The problem is following:
> The size of nodemask_t is greater than the size of long integer, so loading
> and storing of nodemask_t are not atomic operations. If task->mems_allowed
> don't intersect with new_mask, such as the first word of the mask is empty
> and only the first word of new_mask is not empty. When the allocator
> loads a word of the mask before
>
>        current->mems_allowed |= new_mask;
>
> and then loads another word of the mask after
>
>        current->mems_allowed = new_mask;
>
> the allocator gets an empty nodemask.

Couldn't that be solved by having the reader read the nodemask twice
and compare them? In the normal case there's no race, so the second
read is straight from L1 cache and is very cheap. In the unlikely case
of a race, the reader would keep trying until it got two consistent
values in a row.

Paul
