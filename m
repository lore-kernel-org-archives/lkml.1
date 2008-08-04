Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYHDAgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYHDAgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYHDAga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:36:30 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:43900 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547AbYHDAg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:36:28 -0400
Message-ID: <48964E83.80002@snapgear.com>
Date: Mon, 04 Aug 2008 10:34:11 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
References: <20080728200500.GA14284@uranus.ravnborg.org> <48900EE4.8030606@snapgear.com> <20080730083853.GB18366@uranus.ravnborg.org> <4892A719.5090302@snapgear.com> <Pine.LNX.4.64.0808032205120.23329@anakin>
In-Reply-To: <Pine.LNX.4.64.0808032205120.23329@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Geert Uytterhoeven wrote:
> On Fri, 1 Aug 2008, Greg Ungerer wrote:
>> Sam Ravnborg wrote:
>>> On Wed, Jul 30, 2008 at 04:49:08PM +1000, Greg Ungerer wrote:
>>>> Sam Ravnborg wrote:
>>>>> The traditional location of the arch specific Makefiles
>>>>> has been at:
>>>>>
>>>>> 	include/asm-$ARCH
>>>>>
>>>>> But as suggested by several people over time and lately
>>>>> by Linus in the following post:
>>>>> http://kerneltrap.org/mailarchive/linux-kernel/2008/5/21/1903924
>>>>>
>>>>> is is suggested to move the arch specific files under arch/
>>>>> and for the header files this is arch/$ARCH/include.
>>>>>
>>>>> So I have hacked up support for this in kbuild so
>>>>> for the simpler cases a simple move of header files as
>>>>> in:
>>>>> 	git mv include/asm-$ARCH arch/$ARCH/include/asm
>>>>>
>>>>> is enough.
>>>>>
>>>>> If Linus will accept it then I think -rc1 is a perfect
>>>>> time to do it as people has less stuff pending touching
>>>>> the header files that are moved.
>>>>> Validation is easy - does the usual configs build?
>>>>>
>>>>> For the archs that plays games with symlinks this is a
>>>>> splendid opportunity to get rid af these.
>>>>> The receipe is simple:
>>>>> Use 	KBUILD_CFLAGS += -Iarch/$ARCH/include/$CPU
>>>>>
>>>>> to select the CPU and then do a copy of the header files
>>>>> like this:
>>>>>
>>>>> 	git mv include/asm-$ARCH/$CPU arch/$ARCH/include/$CPU/cpu
>>>>>
>>>>> Then the code can continue to use:
>>>>>
>>>>> 	#include <cpu/foo.h>
>>>>>
>>>>> I already converted sparc to use arch/sparc/include -
>>>>> while I merged the header files for sparc and sparc64.
>>>>> This change is already upstream.
>>>>>
>>>>> And for SH I posted a receipe which you can read here:
>>>>> http://lkml.org/lkml/2008/7/28/83
>>>>>
>>>>> It is SH specific but anyway pretty generic.
>>>>>
>>>>> I am limited in time and resources at the moment but I
>>>>> would be glad to help out as time permits should there
>>>>> be any questions.
>>>> I just tried moving the include/asm-m68knommu directory
>>>> to arch/m68knommu/include/asm and it all worked fine.
>>>> Clean compile first go :-)  Nice.  (As noted
>>>> asm-offsets.h was still generated in incldue/asm-m68knommu
>>>> afterwards though).
>>>>
>>>> So what is the status, should I prepare git/patch
>>>> for Linus?
>>> Yes please do so.
>> The move change can be pulled from:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus
>>
>> If there is no complaints I'll send Linus a pull request in a
>> couple of days time.
> 
> I did:
> 
>     mkdir arch/m68k/include
>     mv include/asm-m68k arch/m68k/include/asm
> 
> and m68k still builds fine (I applied Stephen's patch for the
> asm-sparc inclusion problem for Sun 3/3x first, of course).
> 
> As (a) I'm not using git (yet) for merging with Linus, and (b) this will
> cause some breakage in the m68knommu tree anyway, perhaps it's easiest if Greg
> takes care of it in m68knommu.git?
> 
> Greg, is that OK for you?

Yep, I will do that.


> You can add my Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> There seem to be 3 classes of m68knommu header files:
>   1. Plain files (some of them may be (nearly) identical copies of the
>      m68k variants,
>   2. Files that just include the m68k variant,
>   3. Files that include the m68k variant and do something more (pci.h and
>      setup.h).
> 
> Since I don't think we want to do the m68k/m68knommu merge right now
> (Sorry Arnd, I'll keep your script in mind anyway!), the simplest way is to:
>   - Remove all files from class 2, and add to the Makefile:
> 
> 	ccflags-y += -Iarch/m68k/include
> 
>   - Include verbatim the contents of the m68k variant for class 3, cfr.
>     Stephen patch for the asm-sparc inclusion problem for Sun 3/3x).
> 
> Do you agree?

That sounds like a good approach.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
