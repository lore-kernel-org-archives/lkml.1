Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab0BCXIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:08:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756553Ab0BCXIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:08:48 -0500
Date: Wed, 3 Feb 2010 15:08:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Message-Id: <20100203150803.5a4b37fe.akpm@linux-foundation.org>
In-Reply-To: <201002032334.37198.rjw@sisk.pl>
References: <alpine.LFD.2.00.1001221841490.2266@localhost>
	<201002030244.23989.rjw@sisk.pl>
	<20100202174853.67eeccdd.akpm@linux-foundation.org>
	<201002032334.37198.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 23:34:37 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 03 February 2010, Andrew Morton wrote:
> > On Wed, 3 Feb 2010 02:44:23 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > +static inline gfp_t clear_gfp_allowed_mask(gfp_t mask)
> > > +{
> > > +	gfp_t ret = gfp_allowed_mask;
> > > +	gfp_allowed_mask &= ~mask;
> > > +	return ret;
> > > +}
> > 
> > Fair enuf.
> > 
> > Of course, this is all horridly racy/buggy without locking.  Would I be
> > correct in hoping that all the callers happen when the system is in
> > everyone-is-frozen mode?
> 
> As far as I can tell, gfp_allowed_mask is only touched during init apart from
> this.

Well yes - the new interfaces are the problem - they're racy!

> > Perhaps we should add some documentation (or even an assertion) to
> > prevent someone from using these interfaces from within normal code.
> 
> I thought about that, but didn't invent anything smart enough.
> 
> Well, maybe except for a comment like "this must be called with pm_mutex held",
> because that's the only case when it would be really safe.

Is that the locking rule?  My above guess was incorrect?

Maybe slip a

	BUG_ON(!mutex_is_locked(&pm_mutex));

in there?
