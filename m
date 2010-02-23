Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0BWSOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:14:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab0BWSN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:13:57 -0500
Date: Tue, 23 Feb 2010 18:12:29 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
       stable@kernel.org, Junichi Nomura <j-nomura@ce.jp.nec.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [93/93] dm mpath: fix stall when requeueing io
Message-ID: <20100223181229.GF560@agk-dp.fab.redhat.com>
Mail-Followup-To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	stable@kernel.org, Junichi Nomura <j-nomura@ce.jp.nec.com>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
References: <20100219163257.186977438@kvm.kroah.org> <4B815A3D.9040402@canonical.com> <4B825982.3060606@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B825982.3060606@ct.jp.nec.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 07:16:34PM +0900, Kiyoshi Ueda wrote:
> On 02/22/2010 01:07 AM +0900, Stefan Bader wrote:
> >> @@ -1568,12 +1575,16 @@ static void dm_request_fn(struct request
> >>  
> >>  		blk_start_request(rq);
> >>  		spin_unlock(q->queue_lock);
> >> -		map_request(ti, rq, md);
> >> +		if (map_request(ti, rq, md))
> >> +			goto requeued;
> >>  		spin_lock_irq(q->queue_lock);
> >>  	}
> In the current device-mapper code, I would like to go with
> spin_unlock/lock here.
> However, there was a case to enable irq in map_requst() for request
> allocation, and this spin_lock_irq was a work-around for the case.
> Now, there is no such case in the device-mapper code, so spin_lock should
> be enough here.  But I'm still using spin_lock_irq for safeness, since
> there might be some more cases to enable irq during request submission
> to underlying devices.
> I'll remove the _irq in the future after lots of testings.
 
So, have I understood your reasoning?

- This function (dm_request_fn) is always called with local interrupts disabled.
E.g. from generic_unplug_device() or blk_run_queue().

- The 'map_request()' function was found to re-enable interrupts in one case, but
that case got fixed.

- The code still uses spin_lock_irq to ensure they remain disabled as protection
against there being other cases.  This should be changed to spin_lock as a clean-up
but you are not aware of any current breakage.

Alasdair

