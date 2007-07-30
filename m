Return-Path: <linux-kernel-owner+w=401wt.eu-S939068AbXG3XjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939068AbXG3XjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761858AbXG3XjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:39:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25876 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761636AbXG3XjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:39:05 -0400
In-Reply-To: <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Jin <joe.jin@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Date: Mon, 30 Jul 2007 16:38:48 -0700
To: Badari Pulavarty <pbadari@us.ibm.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 30, 2007, at 2:58 PM, Badari Pulavarty wrote:

> On Mon, 2007-07-30 at 14:45 -0700, Zach Brown wrote:
>>> I am also taking a look at it right now.
>>
>> Are we having a race to write a little test app that reproduces the
>> problem? :)
>
> Nope. Feel free to write the test case.

Well, I'm having a heck of a time getting this to fail.  It looks  
possible, though.  Joe, were you guys able to narrow it down to a  
reproducible test case?  Do you have any oops output messages from  
the crashes?

It looks like it takes a very particular set of circumstances to  
actually crash after relying on an uninitialized map_bh.  (see the  
blkfactor, buffer_new(), and this_chunk_blocks tests in dio_zero_block 
()).

> I am just looking at the code
> to see what needs to be done.

It looks like the unconditional dio_cleanup() and dio_zero_block()  
calls outside the nseg loop are relying on state which might not have  
been built up.  _zero_block() tests map_bh's flags without them being  
set.  _cleanup could, in some crazy world, get confused if we managed  
to get here with a 0 nr_segs because dio->head and ->tail wouldn't be  
initialized.

So we could initialize some more fields at the start of  
direct_io_worker for the benefit of these cleanup calls.  Or we could  
conditionally call them based on some other indicator of progress.   
Neither really thrills me.

And I don't have a test case to verify changes with.  Meh.

How do you feel about initializing the dio with kzalloc() and only  
initializing the fields that we rely on being non-zero, and  
commenting the hell out of it?

- z
