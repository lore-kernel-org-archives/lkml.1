Return-Path: <linux-kernel-owner+w=401wt.eu-S1762463AbYBCR0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463AbYBCR0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbYBCR0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:26:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57395 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061AbYBCR0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:26:33 -0500
Date: Sun, 3 Feb 2008 18:26:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by design)
Message-ID: <20080203172635.GA2275@uranus.ravnborg.org>
References: <20080203130844.GS27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203130844.GS27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 01:08:44PM +0000, Al Viro wrote:
> ; cat >a.c <<'EOF'
> const char foo[] __attribute__ ((__section__(".blah"))) = "";
> const char * const bar __attribute__((__section__(".blah"))) = "";
> EOF
> ; gcc -m32 -S a.c
> ; gcc -m64 -S a.c
> a.c:2: error: bar causes a section type conflict
> ;
> 
> That's 4.1.2 on ppc.  What happens is that the second declaration
> wants to make .blah writable.  We actually trigger that in ppc64
> builds on drivers/net/natsemi.c.
> 
> Note that on ppc64 without explicit sections you have the second one land in
> .data.rel.ro.local, which is "aw",progbits.
> 
> The reason why it didn't visibly bite us before is that usually __devinit...
> just expanded to nothing (unless you disable HOTPLUG, which requires
> EMBEDDED, which wasn't apparently common enough for ppc64 builds).
> 
> Suggestions?

Hi Al.

__devinitconst were invented to cover this issue.
So use __devinitconst for const data and 
__devinitdata for non-const data.

We recently had breakage in mainline with x86 64 bit
(sis190) for the exact same case.

Does this work in your ppc example or do we need
to find another solution?

	Sam
