Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbZA0Xvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbZA0Xvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZA0Xvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:51:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:8431 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZA0Xvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uObWaj4S3q2AmNHjmT34IHYdvk49+BLvolIQ1ePdikLabGQaBXCArpZ4D7wI1J1rJx
         kV6OiNKXiLgMPQQmIED+wIQz8wa7UiWETcQlhgymLtfk9V58jZEs4yFi4vDmolSY7z2I
         T9deFAkut29isrt06BVjdpvCRsfQX/8wPxilM=
MIME-Version: 1.0
In-Reply-To: <20090127233159.GA26403@elte.hu>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <20090127233159.GA26403@elte.hu>
Date: Wed, 28 Jan 2009 00:51:36 +0100
Message-ID: <19f34abd0901271551h482b3337k8097849d2ddb26b4@mail.gmail.com>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
> It would be much better if we exported _much_ less and reduced our
> cross-section to user-space. Also, the include/linux/Kbuild rules are all
> but transparent: it would also be nice if whatever we exported was be
> visible straight in the header itself, to make it obvious to people who
> modify/extend those files that those definitions are going to be exported
> to user-space.
>
> Some __user_export tag on structures perhaps? I have no good ideas here -
> #ifdefs are ugly and tags obscure the purity of the code.

Something that might or might not be doable in practice, but at least
it's a suggestion that I haven't seen elsewhere:

Create an include/user/ directory that contains a "mirror" of the
include/ directory _structure_, so that random exported header
include/linux/foo.h now has two parts -- include/linux/foo.h and
include/user/linux/foo.h.

- include/user/linux/foo.h contains the definitions that are needed by
both kernel and userspace
- include/linux/foo.h contains the definitions that are needed only by
the kernel
- include/linux/foo.h can simply #include <user/linux/foo.h> and no
other change (to source files which _use_ this header) is necessary
- no dependency on a kernel header will exist in a "user" header --
that's how it is now, but this way is more explicit
- the whole include/user/ can be shipped verbatim to /usr/include (or
wherever it is needed)
- no #ifdef __KERNEL__ or #ifdef CONFIG_ stuff in the "user" headers;
no stripping or unifdefing is needed
- it's easier to see exactly what is being exported

Of course, obvious disadvantages are:

- less readable in the sense that what used to be in one file is now
spread across two
- the split itself would probably require a tremendous effort
- other things?

It's just an idea...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
