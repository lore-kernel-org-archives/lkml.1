Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXERIEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXERIEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbXERIDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:03:45 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:49662 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbXERIDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:03:41 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MM: use DIV_ROUND_UP() in mm/memory.c
Date: Thu, 17 May 2007 23:51:10 +0200
User-Agent: KMail/1.9.6
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <200704241610.23342.eike-kernel@sf-tec.de> <20070503202808.4f835c8a.akpm@linux-foundation.org>
In-Reply-To: <20070503202808.4f835c8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16384957.9Z6RtxJcUa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705172351.20394.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16384957.9Z6RtxJcUa
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andrew Morton wrote:
> Rolf Eike Beer wrote:

>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1838,12 +1838,11 @@ void unmap_mapping_range(struct address_space
>> *mapping,
>>  {
>>  	struct zap_details details;
>>  	pgoff_t hba =3D holebegin >> PAGE_SHIFT;
>> -	pgoff_t hlen =3D (holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> +	pgoff_t hlen =3D DIV_ROUND_UP(holelen, PAGE_SIZE);
>>
>>  	/* Check for overflow. */
>>  	if (sizeof(holelen) > sizeof(hlen)) {
>> -		long long holeend =3D
>> -			(holebegin + holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> +		long long holeend =3D DIV_ROUND_UP(holebegin + holelen, PAGE_SIZE);
>>  		if (holeend & ~(long long)ULONG_MAX)
>>  			hlen =3D ULONG_MAX - hba + 1;
>>  	}
>> @@ -2592,7 +2591,7 @@ int make_pages_present(unsigned long addr, unsigned
>> long end)
>>  	write =3D (vma->vm_flags & VM_WRITE) !=3D 0;
>>  	BUG_ON(addr >=3D end);
>>  	BUG_ON(end > vma->vm_end);
>> -	len =3D (end+PAGE_SIZE-1)/PAGE_SIZE-addr/PAGE_SIZE;
>> +	len =3D DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
>>  	ret =3D get_user_pages(current, current->mm, addr,
>>  			len, write, 0, NULL, NULL);
>>  	if (ret < 0)
>
> More seriously, on i386:
>
>    text    data     bss     dec     hex filename
>   15509      27      28   15564    3ccc mm/memory.o	(before)
>   15561      27      28   15616    3d00 mm/memory.o	(after)
>
> I'm not sure why - some of the quantities which we're dividing by there a=
re
> 64-bit and perhaps the compiler has decided not to do shifting.
>
> Now I'm worried about all the other DIV_ROUND_UP() conversions we did.  We
> should get in there and work out why it went bad.

It's the first two places that cause the increase in code size. The last on=
e=20
is the exact replacement of how DIV_ROUND_UP() is defined so that can hardl=
y=20
make a difference.

If the compiler can't find out to do shifting we might want to improve=20
DIV_ROUND_UP() to do some tricks with __builtin_constant_p() to do the shif=
t.=20
Something like:

#define DIV_ROUND_UP(n, d)			\
(						\
	__builtin_constant_p(d) ? (		\
		is_power_of_2(d) ?		\
		(((n) + (d) - 1) >> ilog2(d)) :	\
		(((n) + (d) - 1) / (d))		\
	) :					\
	(((n) + (d) - 1) / (d))			\
)

With this version mm/memory.o will result in the same size with and without=
 my=20
patch so I guess it's doing what it should. If you like it tell me and I'll=
=20
send a patch.

Eike

--nextPart16384957.9Z6RtxJcUa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGTM5YXKSJPmm5/E4RAmGHAJwI1Ziuax7+lHnttxtHExuLx5kXlQCdEC5N
Thzjpncmv0DR+Ch7rbqJdEM=
=9hDC
-----END PGP SIGNATURE-----

--nextPart16384957.9Z6RtxJcUa--
