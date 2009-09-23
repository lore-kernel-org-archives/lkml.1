Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZIWJiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZIWJiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZIWJiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:38:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:15697 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZIWJiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:38:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,437,1249282800"; 
   d="scan'208";a="190687890"
Date: Wed, 23 Sep 2009 17:37:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090923093753.GA4579@localhost>
References: <1253608335.8439.283.camel@twins> <20090922155259.GL10825@think> <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <1253697598.2277.13.camel@castor> <1253697811.7695.127.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253697811.7695.127.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 05:23:31PM +0800, Peter Zijlstra wrote:
> On Wed, 2009-09-23 at 10:19 +0100, Richard Kennedy wrote:
> > 
> > I am concerned that the background writeout no longer stops when it
> > reaches the background threshold, as balance_dirty_pages requests all
> > dirty pages to be written. No doubt this is good for large linear writes
> > but what about more random write workloads? 
> 
> I've not had time to look over the current code, but write-out not
> stopping on reaching background threshold is a definite bug and needs to
> get fixed.

Yes, 2.6.31 code stops writeback when background threshold is reached.
But new behavior in latest git is to writeback all pages.

The code only checks over_bground_thresh() for kupdate works:

                if (args->for_kupdate && args->nr_pages <= 0 &&
                    !over_bground_thresh())
                        break;

However the background work started by balance_dirty_pages() won't check
over_bground_thresh(). So it will move all dirty pages.

I think it's very weird to check over_bground_thresh() for kupdate
instead of background work. Jens must intended for the latter case.

Thanks,
Fengguang
