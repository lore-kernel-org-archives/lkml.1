Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbXE3KNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbXE3KNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXE3KNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:13:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:22921 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXE3KNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KW0wOD7iplSlNG6QDIsRb2xeW8gxHdFoJiSUa0wJnuIjWObAXypPoEbq3UN9DybPN2Le53cZNK5I1jt020WlvNZFFbee399gwWN312Nqkb86gy5IsuIY7DXC1oH4qqcCEWXo74ScAIOCTBJL4FzE20ukOA/s2qYOphHLILbtl9Q=
Message-ID: <465D4DF1.5040500@gmail.com>
Date: Wed, 30 May 2007 19:12:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: epoll,threading
References: <MDEHLPKNGKAHNMBLJOLKGEJIEBAC.davids@webmaster.com> <465C809C.60507@gmail.com> <20070530072528.GP943@1wt.eu>
In-Reply-To: <20070530072528.GP943@1wt.eu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Willy Tarreau wrote:
> In my experience, it's not much the context switch by itself which
> causes performance degradation, but the fact that with threads, you
> have to put mutexes everywhere. And frankly, walking a list with
> locks everywhere is quite slower than doing it in one run at a rate
> of 3 or 4 cycles per entry. Also, local storage in function returns
> is not possible anymore, and some functions even need to malloc()
> instead of returning statically allocated data. I believe this is the
> reason for openssl being twice as slow when compiled thread-safe than
> in native mode.
> 
> So in fact, converting a threaded program to a pure async model
> should not improve it much because of the initial architectural
> design. But a program written from scratch to be purely async should
> perform better simply because it has less operations to perform. And
> there's no magics here : less cycles spend synchronizing and locking
> = more cycles available for the real job.

The thing is that the synchronization overhead is something you'll have
to pay anyway to support multiple processors.  Actually, supporting
multiple processors on an async program is beyond painful.  Either you
have to restrict all locking to busy locks or introduce new state for
each possibly blocking synchronization point and what happens if they
have to nest?  You kind of end up with stackable state thingie - an
extremely restricted stack.

If you're really serious about performance and scalability, you just
have to support multiple processors and if you do it right the
performance overhead shouldn't be too high.  Common servers will soon
have 8 cores on two physical processors - paying some overhead for
synchronization is pretty good deal for scalability.

>> In my experience with web caches, epoll or similar for idle clients
>> and thread per active client scaled and performed pretty well - it
>> needed more memory but the performance wasn't worse than
>> asynchronous design and doing complex server in async model is a
>> lot of pain.
> 
> It's true that an async model is a lot of pain. But it's always where
> I got the best performance. For instance, with epoll(), I can achieve
>  20000 HTTP reqs/s with 40000 concurrent sessions. The best
> performance I have observed from threaded competitors was an order of
> magnitude below on either value (sometimes both).

Well, it all depends on how you do it but an order of magnitude
performance difference sounds too much to me.  Memory-wise scalability
can be worse by orders of magnitude.  You need to restrict per-thread
stack size and use epoll for idle threads, if you wanna scale.  Workers
+ async monitoring of idle clients scale pretty well.

> However, I agree that few uses really require to spend time writing
> and debugging async programs.

Yeap, also there are several things which just are too painful in async
server - e.g. adding coordination with another server (virus scan,
sharing cached data), implementing pluggable extension framwork for
third parties (and what happens if they should be able to stack!), and
maintaining the damn thing while trying to add a few features.  :-)

IMHO, complex pure async server doesn't really make sense anymore.

Thanks.

-- 
tejun
