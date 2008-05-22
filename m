Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbYEVXib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbYEVXib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbYEVXiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:38:20 -0400
Received: from sous-sol.org ([216.99.217.87]:38723 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbYEVXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:38:19 -0400
Date: Thu, 22 May 2008 16:37:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com
Subject: Re: capget() overflows buffers.
Message-ID: <20080522233757.GD30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4835F929.7010200@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew G. Morgan (morgan@kernel.org) wrote:
> Chris Wright wrote:
> | Andrew, I think this should be considered a serious problem.  The
> | interface ABI is stable for old programs, and fine for anything new
> | or old that's using libcap.  But the API has changed subtly (taking a
> | pointer to a blob, to a pointer to an array of blobs), and is easily
> | broken for programs recompiled against new headers not using libcap.
>
> [There is a warning about this issue in the kernel header file.]
>
> The kernel is not crashing, the application is...

It's not about crashing.  It's about app security.  Currently, there is
nothing guaranteeing named has actually dropped privileges.  That's why
I consider this serious.

> If you take this compiled binary, that crashes on 2.6.25, and try to run
> it on 2.6.24 it will fail there too - since the magic its 'forcing' is
> not valid on that kernel. So the compiled 'binary' we're discussing does
> not have an existence proof that it will successfully run anywhere.

Right, that's not the issue.

> In point of fact, the kernel is binary compatible with old binaries. The
> problem is that _LINUX_CAPABILITY_VERSION #define now points to _2
> instead of _1 by default and Squid etc., are not paying attention to the
> value of the new magic cookie but expecting the previous revision of the
> ABI to work.

Yes, as they should.  I don't think we should ever expect an existing
userspace program change just by recompiling against a new kernel header
when using an already existing mechanism.  Their app has been working
fine since 2.2.

  int fd = open("foo", O_FLAGS, mode);

compile once...binary compatible going forward (as is cap{s,g}et).
update kernel, recompile...source API comaptible...still working
(this is broken in cap{s,g}et).

> As such, I don't agree that there is a problem with the ABI, and I don't
> agree with your assertion about things being broken. I maintain there is
> a problem with the application source code.

History bites us...libcap wasn't always there.  As we see, people roll
their own.  You can argue that the interface is opaque, I'd agree.
Also that it's their fault for poking into the guts of the opaque
interface...yeah, I tend to even agree there.  However, it's not practical
to argue that when this app code has worked fine for 10 years.

> One 'solution' is to force everyone to notice at compile time by simply
> removing the definition of _LINUX_CAPABILITY_VERSION and force all new
> source code to be explicit about which ABI it wants to use...

No, the solution there would be to keep _LINUX_CAPABILITY_VERSION as
v1 (otherwise you just broke apps again).  And use another mechanism to
signal the availability of 64bit caps.

thanks,
-chris
