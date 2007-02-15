Return-Path: <linux-kernel-owner+w=401wt.eu-S1030449AbXBOSXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbXBOSXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030454AbXBOSXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:23:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:1493 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030449AbXBOSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZS7VwIZmuyKXgYlk+YKQAglFTXCkkOAZh0wGcUb/KtlwRGqXAMYjM7wiDjr77tDjzykml2Nx8/tiyGm6iPqqhfVP9uVuyQmWhmkfSLaWQMkSfoCF6Un1EyAnMsCJk8gv46C9yyHqRhHUZPtnA9J/WNSCfYckPAjNEKt+B+GNL0I=
Date: Thu, 15 Feb 2007 21:23:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 14/14] syslets: x86: optimized sys_umem_add()
Message-ID: <20070215182300.GA5542@martell.zuzino.mipt.ru>
References: <20070215165259.GO4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215165259.GO4285@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:52:59PM +0100, Ingo Molnar wrote:
> provide an optimized assembly version of sys_umem_add().

> --- linux.orig/arch/i386/lib/getuser.S
> +++ linux/arch/i386/lib/getuser.S

> +sys_umem_add:
> +	movl 0x4(%esp), %ecx			# uptr
> +	movl 0x8(%esp), %edx			# inc
> +
> +	cmpl $__PAGE_OFFSET, %ecx		# access_ok(uptr)
> +	jae bad_sys_umem_add
> +
> +1:	addl %edx, (%ecx)			# *uptr += inc
> +2:	movl (%ecx), %eax			# return *uptr
> +	ret
> +
> +bad_sys_umem_add:
> +	movl $-14, %eax

We have EFAULT for this. ;-)

> +	ret
> +
> +.section __ex_table,"a"
> +	.long 1b, bad_sys_umem_add
> +	.long 2b, bad_sys_umem_add
> +.previous

