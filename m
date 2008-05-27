Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbYE0PyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbYE0PyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbYE0Px4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:53:56 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:5873 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbYE0Pxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:53:55 -0400
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20080526153318.29edc0b2@bree.surriel.com>
References: <20080523195506.084894989@redhat.com>
	 <483B0077.7000207@linux.vnet.ibm.com>
	 <20080526153318.29edc0b2@bree.surriel.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 27 May 2008 11:54:02 -0400
Message-Id: <1211903642.7283.16.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-26 at 15:33 -0400, Rik van Riel wrote:
> On Mon, 26 May 2008 23:54:55 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Rik van Riel wrote:
> > > On large memory systems, the VM can spend way too much time scanning
> > > through pages that it cannot (or should not) evict from memory. Not
> > > only does it use up CPU time, but it also provokes lock contention
> > > and can leave large systems under memory presure in a catatonic state.
> > 
> > Hi, Rik,
> > 
> > This patchset looks good (I did a brief scan). I'll go ahead and play with it?
> > What is a good memory size to test the patches on (to see improvements).
> 
> The larger, the better.  One known problem with the current upstream
> VM is large numbers of anonymous pages, or a mix of mlocked and anon
> pages.
> 
> Once the system needs to swap something out, every single anon page
> will have the referenced bit set and the system needs to do lots of
> scanning before it can evict the first page.  This scanning causes
> multiple CPUs to pile up and things slow down exponentially and/or
> catastrophically :)
> 
> Unfortunately the largest system I have access to on a regular basis
> has "only" 16GB of RAM :(
> 
> I am also making 2.6.25 based kernel RPMs available with the split LRU
> patch set, at http://people.redhat.com/riel/splitvm/
> 
> The most recently posted patches are newer, though...
> 

I tested Rik's previous patch set with my noreclaim/mlock patches over
the long weekend on 32GB systems--one ia64 [16cpu x 4 nodes] and one
x86_64 [8 core x 4 nodes] on 26-rc2-mm1.  A fairly heavy stress load ran
for 92-93 hours on each system w/o error.  Stats tracked throughout, no
leaked pages, ...  

Since Balbir is starting to look at this, I need to ask about
interaction with the memory controller.  It is currently unaware of the
noreclaim list.  I'm not sure what will happen if/when the memory
controller tries to reclaim a page that system has moved to the
noreclaim list.  Something we'll need to address.  It's on my list, but
I won't get to it for a couple of weeks.

Lee 

