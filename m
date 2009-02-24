Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZBXQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZBXQ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZBXQ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:59:05 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36747 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZBXQ7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:59:03 -0500
Subject: Re: Another Performance Regression in write() syscall
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200902241947.53180.nickpiggin@yahoo.com.au>
References: <20090224060558.GA14812@google.com>
	 <1235456745.26788.237.camel@nimitz>
	 <200902241947.53180.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 08:58:52 -0800
Message-Id: <1235494732.26788.256.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 19:47 +1100, Nick Piggin wrote:
> On Tuesday 24 February 2009 17:25:45 Dave Hansen wrote:
> > On Mon, 2009-02-23 at 22:05 -0800, Salman Qazi wrote:
> > > Analysis of profile data has led us to believe that the commit
> > > 3d733633a633065729c9e4e254b2e5442c00ef7e has caused a performance
> > > regression.  This commit provides for tracking of writers so that read
> > > only bind mounts function correctly.
> > >
> > > We can verify this regression by applying the following patch to
> > > partially disable the above-mentioned commit and then running the fstime
> > > component of Unixbench.  The settings used were 256 byte writes with
> > > MAX_BLOCK of 2000.
> >
> > I'm a bit surprised that write() is what is regressing.  Unless I
> > screwed up, we do all the expensive accounting at open()/close() time.
> > Is this a test that gets run in parallel on multiple cpus?
> 
> Don't forget touch_atime...

Yeah, that's a good point.  Are we sure that's what is happening here,
though?  That's one thing a profile would hopefully help with.

> Still, open/close isn't unimportant either.

Yeah, that's true.  But, what I noticed was that all of the other
open/close activity masked out any overhead from mnt_want/drop_write()
since a big chunk of the overhead was just going and bringing the
vfsmount pieces into the cache.

> > Could you take a look at Nick's patches to speed this stuff up?
> >
> > 	http://thread.gmane.org/gmane.linux.file-systems/28186
> >
> > We may need to dust those off, although I'm still a bit worried about
> > the complexities of open-coding all the barriers.
> 
> I really need to do something about trying to push them upstream again
> actually because we've got them in SLES11 tree.

Were the patches that you integrated any different from the ones you
posted a few months ago?

-- Dave

