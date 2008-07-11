Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYGKFtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYGKFtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYGKFti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:49:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:22440 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYGKFth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rAP8WIVIrxjaVVqCK8ptL05egs0wIOHo1zSqHfLQq+CacvR6JsaFaYB1t7xUHG7q36
         Yn6W48FkMDeSTALzGHDcJBtt0W/ru3BWNsg99atUE0o1syks5/bMg7ashuOtUCKKDFh+
         67gHd1pC/ltwTeOlnHoUY2B9bvuW7FiyxDLIk=
Message-ID: <19f34abd0807102249t6b2e9e97l97bc5b22cc7709ef@mail.gmail.com>
Date: Fri, 11 Jul 2008 07:49:34 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
	 <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 10:16 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> Yeah, it's possible that a caller of kmem_cache_alloc() ->
> slab_alloc() can be migrated on another CPU right after
> local_irq_restore() and before memset(). The inital cpu can become
> offline in the mean time (or a migration is a consequence of the CPU
> going offline) so its 'kmem_cache_cpu' structure gets freed (
> slab_cpuup_callback).
>
> At some point of time the caller continues on another CPU having an
> obsolete pointer...
>
> does something like this help?

Nice :-)

By the way, this also explains the heavy corruption I was seeing (NULL
pointers in lists detected by list debugging, etc.); SLUB was doing a
HUGE memset of 0 on arbitrary memory, i.e. the memset effectively
became:

    memset(object, 0, 0x1adadada);

..and in some of the cases, the machine didn't crash inside SLUB but
proceeded...

I guess I should reload and try the latest -git now :-)

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
