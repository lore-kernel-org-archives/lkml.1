Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZIMPq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZIMPq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZIMPqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:46:53 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:24593 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbZIMPqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:46:52 -0400
X-Trace: 260999737/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.37.152/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.37.152
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQEAFqwrEpPRSWY/2dsb2JhbACBUtZrhBgF
X-IronPort-AV: E=Sophos;i="4.44,379,1249254000"; 
   d="scan'208";a="260999737"
Date: Sun, 13 Sep 2009 16:46:12 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm: FOLL_DUMP replace FOLL_ANON
In-Reply-To: <28c262360909090916w12d700b3w7fa8a970f3aba3af@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0909131636540.22865@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> 
 <Pine.LNX.4.64.0909072233240.15430@sister.anvils>
 <28c262360909090916w12d700b3w7fa8a970f3aba3af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2139220000-1252856772=:22865"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2139220000-1252856772=:22865
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 10 Sep 2009, Minchan Kim wrote:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 * When core dumping an enormous anonymous a=
rea that nobody
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0* has touched so far, we don't want to all=
ocate page tables.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* has touched so far, we don't want to all=
ocate unnecessary pages or
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* page tables. =C2=A0Return error instead =
of NULL to skip handle_mm_fault,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* then get_dump_page() will return NULL to=
 leave a hole in the dump.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* But we can only make this optimization w=
here a hole would surely
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* be zero-filled if handle_mm_fault() actu=
ally did handle it.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > - =C2=A0 =C2=A0 =C2=A0 if (flags & FOLL_ANON) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page =3D ZERO_PAGE(0=
);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (flags & FOLL_GET=
)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 get_page(page);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(flags & FOLL_=
WRITE);
> > - =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 if ((flags & FOLL_DUMP) &&
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!vma->vm_ops || !vma->vm_ops->fau=
lt))
>=20
> How about adding comment about zero page use?

What kind of comment did you have in mind?
We used to use ZERO_PAGE there, but with this patch we're not using it.
I thought the comment above describes what we're doing well enough.

I may have kept too quiet about ZERO_PAGEs, knowing that a later patch
was going to change the story; but I don't see what needs saying here.

Hugh
--8323584-2139220000-1252856772=:22865--
