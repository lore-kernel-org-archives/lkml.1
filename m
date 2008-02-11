Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbYBLBtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbYBLBtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYBLBtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:49:43 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:23204 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752170AbYBLBtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:49:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0haeI+iUCDSfFaFr1YSRUYxdH4pVxoKD92wdPAY2Yy+A7nqr71R392ftMtOyUkrFSbpOWWrkuV/wgHlxjRcsJVmF7hey93cSQPI1OuJHwy2dcO2ekLHz6JIxy3SNFFSP6KHGNrD8nzNzVSjxI960rvNwCSn9UAUA6nKSao/+RwU=  ;
X-YMail-OSG: cpIj3DUVM1kcQ7h.JZ8naIylLeul0JzdV6uEZr_VMOdVLnoZ_IH_YG5vmtSuRsfe5mZjrpZruw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Avoid buffer overflows in get_user_pages()
Date: Tue, 12 Feb 2008 10:45:14 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <5758.1202771853@vena.lwn.net>
In-Reply-To: <5758.1202771853@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121045.15095.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 10:17, Jonathan Corbet wrote:
> Avoid buffer overflows in get_user_pages()
>
> So I spent a while pounding my head against my monitor trying to figure
> out the vmsplice() vulnerability - how could a failure to check for
> *read* access turn into a root exploit?  It turns out that it's a buffer
> overflow problem which is made easy by the way get_user_pages() is
> coded.
>
> In particular, "len" is a signed int, and it is only checked at the
> *end* of a do {} while() loop.  So, if it is passed in as zero, the loop
> will execute once and decrement len to -1.  At that point, the loop will
> proceed until the next invalid address is found; in the process, it will
> likely overflow the pages array passed in to get_user_pages().
>
> I think that, if get_user_pages() has been asked to grab zero pages,
> that's what it should do.  Thus this patch; it is, among other things,
> enough to block the (already fixed) root exploit and any others which
> might be lurking in similar code.  I also think that the number of pages
> should be unsigned, but changing the prototype of this function probably
> requires some more careful review.
>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
>
> diff --git a/mm/memory.c b/mm/memory.c
> index e5628a5..7f50fd8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -989,6 +989,8 @@ int get_user_pages(struct task_struct *tsk, struct
> mm_struct *mm, int i;
>  	unsigned int vm_flags;
>
> +	if (len <= 0)
> +		return 0;

BUG_ON()?
