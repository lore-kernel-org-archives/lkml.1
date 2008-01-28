Return-Path: <linux-kernel-owner+w=401wt.eu-S1765429AbYA1XYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765429AbYA1XYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764886AbYA1XRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:17:40 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39111 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764877AbYA1XRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:17:39 -0500
Date: Mon, 28 Jan 2008 15:17:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Shaohua Li <shaohua.li@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] some page can't be migrated
In-Reply-To: <20080126220351.a04819f9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801281514260.17050@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
 <1201233590.28282.13.camel@sli10-desk.sh.intel.com>
 <Pine.LNX.4.64.0801242000320.1932@schroedinger.engr.sgi.com>
 <200801251517.02287.nickpiggin@yahoo.com.au> <1201241005.24290.5.camel@sli10-desk.sh.intel.com>
 <20080126220351.a04819f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008, Andrew Morton wrote:

> > 
> > -	if (!page->mapping)
> > +	if (!page->mapping) {
> > +		if (!PageAnon(page) && PagePrivate(page))
> > +			try_to_release_page(page, GFP_KERNEL);
> >  		goto rcu_unlock;
> > +	}
> 
> We call something(GFP_KERNEL) under rcu_read_lock()?  I've lost track of
> the myriad flavours of rcu which we purport to support, but I don't think
> they'll all like us blocking under rcu_read_lock().

I still think your solution is good but even with the original patch we do 
not call try_to_release_page() with GFP_KERNEL under rcu.

   if (PageAnon(page)) {
                rcu_read_lock();
                rcu_locked = 1;
        }


rcu is only active if we have an anonymous page and in that case we do not
call try_to_release_page(). Just to make sure that Nick and I do not get 
dinged needlessly....

