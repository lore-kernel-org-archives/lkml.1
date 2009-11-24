Return-Path: <linux-kernel-owner+w=401wt.eu-S933337AbZKXU7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbZKXU7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932855AbZKXU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:59:40 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49274 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851AbZKXU7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:59:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OPmmGl15J9KOMiJjR61CTfp8J5B7u8qpSWc2anUO8cVPSmcb3wkgk1+Teh0Rsvnj4O
         QNEvaSkmuQEsMukC62SiEYPTaTf+4uFoNj6qufHqLdhwWeNuXlQckUlp5tKupu8Uc3QX
         b8l0Y1yrCws3AbskmRCMLd4Lvx3toO4kxHeIA=
MIME-Version: 1.0
In-Reply-To: <20091124162311.GA8679@linux.vnet.ibm.com>
References: <20091118181202.GA12180@linux.vnet.ibm.com>
	 <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
	 <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>
	 <1258729748.4104.223.camel@laptop>
	 <1259002800.5630.1.camel@penberg-laptop>
	 <20091124162311.GA8679@linux.vnet.ibm.com>
Date: Tue, 24 Nov 2009 22:59:44 +0200
X-Google-Sender-Auth: 3050ce9c4763ebf3
Message-ID: <84144f020911241259r3a604b29yb59902655ec03a20@mail.gmail.com>
Subject: Re: lockdep complaints in slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
       cl@linux-foundation.org, mpm@selenic.com,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 6:23 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Nov 23, 2009 at 09:00:00PM +0200, Pekka Enberg wrote:
>> Hi Peter,
>>
>> On Fri, 2009-11-20 at 16:09 +0100, Peter Zijlstra wrote:
>> > > Uh, ok, so apparently I was right after all. There's a comment in
>> > > free_block() above the slab_destroy() call that refers to the comment
>> > > above alloc_slabmgmt() function definition which explains it all.
>> > >
>> > > Long story short: ->slab_cachep never points to the same kmalloc cache
>> > > we're allocating or freeing from. Where do we need to put the
>> > > spin_lock_nested() annotation? Would it be enough to just use it in
>> > > cache_free_alien() for alien->lock or do we need it in
>> > > cache_flusharray() as well?
>> >
>> > You'd have to somehow push the nested state down from the
>> > kmem_cache_free() call in slab_destroy() to all nc->lock sites below.
>>
>> That turns out to be _very_ hard. How about something like the following
>> untested patch which delays slab_destroy() while we're under nc->lock.
>>
>>                       Pekka
>
> Preliminary tests look good!  The test was a ten-hour rcutorture run on
> an 8-CPU Power system with a half-second delay between randomly chosen
> CPU-hotplug operations.  No lockdep warnings.  ;-)
>
> Will keep hammering on it.

Thanks! Please let me know when you're hammered it enough :-). Peter,
may I have your ACK or NAK on the patch, please?
