Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYD2BJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYD2BJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYD2BJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:09:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYD2BJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:09:00 -0400
Message-ID: <481674FA.4030306@zytor.com>
Date: Mon, 28 Apr 2008 18:08:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429004739.GA23281@redhat.com>
In-Reply-To: <20080429004739.GA23281@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> This would require either that DWARF processing be done far after
> kernel build, and thus the kernel cannot be self-sufficient /
> introspective without user-space assistance (like firmware); or that
> the DWARF data extraction (and systemtap-like $context-variable code
> generation) be part of the kernel build itself.  It *might* be
> workable.

DWARF processing done after the kernel build isn't really a problem, 
although it requires a large vmlinux(.gz) file to be kept around.

As part of the kernel build is probably better, at least in the case of 
static markers.

> At least one complication though is that in the case of markers,
> tracing parameter evaluation is itself conditional (and placed out of
> the hot path due to -freorder-blocks).  With your suggested kind of
> assembly ("g" constraints for all the expressions), those expressions
> would be evaluated unconditionally, just to make them live somewhere.
> That unconditional evaluation can easily entail memory reads and
> dependent arithmetic, which could swamp the savings of eliminating the
> marker-style conditional branch.

Well, it depends a bit on what kind of expressions you put in there.
You don't really want to put *expressions* in there as much as you want 
to put *data* references in there, although, of course, if your have 
something like "foo->bar[baz]->quux" then it's easy to trip upon.

One advantage of using the debugging information in this manner is that 
you can write the actual markers long after the kernel has compiled, as 
long as the data happens to be available at the call site.

Once again, the *proper* way to do this is with compiler support.  That 
way we can do patched branches and out-of-line everything with impunity.

	-hpa

