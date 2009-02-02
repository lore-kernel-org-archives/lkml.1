Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZBBJeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZBBJeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZBBJd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:33:59 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:18344 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbZBBJd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:33:58 -0500
Message-ID: <4986BE07.6090000@panasas.com>
Date: Mon, 02 Feb 2009 11:33:59 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       Eric Sandeen <sandeen@sandeen.net>, mfasheh@suse.com,
       joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk,
       Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
 for compatibility with legacy xfs ioctls
References: <20090130171423.f99c88d0.akpm@linux-foundation.org> <20090201164130.GA32276@infradead.org> <4985D48A.6090007@panasas.com> <200902020131.04203.arnd@arndb.de> <4986AEE8.5040609@panasas.com> <Pine.LNX.4.64.0902020942230.11930@anakin>
In-Reply-To: <Pine.LNX.4.64.0902020942230.11930@anakin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2009 09:33:56.0239 (UTC) FILETIME=[5E7851F0:01C98519]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Mon, 2 Feb 2009, Boaz Harrosh wrote:
>> Arnd Bergmann wrote:
>>> No, the compiler is correct, it has to generate more complex code
>>> if it cannot assume that data is naturally aligned and the architecture
>>> does not support unaligned loads. If you don't understand this, please
>>> at least read the list archives about the last five times this came up
>>> before claiming that the compiler is broken.
>>>
>> Wrong!! Sorry, you guys don't listen.
>> I'm talking of the case where the structures are EXACTLY the same anyway
>> you look at them. sizeof(foo) == sizeof(foo_packed) and 
>> offsetof(foo_memmber) == offsetof(foo_packed_member) for every member of
>> the structure. foo && foo_packed are declared exactly the same but with
>> __attribute__((packed(1))) applied to the later.
>>
>> THEN in ia64 case the compiler is brain dead, because it relates
>> "unalignment" to packed(1) which are two different things.
> 
> The natural alignment of a structure is max(alignment(member)), for all
> members. With __attribute__((packed)), the natural alignment of the structure
> is 1, so the compiler cannot assume anything.
> 

No the natural alignment is what it is, after the application of
__attribute__((packed(1))). In a well defined structure that is a no-opt.
But yes in ai64 the gcc programmers got lazy and did not make that analysis
after laying out the structure.

> While the ints in the structure may still be at offsets 0, 4, 8, and so on,
> this doesn't say anything about their actual memory addresses, as the struct
> base address itself may be unaligned.
> 

The base address can be unaligned even if the structure is aligned. In that
case you need the __atrubute__((aligned)) thingy. It is true that if the sizeof(foo_packed)
is though unaligned, the compiler will have to assume unalignment in array operations.
but if the sizeof(foo_packed) is naturally aligned at the output then the compiler
has all the needed information to know that even if I declared __packed, it calculated
and knows that it is well aligned at the end.

> Gr{oetje,eeting}s,
> 
> 						Geert
> 

Please note that I gave up on the compiler and understand that the use of __packed
is dangerous in some cases, sigh. My standing point is to make sure there are no guesses
left, and a BUILD_BUG_ON to make sure of that.

Boaz
