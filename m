Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYGIUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYGIUQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYGIUQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:16:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbYGIUQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:16:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies (was: Re: [PATCH 00 of 55] xen64: implement 64-bit Xen support)
Date: Wed, 9 Jul 2008 22:17:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
References: <patchbomb.1215554782@localhost> <200807092202.27013.rjw@sisk.pl> <20080709200428.GB14009@elte.hu>
In-Reply-To: <20080709200428.GB14009@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092217.53222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > This combination actually doesn't make sense whatsoever.
> > > 
> > > PM_SLEEP depends (indirectly) on PM and the fact that it's possible 
> > > to use a .config violating this dependency is a build system 
> > > problem, really.
> > 
> > Your patch is correct, though. :-)
> 
> yes, that combination doesnt make sense in -git, but tip/xen64 tries the 
> !PM && PM_SLEEP combination - see the patch below.

It shouldn't.  There are many things compiled if PM is set that PM_SLEEP
depends on, most importantly ->suspend() and ->resume() callbacks of almost
all drivers.  Ignoring this dependency is asking for trouble.

> What do you think about that patch?
> 
> I think Jeremy's patch makes sense, but no strong feelings. We can 
> certainly map out these side-effects. (the fixes you've been Cc:-ed to 
> should be roughly all that can happen i think.)
 
> ------------------->
> commit 6fbbec428c8e7bb617da2e8a589af2e97bcf3bc4
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Tue Jul 8 15:07:08 2008 -0700
> 
>     suspend, xen: enable PM_SLEEP for CONFIG_XEN
>     
>     Xen save/restore requires PM_SLEEP to be set without requiring
>     SUSPEND or HIBERNATION.
>     
>     Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>     Cc: Stephen Tweedie <sct@redhat.com>
>     Cc: Eduardo Habkost <ehabkost@redhat.com>
>     Cc: Mark McLoughlin <markmc@redhat.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index b45da40..1436c47 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -82,7 +82,7 @@ config PM_SLEEP_SMP
>  
>  config PM_SLEEP
>  	bool
> -	depends on SUSPEND || HIBERNATION
> +	depends on SUSPEND || HIBERNATION || XEN
>  	default y
>  
>  config SUSPEND

I don't like this.

I'll have a look at the remaining related patches and see what can be done.

Jeremy, what exactly do you need the !PM && PM_SLEEP combination for, BTW?

Rafael
