Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbYGNWJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbYGNWJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbYGNWCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:47 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58444 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758437AbYGNWCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:45 -0400
Subject: Re: [PATCH] simple dprobe like markers for the kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <487B7E37.9050600@redhat.com>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>
	 <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
	 <1215697794.3353.5.camel@localhost.localdomain>
	 <20080710142208.GC1213@redhat.com>
	 <1215700996.3353.30.camel@localhost.localdomain>
	 <20080710153017.GB25939@mit.edu>
	 <1215886965.3360.16.camel@localhost.localdomain>
	 <487B7E37.9050600@redhat.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 17:02:40 -0500
Message-Id: <1216072960.3378.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 12:26 -0400, Masami Hiramatsu wrote:
> Hi James,
> 
> James Bottomley wrote:
> > This is just an incremental update based on feedback.  The most
> > significant was that making the marker a compiler barrier will free the
> > inserter from worrying about the mark sliding around changes to named
> > variables (and thus having to worry about this in placement) at
> > practically zero optimisation cost.  I also updated the code to drop and
> > asm section instead of using the static variable scheme.  I also added
> > documentation and made the module loader ignore them (since modules
> > don't go through the vmlinux.lds transformations).
> 
> I'm very interested in your approach.
> 
> IMHO, as Aoki investigated, the overhead of markers is not so big
> unless we put a lot of them into kernel.

That's the case which I started from.  The point is that if passive
markers have a cost, we have to be very careful about placing them to
avoid the cost adding up.

>  And from "active"
> overhead point of view, it takes less than tens of nano-seconds,
> while kprobes takes hundreds of nano-seconds. Kprobe also has a
> limitation of probable points, it can't probe "__kprobes" marked
> functions. So, original markers still has advantages.

Yes ... the zero impact markers are completely dependent on the kprobes
overhead for activation ... on the other hand, one of the vendor
complaints is cost of activation of kprobes, so it's nicely tied into
solving that particular problem.

> However, your approach is also useful, especially for embedding
> thousands of markers in kernel or drivers.
> 
> So I think it's better to use both of them as the situation demands.

Certainly ... as I said to Ted, I'm not planning to replace the current
markers, just give a lightweight alternative.

> I just have one comment on its name. Since it doesn't trace
> anything, so I'd rather like notation() or note_mark() than
> trace_simple(). :-)

well ... the current markers code uses trace_mark as its base .. I was
just trying to fit into that scheme.

Also, don't rely on anything in this code yet ... that's why it's an
RFC; I'm still playing around with the section formats and the
information.  After more discussions with people, I'm actually coming to
the conclusion that dropping the address of the simple marker might be
very useful (in place of file and line).  It makes the marker section
need relocation, but it would also mean they could be used simply from
within the kernel as well.

James


