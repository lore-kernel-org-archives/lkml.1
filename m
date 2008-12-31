Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbYLaB4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbYLaB4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYLaB4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:56:37 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:53804 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752911AbYLaB4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:56:36 -0500
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87fxk5ur0h.fsf@basil.nowhere.org>
References: <20081230231152.10427.50620.stgit@hermosa.site>
	 <87fxk5ur0h.fsf@basil.nowhere.org>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Tue, 30 Dec 2008 18:56:29 -0700
Message-Id: <1230688589.3470.45.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 01:28 +0100, Andi Kleen wrote:
> Peter W Morreale <pmorreale@novell.com> writes:
> 
> > The following series implements a fix for pdflush thread creation and an
> > enhancement for allowing the setting of the minimum and maximun number
> > of pdflush threads. 
> 
> You forgot to state why the admin should control that?
> 
> Each sysctl essentially presents a failure of the automatic tuning
> algorithms of the kernel (kernel hackers admitting defeat). 
> 
> So a patch adding new ones at least needs a clear rationale what
> problem it is trying to fix and why the automatic tuning cannot be
> fixed instead to address this case without new knobs.
> 

Understood.  

The rational is simply because one-size may not fit all.  Currently
there is minimalistic tuning wrt pdflush thread creation. 

Each pdflush thread arbitrarily decides to create another thread solely
on the basis of all currently existing threads being busy for >= one
second.  So this can result in NCPUS pdflush threads being created
'concurrently' should all existing threads wind up in the idle check at
the same time (I have seen this).  Or it can result in a thread being
created every second, up to the max.  That seems indeterministic at
best. 

Note that this patch doesn't change that algorithm at all, it merely
allows the admin to control the bounds without having to recompile the
kernel. 

More to the point, on small systems with few file systems, what is the
point of having 8 (the current max) threads competing with each other on
a single disk?  Likewise, on a 64-way, or larger system with dozens of
filesystems/disks, why wouldn't I want more background flushing?

I actually think the question is: Why not allow the admin to control
this?  Since it seems like this is a matter of policy based on machine
configuration.  I don't look at this as a matter of defeat, rather, a
matter of policy. Note that the current defaults remain the same.

So that's the rational.  Its not an attempt to fix background flushing,
and regardless, I would still argue that any 'fix' to background
flushing would involve a number of threads that were bounded by some
min/max  and that min/max would still need to be set on some admin
policy based on intended machine size/use. 

And btw Andi, I should have cc'ed you on this, I know from the flush
code that you were heavily involved.  I only cc'ed Peter Z. since his
name was in pdflush.c.  My apologies.  

Best,
-PWM



> -Andi
> 

