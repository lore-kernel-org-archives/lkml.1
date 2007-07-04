Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbXGDN7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbXGDN7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760547AbXGDN7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:59:40 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56470 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760047AbXGDN7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:59:39 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: jim.houston@ccur.com
Subject: Re: idr_get_new_above() limitation?
Date: Wed, 4 Jul 2007 16:11:29 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       raisch@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>
References: <200707021919.27251.hnguyen@linux.vnet.ibm.com> <1183422700.3130.27.camel@localhost.localdomain>
In-Reply-To: <1183422700.3130.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041611.30056.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007 02:31, Jim Houston wrote:
> The problem is in idr_get_new_above_int() in the loop which
> adds new layers to the top of the radix tree.  It is failing
> the "layers < (MAX_LEVEL - 1)" test.  It doesn't allocate the
> new layer but still calls sub_alloc() which relies on having
> the new layer properly constructed.  I believe that it is
> allocating the slot which corresponds to id = 0.
Hi Jim,
Thanks for your quick reply.
Yes, I realized that while condition too and have tried with a tiny
change like (layers < MAX_LEVEL), but without success with idr_find(), 
even though 6 layers were created and the object was added at proper
location. After several debug cycles I think to find the root cause 
in the if-condition in idr_find():
void *idr_find(struct idr *idp, int id)
{
	int n;
	struct idr_layer *p;

	n = idp->layers * IDR_BITS;
	p = idp->top;

	/* Mask off upper bits we don't use for the search. */
	id &= MAX_ID_MASK;

	if (id >= (1 << n))
		return NULL;
...
}
Since idp->layers is now 6, n is equal 36, ie out of 32-bit-range,
and therefore
	(1 << n) = (1 << 36) = 0
causing that if-cond to be true ie idr_find() fails.
Replacing that if-line by
	if ((long)id >= (1L << n))
makes idr_find() working properly until MAX_ID_MASK.
Since there are other places to be changed like above as well eg.
idr_replace() and because you're creating a patch too, I'm waiting
first for your comment. Let me know if you prefer me to send a
patch.
Regards
Nam


