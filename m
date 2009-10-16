Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZJPGfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZJPGfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 02:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZJPGe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 02:34:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbZJPGe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 02:34:57 -0400
Date: Fri, 16 Oct 2009 08:34:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robin Holt <holt@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>, Cliff Whickman <cpw@sgi.com>
Subject: Re: [patch 0/2] x86, UV: fixups for configurations with a large
	number of nodes.
Message-ID: <20091016063405.GB20388@elte.hu>
References: <20091015223959.783988000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015223959.783988000@alcatraz.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> We need the __uv_hub_info structure to contain the correct values for 
> n_val, gpa_mask, and lowmem_remap_*.  The first patch in the series 
> accomplishes this.  Could this be included in the stable tree as well. 
> Without this patch, booting a large configuration hits a problem where 
> the upper bits of the gnode affect the pnode and the bau will not 
> operate.

i've applied this one.

> The second patch cleans up the broadcast assist unit code a small bit.

Seems to be more than just a 'cleanup'. It changes:

  uv_nshift = uv_hub_info->m_val;

to (in essence):

              uv_hub_info->m_val & ((1UL << uv_hub_info->n_val) - 1)

which is not the same. Furthermore, the new inline is:

+       return gpa >> uv_hub_info->m_val & ((1UL << uv_hub_info->n_val) - 1);

note that >> has higher priority than bitwise & - is that intended? I 
think the intention was:

+       return gpa >> (uv_hub_info->m_val & ((1UL << uv_hub_info->n_val) - 1));

in any case please do that cleaner by adding a separate mask variable.

	Ingo
