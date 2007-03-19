Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbXCSIcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbXCSIcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 04:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXCSIcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 04:32:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:28438 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbXCSIcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 04:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=s1vLIlteKfnk0J9/FGJKEYemddAQX34YUhJPBxYf1A551M2u4nf4q2MCH/73vU3HjphSBuq/PpzQlhGV1UO1/nY/N+Jd0LxHAliU8N0kinuzXhrbHH41Ks8DrMcOAPF0CfKZnOBRDCiTsiqkez/gb4DjS5UsWrz7cmlrhj0WBPE=
Message-ID: <84144f020703190132w4596a810k23f3423f36a52630@mail.gmail.com>
Date: Mon, 19 Mar 2007 10:32:00 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Cc: "Andreas Steinmetz" <ast@domdv.de>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <84144f020703190100j5becc9dka2eba58456ab95f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45FDDA8E.8030100@domdv.de>
	 <20070318220006.7230fd58.akpm@linux-foundation.org>
	 <84144f020703190100j5becc9dka2eba58456ab95f3@mail.gmail.com>
X-Google-Sender-Auth: f467299eed55115f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> EIP is at kmem_cache_free+0x29/0x5a
> eax: c1800000   ebx: f0ae12c0   ecx: c18f73c0   edx: c1800000
> esi: c1919de0   edi: 00000000   ebp: 00001000   esp: f1fe7e14
> ds: 007b   es: 007b   ss: 0068
>
> But somehow eax and edx have the same value 0xc1800000 here. Hmm?

Aah, but if you look at contents of the stack:

Stack: f0ae12c0 c1919de0 ffffffea c0137f97 00000000 f0ae12c0 c1919e20 c0168d45
       f0ae12c0 00001000 c0168fb9 c02a77e3 00001000 00000000 00000000 00000000
       00000000 c17bb6e0 00001000 00000000 f1b38be8 00000003 f54ac050 c1b9d6e8
Call Trace:
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c0168d45>] bio_free+0x21/0x2c
 [<c0168fb9>] bio_put+0x22/0x23

You can see that mempool_free is passing a NULL pointer to
kmem_cache_free() which doesn't handle it properly. The NULL pointer
comes from bio_free() where ->bi_io_vec is  NULL because nr_iovecs
passed to bio_alloc_bioset() was zero.

The question is, why is nr_pages zero in scsi_req_map_sg()?
