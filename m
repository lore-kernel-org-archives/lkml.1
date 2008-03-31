Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbYCaEBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbYCaEBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 00:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYCaEAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 00:00:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:3113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYCaEAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 00:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PfEpwbqphDPwvyjMPT2kLcPQFshwN4QWnSVo50ftcsBkHewzQcBNxI3FOhys/KE7VW6DP+qXWIcTYeilZfOkspnbllTeYCW3kDj6Ve8CpLrar2unsIBSmfeoFN6UQGFJLvoXE6EJOukNEhMpTYRIISX2v0uEyBALJAx5HRvoMhI=
Message-ID: <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com>
Date: Mon, 31 Mar 2008 06:00:50 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Samuel Thibault" <samuel.thibault@ens-lyon.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
In-Reply-To: <20080324122700.GK4434@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080308022321.GC5853@implementation>
	 <20080323.215641.192753003.davem@davemloft.net>
	 <20080324104330.GF4434@implementation.uk.xensource.com>
	 <87abko734d.fsf@basil.nowhere.org>
	 <20080324121719.GJ4434@implementation.uk.xensource.com>
	 <20080324122700.GK4434@implementation.uk.xensource.com>
X-Google-Sender-Auth: 96e668d8ae57bd30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

It would really be much more useful if you CCed me, rather than hoping
that I'd find this patch by trawling LKML...

David, Andi,

My understanding about abstract namespace sockets (what Samuel calls
unnamed sockets) is that the indicator that the address is for an
unnamed socket is that the sun_path starts with a zero byte -- and the
*entire* remainder of the sun_path constitutes the name of the socket.
 As such, information about the size returned by accept() etc. is
redundant. (I've happily written programs that use abstract namespace
sockets without even knowing what is returned by a succesful
accept().)

I agree with Samuel that there should be some documentation of the
return value of accept() etc, for abstract sockets but my inclination
would be to document that the indicator that this is an abstract
socket is the initial null byte in sun_path, and mention the returned
length as an after word.  Does this seem reasonable?

Cheers,

Michael

On 3/24/08, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> Samuel Thibault, le Mon 24 Mar 2008 12:17:19 +0000, a écrit :
>
> > Andi Kleen, le Mon 24 Mar 2008 12:50:10 +0100, a écrit :
>  > > Samuel Thibault <samuel.thibault@ens-lyon.org> writes:
>  > > > David Miller, le Sun 23 Mar 2008 21:56:41 -0700, a écrit :
>  > > > > From: Samuel Thibault <samuel.thibault@ens-lyon.org>
>  > > > > Date: Sat, 8 Mar 2008 02:23:21 +0000
>  > > > >
>  > > > > > Accept and getpeername are supposed to return the amount of bytes
>  > > > > > written in the returned address.  However, on unnamed sockets, only
>  > > > > > sizeof(short) is returned, while a 0 is put in the sun_path member.
>  > > > > > This patch adds 1 for that additional byte.
>  > > > > >
>  > > > > > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
>  > > > >
>  > > > > This change isn't correct.  It's the fact that the
>  > > > > length returned is sizeof(short) that tells the caller
>  > > > > that the unix socket is unnamed.
>  > > >
>  > > > Mmm, where that is documented?
>  > > >
>  > > > I can't find any details about that in SUS, and man 7 unix says
>  > > >
>  > > > `If sun_path starts with a null byte ('' '), then it refers to the
>  > > > abstract namespace main- tained by the Unix protocol module.'
>  > >
>  > > [I wrote unix(7) originally]. The abstract name space is a Linux
>  > > extension and there is no written standard and whatever the kernel
>  > > implements is the de-facto standard. If unix(7) differs in anything
>  > > from what the code does please send patches to the manpages
>  > > maintainer.
>  >
>  > Oops, sorry, we are not talking about abstract namespace actually (their
>  > sockaddr length are necessarily bigger than sizeof(sa_family_t) since
>  > they need some data), but unamed sockets.  So the Address Format
>  > paragraph just misses description of unnamed sockets.
>
>
> How about this?
>
>  --- unix.7.orig 2008-03-24 12:24:37.000000000 +0000
>  +++ unix.7      2008-03-24 12:24:56.000000000 +0000
>  @@ -87,6 +87,15 @@
>   bytes in
>   .IR sun_path .
>   Note that names in the abstract namespace are not zero-terminated.
>  +If the size returned by
>  +.BR accept
>  +or
>  +.BR getpeername
>  +is
>  +.IR sizeof(sa_family_t) ,
>  +then it refers to a unnamed socket and
>  +.I sun_path
>  +should not be read.
>   .SS Socket Options
>   For historical reasons these socket options are specified with a
>   .B SOL_SOCKET
>
>
>  Samuel
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
I'll likely only see replies if they are CCed to mtk.manpages at gmail dot com
