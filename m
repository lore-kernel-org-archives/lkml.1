Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbYFLKfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbYFLKfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYFLKfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:35:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48837 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbYFLKfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:35:24 -0400
Date: Thu, 12 Jun 2008 13:35:20 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: repeatable slab corruption with LTP msgctl08
In-Reply-To: <20080611221324.42270ef2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806121332130.11556@sbz-30.cs.Helsinki.FI>
References: <20080611221324.42270ef2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 11 Jun 2008, Andrew Morton wrote:
> version is ltp-full-20070228 (lots of retro-computing there).
> 
> Config is at http://userweb.kernel.org/~akpm/config-vmm.txt
> 
> ./testcases/bin/msgctl08 crashes after ten minutes or so:
> 
> slab: Internal list corruption detected in cache 'size-128'(26), slabp f2905000(20). Hexdump:
> 
> 000: 00 e0 12 f2 88 32 c0 f7 88 00 00 00 88 50 90 f2
> 010: 14 00 00 00 0f 00 00 00 00 00 00 00 ff ff ff ff
> 020: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 030: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 040: fd ff ff ff fd ff ff ff 00 00 00 00 fd ff ff ff
> 050: fd ff ff ff fd ff ff ff 19 00 00 00 17 00 00 00
> 060: fd ff ff ff fd ff ff ff 0b 00 00 00 fd ff ff ff
> 070: fd ff ff ff fd ff ff ff fd ff ff ff fd ff ff ff
> 080: 10 00 00 00

Looking at the above dump, slabp->free is 0x0f and the bufctl it points to 
is 0xff ("BUFCTL_END") which marks the last element in the chain. This is 
wrong as the total number of objects in the slab (cachep->num) is 26 but 
the number of objects in use (slabp->inuse) is 20. So somehow you have 
managed to lost 6 objects from the bufctl chain.

I really don't understand how your bufctl chains has so many BUFCTL_END 
elements in the first place. It's doesn't look like the memory has been 
stomped on (slab->s_mem, for example, is 0xf2906088), so I'd look for a 
double kfree() of size 128 somewhere...

		Pekka
