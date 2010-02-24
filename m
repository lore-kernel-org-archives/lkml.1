Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0BXBzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:55:46 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59928 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0BXBzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:55:45 -0500
Message-ID: <4B847D10.9040509@ct.jp.nec.com>
Date: Wed, 24 Feb 2010 10:12:48 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, Alasdair Kergon <agk@redhat.com>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
       stable@kernel.org, Junichi Nomura <j-nomura@ce.jp.nec.com>,
       akpm@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [93/93] dm mpath: fix stall when requeueing io
References: <20100219163257.186977438@kvm.kroah.org> <4B815A3D.9040402@canonical.com> <4B825982.3060606@ct.jp.nec.com> <20100223181229.GF560@agk-dp.fab.redhat.com>
In-Reply-To: <20100223181229.GF560@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair, Linus,

On 02/24/2010 03:12 AM +0900, Alasdair G Kergon wrote:
> On Mon, Feb 22, 2010 at 07:16:34PM +0900, Kiyoshi Ueda wrote:
>> On 02/22/2010 01:07 AM +0900, Stefan Bader wrote:
>>>> @@ -1568,12 +1575,16 @@ static void dm_request_fn(struct request
>>>>  
>>>>  		blk_start_request(rq);
>>>>  		spin_unlock(q->queue_lock);
>>>> -		map_request(ti, rq, md);
>>>> +		if (map_request(ti, rq, md))
>>>> +			goto requeued;
>>>>  		spin_lock_irq(q->queue_lock);
>>>>  	}
>> In the current device-mapper code, I would like to go with
>> spin_unlock/lock here.
>> However, there was a case to enable irq in map_requst() for request
>> allocation, and this spin_lock_irq was a work-around for the case.
>> Now, there is no such case in the device-mapper code, so spin_lock should
>> be enough here.  But I'm still using spin_lock_irq for safeness, since
>> there might be some more cases to enable irq during request submission
>> to underlying devices.
>> I'll remove the _irq in the future after lots of testings.
>  
> So, have I understood your reasoning?
> 
> - This function (dm_request_fn) is always called with local interrupts disabled.
> E.g. from generic_unplug_device() or blk_run_queue().
> 
> - The 'map_request()' function was found to re-enable interrupts in one case, but
> that case got fixed.
> 
> - The code still uses spin_lock_irq to ensure they remain disabled as protection
> against there being other cases.  This should be changed to spin_lock as a clean-up
> but you are not aware of any current breakage.

That's correct.
I think the spin_lock_irq can be changed to spin_lock as a clean-up.
But I don't want to break things in this late stage of 2.6.33-rc
and/or the stable tree.
So I'll send the clean-up patch for 2.6.34 once I make sure it's ok.

Thanks,
Kiyoshi Ueda
