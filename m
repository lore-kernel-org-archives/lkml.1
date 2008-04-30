Return-Path: <linux-kernel-owner+w=401wt.eu-S933736AbYD3VCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbYD3VCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbYD3VCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:02:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYD3VCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:02:39 -0400
Date: Wed, 30 Apr 2008 17:01:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [patch 0/3] dynamic_printk: new feature
Message-ID: <20080430210147.GA5616@redhat.com>
References: <20080429183935.GA8717@redhat.com> <20080430124506.0dd2a473.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430124506.0dd2a473.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 12:45:06PM -0700, Andrew Morton wrote:
> We're now in the situation where numerous different subsystems have
> implemented private mechnisms for tuning their printk verbosity levels.
> 
> Have you taken a look across the tree with a view to converting some of
> them?  If so, how sizeable/messy/feasible would that task be?
> 
> 

i really only focused on pr_debug()/dev_dbg(), with an eye towards
widening the scope as we go...but I agree that it would be nice to
understand the scope for the start...i find ~5000 call sites to
dprintk(), which would be ideal candidates for this type of
infrastructure.

> 
> The situation is far, far worse with compile-time debugging selection.  We
> have over two hundred different implementations of dprintk!
> 
> Have you considered the feasibility of ploddingly converting each of those
> drivers, one at a time over to the new infrastructure?  Because that's what
> we should do, I'm afraid.
> 
> An implication of this is that once a dprintk-using driver has been
> converted over to use your new infrastructure, it should still be possible
> to fully disable the debugging at compile time.  Do you handle that?
> 

that's correct. the way i've handled this in the patch is:

if DEBUG 
	you get the current compiled in behavior per .c file
elif DYNAMIC_PRINTK
	you get the dynamic runtime configurable debugging
else
	its compiled out

> > If this patch is accepted, i'd like to convert the myriad 'debug' printks -
> > DEBUGP(), dprintk(), to a standard format, either pr_debug() or dev_dbg(), to
> > hook into this mechanism.
> 
> ah, so you have looked.  How nasty will it be?
> 
> 
> A couple of things:
> 
> - Your design handles a boolean on/off control.  But some code implements
>   a verbosity-level control.  Thoughts on this?
> 

right, i think though it could easily be extended to level control.
Basically the patch associates the on/off per KBUILD_MODNAME, however we
could also associate a level per KBUILD_MODNAME. This level could be set
either by the generic debugfs interface, via module parameters at module
load time, or in the the module __init sections as appropriate.


> - I expect that other code implements a field-selector control, for the
>   lack of a better term: an greater-than-one number of separate boolean
>   controls.  How to handle this?
> 
> 

hmmm...i think this is handled by having the driver call the conditions
in its scope and then call out to the generic infrastructure if the
conditions are met.

> Thanks for working on this.  If we can get this underway and get a decent
> amount of conversion done, it will be a huuuuuuuuuuuuge cleanup to the
> kernel.  But we will need to design it carefully first.
> 
> I guess one good testcase would be ALSA.  It has pretty fancy debugging
> control (which I apparently have never been smart enough to understand). 
> Did you take a look at what they're doing, with a view to
> can-we-switch-ALSA-to-use-this?
> 
> 

ok. i'll take a more detailed look at the pontentially wider scope of this change.

thanks,

-Jason

