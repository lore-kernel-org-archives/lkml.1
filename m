Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYA0LPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYA0LPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYA0LPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:15:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56049 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYA0LPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:15:15 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] [14/18] BKL-removal: Add unlocked_fasync
To: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Reply-To: 7eggert@gmx.de
Date: Sun, 27 Jan 2008 12:14:52 +0100
References: <9Q5hR-3MI-9@gated-at.bofh.it> <9Q5rE-3ZD-17@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1JJ5TR-0003VJ-3U@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19Mk8wi9KQuv2lQf2SrkS0IDKm2CXayd0wAqaf
 Wn7A+x5JtTVLzMIqhk1wESQSRpNfKphxtAqha9cRo/kSVuRzOz
 vUAYKlmCl77zSg7AECLYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ linux/fs/fcntl.c
> @@ -240,11 +240,15 @@ static int setfl(int fd, struct file * f
>  
>         lock_kernel();
>         if ((arg ^ filp->f_flags) & FASYNC) {
> -               if (filp->f_op && filp->f_op->fasync) {
> +               if (filp->f_op && filp->f_op->unlocked_fasync)
> +                       error = filp->f_op->unlocked_fasync(fd, filp,
> +                                       !!(arg & FASYNC));
> +               else if (filp->f_op && filp->f_op->fasync) {
>                         error = filp->f_op->fasync(fd, filp, (arg & FASYNC) !=
0);
>                         if (error < 0)
>                                 goto out;

No goto if you use unlocked_fasync?

>                 }
> +               /* AK: no else error = -EINVAL here? */
>         }
>  
>         filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
> --
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

