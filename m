Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYE2DtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYE2DtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYE2DtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:49:05 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1276 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYE2DtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:49:04 -0400
Subject: Re: optimizing out inline functions
From: Joe Perches <joe@perches.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: James Kosin <jkosin@beta.intcomgrp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <87lk1trdr8.fsf@saeurebad.de>
References: <ayzYV-7mv-5@gated-at.bofh.it> <ayA8E-89e-29@gated-at.bofh.it>
	 <483DC28B.4060001@support.intcomgrp.com>  <87lk1trdr8.fsf@saeurebad.de>
Content-Type: text/plain
Date: Wed, 28 May 2008 20:04:22 -0700
Message-Id: <1212030262.27103.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 05:27 +0200, Johannes Weiner wrote:
> James Kosin <jkosin@beta.intcomgrp.com> writes:
> >> But we do not have KCONFIG_DEBUG_SOMETHING available
> >> so the second best is to use an empty function
> >> to keep the typechecking in place.
> >> IIRC gcc optimize both away.
> > Another way would be to have:
> > static inline void some_debug_function(var1)
> > {
> >    #ifdef KCONFIG_DEBUG_SOMETHING
> >       something = var1;
> >       printk(some debug text);
> >    #endif
> > }

A potential issue is a possible unnecessary call of any
function used as an argument to some_debug_function.

int unnecessary_debug_test(void)
{
	int foo;
	[]
	return foo;
}

static inline void some_debug_function(int bar)
{
}

some_debug_function(unnecessary_debug_test())

unnecessary_debug_test will still get called

Macro wrappers/statement expressions can be used to avoid
the function call.  see kernel.h/pr_debug for an example.

#ifdef DEBUG
/* If you are writing a driver, please use dev_dbg instead */
#define pr_debug(fmt, arg...) \
	printk(KERN_DEBUG fmt, ##arg)
#else
#define pr_debug(fmt, arg...) \
	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
#endif


