Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbXLFU3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbXLFU3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLFU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:28:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXLFU24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:28:56 -0500
Date: Thu, 6 Dec 2007 12:31:18 -0800
From: Greg KH <greg@kroah.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rsa@us.ibm.com, apw@shadowen.org, balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on
	powerpc
Message-ID: <20071206203118.GA28618@kroah.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com> <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com> <47584672.8040201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47584672.8040201@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 12:28:58AM +0530, Balbir Singh wrote:
> Greg KH wrote:
> 
> >> Why release the spinlock here? It's done after the count is incremented.
> >> This patch does not seem correct.
> > 
> > Doh, you are correct, I'll make sure that I fix this up before applying
> > it.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi, Greg,
> 
> I ran some tests with the fixed up version of this patch and the system
> fails to come up.
> 
> I see the WARN_ON in lib/kref.c:33 and the system fails to boot beyond
> that point. I have not yet found time to debug it though.

That's not good, that warning means that someone has tried to use this
kref _before_ it was initialized, so there is a logic error in the code
that was previously being papered over with the lack of this message in
the kobject code.

I do have this same message availble as a patch for the kobject core, it
would be interesting if you could just run 2.6.24-rc4 with just this
patch:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kobject-warn.patch

it might take some fuzz to fit properly, but all you really want to do
is add:
	WARN_ON(atomic_read(&kobj->kref.refcount));
before the kref_init() call in kobject_init().

thanks,

greg k-h
