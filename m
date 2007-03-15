Return-Path: <linux-kernel-owner+w=401wt.eu-S1751324AbXCOS1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbXCOS1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXCOS1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:27:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29214 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbXCOS1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:27:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lHJw4BBotrikpDifDQQqP/TOdpisNxuuoPKLuwT/hlVyrti/mCh5YUzhfbY4DYDVuWCfFTVTlu1GObOy+nczPlr54tQwMlmtF7LkGxoPH5BhiG4V/BD6FxdGzJEd7Q7lq3DnrQeSOzaKMjj1lqjaF7u8xCq8OeYgOUwVT+bgv08=
Date: Thu, 15 Mar 2007 21:26:53 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, mingo@elte.hu,
       tglx@linutronix.de, viro@zeniv.linux.org.uk, rusty@rustcorp.com.au
Subject: Re: [PATCH] Fix some kallsyms_lookup() vs rmmod races
Message-ID: <20070315182653.GA5333@martell.zuzino.mipt.ru>
References: <20070315161442.GA6812@localhost.sw.ru> <45F97A27.4030002@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F97A27.4030002@grupopie.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 04:53:59PM +0000, Paulo Marques wrote:
> Alexey Dobriyan wrote:
> >[cc'ing folks whose proc files are affected]
> >
> >kallsyms_lookup() can call module_address_lookup() which iterates over
> >modules list without module_mutex taken. Comment at the top of
> >module_address_lookup() says it's for oops resolution so races are
> >irrelevant, but in some cases it's reachable from regular code:
>
> So maybe we should just add a new parameter to "kallsyms_lookup" to
> inform it if it is safe to take a mutex or not.

You have to drag "mod->name" out of kallsyms_lookup(), so if you drop
module_mutex in it, you still have a bug.

We can agree on kallsyms_lookup() or whatever other low-level function
to copy everything into caller-supplied structure and not spreading
module_mutex. module's name is 64 minus a little, so stack usage should
be fine.

> Spreading module_mutex everywhere doesn't seem like the right interface
> for several reasons:
>
>  - new users of "kallsyms_lookup" might not be aware that they should
> take module_mutex if it is safe

Well, yes.

>  - many times we will be taking module_mutex even when we are fetching
> a kernel symbol that shouldn't require the mutex at all
>
>  - it just creates new dependencies (hint: this patch shouldn't even
> compile with current git since module_mutex is not declared in module.h,

Yeah, I remembered about it only in subway :).

This patch is techically dependent on http://lkml.org/lkml/2007/3/14/128 aka
[PATCH v2] Race between cat /proc/kallsyms and rmmod

> not to mention compile when CONFIG_MODULES not set)

OK, I'll fix it.

> IMHO we should not expose module_mutex outside of module.c. That is just
> wrong from an encapsulation point of view.

