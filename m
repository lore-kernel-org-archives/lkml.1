Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZAEQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZAEQMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZAEQMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:12:46 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:46683 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZAEQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:12:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ts+SBqOR4/dg5cizcZFelKleMAcOu4OmsayHqnNa3gu2X6C2IOz+A0AJcJpRNJju5O
         ic4qNUOABVyRFLla/BxJ8uwVw0NJ33pZ7AIKQJsZDkaWyTqbzSVV2cwYZGIAoXCRVkPr
         S6Iq7P3PdsQT9HSrT70tE4aItFGVb1l4K6N3M=
Date: Mon, 5 Jan 2009 19:12:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow
Message-ID: <20090105161241.GJ7645@localhost>
References: <20090105094034.GA7645@localhost> <Pine.LNX.4.64.0901050906180.12774@quilx.com> <20090105152848.GG7645@localhost> <20090105153406.GB32675@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105153406.GB32675@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Nick Piggin - Mon, Jan 05, 2009 at 04:34:06PM +0100]
| On Mon, Jan 05, 2009 at 06:28:48PM +0300, Cyrill Gorcunov wrote:
| > [Christoph Lameter - Mon, Jan 05, 2009 at 09:10:57AM -0600]
| > | On Mon, 5 Jan 2009, Cyrill Gorcunov wrote:
| > | 
| > | >  	/*
| > | >  	 * This is, logically, a pointer to an array of struct
| > | > @@ -980,9 +986,12 @@ extern struct mem_section mem_section[NR
| > | >
| > | >  static inline struct mem_section *__nr_to_section(unsigned long nr)
| > | >  {
| > | > -	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
| > | > +	unsigned long idx = SECTION_NR_TO_ROOT(nr);
| > | > +	WARN_ON_ONCE(idx >= NR_SECTION_ROOTS);
| > | > +
| > | > +	if (idx >=NR_SECTION_ROOTS || !mem_section[idx])
| > | >  		return NULL;
| > | > -	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
| > | > +	return &mem_section[idx][nr & SECTION_ROOT_MASK];
| > | >  }
| > | >  extern int __section_nr(struct mem_section* ms);
| > | >  extern unsigned long usemap_size(void);
| > | 
| > | Not that you are adding code to numerous hot code path. Plus this is a
| > | frequently used inline. Code size is going to increase if you do this.
| > 
| > yes, I know, that is why I've changed WARN_ON_ONCE to plain WARN_ON.
| 
| Still costs. Putting it under a config option would be nice.
| 
| 
| > | I would think that the code does not have the tests because of performance
| > | and code size concerns. Can we just say that a sane nr must be passed to
| > | __nr_section?
| > | 
| > 
| > If you mean did I test this patch for speed regresson then to be fair --
| > no, I didn't. BUT we have a number of macros wich are self protective
| > like present_section which is used havily too. On the other hand --
| > bad argument passed to __nr_to_section will be (and it is now) really
| > harmfull -- since it would allow to reference a memory outside the
| > valid bounds. The second -- SECTION_ROOT_MASK wich is fragile, any
| > attempt to modify mem_section structure will silently lead to insane
| > referencing, that is why it deserve a comment on top of structure.
| > 
| > Don't know Christoph, if it really that important to not spend a few
| > cycles here in a sake of safety -- we could easily drop this patch.
| 
| The problem with testing every little slowdown for a speed regression
| is that they are just going to be in the noise. But we *know* it will
| go slower. The problem is that they add up. We just have to be sensible
| about it.
| 
| Has there ever been a problem here before? Has it been a problem during
| development? (in which case putting it in a .config option might make
| sense).
| 

After checking all 'for' and 'against' -- I think I just overzealous
about it. Please drop it. (the case I was concerning to actually protected
by present_section macro anyway). Sorry for noise.

		- Cyrill -
