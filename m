Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZETTId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZETTId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZETTI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 15:08:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZETTIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 15:08:25 -0400
Date: Wed, 20 May 2009 21:03:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Q: put_user_try & co (Was: [PATCH 1/5] Split wait_noreap_copyout())
Message-ID: <20090520190312.GA32333@redhat.com>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com> <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com> <20090511120418.GA3859@infradead.org> <20090511121708.GD13954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511121708.GD13954@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Ingo Molnar wrote:
>
> See the (new) put_user_try / put_user_ex() / put_user_catch()
> abstraction in arch/x86/include/asm/uaccess.h, and how all the x86
> signal code makes use of that to optimize such patterns of per field
> user copies.

Just curious, can't we simplify put_user_{try,ex,catch} ?

Pseudo-code:

	#define put_user_try				\
		do {					\
			__label__  __efault_label;	\


	#define put_user_catch(err)			\
			err = 0;			\
			if (0) {			\
			__efault_label:			\
				err = -EFAULT;		\
			}				\
		while (0)
		

	#define __put_user_asm_ex(...)				\
		asm volatile(					\
			"1:	mov ..."			\
			_ASM_EXTABLE(1b, &__efault_label)	\
		     	: : ...)


Now, we don't need thread_info->uaccess_err, and we don't need the
special "if (fixup->fixup < 16)" hack in fixup_exception(). Once
any put_user_ex() fails, we jump to the __efault_label and set
err = -EFAULT.

This also means that we skip other put_user_ex's after the faulted
one. Not very important, this is unlikely case, but imho nice anyway.

Can this work? (warning: my asm skills is almost zero ;)

Oleg.

