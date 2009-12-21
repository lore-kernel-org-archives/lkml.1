Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZLUNx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZLUNx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZLUNx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:53:28 -0500
Received: from mga10.intel.com ([192.55.52.92]:36476 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752260AbZLUNx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:53:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,431,1257148800"; 
   d="scan'208";a="525088654"
Message-ID: <4B2F7DD2.2080902@linux.intel.com>
Date: Mon, 21 Dec 2009 14:53:22 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>
In-Reply-To: <4B2F768C.1040704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 14:22, Tejun Heo wrote:
> Hello,
>
> On 12/21/2009 08:11 PM, Arjan van de Ven wrote:
>> I don't mind a good and clean design; and for sure sharing thread
>> pools into one pool is really good.  But if I have to choose between
>> a complex "how to deal with deadlocks" algorithm, versus just
>> running some more threads in the pool, I'll pick the later.
>
> The deadlock avoidance algorithm is pretty simple.  It creates a new
> worker when everything is blocked.  If the attempt to create a new
> worker blocks, it calls in dedicated workers to ensure allocation path
> is not blocked.  It's not that complex.

I'm just wondering if even that is overkill; I suspect you can do entirely without the scheduler intrusion;
just make a new thread for each work item, with some hesteresis:
* threads should stay around for a bit before dying (you do that)
* after some minimum nr of threads (say 4 per cpu), you wait, say, 0.1 seconds before deciding it's time
   to spawn more threads, to smooth out spikes of very short lived stuff.

wouldn't that be a lot simpler than "ask the scheduler to see if they are all blocked". If they are all
very busy churning cpu (say doing raid6 work, or btrfs checksumming) you still would want more threads
I suspect
