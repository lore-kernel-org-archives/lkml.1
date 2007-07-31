Return-Path: <linux-kernel-owner+w=401wt.eu-S940130AbXGaANc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940130AbXGaANc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbXGaANX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:13:23 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37331 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbXGaANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:13:22 -0400
Subject: Re: [PATCH] add check do_direct_IO() return val
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Jin <joe.jin@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
In-Reply-To: <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com>
	 <20070726221307.3d7b3446.akpm@linux-foundation.org>
	 <20070727071547.GA25084@joejin-pc.cn.oracle.com>
	 <46A9E6F9.20603@oracle.com>
	 <20070728034719.GA24448@joejin-pc.cn.oracle.com>
	 <20070730135316.2ce21b28.akpm@linux-foundation.org>
	 <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
	 <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
	 <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
	 <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 17:15:23 -0700
Message-Id: <1185840923.24525.11.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 16:38 -0700, Zach Brown wrote:
> On Jul 30, 2007, at 2:58 PM, Badari Pulavarty wrote:
> 
> > On Mon, 2007-07-30 at 14:45 -0700, Zach Brown wrote:
> >>> I am also taking a look at it right now.
> >>
> >> Are we having a race to write a little test app that reproduces the
> >> problem? :)
> >
> > Nope. Feel free to write the test case.
> 
> Well, I'm having a heck of a time getting this to fail.  It looks  
> possible, though.  Joe, were you guys able to narrow it down to a  
> reproducible test case?  Do you have any oops output messages from  
> the crashes?
> 
> It looks like it takes a very particular set of circumstances to  
> actually crash after relying on an uninitialized map_bh.  (see the  
> blkfactor, buffer_new(), and this_chunk_blocks tests in dio_zero_block 
> ()).


Looking at the crash

CPU:    0
EIP:    0060:[<c04a07fd>]    Not tainted VLI
EFLAGS: 00010293   (2.6.22 #2)
EIP is at bio_get_nr_vecs+0x0/0x30
eax: 23c07063   ebx: 00000003   ecx: ffffffff   edx: 00000000
esi: de5cef74   edi: f54a9600   ebp: 00000000   esp: de5ceca8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process fio (pid: 17820, ti=de5ce000 task=de6570e0 task.ti=de5ce000)
Stack: c04a1c9d ffffffff ffffffff 00000009 f54a9600 de5cef74 00000000
f54a9600
       c04a1f43 00000000 c04a2b46 c0460466 c2c5baa0 c0812500 c0462c0a
00000001
       00000001 df4b90d4 de5ceee4 00000011 00000001 00000009 00000009
00000000
Call Trace:
 [<c04a1c9d>] dio_new_bio+0x82/0xfe
 [<c04a1f43>] dio_send_cur_page+0x4a/0x92
 [<c04a2b46>] __blockdev_direct_IO+0xa09/0xc83
 [<c0460466>] __pagevec_free+0x14/0x1a
 [<c0462c0a>] release_pages+0x137/0x13f
 [<f8856f30>] journal_start+0xaf/0xdd [jbd]
 [<f8890fec>] ext3_direct_IO+0xfd/0x190 [ext3]
..

I am not sure, I really understand whats happening here. It looks
like dio->map_bh.b_dev is junk. But looking at the code, we shouldn't
be in dio_send_cur_page() unless if we have a valid dio->cur_page.
(which means, that we added a page to submit, which also means
previous getblock() succeded, which means that we should have a
valid map_bh). What am I missing here ?


        if (dio->cur_page) {
                ret2 = dio_send_cur_page(dio);
                if (ret == 0)
                        ret = ret2;
                page_cache_release(dio->cur_page);
                dio->cur_page = NULL;
        }

> 
> > I am just looking at the code
> > to see what needs to be done.
> 
> It looks like the unconditional dio_cleanup() and dio_zero_block()  
> calls outside the nseg loop are relying on state which might not have  
> been built up.  _zero_block() tests map_bh's flags without them being  
> set.  _cleanup could, in some crazy world, get confused if we managed  
> to get here with a 0 nr_segs because dio->head and ->tail wouldn't be  
> initialized.
> 
> So we could initialize some more fields at the start of  
> direct_io_worker for the benefit of these cleanup calls.  Or we could  
> conditionally call them based on some other indicator of progress.   
> Neither really thrills me.
> 
> And I don't have a test case to verify changes with.  Meh.
> 
> How do you feel about initializing the dio with kzalloc() and only  
> initializing the fields that we rely on being non-zero, and  
> commenting the hell out of it?

Yeah. kzalloc() may be right way to go.. But I would like to understand
what exactly is happening here.

Thanks,
Badari

