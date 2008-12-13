Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYLMCJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYLMCJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYLMCI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:08:59 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:41921 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYLMCI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:08:58 -0500
Date: Fri, 12 Dec 2008 20:07:56 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 6/7] fs: struct file move from call_rcu() to
 SLAB_DESTROY_BY_RCU
In-Reply-To: <494295C6.2020906@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0812121958470.15781@quilx.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com>
 <494196DD.5070600@cosmosbay.com> <200707241113.46834.nickpiggin@yahoo.com.au>
 <4941EC65.5040903@cosmosbay.com> <494295C6.2020906@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Eric Dumazet wrote:

> > a truly allocated file. At this point the file is
> > a truly allocated file but not anymore ours.

Its a valid file. Does ownership matter here?

> Reading again this mail I realise we call put_filp(file), while this should
> be fput(file) or put_filp(file), we dont know.
>
> Damned, this patch is wrong as is.
>
> Christoph, Paul, do you see the problem ?

Yes.

> In fget()/fget_light() we dont know if the other thread (the one who re-allocated the file,
> and tried to close it while we got a reference on file) had to call put_filp() or fput()
> to release its own reference. So we call atomic_long_dec_and_test() and cannot
> take the appropriate action (calling the full __fput() version or the small one,
> that some systems use to 'close' an not really opened file.

The difference is mainly that fput() does full processing whereas
put_filp() is used when we know that the file was not fully operational.
If the checks in __fput are able to handle the put_filp() situation by not
releasing resources that were not allocated then we should be fine.

> I believe put_filp() is only called on slowpath (error cases).

Looks like it. It seems to assume that no dentry is associated.

> Should we just zap it and always call fput() ?

Only if fput() can handle partially setup files.

