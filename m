Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZCLLva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZCLLva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZCLLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:51:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZCLLvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:51:19 -0400
Subject: Re: [uClinux-dev] RE: [PATCH] NOMMU: Pages allocated to a ramfs
 inode's pagecache may get wrongly discarded
From: Peter Zijlstra <peterz@infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: uClinux development list <uclinux-dev@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090312112953.GD6995@shareable.org>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
	 <20090311170840.2f136849.akpm@linux-foundation.org>
	 <5DC5324CE00E4D4494EE5F031E354E9501CE9C0F@BUDMLVEM03.e2k.ad.ge.com>
	 <20090312112953.GD6995@shareable.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Mar 2009 12:50:08 +0100
Message-Id: <1236858608.22914.3689.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 11:29 +0000, Jamie Lokier wrote:
> Berkhan, Enrik (GE Infra, Oil & Gas) wrote:
> > Andrew Morton wrote:
> > > On Wed, 11 Mar 2009 15:30:35 +0000
> > > David Howells <dhowells@redhat.com> wrote:
> > >> From: Enrik Berkhan <Enrik.Berkhan@ge.com>
> > >> 
> > >> The solution is to mark the pages dirty at the point of allocation by
> > >> the truncation code.
> > > 
> > > Was there a specific reason for using the low-level SetPageDirty()?
> > 
> > No, no specific reason. It was just my first try of a fix after spotting 
> > the problem. After a short discussion with David, we decided to wait for 
> > others' comments on using the low-/high-level approach.
> 
> Tangentially related...
> 
> Does the vm pageout logic include or skip these "dirty" pages looking
> for candidates to flush to storage?  What about with MMU?

Includes them, regular pageout will try to do the writeout to clean them
and then discard them. 

The ramfs stuff is rather icky in that it adds the pages to the aging
list, marks them dirty, but does not provide a writeout method. 

This will make the paging code scan over them (continuously) trying to
clean them, failing that (lack of writeout method) and putting them back
on the list.
