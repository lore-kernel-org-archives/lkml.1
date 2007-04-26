Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbXDZBRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbXDZBRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbXDZBRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:17:05 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:58573 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754628AbXDZBRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:17:02 -0400
Message-ID: <377550217.31149@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 26 Apr 2007 09:16:55 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] on-demand readahead
Message-ID: <20070426011655.GA6373@mail.ustc.edu.cn>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org
References: <377506695.54393@ustc.edu.cn> <p73odlc34ga.fsf@bingen.suse.de> <20070425160400.GA27954@mail.ustc.edu.cn> <20070425160844.GA30132@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425160844.GA30132@one.firstfloor.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 06:08:44PM +0200, Andi Kleen wrote:
> > Yeah, the on-demand readahead can avoid _all_ lookups for small in-cache files.
> 
> How?

In filemap.c:
                if (!page) {
                        page_cache_readahead_adaptive(mapping,
                                        &ra, filp, page,
                                        index, last_index - index);
                        page = find_get_page(mapping, index);
                }
                if (page && PageReadahead(page)) {
                        page_cache_readahead_adaptive(mapping,
                                        &ra, filp, page,
                                        index, last_index - index);
                }
        
Cache hot files neither have missing pages (!page) or lookahead
pages (PageReadahead(page)).  So it will not even be called.

> > > You seem to have a lot of magic numbers. They probably all need symbols and 
> > > explanations.
> > 
> > The magic numbers are for easier testings, and will be removed in
> > future.  For now, they enables convenient comparing of the two
> > algorithms in one kernel.
> 
> I mean the 16 and 4 not the sysctl

The numbers and the code in get_next_ra_size2() is simply copied from
get_next_ra_size():

        if (cur < max / 16) {
                newsize = 4 * cur;
        } else {
                newsize = 2 * cur;
        }

It's a trick to ramp up small sizes more quickly.
That trick is documented in the related get_init_ra_size().
So, it would be better to put the two routines together to make it clear.

> > 
> > If this new algorithm has been further tested and approved, I'll
> > re-submit the patch in a cleaner, standalone form. The adaptive
> > readahead patches can be dropped then. They may better be reworked as
> > a kernel module.
> 
> If they actually help and don't cause regressions they shouldn't be a module, 
> but integrated eventually Just it has to be all step by step.

Yeah, the adaptive readahead is complex and the possible workloads diverse.
It becomes obvious that there is a long way to go, and kernel module makes
life easier.

> > > Your white space also needs some work.
> > 
> > White space in patch description?
> 
> In the code indentation.

Ah, got it: a silly copy/paste mistake.

Thank you,
Wu

