Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZILLS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZILLS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZILLS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:18:28 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:19871 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbZILLS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:18:27 -0400
X-Trace: 261150089/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.93.26/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.93.26
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAI4gq0pQKV0a/2dsb2JhbACBU9kKhBgF
X-IronPort-AV: E=Sophos;i="4.44,375,1249254000"; 
   d="scan'208";a="261150089"
Date: Sat, 12 Sep 2009 12:17:49 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Huber <shuber2@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Meerwald <pmeerw@cosy.sbg.ac.at>,
       James Morris <jmorris@namei.org>, William Irwin <wli@movementarian.org>,
       Mel Gorman <mel@csn.ul.ie>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hugetlb bug due to user_shm_unlock call
In-Reply-To: <8bd0f97a0909110703o4d496a45jddc0d7d6fd8674b4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0909121212560.488@sister.anvils>
References: <alpine.LRH.2.00.0908241110420.21562@tundra.namei.org> 
 <Pine.LNX.4.64.0908241258070.27704@sister.anvils> <4A929BF5.2050105@gmail.com>
  <Pine.LNX.4.64.0908241532470.9322@sister.anvils>
 <8bd0f97a0909110703o4d496a45jddc0d7d6fd8674b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1181830492-1252754269=:488"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1181830492-1252754269=:488
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 11 Sep 2009, Mike Frysinger wrote:
> On Mon, Aug 24, 2009 at 11:30, Hugh Dickins wrote:
> >
> > =C2=A0no_id:
> > + =C2=A0 =C2=A0 =C2=A0 if (shp->mlock_user) =C2=A0 =C2=A0/* shmflg & SH=
M_HUGETLB case */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user_shm_unlock(size=
, shp->mlock_user);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0fput(file);
> > =C2=A0no_file:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0security_shm_free(shp);
>=20
> this breaks on no-mmu systems due to user_shm_unlock() being
> mmu-specific.  normally gcc is smart enough to do dead code culling so
> it hasnt caused problems, but not here.  hugetlb support is not
> available on no-mmu systems, so the stubbed hugepage functions prevent
> calls to user_shm_unlock() and such, but here gcc cant figure it out:
>=20
=2E..
>=20
> hugetlb_file_setup() expands to nothing and so mlock_user will never
> come back from NULL, but gcc still emits a reference to
> user_shm_unlock() in the error path.  perhaps the best thing here is
> to just add an #ifdef ?
>  no_id:
> +#ifdef CONFIG_HUGETLB_PAGE
> +    /* gcc isn't smart enough to see that mlock_user goes non-NULL
> only by hugetlb */
>     if (shp->mlock_user)    /* shmflg & SHM_HUGETLB case */
>         user_shm_unlock(size, shp->mlock_user);
> +#endif

Many thanks for reporting that, Mike.
Sorry, I've messed up both 2.6.31 final and 2.6.30.6 stable.
My preference is to avoid the #ifdef and use precisely the same
optimization technique as is working for it elsewhere.
Patch follows immediately in separate mail.

Hugh
--8323584-1181830492-1252754269=:488--
