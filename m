Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZDMNo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZDMNo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 09:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZDMNor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 09:44:47 -0400
Received: from mga12.intel.com ([143.182.124.36]:33007 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833AbZDMNor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 09:44:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,180,1239001200"; 
   d="scan'208";a="130845977"
Date: Mon, 13 Apr 2009 21:44:35 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] radix-tree: add radix_tree_prev_hole()
Message-ID: <20090413134435.GA10143@localhost>
References: <20090412071950.166891982@intel.com> <20090412072052.457214378@intel.com> <20090412102952.0dd377d6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412102952.0dd377d6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 10:29:52AM -0700, Andrew Morton wrote:
> On Sun, 12 Apr 2009 15:19:51 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > +unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
> > +				   unsigned long index, unsigned long max_scan)
> > +{
> > +	unsigned long i;
> > +
> > +	for (i = 0; i < max_scan; i++) {
> > +		if (!radix_tree_lookup(root, index))
> > +			break;
> > +		index--;
> > +		if (index == LONG_MAX)
> > +			break;
> > +	}
> > +
> > +	return index;
> > +}
> 
> argh.  This is about as inefficient as we could possibly make it :(

Right, a dumb loop!

> Really, this function should dive into radix-tree internals and walk
> individual radix_tree_node.slots[] arrays.  And heck, it can peek at
> radix_tree_node.count and _bypass_ entire nodes, too.

Good idea! In fact I'm planning such a smart version. It will be using
radix_tree_lookup_slot() to access the ->count member, in order to
check if the whole slot can be bypassed.

radix_tree_next_hole() is another optimization candidate.
But that will be a post 2.6.30 stuff.

The current dumb-but-obvious-right version is OK for 2.6.30, because
in most radix_tree_prev_hole() invocations the actual loop count will
be merely 1.

Thanks,
Fengguang
