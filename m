Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZKTKh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZKTKh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZKTKh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:37:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:32475 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZKTKh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TjeAbCH1LRmAlgmg/ihTQoNuPDKwtwuu4YPmCv19WsMqp4DdDfCHnMZaOwIwnBrHic
         TNoQ/NvLoEdr5dDpeY8MI5WN6sKDkU/Zmq0aB5jUBaYTyjnxQ9B1QZxPHlIA1c3IvAvI
         PkfcgmHBPSmzD44ZdPGN8/o2DwQA8/xB/vv7Y=
MIME-Version: 1.0
In-Reply-To: <1258709153.11284.429.camel@laptop>
References: <20091118181202.GA12180@linux.vnet.ibm.com>
	 <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
Date: Fri, 20 Nov 2009 12:38:02 +0200
X-Google-Sender-Auth: 1cacd35034aa02da
Message-ID: <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
Subject: Re: lockdep complaints in slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, linux-mm@kvack.org, cl@linux-foundation.org,
       mpm@selenic.com, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Did anything change recently? git-log mm/slab.c doesn't show anything
> obvious, although ec5a36f94e7ca4b1f28ae4dd135cd415a704e772 has the exact
> same lock recursion msg ;-)

No, SLAB hasn't changed for a while.

On Fri, Nov 20, 2009 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> So basically its this stupid recursion issue where you allocate the slab
> meta structure using the slab allocator, and now have to free while
> freeing, right?

Yes.

On Fri, Nov 20, 2009 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> The code in kmem_cache_create() suggests its not even fixed size, so
> there is no single cache backing all this OFF_SLAB muck :-(

Oh, crap, I missed that. It's variable-length because we allocate the
freelists (bufctls in slab-speak) in the slab managment structure. So
this is a genuine bug.

On Fri, Nov 20, 2009 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> It does appear to be limited to the kmalloc slabs..
>
> There's a few possible solutions -- in order of preference:
>
>  1) do the great slab cleanup now and remove slab.c, this will avoid any
> further waste of manhours and braincells trying to make slab limp along.

:-) I don't think that's an option for 2.6.33.

On Fri, Nov 20, 2009 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>  2) propagate the nesting information and user spin_lock_nested(), given
> that slab is already a rat's nest, this won't make it any less obvious.

spin_lock_nested() doesn't really help us here because there's a
_real_ possibility of a recursive spin lock here, right?

                        Pekka
