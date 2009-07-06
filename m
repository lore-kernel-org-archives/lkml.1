Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZGFRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZGFRip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZGFRih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:38:37 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:42625 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752290AbZGFRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:38:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NmZ6HC5J6/57zWCoQqArXjeXovoJsZNAtQdlUwbuk6rNOnFXPOyUb7NyWIT/UG2/HAgIIXaKnBFRRUH7VdaKvEeyFtAO52ePAtOgh79D8D/1oq+PFO8ODfz8+18YIpuM;
Date: Mon, 6 Jul 2009 10:38:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Roger WANG <roger.wang@intel.com>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class
 citizen
Message-ID: <20090706103831.5b987524@jbarnes-g45>
In-Reply-To: <20090704012754.GC3910@wwang29-mobl1.ccr.corp.intel.com>
References: <20090516090005.916779788@intel.com>
	<1242485776.32543.834.camel@laptop>
	<20090617141135.0d622bfe@jbarnes-g45>
	<20090618012532.GB19732@localhost>
	<20090619090011.GA30561@localhost>
	<1245402289.13761.24606.camel@twins>
	<20090619093224.GA30898@localhost>
	<20090619094338.4d3c566d@jbarnes-g45>
	<20090704012754.GC3910@wwang29-mobl1.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jul 2009 09:27:54 +0800
Roger WANG <roger.wang@intel.com> wrote:

> Hello Jesse,
> 
> On Sat, 2009-06-20 at 00:43 +0800 Jesse Barnes wrote:
> > On Fri, 19 Jun 2009 17:32:24 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > On Fri, Jun 19, 2009 at 05:04:49PM +0800, Peter Zijlstra wrote:
> > > > On Fri, 2009-06-19 at 17:00 +0800, Wu, Fengguang wrote:
> > > > > [add CC]
> > > > > 
> > > > > This OOM case looks like the same bug encountered by David
> > > > > Howells.
> > > > > 
> > > > > > Jun 18 07:44:53 jbarnes-g45 kernel: [64377.426766]
> > > > > > Active_anon:290797 active_file:28 inactive_anon:97034 Jun 18
> > > > > > 07:44:53 jbarnes-g45 kernel: [64377.426767]
> > > > > > inactive_file:61 unevictable:11322 dirty:0 writeback:0
> > > > > > unstable:0 Jun 18 07:44:53 jbarnes-g45 kernel:
> > > > > > [64377.426768]  free:3341 slab:13776 mapped:5880
> > > > > > pagetables:6851 bounce:0
> > > > > 
> > > > > active/inactive_anon pages take up 4/5 memory.  Are you using
> > > > > TMPFS a lot?
> > > > 
> > > > I suspect its his GEM thingy ;-)
> > > 
> > > Very likely - GEM allocates drm objects from the internal tmpfs,
> > > and libdrm_intel seems to never free drm objects from its cache.
> > 
> > Yeah, a good chunk of that is GEM objects.  I generally haven't seen
> > OOMs due to excessive GEM allocation though, until recently.  We've
> > got some patches queued up to manage the object cache better
> > (actually free pages when we don't need them!), so that should help.
> 
> Could you please point me to those patches so I can try them here? I
> have to kill my X once per day.

They're all upstream now; I've been running 2.6.31ish plus the latest
libdrm, Mesa and xf86-video-intel for a week or so and things are much
better (using the Ubuntu xorg edgers repo).

-- 
Jesse Barnes, Intel Open Source Technology Center
