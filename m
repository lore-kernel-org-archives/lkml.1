Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbYBNQqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbYBNQqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbYBNQpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:45:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:60130 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYBNQpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:45:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NpV30qtLxiE0+syiRPTT2qizbvr5fwo3OcSp1iUI9aUUhO5JkJQAozuJKZ60yuAdjc31D3ZX9RSzWf88SgR7/qLaJJuN9QOfdsZszn/u+inQQj7lrfx4llUkmYV5V83nkBXPYSorq/aP9vHfkPdUY60moqB5BbhDHO5OHPQmJcs=
Message-ID: <6101e8c40802140845h563f7ceeseea824dee4a1ab77@mail.gmail.com>
Date: Thu, 14 Feb 2008 17:45:51 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: stable@kernel.org
Subject: Re: [PATCH] Avoid buffer overflows in get_user_pages()
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, "Jonathan Corbet" <corbet@lwn.net>
In-Reply-To: <5758.1202771853@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5758.1202771853@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for stable (.22 .23 .24) ?

git id in mainline: 900cf086fd2fbad07f72f4575449e0d0958f860f

--

tested in: http://repo.or.cz/w/linux-2.6.22.y-op.git testing

On 2/12/08, Jonathan Corbet <corbet@lwn.net> wrote:
> Avoid buffer overflows in get_user_pages()
>
> So I spent a while pounding my head against my monitor trying to figure
> out the vmsplice() vulnerability - how could a failure to check for
> *read* access turn into a root exploit? It turns out that it's a buffer
> overflow problem which is made easy by the way get_user_pages() is
> coded.
>
> In particular, "len" is a signed int, and it is only checked at the
> *end* of a do {} while() loop. So, if it is passed in as zero, the loop
> will execute once and decrement len to -1. At that point, the loop will
> proceed until the next invalid address is found; in the process, it will
> likely overflow the pages array passed in to get_user_pages().
>
> I think that, if get_user_pages() has been asked to grab zero pages,
> that's what it should do. Thus this patch; it is, among other things,
> enough to block the (already fixed) root exploit and any others which
> might be lurking in similar code. I also think that the number of pages
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
> mm_struct *mm,
> int i;
> unsigned int vm_flags;
>
> +	if (len <= 0)
> +	return 0;
> /*
> * Require read or write permissions.
> * If 'force' is set, we only require the "MAY" flags.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
--
Thanks,
Oliver
