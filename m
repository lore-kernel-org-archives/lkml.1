Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbYELNKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbYELNKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYELNKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:10:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:56718 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbYELNKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=Vwe4gNapb5h662yJ73HXY4L1g2jdn2rC1TXy2nCcDqMBq3l+S2rOI+qIep7UsRFGVPOO6cMyxrovppLWeX69BG6sSjUkiGASjFOJiV+tGTdry0aLzsDwgc7MX1tTa/5PWGuDbvKtSVswQFYDxmqOceCvBSuhPKY+nrSyxFCl22Y=
Message-ID: <482841AC.4020609@gmail.com>
Date: Mon, 12 May 2008 15:10:04 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: samuel.thibault@ens-lyon.org
CC: David Miller <davem@davemloft.net>, mtk.manpages@googlemail.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
References: <20080424001656.GM4825@implementation>	<517f3f820804240131v3466713bi70d0eb0fb1f5cd8d@mail.gmail.com>	<20080426014445.GD4792@implementation> <20080426.225432.128575953.davem@davemloft.net>
In-Reply-To: <20080426.225432.128575953.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel, et al.

David Miller wrote:
> From: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Date: Sat, 26 Apr 2008 02:44:45 +0100
> 
>> AF_UNIX: make unix_getname use sizeof(sunaddr->sun_family) instead of
>> sizeof(short).
>>
>> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> This is just syntactic masterbation, sa_family_t is typedef'd
> "unsigned short".
> 
> No system on planet earth providing the BSD sockets API uses
> anything other than uint16_t or unsigned short for this.
> 
> Sorry, I'm not applying this.

I finally got round to testing on FreeBSD.  Linux and BSD are unfortunately not
compatible.  For the unnamed sockets, FreeBSD says the socket address length is
16 bytes (whereas Linux says it's 2 bytes).  On the other hand, there doesn't
seem to be much consistency across implementations: HP-UX's get{peer,sock}name()
says that unnamed sockets have a zero-length address.

Anyway, the situation we have is three address formats in the Unix domain on Linux:

Named sockets (socket was given an string name with bind())
length >= 4 (i.e., sizeof(unsigned short) + at least one character for a
pathname + 1 for the NUL
sun_path is a null-terminated string

Abstract sockets (socket was bound to a sun_path whose initial byte is 0)
Length == sizeof(struct sockaddr_un) (i.e., 110)
sun_path is an initial null byte, followed by 107 other bytes that make the name
unique

Unnamed sockets (created by socketpair(), or when we connect() a socket that was
not bound to a name; the current unix.7 page suggests that when we connect() a
socket that was not bound, then it gets a name in the abstract name space --
that's not true)
Length = 2
sun_path is 108 null bytes .

I have drafted a revision to section of the unix.7 page describing the address
format to try and cover all of the above.  Samuel (and David?) could you review
please?

Cheers,

Michael


   Address Format
       A Unix domain socket address is represented in the  following
       structure:

           #define UNIX_PATH_MAX    108

           struct sockaddr_un {
               sa_family_t sun_family;               /* AF_UNIX */
               char        sun_path[UNIX_PATH_MAX];  /* pathname */
           };

       sun_family always contains AF_UNIX.

       Three types of address are distinguished in this structure:

       *  pathname: a Unix domain socket can be bound to a null-ter-
          minated file system  pathname  using  bind(2).   When  the
          address  of the socket is returned by getsockname(2), get-
          peername(2), and accept(2), its length  is  sizeof(sa_fam-
          ily_t)  +  strlen(sun_path) + 1, and sun_path contains the
          null-terminated pathname.

       *  anonymous: A stream socket that is connect(2)ed to another
          socket  without  first being bound to an address is anony-
          mous.  Likewise, the two sockets created by  socketpair(2)
          are anonymous.  When the address of an anonymous socket is
          returned by getsockname(2), getpeername(2), and accept(2),
          its length is sizeof(sa_family_t), and sun_path should not
          be inspected.

       *  abstract: an abstract socket address is  distinguished  by
          the  fact  that sun_path[0] is a null byte (`\0').  All of
          the remaining bytes in sun_path define the "name"  of  the
          socket.   (Null bytes in the name have no special signifi-
          cance.)  The name has no connection with file system path-
          names.  The socket's address in this namespace is given by
          the rest of the bytes in sun_path.  When the address of an
          abstract  socket  is  returned by getsockname(2), getpeer-
          name(2), and accept(2), its length is sizeof(struct  sock-
          addr_un),  and  sun_path  contains the abstract name.  The
          abstract socket namespace is a non-portable  Linux  exten-
          sion.

== END ==

