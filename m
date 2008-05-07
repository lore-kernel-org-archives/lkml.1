Return-Path: <linux-kernel-owner+w=401wt.eu-S1765043AbYEGRdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765043AbYEGRdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765011AbYEGRc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:32:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763120AbYEGRcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:32:53 -0400
Date: Wed, 7 May 2008 10:31:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507172246.GA13262@elte.hu>
Message-ID: <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org>
 <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> There's far more normal mutex fastpath use during an AIM7 run than any 
> BKL use. So if it's due to any direct fastpath overhead and the 
> resulting widening of the window for the real slowdown, we should see a 
> severe slowdown on AIM7 with CONFIG_MUTEX_DEBUG=y. Agreed?

Not agreed.

The BKL is special because it is a *single* lock.

All the "normal" mutex code use fine-grained locking, so even if you slow 
down the fast path, that won't cause the same kind of fastpath->slowpath 
increase.

In order to see the fastpath->slowpath thing, you do need to have many 
threads hitting the same lock: ie the slowdown has to result in real 
contention. 

Almost no mutexes have any potential for contention what-so-ever, except 
for things that very consciously try to hit it (multiple threads doing 
readdir and/or file creation on the *same* directory etc).

The BKL really is special. 

		Linus
