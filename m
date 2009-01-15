Return-Path: <linux-kernel-owner+w=401wt.eu-S936195AbZAOWxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936195AbZAOWxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933825AbZAOWJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:09:41 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:50047 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934914AbZAOWJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:09:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L1eTn5nJqL05SiOv6iOqOHRwMgbcYViIiDDV3zF4l4nKq8UHFuyXDxtE+KYDPw3YVA
         87AukW7w9+m/Et4Ox8wYPlVwb6rwzyHclaQri/N2t23nLNYYCG5dB/FJOgbHEXqon2rZ
         GYkC0WFQjzK0xI/PKZ8PX1aXkHbqyH3x9pvAs=
MIME-Version: 1.0
In-Reply-To: <1231944602.24082.42.camel@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20090108144538.e5195575.akpm@linux-foundation.org>
	 <1231753866.10982.11.camel@pc1117.cambridge.arm.com>
	 <20090112022138.bd2e6ce4.akpm@linux-foundation.org>
	 <20090112213339.feefdd02.sfr@canb.auug.org.au>
	 <1231936220.24082.11.camel@pc1117.cambridge.arm.com>
	 <20090115010141.42e1dfc5.sfr@canb.auug.org.au>
	 <1231944602.24082.42.camel@pc1117.cambridge.arm.com>
Date: Thu, 15 Jan 2009 17:09:35 -0500
Message-ID: <170fa0d20901151409p5ce88a4cqb3686d600ac6190e@mail.gmail.com>
Subject: Re: [PATCH 00/14] Kernel memory leak detector
From: Mike Snitzer <snitzer@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/09, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, 2009-01-15 at 01:01 +1100, Stephen Rothwell wrote:
>  > On Wed, 14 Jan 2009 12:30:20 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> > > Are you OK with applying patches to linux-next (git am) rather than
>  > > using git merge? This way I can rebase kmemleak on top of linux-next.
>  >
>  > I would much prefer a few conflicts to carrying a post linux-next patch
>  > because linux-next can change radically day to day - especially since we
>  > know there will be clashes in the areas of files you would be patching.
>  >
>  > So lets use the above git tree and see how we go. OK?
>
>
> It sounds fine. Thanks.

Hi Catalin,

I figured I'd post here so others can weigh in on what I'm seeing with
kmemleak (especially the section mismatch warnings during modpost).

When running your latest git kmemleak branch (as is being pulled into
linux-next AFAIK) I'm still seeing that kmemleak fails to initialize
with:

kmemleak: Early log buffer exceeded
Pid: 0, comm: swapper Not tainted 2.6.29-rc1.devel #2
Call Trace:
 [<ffffffff80803276>] log_early+0x26/0x74
 [<ffffffff802ad983>] kfree+0x94/0x1eb
 [<ffffffff802adefd>] do_tune_cpucache+0x1b1/0x422
 [<ffffffff802ae32c>] enable_cpucache+0x63/0xaa
 [<ffffffff808031f8>] kmem_cache_init+0x402/0x45a
 [<ffffffff8025dd3b>] __mutex_init+0x21/0x32
 [<ffffffff807e8b86>] start_kernel+0x297/0x337
 [<ffffffff807e8392>] x86_64_start_kernel+0xde/0xe2
Kernel memory leak detector disabled

Now when I built the kernel I got the following:

WARNING: modpost: Found 6 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Doing so yields:
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0xaed80): Section mismatch in reference from
the function kmemleak_free() to the function .init.text:log_early()
The function kmemleak_free() references
the function __init log_early().
This is often because kmemleak_free lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: vmlinux.o(.text+0xaf0b0): Section mismatch in reference from
the function kmemleak_no_scan() to the function .init.text:log_early()
The function kmemleak_no_scan() references
the function __init log_early().
This is often because kmemleak_no_scan lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: vmlinux.o(.text+0xaf13e): Section mismatch in reference from
the function kmemleak_ignore() to the function .init.text:log_early()
The function kmemleak_ignore() references
the function __init log_early().
This is often because kmemleak_ignore lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: vmlinux.o(.text+0xaf1ca): Section mismatch in reference from
the function kmemleak_not_leak() to the function
.init.text:log_early()
The function kmemleak_not_leak() references
the function __init log_early().
This is often because kmemleak_not_leak lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: vmlinux.o(.text+0xafaba): Section mismatch in reference from
the function kmemleak_scan_area() to the function
.init.text:log_early()
The function kmemleak_scan_area() references
the function __init log_early().
This is often because kmemleak_scan_area lacks a __init
annotation or the annotation of log_early is wrong.

WARNING: vmlinux.o(.text+0xafd77): Section mismatch in reference from
the function kmemleak_alloc() to the function .init.text:log_early()
The function kmemleak_alloc() references
the function __init log_early().
This is often because kmemleak_alloc lacks a __init
annotation or the annotation of log_early is wrong.
