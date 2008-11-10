Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYKJSSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYKJSSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYKJSSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:18:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbYKJSSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:18:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Date: Mon, 10 Nov 2008 19:23:15 +0100
User-Agent: KMail/1.9.9
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
References: <20081109140726.GB1786@ucw.cz> <20081110172407.5584156d.kamezawa.hiroyu@jp.fujitsu.com> <20081110082802.GA22392@elte.hu>
In-Reply-To: <20081110082802.GA22392@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101923.16548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Ingo Molnar wrote:
> 
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Mon, 10 Nov 2008 08:55:29 +0100
> > Pavel Machek <pavel@suse.cz> wrote:
> > 
> > > > 
> > > > * Pavel Machek <pavel@suse.cz> wrote:
> > > > 
> > > > > ...at least on 2.6.27 and 2.6.28-rc3. Resume gets to 
> > > > > acpi_hibernation_leave, then SLAB corruption is detected and machine 
> > > > > ends in series of oops.
> > > > > 
> > > > > Any ideas how to debug that?
> > > > 
> > > > do you get any serial log or USB key output, so that it's debuggable 
> > > > directly?
> > > 
> > > Well, I can transcribe the BUG() from a picture, I guess, but it does
> > > not seem to contain much useful info: SLAB corruption was detected and
> > > backtrace is not quite important at that point...
> > > 
> > > Serial console is probably possible, but would take few days to setup.
> > > 									Pavel
> > 
> > How about this patch ?
> > ==
> > http://marc.info/?l=linux-mm-commits&m=122624388629106&w=2
> > ==
> 
> note, that fix of Rafael's is now upstream as:
> 
>   c5d7124: Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
> 
> and included in v2.6.28-rc4.
> 
> But yes, this area of code (the save/restore of memory maps) would be 
> the main suspect to investigate.

It surely is, but the root cause need not be there, actually.

The problem only happens with CONFIG_NUMA enabled, only on 32-bit systems
and it _doesn't_ happen if the kernel is booted with highmem=0.

Evidently, CONFIG_NUMA is sufficient for the breakage to appear, even if
CONFIG_DISCONTIGMEM is not set (CONFIG_SPARSEMEM is set in this case, but
hibernation works with CONFIG_SPARSEMEM and without CONFIG_NUMA, both for
CONFIG_HIGHMEM64G=y).

I've been investigating this issue for quite some time now and it's starting
to look like a problem with kmap_atomic() or something along these lines.

Thanks,
Rafael
