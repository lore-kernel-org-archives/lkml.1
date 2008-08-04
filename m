Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYHDXJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYHDXJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYHDXJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:09:33 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:58494 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYHDXJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:09:32 -0400
Message-ID: <48978C21.7030107@keyaccess.nl>
Date: Tue, 05 Aug 2008 01:09:21 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Matthew Wilcox <matthew@wil.cx>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org> <4896225D.9090203@cs.helsinki.fi> <48966B6D.604@keyaccess.nl> <48977330.4090501@cs.helsinki.fi> <4897777C.1070801@linux-foundation.org>
In-Reply-To: <4897777C.1070801@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-08-08 23:41, Christoph Lameter wrote:

>>> General interested question -- I recently "accidentally" read some of
>>> slub and I believe that it doesn't feature the cache colouring support
>>> that slab did? Is that true, and if so, wasn't it needed/useful?
>> I don't know why Christoph decided not to implement it. Christoph?
> 
> IMHO cache coloring issues seem to be mostly taken care of by newer more
> associative cpu caching designs.

I see. Just gathered a bit of data on this (from sandpile.org):

32-byte lines:

P54 : L1 I 8K,            2-Way
          D 8K,            2-Way
       L2 External

P55 : L1 I 16K,           4-Way
          D 16K,           4-Way
       L2 External

P2  : L1 I 16K            4-Way
          D 16K            4-Way
       L2 128K to 2MB      4-Way

P3  : L1 I 16K            4-Way
          D 16K            4-Way
       L2 128K to 2MB      4-Way or
          256K to 2MB      8-Way

64-byte lines:

P4  : L1 I 12K uOP Trace  (8-Way, 6 uOP line)
          D  8K            4-Way or
            16K            8-Way
       L2 128K             2-Way or
          128K, 256K       4-Way or
          512K, 1M, 2M     8-Way
       L3 512K             4-Way or
          1M to 8M         8-Way or
          2M to 16M       16-Way

Core: L1 I 32K            8-Way
          D 32K            8-Way
       L2 512K             2-Way or
          1M               4-Way or
          2M               8-Way or
          3M              12-Way or
          4M              16-Way

K7  : L1 I 64K            2-Way
          D 64K            2-Way
       L2 512, 1M, 2M      2-Way or
          4M, 8M           1-Way or
          64K, 256K, 512K 16-Way

K8  : L1 I 64K            2-Way
          D 64K            2-Way
       L2 128K to 1M      16-Way


The L1 on K7 and K8 especially seems still a bit of worry here.

> Note that the SLAB design origin is Solaris (See the paper by Jeff Bonwick in
> 1994 that is quoted in mm/slab.c). Logic for cache coloring is mostly avoided
> today due to the complexity it would introduce. See also
> http://en.wikipedia.org/wiki/CPU_cache.
> 
> What one could add to support cache coloring in SLUB is a prearrangement of
> the order of object allocation order by constructing the initial freelist for
> a page in a certain way. See mm/slub.c::new_slab()

<remains silent>

To me, colouring always seemed like a fairly promising thing but I won't 
pretend to have any sort of data.

Rene.
