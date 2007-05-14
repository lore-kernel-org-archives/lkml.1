Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXENWIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXENWIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbXENWIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:08:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758AbXENWIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:08:45 -0400
Date: Mon, 14 May 2007 15:08:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: olof@lixom.net (Olof Johansson)
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
Message-Id: <20070514150802.b9120e9f.akpm@linux-foundation.org>
In-Reply-To: <20070512143105.GA12890@lixom.net>
References: <20070512143105.GA12890@lixom.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 09:31:05 -0500
olof@lixom.net (Olof Johansson) wrote:

> ppc64 really needs ioaddr_t to be 64-bit, since I/O addresses really
> are MMIO addresses, and remapped to a high range.
> 
> While the type is exported to userspace, there hasn't been any platforms
> with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> any existing users.
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> Index: 2.6.21/include/pcmcia/cs_types.h
> ===================================================================
> --- 2.6.21.orig/include/pcmcia/cs_types.h
> +++ 2.6.21/include/pcmcia/cs_types.h
> @@ -21,12 +21,17 @@
>  #include <sys/types.h>
>  #endif
>  
> +#if defined(__powerpc64__)
> +/* I/O addresses are really MMIO addresses on PPC, and can thus be 64 bits */
> +typedef unsigned long ioaddr_t;
> +#else
>  #if defined(__arm__) || defined(__mips__)
>  /* This (ioaddr_t) is exposed to userspace & hence cannot be changed. */
>  typedef u_int   ioaddr_t;
>  #else
>  typedef u_short	ioaddr_t;
>  #endif
> +#endif
>  typedef unsigned long kio_addr_t;
>  
>  typedef u_short	socket_t;

Well that's some pretty sad code you've found there.  The kernel surely has
some appropriate type to use here without us having to invent a new one. 
But I suspect if we were to rationalise things in there it will get messy.

I think your patch can be cast more neatly if we use #elif:

--- a/include/pcmcia/cs_types.h~pcmcia-ppc64-needs-64-bit-ioaddr_t
+++ a/include/pcmcia/cs_types.h
@@ -21,12 +21,16 @@
 #include <sys/types.h>
 #endif
 
-#if defined(__arm__) || defined(__mips__)
+#if defined(__powerpc64__)
+/* I/O addresses are really MMIO addresses on PPC, and can thus be 64 bits */
+typedef unsigned long ioaddr_t;
+#elif defined(__arm__) || defined(__mips__)
 /* This (ioaddr_t) is exposed to userspace & hence cannot be changed. */
 typedef u_int   ioaddr_t;
 #else
 typedef u_short	ioaddr_t;
 #endif
+
 typedef unsigned long kio_addr_t;
 
 typedef u_short	socket_t;
_

Also, I wonder if `unsigned long' is the correct type to use here.  32-bit
userspace will treat it as 32-bit and 64-bit userspace will treat it as
64-bit.

Would it be better to use uint64_t here?

