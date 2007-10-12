Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbXJLRUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbXJLRUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762421AbXJLRTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:19:13 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40910 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762708AbXJLRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:19:10 -0400
Date: Fri, 12 Oct 2007 19:19:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Discardable strings for init and exit sections
Message-ID: <20071012171938.GB6476@stusta.de>
References: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 05:50:01PM +0100, Maciej W. Rozycki wrote:

>  We currently have infrastructure for discardable text and data, but no 
> such thing for strings.  This is especially notable for inline strings 
> such as ones used by printk() which are left behind resident in the memory 
> throughout the life of the system even though code referring to them has 
> been removed.
> 
>  Following a short discussion at the linux-mips list, here is a proposed 
> implementation for discardable strings.  It adds __initstr and __exitstr 
> plus most of the usual variations, but most importantly it adds wrapper 
> macros that may be used for inline strings that make them be put in
> separate sections which may then be discarded, while still preserving the 
> usual merging property of sections containing strings.  The macros are 
> called _i() and _e(), with the other alternatives adding at most two 
> letters each.  This has been inspired by how the GNU gettext handles 
> localised strings in a way that does not add too much clutter and the 
> result is still reasonably well readable.  Some use examples have been 
> included in <linux/init.h>.
>...

I have an objection against this approach:

Our __*init*/__*exit* annotations are already a constant source of bugs, 
and adding more pifalls (e.g. forgotten removal of _i()/_e() when a 
function is no longer __*init*/__*exit*) doesn't sound like a good plan.

Shouldn't it be possible to automatically determine where to put the 
strings? I don't know enough gcc/ld voodoo for being able to tell 
whether it is currently possible, and if yes how, but doing it 
automatically sounds like the only solution that wouldn't result in an
unmaintainable mess.

Ideally, even the current annotations might one day no longer be 
required and replaced with some way to express things like "everything 
only required by module_init() can be __init".

cu
Adrian

BTW: Please add diffstat output when sending patches.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

