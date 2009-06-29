Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZF2PaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZF2PaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbZF2P3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:29:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:60326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZF2P3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:29:55 -0400
Date: Mon, 29 Jun 2009 08:30:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] RO/NX protection for loadable kernel modules
Message-ID: <20090629083051.232bac68@infradead.org>
In-Reply-To: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com>
References: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 11:16:40 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> This patch is a logical extension of the protection provided by
> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> module_core and module_init into three logical parts each and setting
> appropriate page access permissions for each individual section:
> 
>   1. Code: RO+X
>   2. RO data: RO+NX
>   3. RW data: RW+NX
> 
> In order to achieve proper protection, layout_sections() have been
> modified to align each of the three parts mentioned above onto page
> boundary. Next, the corresponding page access permissions are set
> right before successful exit from load_module(). Further,
> module_free() have been modified to set module_core or module_init as
> RW+NX right before calling vfree(). Functionality of this patch is
> enabled only when CONFIG_DEBUG_RODATA defined at compile time.
> 
> This is the second revision of the patch: it have been re-written to
> reduce the number of #ifdefs and to make it architecture-agnostic.
> Code formatting have been corrected also.
> 

you can still go one step further....
there is no downside to doing NX at all for modules, except for the 3
sections now each being page aligned thing. So in principle NX should
just not be part of any ifdef, only the alignment has any justification
for being so.
What you can do in the !CONFIG_OPTION case, is treating the "overlap"
pages as "most permissive goes"..... if you do that you should have 1
ifdef in total.

(and one can still argue that making this an option is not even worth
that, and just always do it unconditional)
