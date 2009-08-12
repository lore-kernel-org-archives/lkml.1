Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbZHLEsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbZHLEsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZHLEsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:48:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZHLEsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:48:37 -0400
Date: Wed, 12 Aug 2009 06:48:37 +0200
From: Nick Piggin <npiggin@suse.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
Message-ID: <20090812044837.GC5330@wotan.suse.de>
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de> <20090811200711.GA24213@lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811200711.GA24213@lenovo>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 12:07:11AM +0400, Cyrill Gorcunov wrote:
> [npiggin@suse.de - Tue, Aug 11, 2009 at 09:09:06PM +1000]
> ...
> | +static void update_queue_simple(struct sem_array *sma, ushort semnum)
> | +{
> | +	if (unlikely(sma->complex_count)) {
> | +		update_queue(sma);
> | +	} else {
> | +		struct sem *sem;
> | +
> | +		sem = &sma->sem_base[semnum];
> | +		if (sem->semval > 0)
> | +			update_negv_queue(sma, sem);
> | +		if (sem->semval == 0)
> | +			update_zero_queue(sma, sem);
> | +	}
> | +}
> | +
> ...
> 
> Hi Nick,
> 
> mostly probably miss something but can't we trgigger BUG_ON at updating
> zero queue if semaphore was created with undo list and via new operation
> reached -ERANGE on undo value?
> 
> Again, I could be missing something or plain wrong. Just a thought.

Hi Cyrill,

Thanks for looking... Hmm, you mean BUG_ON(error) due to try_atomic_semop
returning -ERANGE? I think it should not be possible because it should
prevent any operation from bringing the undo list to -ERANGE so then any
operation which does not modify the sem value should not go out of range
I think.

(I think it would be a bug if we ever return -ERANGE for a wait-for-zero
operation).

Thanks,
Nick
