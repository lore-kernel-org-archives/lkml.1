Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbYBHIrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbYBHIrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbYBHIrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:47:39 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41347 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbYBHIrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:47:39 -0500
Date: Fri, 8 Feb 2008 09:47:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by design)
Message-ID: <20080208084744.GA27120@uranus.ravnborg.org>
References: <20080203130844.GS27894@ZenIV.linux.org.uk> <47AB4F0E.3050907@redhat.com> <20080207185409.GA21145@uranus.ravnborg.org> <47AC1D63.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC1D63.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 08:14:11AM +0000, Jan Beulich wrote:
> >I cannot see any other way out of this than to loose all the newly added
> >consts. We have to different behavior across platforms to find a suitable
> >solution that is reliable.
> >
> >[Kept rest of mail as I added Jan - hope he have some ideas to throw in].
> 
> I'd first of all need a better understanding of what these comments are
> really based upon:
> 
> /* On some platforms relocations to global data cannot go into read-only
>    sections, so 'const' makes no sense and even causes compile failures
>    with some compilers. */

Al posted the following:
====================================================================
; cat >a.c <<'EOF'
const char foo[] __attribute__ ((__section__(".blah"))) = "";
const char * const bar __attribute__((__section__(".blah"))) = "";
EOF
; gcc -m32 -S a.c
; gcc -m64 -S a.c
a.c:2: error: bar causes a section type conflict
;

That's 4.1.2 on ppc.  What happens is that the second declaration
wants to make .blah writable.  We actually trigger that in ppc64
builds on drivers/net/natsemi.c.

Note that on ppc64 without explicit sections you have the second one land in
.data.rel.ro.local, which is "aw",progbits.
====================================================================

Se we see that despite being marked as const the the section
is in one case marked as read-only by gcc and in another case the section
is marked as rw.

And this is with the gcc version that is in use today and which
we must support.
Thats why I think we have to loose the constification that is going on
or we should loose the section attribute on the data.


> 
> While I can see such behavior as reasonable for, say, shared objects,
> I severely doubt that this is generally appropriate for executables, not
> to say for the kernel. This is particularly in the light of this comment in
> gcc/output.h:
> 
>   /* To optimize loading of shared programs, define following subsections
>      of data section:
> 
> which clearly says that the resulting (default) object placement (of read-
> only data in writeable sections) is an optimization, not a requirement,
> and even then only for shared programs (which the kernel clearly isn't).
> Has there been any communication with the gcc folks on this subject?

No.

	Sam
