Return-Path: <linux-kernel-owner+w=401wt.eu-S1751362AbXBMWaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbXBMWaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXBMWaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:30:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39291 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbXBMWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:30:18 -0500
Date: Tue, 13 Feb 2007 23:30:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070213223017.GJ29492@one.firstfloor.org>
References: <20060529212109.GA2058@elte.hu> <20070213142035.GF638@elte.hu> <p73bqjxhcnl.fsf@bingen.suse.de> <20070213222443.GH22104@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213222443.GH22104@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:24:43PM +0100, Ingo Molnar wrote:
> > > +	memset(atom->args, 0, sizeof(atom->args));
> > > +
> > > +	ret |= __get_user(arg_ptr, &uatom->arg_ptr[0]);
> > > +	if (!arg_ptr)
> > > +		return ret;
> > > +	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
> > > +		return -EFAULT;
> > 
> > It's a little unclear why you do that many individual access_ok()s. 
> > And why is the target constant sized anyways?
> 
> each indirect pointer has to be checked separately, before dereferencing 
> it. (Andrew pointed out that they should be VERIFY_READ, i fixed that in 
> my tree)

But why only constant sized? It could be a variable length object, couldn't it?

If it's an array it could be all checked together

(i must be missing something here) 

> > If it's only a few pages you don't need any resource accounting. If 
> > it's more then it's nasty to steal the users quota. I think plain 
> > gup() would be better.
> 
> get_user_pages() would have to be limited in some way - and i didnt want 

If you only use it for a small ring buffer it is naturally limited.

Also beancounter will fix that eventually.

> a single page is enough for 1024 completion pointers - that's more than 
> enough for most purposes - and the default mlock limit is 40K.

Then limit it to a single page and use gup

-Andi
