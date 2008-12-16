Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYLPJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYLPJNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYLPJNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:13:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60097
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbYLPJNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:13:33 -0500
Date: Tue, 16 Dec 2008 01:13:34 -0800 (PST)
Message-Id: <20081216.011334.124918024.davem@davemloft.net>
To: bluebird@gentoo.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       harvey.harrison@gmail.com
Subject: Re: Compiling glibc with 2.6.28 linux headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4943DAD6.7070402@gentoo.org>
References: <4943DAD6.7070402@gentoo.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Friedrich Oslage <bluebird@gentoo.org>
Date: Sat, 13 Dec 2008 16:55:02 +0100

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> 
> when compiling glibc(2.9, 20081208 snapshot) with linux 2.6.28-rc8
> headers I get a lot of errors like this one:
> 
> In file included from
> /tmp/toolchain-build/rootfs/usr/include/asm/byteorder.h:49,
>                  from
> /tmp/toolchain-build/rootfs/usr/include/linux/atalk.h:4,
>                  from ../sysdeps/unix/sysv/linux/netatalk/at.h:25,
>                  from ../sysdeps/unix/sysv/linux/sa_len.c:22:
> /tmp/toolchain-build/rootfs/usr/include/linux/byteorder.h:8:3: error:
> #error Fix asm/byteorder.h to define one endianness

Harvey, we might need to do something about this.

> About a month ago arch/sparc/include/asm/byteorder.h was changed to
> include the new linux/byteorder.h instead of the old
> linux/byteorder/big_endian.h. The new one panics if both __LITTLE_ENDIAN
> and __BIG_ENDIAN are defined.
> 
> But since glibc's string/endian.h(/usr/include/endian.h) always defines
> __BIG_ENDIAN and __LITTLE_ENDIAN it may occur, depending on the
> includes, that both are defined when asm/byteorder.h is included.
> 
> My assumption is that asm/byteorder.h should ensure that only one of
> these is defined.
> 
> After applying the patch below compiling glibc works again. But when
> compiling the kernel I get
> 
> In file included from drivers/scsi/qla2xxx/qla_dfs.c:7:
> drivers/scsi/qla2xxx/qla_def.h:1487:7: warning: "__LITTLE_ENDIAN" is not
> defined
> 
> Which sould be okay...I think the #elif should really be an #elif
> defined but that's another thing ;)
> 
> Is this the right solution or did I miss anything?
> 
> Cheers,
> Friedrich
> 
> - --- arch/sparc/include/asm/byteorder.h
> +++ arch/sparc/include/asm/byteorder.h
> @@ -5,6 +5,9 @@
>  #include <asm/asi.h>
> 
>  #define __BIG_ENDIAN
> +#ifdef __LITTLE_ENDIAN
> +# undef __LITTLE_ENDIAN
> +#endif
> 
>  #ifdef CONFIG_SPARC32
>  #define __SWAB_64_THRU_32__
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iEYEARECAAYFAklD2tYACgkQknxn9PmJ76XvEACZAajpv/iRLAeEHXp7cIWBCEEX
> V9kAnRZ0BBDwLrMENDsPsYMuPWpLDlKv
> =48UQ
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
