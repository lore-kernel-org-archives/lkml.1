Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbYDCAGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbYDCAGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYDCAGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:06:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34804 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbYDCAGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:06:15 -0400
Subject: Re: HugeTLB vs. SH3 cpu
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Nish Aravamudan <nish.aravamudan@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402225556.GI21524@us.ibm.com>
References: <20080401225809.GC32269@cs181133002.pp.htv.fi>
	 <29495f1d0804011626n2399d69aj7566df7f78953458@mail.gmail.com>
	 <20080402080448.GA4171@linux-sh.org>  <20080402225556.GI21524@us.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:06:09 -0700
Message-Id: <1207181169.23710.84.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 15:55 -0700, Nishanth Aravamudan wrote:
> On 02.04.2008 [17:04:48 +0900], Paul Mundt wrote:
> > On Tue, Apr 01, 2008 at 04:26:14PM -0700, Nish Aravamudan wrote:
> > Sorting out the mess noted by Adrian is pretty trivial with a
> > HAVE_HUGETLB_PAGE. How about this?
> 
> I'm confused, isn't the following simpler fix equivalent?
> 
> Fix sh3 build with HUGETLBFS=y. Only SH4 and SH5 actually support
> HUGETLB_PAGE (which HUGETLBFS depends on).
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index d731282..1981f8e 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -978,7 +978,7 @@ config TMPFS_POSIX_ACL
>  
>  config HUGETLBFS
>  	bool "HugeTLB file system support"
> -	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
> +	depends on X86 || IA64 || PPC64 || SPARC64 || ((CPU_SH4 || CPU_SH5) && MMU) || BROKEN

Yeah, that's equivalent.  But, you have to draw the line at some point
on how complex that "depends on" is going to get.  I think you each have
unique pain tolerances. :)

Personally, I kinda prefer to break it out per-arch, because that SUPERH
logic is getting a bit screwy.

You could also do something like this:

>  config HUGETLBFS
>  	bool "HugeTLB file system support"
> -	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
> +	depends on X86 || IA64 || PPC64 || SPARC64 || SUPERH_HUGETLBFS || BROKEN

And then:

config SUPERH_HUGETLBFS
	def_bool y
	depends on (CPU_SH4 || CPU_SH5) && MMU

on the arch-specific side.  

-- Dave

