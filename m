Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYAFPml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYAFPml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYAFPme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:42:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52127 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYAFPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:42:33 -0500
Date: Sun, 6 Jan 2008 07:42:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: Re: [patch 1/5] Introduce __WARN()
Message-ID: <20080106074202.3c25b115@laptopd505.fenrus.org>
In-Reply-To: <4780BF38.3010902@student.ltu.se>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
	<20080105190840.48a8c2c5@laptopd505.fenrus.org>
	<4780BF38.3010902@student.ltu.se>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jan 2008 12:44:56 +0100
Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> Arjan van de Ven wrote:
> > From: Olof Johansson <olof@lixom.net>
> >
> > Introduce __WARN() in the generic case, so the generic WARN_ON()
> > can use arch-specific code for when the condition is true.
> >
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > Cc: <linux-arch@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  include/asm-generic/bug.h |   17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > Index: linux-2.6.24-rc6/include/asm-generic/bug.h
> > ===================================================================
> > --- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
> > +++ linux-2.6.24-rc6/include/asm-generic/bug.h
> > @@ -31,14 +31,19 @@ struct bug_entry {
> >  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); }
> > while(0) #endif
> >  
> > -#ifndef HAVE_ARCH_WARN_ON
> > +#ifndef __WARN
> > +#define __WARN() do
> > {							\
> > +	printk("WARNING: at %s:%d %s()\n",
> > __FILE__,			\
> > +		__LINE__,
> > __FUNCTION__);				\
> > +
> > dump_stack();
> > \ +} while (0) +#endif
> > +
> > +#ifndef WARN_ON
> >  #define WARN_ON(condition)
> > ({						\ int
> > __ret_warn_on = !!(condition);				\ 

> What about using a boolean for __ret_warn_on, which then let us
> remove the '!!'?

is iffy.. like what happens if an u64 is cast to a boolean?
No matter what the final assembly code will need to be the same

> (btw, wouldn't 'var != 0' actually be the proper semantic instead of 
> playing with '!'s?)

no because var could be a pointer for example...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
