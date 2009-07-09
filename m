Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZGIBOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZGIBOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbZGIBNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:13:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:36567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbZGIBNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:13:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,371,1243839600"; 
   d="scan'208";a="531274233"
Date: Thu, 9 Jul 2009 09:11:41 +0800
From: Feng Tang <feng.tang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Len Brown <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 08/12] SFI, x86: hook e820() for memory map
 initialization
Message-ID: <20090709091141.19652887@feng-desktop>
In-Reply-To: <4A551184.1020707@zytor.com>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
	<5bf6b3c7c08a76ea8dc52e9e07728c2958938952.1247025117.git.len.brown@intel.com>
	<4A551184.1020707@zytor.com>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009 05:37:08 +0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> This bothers me... we keep saying that memory map initialization
> belongs to the boot loader, and yet we keep doing the opposite.  This
> isn't just an arbitrary difference, either: it is pretty essential to
> being able to use the early range allocator safely.
> 
> 	-hpa

Hi hpa,

I understand your concern, and I've added that code into our boot loader
for Moosrestown which sets up a e820 memory table in boot parameters by 
parsing SFI table. 

The reason we still keep this piece of code is to be compatible with old
version boot loaders which may not know SFI info yet. And
sfi_init_memory_map() only get called when kernel can't find an e820 table
in boot parameters.

Anyway, I think we can remove the code if it really breaks the rule.

Thanks,
Feng

> 
> 
> Len Brown wrote:
> > From: Feng Tang <feng.tang@intel.com>
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > ---
> >  arch/x86/kernel/e820.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> > index c4ca89d..e399d0e 100644
> > --- a/arch/x86/kernel/e820.c
> > +++ b/arch/x86/kernel/e820.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/pfn.h>
> >  #include <linux/suspend.h>
> >  #include <linux/firmware-map.h>
> > +#include <linux/sfi.h>
> >  
> >  #include <asm/pgtable.h>
> >  #include <asm/page.h>
> > @@ -1437,6 +1438,10 @@ char *__init
> > default_machine_specific_memory_setup(void) < 0) {
> >  		u64 mem_size;
> >  
> > +		/* if SFI mmap table exists, use SFI to setup e820
> > mmap */
> > +		if (!sfi_init_memory_map())
> > +			return "SFI";
> > +
> >  		/* compare results from other methods and take the
> > greater */ if (boot_params.alt_mem_k
> >  		    < boot_params.screen_info.ext_mem_k) {
> 
