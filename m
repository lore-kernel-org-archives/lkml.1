Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYFNOxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYFNOxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 10:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYFNOw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 10:52:56 -0400
Received: from [194.117.236.238] ([194.117.236.238]:46843 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYFNOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 10:52:55 -0400
Date: Sat, 14 Jun 2008 17:52:23 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
 writing to a CPU buffer.
Message-ID: <20080614175223.4d3c6084@linux360.ro>
In-Reply-To: <1213418437.8237.51.camel@charm-linux>
References: <20080613040947.7465b9a5@linux360.ro>
	<1213418437.8237.51.camel@charm-linux>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 23:40:37 -0500
Tom Zanussi <tzanussi@gmail.com> wrote:

> I'm wondering if the all-zeroes at the end of the buffer might be
> another case of the all-zeroes you were seeing due to cross-cpu
> reading you decribed in the other patch.  In any case, I'm pretty
> sure this patch isn't doing what you think it is, and don't see how
> it could have fixed the problem (see below).  There may still be a
> bug somewhere, but it would be good to be able to reproduce it.  Does
> it happen even when running on a single cpu?

Hi,

I noticed this problem after adding those spinlocks. As far as I can
tell, having (offset == subbuf_size + 1) at any given moment allows the
read() handler to see inconsistent offsets:
1. writer sets offset = subbuf_size + 1
2. writer releases spinlock
3. read() acquires spinlock and reads the wrong offset
4. read() releases spinlock
5. next writer corrects the offset at the next write
 
> This case, offset being 1 larger than the subbuf size, is how we note
> a full sub-buffer, so changing this will break full-subbuffer cases. 

No, it won't. Maximum length messages result in the following condition:
start + offset == subbuf_size
This happens because a buffer of length subbuf_size actually ranges
from zero to (subbuf_size - 1) in regard to how it is addressed. Then,
subbuf_size + 1 isn't just outside the bounds, but one more byte off.
"Visual" example:
subbuf_size = 4
|[ ][ ][ ][ ]|[ ]
  0  1  2  3   subbuf_size

So, a full subbufer means offset equals subbuf_size, that is, the next
empty slot is just outside the subbuffer.


	Eduard
