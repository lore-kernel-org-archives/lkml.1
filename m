Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752252AbYLQU1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbYLQU1h (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYLQU1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:27:22 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:49642 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYLQU1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:27:21 -0500
Message-ID: <49496030.9080409@cosmosbay.com>
Date: Wed, 17 Dec 2008 21:25:20 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Christoph Hellwig <hch@infradead.org>,
        David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org,
        "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Netdev List <netdev@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 6/7] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com> <494196DD.5070600@cosmosbay.com> <200707241113.46834.nickpiggin@yahoo.com.au> <4941EC65.5040903@cosmosbay.com> <494295C6.2020906@cosmosbay.com> <Pine.LNX.4.64.0812121958470.15781@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0812121958470.15781@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 17 Dec 2008 21:25:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Fri, 12 Dec 2008, Eric Dumazet wrote:
> 
>>> a truly allocated file. At this point the file is
>>> a truly allocated file but not anymore ours.
> 
> Its a valid file. Does ownership matter here?
> 
>> Reading again this mail I realise we call put_filp(file), while this should
>> be fput(file) or put_filp(file), we dont know.
>>
>> Damned, this patch is wrong as is.
>>
>> Christoph, Paul, do you see the problem ?
> 
> Yes.
> 
>> In fget()/fget_light() we dont know if the other thread (the one who re-allocated the file,
>> and tried to close it while we got a reference on file) had to call put_filp() or fput()
>> to release its own reference. So we call atomic_long_dec_and_test() and cannot
>> take the appropriate action (calling the full __fput() version or the small one,
>> that some systems use to 'close' an not really opened file.
> 
> The difference is mainly that fput() does full processing whereas
> put_filp() is used when we know that the file was not fully operational.
> If the checks in __fput are able to handle the put_filp() situation by not
> releasing resources that were not allocated then we should be fine.
> 
>> I believe put_filp() is only called on slowpath (error cases).
> 
> Looks like it. It seems to assume that no dentry is associated.
> 
>> Should we just zap it and always call fput() ?
> 
> Only if fput() can handle partially setup files.

It can do that if we add a check for NULL dentry in __fput(), so put_filp() can disappear.

But there is a remaining point where we do an atomic_long_dec_and_test(&...->f_count),
in fs/aio.c, function __aio_put_req(). This one is tricky :(


