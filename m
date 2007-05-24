Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbXEXDYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbXEXDYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbXEXDXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:23:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:37538 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbXEXDXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mom8x8/UnGtJlIDyQLTLENfkVBzOp5F6wUbMKGkeEhetdHSnpZkMClaHrTthbhAIDdFTpFsKeQVQ6lGRWZFqUqjOJzq2ehiSNGTsNkiPiHOu6DrFrEruHNDIGf2V452LOYPd7up+cN0IWzVzb1ZQM233enogIzbkDGKaiv8kYPw=
Message-ID: <6d6a94c50705232023w18fea193i44f1409dc7dd3377@mail.gmail.com>
Date: Thu, 24 May 2007 11:23:53 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] blackfin: Enable arbitary speed serial setting
Cc: aubrey.li@analog.com, akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070523173050.275119c7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523173050.275119c7@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Aubrey Li <aubrey.li@analog.com>

On 5/24/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Add the needed definitions to activate arbitary speed support on the
> blackfin platform.
>
> Signed-off-by: Alan Cox <alan@redhat.com>
>
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/ioctls.h linux-2.6.22-rc1-mm1/include/asm-blackfin/ioctls.h
> --- linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/ioctls.h  2007-05-18 16:22:03.000000000 +0100
> +++ linux-2.6.22-rc1-mm1/include/asm-blackfin/ioctls.h  2007-05-23 16:27:40.720142616 +0100
> @@ -47,6 +47,10 @@
>  #define TIOCSBRK       0x5427  /* BSD compatibility */
>  #define TIOCCBRK       0x5428  /* BSD compatibility */
>  #define TIOCGSID       0x5429  /* Return the session ID of FD */
> +#define TCGETS2                _IOR('T',0x2A, struct termios2)
> +#define TCSETS2                _IOW('T',0x2B, struct termios2)
> +#define TCSETSW2       _IOW('T',0x2C, struct termios2)
> +#define TCSETSF2       _IOW('T',0x2D, struct termios2)
>  #define TIOCGPTN       _IOR('T',0x30, unsigned int)    /* Get Pty Number (of pty-mux device) */
>  #define TIOCSPTLCK     _IOW('T',0x31, int)     /* Lock/unlock Pty */
>
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h linux-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h
> --- linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h        2007-05-18 16:22:03.000000000 +0100
> +++ linux-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h        2007-05-23 16:27:23.293791824 +0100
> @@ -129,6 +129,7 @@
>  #define HUPCL  0002000
>  #define CLOCAL 0004000
>  #define CBAUDEX 0010000
> +#define           BOTHER 0010000
>  #define    B57600 0010001
>  #define   B115200 0010002
>  #define   B230400 0010003
> @@ -144,10 +145,12 @@
>  #define  B3000000 0010015
>  #define  B3500000 0010016
>  #define  B4000000 0010017
> -#define CIBAUD   002003600000  /* input baud rate (not used) */
> +#define CIBAUD   002003600000  /* input baud rate */
>  #define CMSPAR   010000000000  /* mark or space (stick) parity */
>  #define CRTSCTS          020000000000  /* flow control */
>
> +#define        IBSHIFT 16              /* Shift from CBAUD to CIBAUD */
> +
>  /* c_lflag bits */
>  #define ISIG   0000001
>  #define ICANON 0000002
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/termios.h linux-2.6.22-rc1-mm1/include/asm-blackfin/termios.h
> --- linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/termios.h 2007-05-18 16:22:03.000000000 +0100
> +++ linux-2.6.22-rc1-mm1/include/asm-blackfin/termios.h 2007-05-23 16:28:04.353549792 +0100
> @@ -98,8 +98,10 @@
>         copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
>  })
>
> -#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
> -#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
> +#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
> +#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
> +#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
> +#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
>
>  #endif                         /* __KERNEL__ */
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
