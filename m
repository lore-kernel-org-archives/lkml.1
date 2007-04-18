Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXDRFR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXDRFR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 01:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXDRFR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 01:17:27 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47160 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbXDRFR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 01:17:26 -0400
Date: Tue, 17 Apr 2007 22:14:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Florin Iucha <florin@iucha.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
In-Reply-To: <20070418043040.GD24044@iucha.net>
Message-ID: <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
References: <1176792399.3035.30.camel@twins> <1176796503.3035.33.camel@twins>
 <87hcrfaqam.fsf@duaron.myhome.or.jp> <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
 <20070417195823.943f9472.akpm@linux-foundation.org>
 <1176865565.6796.16.camel@heimdal.trondhjem.org> <20070418033055.GA24044@iucha.net>
 <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net>
 <20070417211350.ebba1493.akpm@linux-foundation.org>
 <20070418043040.GD24044@iucha.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Apr 2007, Florin Iucha wrote:
> 
> Already did.  Traces from vanilla kernel at
>    http://iucha.net/nfs/21-rc7/big-copy

Well, there's a pdflush in io_schedule_timeout/congestion_wait, and 
there's a nfsv4-scv in svc_recv/nfs_callback_sv, and a lot of processes 
either just in schedule_timeout or similar "normal" waiting (pollwait 
etc).

[ The call traces could be prettier, but sadly, even if you enable frame 
  pointers, the x86-64 kernel is too stupid to follow them. So you kind of 
  just have to ignore the noise) ]

The triggering process looks like it might be that "cp", it is in the 
__wait_on_bit/sync_page/wait_on_page_bit/wait_on_page_writeback_range/ 
filemap_fdatawait.

Is this a trace from the "big copy" hang, or from a gnome splashscreen 
hang? It *looks* like it's a big copy. Yes/no?

Anyway, looks like the cp did a "utimes()" system call, which triggers 
"nfs_setattr(), which in turn triggers the filemap_fdatawait() and some 
kind of endless wait. Nothing stands out from the traces, in other words. 
Doesn't look like a locking thing, for example - we're not stuck on some 
inode semaphore, we're literally waiting for the page to be written out.

		Linus
