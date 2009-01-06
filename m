Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZAFF64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZAFF64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZAFF6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:58:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43739 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZAFF6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:58:46 -0500
Date: Tue, 6 Jan 2009 14:57:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, npiggin@suse.de, riel@redhat.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow v2
Message-Id: <20090106145741.e9844b93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090105163742.08777d73.akpm@linux-foundation.org>
References: <20090105103132.GD7645@localhost>
	<20090105163742.08777d73.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 16:37:42 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 5 Jan 2009 13:31:32 +0300
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > __nr_to_section should check for array bound overflow.
> > We should better get NULL dereference then silently
> > pass some memory snippet out of bounds to a caller.
> > 
> 
> Are there actually any known problems here?
> 

IIRC, I never saw any problem. (But I may see in memory-hotplug development.)
I don't like adding any check here.

This __nr_to_section[] is very internal function and will not be accessed directly
by codes other than VM(of sparsemem and memory hotplug).

For general users,  this function will be called via pfn_to_page(). So, this means
what this patch should really do is checking "pfn" argugments to pfn_to_page().
Of course, I don't want any check in pfn_to_page()'s "pfn" range.But, pfn_to_page()
is usually called with pfn_valid() if necessary. pfn_valid() and pfn_present(),
other callers of this, check this in explicit way.


Cyrill, if you really want to do check "idx", please add

==
__nr_to_section_direct(unsigned long nr) (or some better name)
{
	BUG_ON(nr >NR_SECTION_ROOTS);
	return __nr_to_section(nr);
}
==
to, mm/internal.h or somewhere. and use this in sparse.c and memhotplug.c


So, Nack from me for now.


Thanks,
-Kame

