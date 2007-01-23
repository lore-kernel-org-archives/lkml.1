Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXAWDxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXAWDxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbXAWDxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:53:36 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:50656 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932823AbXAWDxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:53:35 -0500
Date: Mon, 22 Jan 2007 19:51:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Balbir Singh <balbir@in.ibm.com>
cc: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
In-Reply-To: <45B584E7.30407@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0701221947050.30909@schroedinger.engr.sgi.com>
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random>
 <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
 <45B57E73.3000307@in.ibm.com> <Pine.LNX.4.64.0701221923300.30667@schroedinger.engr.sgi.com>
 <45B584E7.30407@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Balbir Singh wrote:

> Yes, good point, I see what you mean in terms of impact. But the trade
> off could come from shrink_active_list() which does
> 
> list_del(&page->lru)
> if (!reclaim_mapped && other_conditions)
> 	list_add(&page->lru, &l_active);
> ...
> 
> In the case mentioned above, we would triple the cachlines when an area
> is mapped/unmapped (which might be acceptable since it is a state change
> for the page ;) ). In the trade-off I mentioned, it would happen
> everytime reclaim is invoked and it has nothing to do with a page changing
> state.
> 
> Did I miss something?

We do the list_del/list_add right now in reclaim while moving pages 
between active and inactive lists. However, reclaim is not run until the 
systems is under memory pressure. Reclaim is run rarely and then lots of 
these movements are occurring. At that point is it likely that the 
cachelines are already available since the page structs had to be touched 
for earlier movements.

