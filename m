Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYICINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYICINs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYICINc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:13:32 -0400
Received: from ns.suse.de ([195.135.220.2]:49366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYICINb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:13:31 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: Novell, SuSE Labs
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [genksyms patch 3/4] Track symbol checksum changes
Date: Wed, 3 Sep 2008 10:13:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <20080721022823.896799736@suse.de> <20080721025913.063165574@suse.de> <20080902220231.0197237e.akpm@linux-foundation.org>
In-Reply-To: <20080902220231.0197237e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031013.27948.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 07:02:31 Andrew Morton wrote:
> On Mon, 21 Jul 2008 04:28:26 +0200 Andreas Gruenbacher <agruen@suse.de> 
wrote:
> > Sometimes it is preferable to avoid changes of exported symbol checksums
> > (to avoid breaking externally provided modules).  When a checksum change
> > occurs, it can be hard to figure out what caused this change: underlying
> > types may have changed, or additional type information may simply have
> > become available at the point where a symbol is exported.
> >
> > Add a new --reference option to genksyms which allows it to report why
> > checksums change, based on the type information dumps it creates with
> > the --dump-types flag.  Genksyms will read in such a dump from a previous
> > run, and report which symbols have changed (and why).
> >
> > The behavior can be controlled for an entire build as follows: If
> > KBUILD_SYMTYPES is set, genksyms uses --dump-types to produce *.symtypes
> > dump files.  If any *.symref files exist, those will be used as the
> > reference to check against.  If KBUILD_PRESERVE is set, checksum changes
> > will fail the build.
>
> This breaks `make M=...'
>
> With i386 allmodconfig,
>
>
> akpm2:/usr/src/25> make M=drivers/rtc
>
>   WARNING: Symbol version dump /usr/src/devel/Module.symvers
>            is missing; modules will have no dependencies and modversions.
>
>   LD      drivers/rtc/built-in.o
>   CC [M]  drivers/rtc/rtc-lib.o
> scripts/genksyms/genksyms: invalid option -- r
> Usage:
> genksyms [-adDTwqhV] > /path/to/.tmp_obj.ver
>
>   -a, --arch            Select architecture
>   -d, --debug           Increment the debug level (repeatable)
>   -D, --dump            Dump expanded symbol defs (for debugging only)
>   -T, --dump-types file Dump expanded types into file (for debugging only)
>   -w, --warnings        Enable warnings
>   -q, --quiet           Disable warnings (default)
>   -h, --help            Print this message
>   -V, --version         Print the release version
> make[1]: *** [drivers/rtc/rtc-lib.o] Error 1
> make: *** [_module_drivers/rtc] Error 2

The usage information above is from an unpatched genksyms; a "make scripts" is 
needed. On a clean tree, this works for me:

	make allmodconfig prepare scripts
	make M=drivers/rtc

When compiling out-of-tree modules with M=, the O= tree is not rebuilt 
automatically; it may even be read-only (as when building an external module 
as a user using the distro kernel packages).

Thanks,
Andreas
