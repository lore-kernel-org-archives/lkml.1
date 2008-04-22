Return-Path: <linux-kernel-owner+w=401wt.eu-S1765165AbYDVPPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765165AbYDVPPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762464AbYDVPPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:15:36 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:35664
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762129AbYDVPPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:15:35 -0400
Date: Tue, 22 Apr 2008 17:15:30 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080422151529.GE24536@duo.random>
References: <ea87c15371b1bd49380c.1208872277@duo.random> <480DFC8A.8040105@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <480DFC8A.8040105@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 04:56:10PM +0200, Eric Dumazet wrote:
> Andrea Arcangeli a écrit :
>> +
>> +static int mm_lock_cmp(const void *a, const void *b)
>> +{
>> +	cond_resched();
>> +	if ((unsigned long)*(spinlock_t **)a <
>> +	    (unsigned long)*(spinlock_t **)b)
>> +		return -1;
>> +	else if (a == b)
>> +		return 0;
>> +	else
>> +		return 1;
>> +}
>> +
> This compare function looks unusual...
> It should work, but sort() could be faster if the
> if (a == b) test had a chance to be true eventually...

Hmm, are you saying my mm_lock_cmp won't return 0 if a==b?

> static int mm_lock_cmp(const void *a, const void *b)
> {
> 	unsigned long la = (unsigned long)*(spinlock_t **)a;
> 	unsigned long lb = (unsigned long)*(spinlock_t **)b;
>
> 	cond_resched();
> 	if (la < lb)
> 		return -1;
> 	if (la > lb)
> 		return 1;
> 	return 0;
> }

If your intent is to use the assumption that there are going to be few
equal entries, you should have used likely(la > lb) to signal it's
rarely going to return zero or gcc is likely free to do whatever it
wants with the above. Overall that function is such a slow path that
this is going to be lost in the noise. My suggestion would be to defer
microoptimizations like this after 1/12 will be applied to mainline.

Thanks!

