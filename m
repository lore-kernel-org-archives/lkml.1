Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYDOHV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYDOHV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYDOHVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:21:21 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59396 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYDOHVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:21:20 -0400
Date: Tue, 15 Apr 2008 09:21:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, borntraeger@de.ibm.com,
       peter.oberparleiter@de.ibm.com, schwidefsky@de.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + s390-tty-prepare-for-put_char-to-return-success-fail.patch
	added to -mm tree
Message-ID: <20080415072117.GA4177@osiris.boeblingen.de.ibm.com>
References: <200804150204.m3F24GdU005600@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804150204.m3F24GdU005600@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   * NOTE: include/linux/tty_driver.h specifies that a character should be
>   * ignored if there is no room in the queue. This driver implements a different
>   * semantic in that it will block when there is no more room left.
> + *
> + * FIXME: putchar can currently be called from BH and other non blocking
> + * handlers so  this semantic isn't a good idea.
>   */
> -static void
> +static int
>  sclp_vt220_put_char(struct tty_struct *tty, unsigned char ch)
>  {
>  	__sclp_vt220_write(&ch, 1, 0, 0, 1);
> +	return 1;

Uh, oh... the comment above used to mean "block if in schedulable context or
busy wait otherwise". Figuring out which context we were in was done via
in_atomic(), which was broken on !SMP anyway, so that had to go.
So the last parameter for __sclp_vt220_write is now an indicator if scheduling
is allowed or not (1 means yes). Somebody told me that the put_char routine
will only be called from schedulable context, which now doesn't seem to be
true?!
For the console functions we pass indeed 0 to __sclp_vt220_write since printk
may be called within any context. Is that also true for the tty put_char
routine?
