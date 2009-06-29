Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZF2KWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZF2KWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZF2KWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:22:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZF2KWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:22:10 -0400
Date: Mon, 29 Jun 2009 06:21:52 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090629102152.GA7993@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090629003514.GC2479@localhost.localdomain> <20090628222455.GA21475@redhat.com> <20090629023621.GA4289@localhost.localdomain> <20090628233200.GA26669@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628233200.GA26669@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 01:32:00AM +0200, Oleg Nesterov wrote:
> On 06/28, Neil Horman wrote:
> >
> > On Mon, Jun 29, 2009 at 12:24:55AM +0200, Oleg Nesterov wrote:
> > >
> > > Perhaps this sysctl should be added in a separate patch? This patch mixes
> > > differents things imho.
> > >
> > No, I disagree. If we're going to have a sysctl, It should be added in this
> > patch.  I agree that since these processes run as root, we can have all sort of
> > bad things happen.  But I think theres an advantage to being able to limit the
> > damage that a core_pattern process can do if it never exits.
> 
> Yes, but why it should be added in this patch?
> 
I agree with what you said earlier, in that the sysctl is orthogonal to the
wait_for_complete functionality, from an implementation standpoint.  But I don't
feel as though they are independent from a behavioral standpoint.  Given that
the sysctl defines a default value of zero in which unlimited parallel core
dumps are allowed, but none are waited for, separating the patches creates a
behavioral split in which the the core_pattern behavior changes for the span of
one commit, and in such a way that the system can deadlock if the core_pattern
process does bad things.  To illustrate, say we applied the wait_for_core patch
separately from sysctl patch.  If someone built with both patches, their
core_pattern behavior would appear unchanged, but if they built with only the
first patch, and their core_pattern app had a bug in which the process never
exited properly, they would get an unbounded backlog of unreaped processes.  I
could certainly modify the first patch to never wait, and then modify the sysctl
to decide when it was ok to wait, but to add a patch that allows for a wait
state that never happens seems a bit odd to me.

Regards
Neil

