Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZFCPvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZFCPvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZFCPvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:51:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:17689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZFCPvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:51:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,299,1241420400"; 
   d="scan'208";a="150233185"
Date: Wed, 3 Jun 2009 23:51:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
	in the VM v3
Message-ID: <20090603155133.GA7529@localhost>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528095934.GA10678@localhost> <20090528122357.GM6920@wotan.suse.de> <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601183225.GS1065@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 02:32:25AM +0800, Andi Kleen wrote:
[snip]
> > > > > Clean swap cache pages can be directly isolated. A later page fault will bring
> > > > > in the known good data from disk.
> > > > 
> > > > OK, but why do you ClearPageUptodate if it is just to be deleted from
> > > > swapcache anyway?
> > > 
> > > The ClearPageUptodate() is kind of a careless addition, in the hope
> > > that it will stop some random readers. Need more investigations.
> > 
> > OK. But it just muddies the waters in the meantime, so maybe take
> > such things out until there is a case for them.
> 
> It's gone

Andi, I'd recommend to re-add ClearPageUptodate() for dirty swap cache
pages. It will then make shmem_getpage() return EIO for
- shmem_fault()        => kill app with VM_FAULT_SIGBUS
- shmem_readpage()     => fail splice()/sendfile() etc.
- shmem_write_begin()  => fail splice()/sendfile() etc.
which is exactly what we wanted. Note that the EIO here is permanent.

I'll continue to do some experiments on its normal read/write behaviors.

Thanks,
Fengguang
