Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYDVO4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYDVO4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYDVO4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:56:39 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:25302 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYDVO4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:56:38 -0400
X-ME-UUID: 20080422145636729.B21B9700005C@mwinf2a14.orange.fr
Message-ID: <480DFC8A.8040105@cosmosbay.com>
Date: Tue, 22 Apr 2008 16:56:10 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
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
References: <ea87c15371b1bd49380c.1208872277@duo.random>
In-Reply-To: <ea87c15371b1bd49380c.1208872277@duo.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli a écrit :
> +
> +static int mm_lock_cmp(const void *a, const void *b)
> +{
> +	cond_resched();
> +	if ((unsigned long)*(spinlock_t **)a <
> +	    (unsigned long)*(spinlock_t **)b)
> +		return -1;
> +	else if (a == b)
> +		return 0;
> +	else
> +		return 1;
> +}
> +
This compare function looks unusual...
It should work, but sort() could be faster if the
if (a == b) test had a chance to be true eventually...

static int mm_lock_cmp(const void *a, const void *b)
{
	unsigned long la = (unsigned long)*(spinlock_t **)a;
	unsigned long lb = (unsigned long)*(spinlock_t **)b;

	cond_resched();
	if (la < lb)
		return -1;
	if (la > lb)
		return 1;
	return 0;
}





