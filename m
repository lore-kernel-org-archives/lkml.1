Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYCXKoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYCXKoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 06:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbYCXKoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 06:44:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44397 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296AbYCXKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 06:44:22 -0400
X-SBRS: 3.6
X-MesageID: 47212261
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,546,1199682000"; 
   d="scan'208";a="47212261"
Date: Mon, 24 Mar 2008 10:43:30 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
Message-ID: <20080324104330.GF4434@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080308022321.GC5853@implementation> <20080323.215641.192753003.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080323.215641.192753003.davem@davemloft.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller, le Sun 23 Mar 2008 21:56:41 -0700, a écrit :
> From: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Date: Sat, 8 Mar 2008 02:23:21 +0000
> 
> > Accept and getpeername are supposed to return the amount of bytes
> > written in the returned address.  However, on unnamed sockets, only
> > sizeof(short) is returned, while a 0 is put in the sun_path member.
> > This patch adds 1 for that additional byte.
> > 
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> This change isn't correct.  It's the fact that the
> length returned is sizeof(short) that tells the caller
> that the unix socket is unnamed.

Mmm, where that is documented?

I can't find any details about that in SUS, and man 7 unix says

`If sun_path starts with a null byte ('' '), then it refers to the
abstract namespace main- tained by the Unix protocol module.'

It doesn't talk about the size being only sizeof(short) (which I guess
you meant sizeof(sa_family_t) actually).

> We zero out the sun_path[0] member just to be polite and tidy.
> 
> You would break applications if you changed this, so
> marking this patch as "trivial" is extremely premature.

See documentation above.  If applications don't follow documentation,
then they deserve breaking :)

Note also that on some (BSD-ish) systems, sockaddr_un contains a sun_len
field, containing the length of the data, and thus on them accept and
getpeername return more that sizeof(sa_family_t) as length (it actually
returns 16).  So such applications are really broken.

Samuel
