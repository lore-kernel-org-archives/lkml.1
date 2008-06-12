Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYFLPq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYFLPq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYFLPqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:46:20 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44823 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982AbYFLPqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:46:19 -0400
Date: Fri, 13 Jun 2008 00:43:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: Correct kobjsize() page validity checks.
Message-ID: <20080612154359.GA9327@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <clameter@sgi.com>,
	Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org
References: <27332.1213264136@redhat.com> <20080612072955.GA8097@linux-sh.org> <2336.1213266053@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2336.1213266053@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:20:53AM +0100, David Howells wrote:
> Here kobjsize() returns 16384 (PAGE_SIZE) when it should return something a
> lot smaller.  This appears related to SLOB not setting PG_slab, so
> /proc/pic/status gets messed up:
> 
> 	Mem:      983040 bytes
> 	Slack:     44112 bytes
> 	Shared:  1687552 bytes
> 
> SLAB returns 64 at this point, and in /proc/pid/status shows:
> 
> 	Mem:      594016 bytes
> 	Slack:     44112 bytes
> 	Shared:  1638688 bytes
> 
> with or without the patch, which might even be correct.
> 
Yes, this is the fundamental problem with kobjsize() as it is today.
Without the setting of PG_slab, non-compound page objects default to
PAGE_SIZE. Pekka posted a series of patches that hooked PG_slab in to
SLUB and SLOB that get the same degree of accuracy that SLAB has today,
but there was opposition to merging those.

> Maybe on SLOB we want kobjsize() to become sizeof() where we're dealing with
> fixed size units such as structs.  On the other hand, getting rid of
> kobjsize() entirely would be good.
> 
I think for the time being we have to live with the innacuracy, and
simply focus on getting rid of kobjsize() entirely. Without additional
help from the various allocators, there's really not that much we can do.
Rather than papering over that, bringing nommu more in line with MMU
semantics is certainly a preferable option.

This patch in particular is unrelated to the inaccuracy issues, although
it should fix the cases where kobjsize() would mistakenly account
reserved pages.
