Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYCDIBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYCDIBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYCDIBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:01:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbYCDIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:01:20 -0500
Date: Tue, 4 Mar 2008 00:00:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-Id: <20080304000031.49b558b8.akpm@linux-foundation.org>
In-Reply-To: <20080304073248.GA2947@elte.hu>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi>
	<20080303085720.GD15943@elte.hu>
	<20080303091314.GC4457@cs181133002.pp.htv.fi>
	<20080303091714.GA18250@elte.hu>
	<20080303093103.GA23651@uranus.ravnborg.org>
	<20080303103933.GC21190@elte.hu>
	<20080303113451.GF4457@cs181133002.pp.htv.fi>
	<20080303114533.GA4183@elte.hu>
	<20080303121335.GA15381@elte.hu>
	<20080303224231.86c22ed0.akpm@linux-foundation.org>
	<20080304073248.GA2947@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 08:32:48 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > urgh.  This will cause whatever problem 
> > 4507a6a59cfc6997e532cd812a8bd244181e6205 fixed five years ago to 
> > resurface for incautious gcc-3.x users.
> 
> hm, commit 4507a6a59cfc6997e532cd812a8bd244181e6205 does not exist:
> 
>   fatal: bad object 4507a6a59cfc6997e532cd812a8bd244181e6205

This was 2.5.x - you'll need to look in the historical-git tree.

Here it is:



: commit 4507a6a59cfc6997e532cd812a8bd244181e6205
: Author: akpm <akpm>
: Date:   Tue Mar 11 07:42:00 2003 +0000
: 
:     [PATCH] work around gcc-3.x inlining bugs
:     
:     Force inlining even when gcc-3.x is too confused to do it for us.
:     
:     BKrev: 3e6d9348GA9aKzeN-bjzQzMMt85t8g
: 
: diff --git a/include/linux/compiler.h b/include/linux/compiler.h
: index e92f472..a28d0d5 100644
: --- a/include/linux/compiler.h
: +++ b/include/linux/compiler.h
: @@ -1,6 +1,12 @@
:  #ifndef __LINUX_COMPILER_H
:  #define __LINUX_COMPILER_H
:  
: +#if (__GNUC__ > 3) || (__GNUC__ == 3 && __GNUC_MINOR__ >= 1)
: +#define inline		__inline__ __attribute__((always_inline))
: +#define __inline__	__inline__ __attribute__((always_inline))
: +#define __inline	__inline__ __attribute__((always_inline))
: +#endif
: +
:  /* Somewhere in the middle of the GCC 2.96 development cycle, we implemented
:     a mechanism by which the user can annotate likely branch directions and
:     expect the blocks to be reordered appropriately.  Define __builtin_expect
: 

I was very bad about changelogging that one.  I do remember there was a bit
of to-and-fro before we decided to do it this way.  Some googling would be
needed.  

> but i suspect it must be something along the lines of the known problem 
> of really old gcc versions creating huge stackframes?

iirc gcc was failing to inline functions which we'd marked `inline' and it
was generating poorer code as a result.  It might also have been generating
an out-of-line copy for each compilation unit which called the inline (it
would have to do this?)

> Those pristine gcc 
> versions were practically unusable for distro kernels anyway (and were 
> patched by distros) - but i have no problem with restricting this 
> feature to gcc4x. gcc4x creates more compact -Os code too, so it's 
> recommended for smaller image sizes.

yup.

