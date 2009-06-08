Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZFHOd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZFHOd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZFHOdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:33:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35627 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbZFHOdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:33:19 -0400
Date: Mon, 8 Jun 2009 10:32:20 -0400
From: Dave Jones <davej@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Young <hidave.darkstar@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       cpufreq@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       trenn@suse.de, sven.wegener@stealer.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #13475] suspend/hibernate lockdep warning
Message-ID: <20090608143220.GC2516@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Dave Young <hidave.darkstar@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	cpufreq@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
	trenn@suse.de, sven.wegener@stealer.net,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.7vF.2Y7KKB@chimera> <84144f020906070621r1f480eaeief026d23662df380@mail.gmail.com> <a8e1da0906080035j9f8b38drb46132de5a515915@mail.gmail.com> <1244447366.13471.4.camel@penberg-laptop> <20090608124844.GA17588@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608124844.GA17588@Krystal>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 08:48:45AM -0400, Mathieu Desnoyers wrote:
 
 > > > >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13475
 > > > >> Subject         : suspend/hibernate lockdep warning
 > > > >> References      : http://marc.info/?l=linux-kernel&m=124393723321241&w=4
 > > > 
 > > > I suspect the following commit, after revert this patch I test 5 times
 > > > without lockdep warnings.
 > > > 
 > > > commit b14893a62c73af0eca414cfed505b8c09efc613c
 > > > Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
 > > > Date:   Sun May 17 10:30:45 2009 -0400
 > > > 
 > > > 	[CPUFREQ] fix timer teardown in ondemand governor
 > > 
 > > The patch is probably not at fault here. I suspect it's some latent bug
 > > that simply got exposed by the change to cancel_delayed_work_sync(). In
 > > any case, Mathieu, can you take a look at this please?
 > 
 > Yes, it's been looked at and discussed on the cpufreq ML. The short
 > answer is that they plan to re-engineer cpufreq and remove the policy
 > rwlock taken around almost every operations at the cpufreq level.
 > 
 > The short-term solution, which is recognised as ugly, would be do to the
 > following before doing the cancel_delayed_work_sync() :
 > 
 > unlock policy rwlock write lock
 > 
 > lock policy rwlock write lock
 > 
 > It basically works because this rwlock is unneeded for teardown, hence
 > the future re-work planned.
 > 
 > I'm sorry I cannot prepare a patch current... I've got quite a few pages
 > of Ph.D. thesis due for the beginning of July.
 
I'm kinda scared to touch this code at all for .30 due to the number of
unexpected gotchas we seem to run into every time we touch something
locking related.  So I'm inclined to just live with the lockdep warning
for .30, and see how the real fixes look for .31, and push them back
as -stable updates if they work out.


Venki, what are your thoughts?

	Dave

