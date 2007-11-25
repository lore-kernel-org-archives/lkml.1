Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbXKYU1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbXKYU1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 15:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbXKYU1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 15:27:09 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:46885 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbXKYU1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:27:06 -0500
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
X-Message-Flag: Warning: May contain useful information
References: <20071122343.446909000@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 25 Nov 2007 12:27:03 -0800
In-Reply-To: <20071122343.446909000@suse.de> (Andi Kleen's message of "Thu, 22 Nov 2007 03:43:06 +0100 (CET)")
Message-ID: <adatznarrzc.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Nov 2007 20:27:04.0089 (UTC) FILETIME=[8A8E7090:01C82FA1]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > This patch allows to export symbols only for specific modules by 
 > introducing symbol name spaces. A module name space has a white
 > list of modules that are allowed to import symbols for it; all others
 > can't use the symbols.
 > 
 > It adds two new macros: 
 > 
 > MODULE_NAMESPACE_ALLOW(namespace, module);

I definitely like the idea of organizing exported symbols into
namespaces.  However, I feel like it would make more sense to have
something like

MODULE_NAMESPACE_IMPORT(namespace);

inside the modules that use a namespace.  This matches the way C
preprocessor #includes, C++ namespaces, perl "use", etc. works and so
it is probably closer to how programmers think.  It does weaken the
enforcement of review a little bit, since there are no changes to the
site where things are exported to catch, but git makes it easy to
sneak that kind of change in anyway.

The practical benefits are that you don't end up with stupid patch
conflicts caused by one patch adding MODULE_NAMESPACE_ALLOW() for
module "foo" and another patch adding it for module "bar" at the same
place, and that it becomes simpler for people to test or deliver, say,
a new TCP congestion module without having to rebuild the whole kernel
(which is an especially huge pain for distro kernels).

In any case I would make use of this in whatever form it gets merged
in -- Mellanox ConnectX hardware can operate simultaneously as an
InfiniBand adapter and a 10Gb ethernet NIC, and so my driver is split
up into a low-level mlx4_core driver that exports symbols for other
mlx4 drivers to use; clearly it only makes sense to export them to
other parts of the driver, and in this case the difference between
"ALLOW" and "IMPORT" semantics is not a big deal.

 - R.
