Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYGHAbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYGHAbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYGHAbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:31:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbYGHAba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:31:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: benh@kernel.crashing.org
X-Fcc: ~/Mail/linus
Cc: Andreas Schwab <schwab@suse.de>, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
In-Reply-To: Benjamin Herrenschmidt's message of  Tuesday, 8 July 2008 08:56:33 +1000 <1215471393.8970.157.camel@pasglop>
References: <20080703234140.GC9594@localdomain>
	<20080704021929.5E9EF1541F5@magilla.localdomain>
	<1215409693.8970.79.camel@pasglop>
	<20080707061811.19989154246@magilla.localdomain>
	<1215411800.8970.91.camel@pasglop>
	<20080707063522.5FE55154246@magilla.localdomain>
	<je8wwet9p6.fsf@sykes.suse.de>
	<20080707093151.8798A154246@magilla.localdomain>
	<je63rirp1x.fsf@sykes.suse.de>
	<1215471393.8970.157.camel@pasglop>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080708003127.6D3B9154244@magilla.localdomain>
Date: Mon,  7 Jul 2008 17:31:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The kernel does not have to come from the same place as the root
> > filesystem.  You may want to run a new kernel with an old filesystem, or
> > vice-versa.

Well, it's not like these bits are really going to change in practice.  My
point was just that this is a far "softer" ABI than the general kernel-user
contract.  Sorry if my being precise about things gives you indigestion.

> I agree, I'm pretty dubious here...

Dubious about whether the dsocaps bit assignments are "part of the ABI"?
Fine.  Let's talk again when you've used up 32 bits and want to figure out
what to do next.

Dubious about whether dsocaps is the right thing to do?  I think you are
overlooking what the actual kernel-user compatibility reality is here.

Firstly, what is the "risk" in the "gone wrong" case?  The risk is that a
DSO load via ld.so.cache will overlook a /lib/power99/foo.so match and get
a /lib/foo.so match instead because ldconfig doesn't know about "power99".
If foo.so wasn't in ld.so.cache at all, there is no problem.
If you used LD_LIBRARY_PATH, there is no problem.
If you used dlopen with an explicit file name (has /), there is no problem.

What happens if you boot a kernel that uses dsocaps with the new string
"power99", but you are missing the ld.so.conf.d file to match your kernel?
Then a DSO load via ld.so.cache will overlook "power99" matches.

How do you fix it?
Install the right (tiny text) file, and run ldconfig.

What happens now if you are using a new kernel that supplies a new string
"power99" in AT_PLATFORM or another auxv element used the same way, but
with an old root filesystem (say one including any glibc that exists today)?
Then a DSO load via ld.so.cache will overlook "power99" matches.

How do you fix it?
You add a bit assignment in the glibc sources, recompile glibc,
install a new whole glibc package.  (Conceivably if you are extremely
careful you can manage to redo an otherwise completely identical
build to the glibc on your old system and replace only ld{64,}.so.1
and ldconfig.)  Then run the new ldconfig.

In short, if you use a root filesystem from before kernels started using
the new string, then you will degenerate to default-platform library
matches from loads via ld.so.cache (i.e. /lib/foo.so, not /lib/somecpu/foo.so).
If you want to do better than that for this case, it's intractable using
AT_PLATFORM, and simple using dsocaps (probably simpler than booting a
special kernel was).

I haven't figured out what in this old-vs-new picture you think AT_PLATFORM
or something else like it would ever buy you.


Thanks,
Roland
