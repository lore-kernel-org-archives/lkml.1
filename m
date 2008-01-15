Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYAOCQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYAOCQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYAOCPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:15:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYAOCPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:15:50 -0500
Date: Mon, 14 Jan 2008 21:15:40 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] mmaped copy too slow?
Message-ID: <20080114211540.284df4fb@bree.surriel.com>
In-Reply-To: <20080115100450.1180.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115100450.1180.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 10:45:47 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> the problem is when almost page is mapped and PTE access bit on,
> page reclaim process below steps.
> 
>   1) page move to inactive list -> active list
>   2) page move to active list   -> inactive list
>   3) really pageout
> 
> It is too roundabout and unnecessary memory pressure happend.
> if you don't mind, please discuss.

While being able to deal with used-once mappings in page reclaim
could be a good idea, this would require us to be able to determine
the difference between a page that was accessed once since it was
faulted in and a page that got accessed several times.

That kind of infrastructure could end up adding more overhead than
an immediate reclaim of these streaming mmap pages would save.

Given that page faults have overhead too, it does not surprise me
that read+write is faster than mmap+memcpy.

In threaded applications, page fault overhead will be worse still,
since the TLBs need to be synchronized between CPUs (at least at
reclaim time).

Maybe we should just advise people to use read+write, since it is
faster than mmap+memcpy?

-- 
All rights reversed.
