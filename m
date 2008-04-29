Return-Path: <linux-kernel-owner+w=401wt.eu-S934996AbYD2At7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934996AbYD2At7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYD2Atv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:49:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbYD2Atu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:49:50 -0400
Date: Mon, 28 Apr 2008 20:47:39 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080429004739.GA23281@redhat.com>
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48165866.5060403@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Apr 28, 2008 at 04:06:14PM -0700, H. Peter Anvin wrote:
> [...]
> >>The call site is created with an asm() statement as opposed to a gcc 
> >>function call; it is up to the logging function to take the state and 
> >>mangle it into whatever format it wants to; the debugging information 
> >>(e.g. DWARF) should tell it all it needs to know [...]
> >
> >that would be rather impractical as we'd force DEBUG_INFO builds on 
> >anyone (it's HUGE) just to do some trivial tracing. Look at the ftrace 
> >plugin usage model - it wants to be widely available and easy to use.
> 
> Otherwise you're forcing everyone to take the cost of additional cache 
> footprint, plus optimizer interference, just because they might want to 
> possibly do some trivial tracing.  

The intent is for the tracing not to be trivial but useful.

> DEBUG_INFO is The Right Thing for this, as it carries all the
> information you may want in a well-defined format.  [...]

This would require either that DWARF processing be done far after
kernel build, and thus the kernel cannot be self-sufficient /
introspective without user-space assistance (like firmware); or that
the DWARF data extraction (and systemtap-like $context-variable code
generation) be part of the kernel build itself.  It *might* be
workable.

At least one complication though is that in the case of markers,
tracing parameter evaluation is itself conditional (and placed out of
the hot path due to -freorder-blocks).  With your suggested kind of
assembly ("g" constraints for all the expressions), those expressions
would be evaluated unconditionally, just to make them live somewhere.
That unconditional evaluation can easily entail memory reads and
dependent arithmetic, which could swamp the savings of eliminating the
marker-style conditional branch.

- FChE
