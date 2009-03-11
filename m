Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZCKTxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZCKTxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCKTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:53:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbZCKTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:53:31 -0400
Date: Wed, 11 Mar 2009 12:50:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org, s.L-H@gmx.de
Subject: Re: [GIT-PULL] More Squashfs fixes for 2.6.29?
In-Reply-To: <E1LhU3m-0001f1-Cw@dylan.lougher.demon.co.uk>
Message-ID: <alpine.LFD.2.00.0903111237410.32478@localhost.localdomain>
References: <E1LhU3m-0001f1-Cw@dylan.lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Mar 2009, Phillip Lougher wrote:
> 
> Squashfs: Valid filesystems are flagged as bad by the corrupted fs patch
> 
> The problem arises due to an unexpected corner-case with zlib which the
> corrupted filesystems patch didn't address.  Very occasionally zlib
> exits needing a couple of extra bytes of input (up to 6 seen bytes in the
> test filesystems), but with avail_out == 0 and no more output buffer
> space available.  This situation was incorrectly flagged as an output buffer
> overrun by the corrupted filesystems patch.

I'm almost certain that this situation is caused by a bug in how you call 
zlib().

You've explicitly asked for Z_NO_FLUSH, and I suspect you should be using 
Z_SYNC_FLUSH (of Z_FINISH if you know you have all the input data). You 
want as much to be inflated as possible, and you do seem to be expecting 
it to flush as much as possible. 

However, I think the more direct cause is your inflate loop. The rules for 
running inflate() is to call it until it is done, or returns an error:

    inflate() should normally be called until it returns Z_STREAM_END or an
  error. However if all decompression is to be performed in a single step
  (a single call of inflate), the parameter flush should be set to
  Z_FINISH.

so you seem to be doing this all wrong. I think you _should_ be doing an 
inner loop over zlib_inflate() that just does inflates until you get a 
buffer error, and if you get a buffer error you then go on to the next 
page if avail_out is zero (all done if it's the last page), or fill the 
input buffer if it's empty.

So I really think you should fix the zlib_inflate() loop instead.

I dunno. At least that's what the docs suggest, and it's what we do in 
git (another heavy user of zlib, althoughb the usage patterns are rather 
different, and we _tend_ to 

			Linus
