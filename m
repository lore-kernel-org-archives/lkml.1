Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbZJOXEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbZJOXEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763264AbZJOXEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:04:53 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:29111 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763263AbZJOXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:04:52 -0400
X-Trace: 275031517/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.3.134/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.3.134
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAANH10pPRQOG/2dsb2JhbACBUtdOhDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="275031517"
Date: Fri, 16 Oct 2009 00:04:14 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] swap_info: change to array of pointers
In-Reply-To: <Pine.LNX.4.64.0910152324220.4447@sister.anvils>
Message-ID: <Pine.LNX.4.64.0910152356110.9759@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150146210.3291@sister.anvils>
 <20091015111107.b505b676.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0910152324220.4447@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Hugh Dickins wrote:
> On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > On Thu, 15 Oct 2009 01:48:01 +0100 (BST)
> > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > > @@ -1675,11 +1674,13 @@ static void *swap_start(struct seq_file
> > >  	if (!l)
> > >  		return SEQ_START_TOKEN;
> > >  
> > > -	for (i = 0; i < nr_swapfiles; i++, ptr++) {
> > > -		if (!(ptr->flags & SWP_USED) || !ptr->swap_map)
> > > +	for (type = 0; type < nr_swapfiles; type++) {
> > > +		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
> > > +		si = swap_info[type];
> > 
> > 		if (!si) ?

Re-reading, I see that I missed your interjection there.

Precisely because we read swap_info[type] after reading nr_swapfiles,
with smp_rmb() here to enforce that, and smp_wmb() where they're set
in swapon, there is no way for si to be seen as NULL here.  Is there?

Or are you asking for a further comment here on why that's so?
I think I'd rather just switch to taking swap_lock in swap_start()
and swap_next(), than be adding comments on why we don't need it.

Hugh
