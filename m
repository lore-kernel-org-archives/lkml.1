Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbZJFVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbZJFVlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbZJFVlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:41:16 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:22655 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933111AbZJFVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:41:15 -0400
X-Trace: 271000346/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.109.156/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.109.156
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsFAIdWy0pPRW2c/2dsb2JhbACBUtMEgj6BbASBUw
X-IronPort-AV: E=Sophos;i="4.44,515,1249254000"; 
   d="scan'208";a="271000346"
Date: Tue, 6 Oct 2009 22:40:21 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Ronny Egner <RonnyEgner@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question regarding Page Table size
In-Reply-To: <20091006081822.154790@gmx.net>
Message-ID: <Pine.LNX.4.64.0910062218350.18136@sister.anvils>
References: <20091006081822.154790@gmx.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1339190357-1254865221=:18136"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1339190357-1254865221=:18136
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 6 Oct 2009, Ronny Egner wrote:

> Dear Kernel gurus,
>=20
> i have a simple question but until now i did not find an answer. I beg yo=
ur apologize if my question is misplaced.
>=20
>=20
>=20
> So my question is:
>=20
> "How much memory is needed in the kernel page table for a=20
> process accessing a shared memory segment?"
>=20
>=20
> According to the information i have and found at the web the rule is:
>=20
>=20
> "4 Bytes per 4 KB referenced memory per process is allocated=20
> in the page table"

That's often the case, but depends very much on your architecture
and its configuration.

4 bytes per 4kB is good for i386 (x86_32) architecture without PAE.

With PAE (Page Address Extension, originally a feature to allow the
32-bit Intel machine to support more than 4GB of physical memory,
nowadays often used on smaller machines for its NX no-execute flag),
the page table entry size is doubled to 8 bytes per 4kB page:
8 bytes per 4kB page applies also to x86_64 or amd64.

Some other architectures have 8kB or larger pages; 4 byte or 8 byte
page table entry per page will be common, but I'll bet there are
exceptions.

>=20
> However i found one note saying because shared memory is=20
> referenced 8 Bytes are needed:
>=20
>=20
> --- BEGIN QUOTE ---
> PageTables is memory to manage memory.
>=20
> Each entry takes 4 bytes. Each 4 Kb of virtual (not swap)=20
> memory requires one PTE to manage. This also counts for=20
> shared memory, as with shared memory there is one physical=20
> segment, but each process has its own virtual memory which=20
> maps to this segment.
>=20
> In Oracle=E2=80=99s case, assuming an SGA of 2 Gb, that is:
>=20
> 524,288 pages * 8 bytes =3D 4 Mb per process
>=20
> --- END QUOTE ---
> (Source: http://www.pythian.com/news/741/pythian-goodies-free-memory-swap=
-oracle-and-everything)
>=20
> Until now i was not able to verify this information. So i am asking here
> for more information or perhaps a link.
>=20
>=20
> Where does the 8 byte in the calculation above come from?

I don't know, it doesn't explain; it seems like a misunderstanding.

It might be including, in addition to one set of page table entries,
the shmem/tmpfs tables allocated to hold swap entries in case the shared
memory pages get swapped out: that would add another 4 bytes on 32-bit
or 8 bytes on 64-bit; but there's only one set of those tables for the
shared memory object, it's not duplicated per process.

>=20
> Taking the above example with a 2 GB shared memory segment the space=20
> needed in the page table should be:
>=20
>  524288 pages * 4 Bytes =3D 2 MB=20
>      (for the process "owning" the shared memory segment)
>=20
>  PLUS
>=20
>  524288 pages * 4 Bytes =3D 2 MB=20
>      (for *every* process referencing the shared memory=20
>       segment assuming the fact the shared memory segment=20
>       is referenced completely)

Yes, on i386 without PAE that's correct.  (I'd prefer not to
distinguish the "owner" and those sharing, just think of all
the processes using that shared memory segment.)

Hugh

>=20
> Could anybody please give me a hint?
>=20
>=20
> Thanks in advance
>=20
> --=20
> Ronny Egner
> --=20
> Ronny Egner
> RonnyEgner@gmx.de
--8323584-1339190357-1254865221=:18136--
