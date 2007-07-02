Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbXGBW6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbXGBW6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbXGBW56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:57:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756002AbXGBW55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:57:57 -0400
Date: Mon, 2 Jul 2007 15:56:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, jim.houston@ccur.com,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>, raisch@de.ibm.com
Subject: Re: idr_get_new_above() limitation?
Message-Id: <20070702155633.720b5667.akpm@linux-foundation.org>
In-Reply-To: <200707021919.27251.hnguyen@linux.vnet.ibm.com>
References: <200707021919.27251.hnguyen@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 19:19:26 +0200
Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com> wrote:

> For ehca device driver we're intending to utilize 
> idr_get_new_above() and have written a test case, which I'm attaching
> at the end. Basically it tries to get an idr token above a lower boundary
> by calling idr_get_new_above() and then uses idr_find() to check if 
> the returned token can be found. 
> Here is our observation with 2.6.22-rc7 on ppc64:
> 
> Use lower boundary 0x3ffffffc
> [root@xyz idr_bug]# insmod idr_test_mod.ko start=1073741820
> insmod: error inserting 'idr_test_mod.ko': -1 Unknown symbol in module
> [root@xyz idr_bug]# dmesg -c
> i=3ffffffc token=3ffffffc t=000000003ffffffc
> i=3ffffffd token=3ffffffd t=000000003ffffffd
> i=3ffffffe token=3ffffffe t=000000003ffffffe
> i=3fffffff token=3fffffff t=000000003fffffff
> i=40000000 token=40000000 t=0000000000000000
> Invalid object 0000000000000000. Expected 40000000
> 
> That means token 0x40000000 seems to be the "upper boundary" of idr_find().
> However the behaviour is not consistent in that it was returned by
> idr_get_new_above().
> 
> Looking at void *idr_find(struct idr *idp, int id)
> {
> 	int n;
> 	struct idr_layer *p;
> 
> 	n = idp->layers * IDR_BITS;
> 	p = idp->top;
> 
> 	/* Mask off upper bits we don't use for the search. */
> 	id &= MAX_ID_MASK;
> 
> 	if (id >= (1 << n))
> 		return NULL;
> 
> 	while (n > 0 && p) {
> 		n -= IDR_BITS;
> 		p = p->ary[(id >> n) & IDR_MASK];
> 	}
> 	return((void *)p);
> }
> we found that the if-condition has failed:
>   layers = 5
>   IDR_BITS = 6
>   n = 30
>   (id >= (1 << n)) = (0x40000000 >= 0x40000000) = 1
> 
> Since MAX_ID_MASK=0x7fffffff, I'm wondering if 0x40000000 is the actual
> upper boundary. Any hints or suggestions are appreciated.

Looks like a bug to me.  Really an IDR tree on 32-bit should go all
the way up to 0xffffffff.  Certainly up to 0x7fffffff.  And the fact
that idr_find() disagrees with idr_get_new_above() is a big hint
that the code is getting it wrong.


