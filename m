Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYA3C7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYA3C7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYA3C71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:59:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:36789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYA3C70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:59:26 -0500
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH 2/2] x86_64: make early_node_mem return align address
Date: Wed, 30 Jan 2008 03:55:45 +0100
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200801290053.45776.yinghai.lu@sun.com> <200801291033.29871.ak@suse.de> <200801290941.54145.yinghai.lu@sun.com>
In-Reply-To: <200801290941.54145.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801300355.46342.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 18:41, Yinghai Lu wrote:
> On Tuesday 29 January 2008 01:33:29 am Andi Kleen wrote:
> > On Tuesday 29 January 2008 10:05, Yinghai Lu wrote:
> > > [PATCH 2/2] x86_64: make early_node_mem return align address
> > >
> > > boot oops when system get 64g or 128g installed
> >
> > Probably it should just use reserve_early(). Does this patch work?
> >
> > The alignment change is needed at some point too, but only to
> > relax the alignment to not force all early allocations to be page
> > padded.
>
> No, my patch doesn't force all early allocations to be page padded.
> for find_e820_mem, i just change PAGE_ALIGN to be aligned align
> parameter....

They are already all PAGE_ALIGN()ed (which is too strict, but needs
some care to fix properly), but your patch uses it the wrong way.
The PAGE_ALIGNment was added some time ago to avoid such over
lapping, but it should not actually be needed for that anymore.

>
> only make early_node_mem have aligned data. because it seems it like
> to...and assume that.

Using alignment doesn't seem the correct way to avoid overlapping.

If there is still overlap then some reservation needs to be extended.

> I think your patch will get early panic about overlap between bss and
> bootmem... like the 256g machine, bss is overlapped with early page
> table...

Well did you test it? 

bss should have been reserved by this line in head64.c 

        reserve_early(__pa_symbol(&_text), __pa_symbol(&_end));

(in git-x86). In earlier kernels it was checked for explicitely by the e820 
allocator.

-Andi

>
