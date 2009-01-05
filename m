Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZAEP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZAEP3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZAEP2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:28:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:29168 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZAEP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mM6jHBWIVPB5qtyKBMyByigWxHPjj0siTHGdzuptgsmnDjgZuYUOPO3EcJGPbbzLjo
         0dJjBpPAW+D2WCHXvfaRmzOkCqk7DlWGAqZMj8pvlrd45AAmhzTSACWKmhjGuruKmyOb
         KygW4/Ea5YJf9mKaJzgtfne4vD3jGZv3OOfrQ=
Date: Mon, 5 Jan 2009 18:28:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow
Message-ID: <20090105152848.GG7645@localhost>
References: <20090105094034.GA7645@localhost> <Pine.LNX.4.64.0901050906180.12774@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901050906180.12774@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Mon, Jan 05, 2009 at 09:10:57AM -0600]
| On Mon, 5 Jan 2009, Cyrill Gorcunov wrote:
| 
| >  	/*
| >  	 * This is, logically, a pointer to an array of struct
| > @@ -980,9 +986,12 @@ extern struct mem_section mem_section[NR
| >
| >  static inline struct mem_section *__nr_to_section(unsigned long nr)
| >  {
| > -	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
| > +	unsigned long idx = SECTION_NR_TO_ROOT(nr);
| > +	WARN_ON_ONCE(idx >= NR_SECTION_ROOTS);
| > +
| > +	if (idx >=NR_SECTION_ROOTS || !mem_section[idx])
| >  		return NULL;
| > -	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
| > +	return &mem_section[idx][nr & SECTION_ROOT_MASK];
| >  }
| >  extern int __section_nr(struct mem_section* ms);
| >  extern unsigned long usemap_size(void);
| 
| Not that you are adding code to numerous hot code path. Plus this is a
| frequently used inline. Code size is going to increase if you do this.

yes, I know, that is why I've changed WARN_ON_ONCE to plain WARN_ON.

| 
| I would think that the code does not have the tests because of performance
| and code size concerns. Can we just say that a sane nr must be passed to
| __nr_section?
| 

If you mean did I test this patch for speed regresson then to be fair --
no, I didn't. BUT we have a number of macros wich are self protective
like present_section which is used havily too. On the other hand --
bad argument passed to __nr_to_section will be (and it is now) really
harmfull -- since it would allow to reference a memory outside the
valid bounds. The second -- SECTION_ROOT_MASK wich is fragile, any
attempt to modify mem_section structure will silently lead to insane
referencing, that is why it deserve a comment on top of structure.

Don't know Christoph, if it really that important to not spend a few
cycles here in a sake of safety -- we could easily drop this patch.

		- Cyrill -
