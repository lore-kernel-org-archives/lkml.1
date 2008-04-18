Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYDRPkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYDRPkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYDRPkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:40:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:60337 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYDRPkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=u1b+pKXye7SwYbhzbHr9rSwVJixqWq5GmAFBUHMq0/Y21L57VKc9onau7ok2I+6mA9sM3092UaS1Ox3066RAbZveuXQGwqhvD8uGRHRimPIvqvwe4Ty0PBerpNYC+5j7Sc2ICbnt5A2oHhZbS2bqS7XAkzBR5n3QEQeZad41Ih8=
Message-ID: <4808D1C5.8050304@gmail.com>
Date: Fri, 18 Apr 2008 18:52:21 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
CC: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
References: <20080308022321.GC5853@implementation>	 <20080323.215641.192753003.davem@davemloft.net>	 <20080324104330.GF4434@implementation.uk.xensource.com>	 <87abko734d.fsf@basil.nowhere.org>	 <20080324121719.GJ4434@implementation.uk.xensource.com>	 <20080324122700.GK4434@implementation.uk.xensource.com> <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com>
In-Reply-To: <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,


Michael Kerrisk wrote:
> On 3/24/08, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
>> Samuel Thibault, le Mon 24 Mar 2008 12:17:19 +0000, a écrit :
>>
>>> Andi Kleen, le Mon 24 Mar 2008 12:50:10 +0100, a écrit :
>>  > > Samuel Thibault <samuel.thibault@ens-lyon.org> writes:
>>  > > > David Miller, le Sun 23 Mar 2008 21:56:41 -0700, a écrit :
>>  > > > > From: Samuel Thibault <samuel.thibault@ens-lyon.org>
>>  > > > > Date: Sat, 8 Mar 2008 02:23:21 +0000
>>  > > > >
>>  > > > > > Accept and getpeername are supposed to return the amount of bytes
>>  > > > > > written in the returned address.  However, on unnamed sockets, only
>>  > > > > > sizeof(short) is returned, while a 0 is put in the sun_path member.
>>  > > > > > This patch adds 1 for that additional byte.
>>  > > > > >
>>  > > > > > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
>>  > > > >
>>  > > > > This change isn't correct.  It's the fact that the
>>  > > > > length returned is sizeof(short) that tells the caller
>>  > > > > that the unix socket is unnamed.
>>  > > >
>>  > > > Mmm, where that is documented?
>>  > > >
>>  > > > I can't find any details about that in SUS, and man 7 unix says
>>  > > >
>>  > > > `If sun_path starts with a null byte ('' '), then it refers to the
>>  > > > abstract namespace main- tained by the Unix protocol module.'
>>  > >
>>  > > [I wrote unix(7) originally]. The abstract name space is a Linux
>>  > > extension and there is no written standard and whatever the kernel
>>  > > implements is the de-facto standard. If unix(7) differs in anything
>>  > > from what the code does please send patches to the manpages
>>  > > maintainer.
>>  >
>>  > Oops, sorry, we are not talking about abstract namespace actually (their
>>  > sockaddr length are necessarily bigger than sizeof(sa_family_t) since
>>  > they need some data), but unamed sockets.  So the Address Format
>>  > paragraph just misses description of unnamed sockets.
>>
>>
>> How about this?

The idea of this patch seems okay.  But one minor question below.

>>  --- unix.7.orig 2008-03-24 12:24:37.000000000 +0000
>>  +++ unix.7      2008-03-24 12:24:56.000000000 +0000
>>  @@ -87,6 +87,15 @@
>>   bytes in
>>   .IR sun_path .
>>   Note that names in the abstract namespace are not zero-terminated.
>>  +If the size returned by
>>  +.BR accept
>>  +or
>>  +.BR getpeername

or getsockname()

>>  +is
>>  +.IR sizeof(sa_family_t) ,

Why did you write sa_family_t here?  Dave M already said sizeof(short), which is
the same thing, and I see that in net/unix/af_unix.c::unix_getname() there is:

        u = unix_sk(sk);

        unix_state_lock(sk);
                if (!u->addr) {

                sunaddr->sun_family = AF_UNIX;

                sunaddr->sun_path[0] = 0;

                *uaddr_len = sizeof(short);
        } else {


>>  +then it refers to a unnamed socket and
>>  +.I sun_path
>>  +should not be read.
>>   .SS Socket Options
>>   For historical reasons these socket options are specified with a
>>   .B SOL_SOCKET

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html

