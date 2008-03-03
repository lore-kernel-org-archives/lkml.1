Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYCCXsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYCCXsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYCCXsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:48:35 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:54626 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYCCXse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Fg9AUeFjWKDM0znnwdoA2ugwe/r8P2Ke8Y3z63OrJ4MoPIcRWy0GvUwElEXJ4woImp4S4odODqoG08wgk7xDiaaVXEs10vGa455tYlN1sRBuxwFxSAPK2XpIs94c65OXZQYlPaL5CaLV5NlDAznNteRag9/N5YvHq9LonrRolfo=
Date: Tue, 4 Mar 2008 02:26:58 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH RFC] introduce pm_call() macro to get rid of most
	#ifdef CONFIG_PM
Message-ID: <20080303232658.GB27395@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080302234308.GA10116@zarina> <20080302160820.1930a770@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080302160820.1930a770@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 04:08:20PM -0800, Arjan van de Ven wrote:
> On Mon, 3 Mar 2008 02:43:08 +0300
> Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> 
> > Currently drivers handle CONFIG_PM this way:
> > 
> > #ifdef CONFIG_PM
> > drv_suspend() {}
> > drv_resume() {}
> > #else
> > #define drv_suspend NULL
> > #define drv_resume NULL
> > #endif
> > 
> > struct driver drv = {
> > 	.suspend = drv_suspend,
> > 	.resume = drv_resume,
> > };
> > 
> > With this patch, the code above converts into:
> > 
> > drv_suspend() {}
> > drv_resume() {}
> > 
> > struct driver drv = {
> > 	.suspend = pm_call(drv_suspend),
> > 	.resume = pm_call(drv_resume),
> > };
> > 
> > GCC will optimize away suspend/resume calls if they're really
> > not used.
> > 
> 
> 
> to be honest, at this point I would think it's time to remove
> CONFIG_PM, or rather,
> just make it always be there and just get rid of the ifdefs.

Don't be so CONFIG_PM-centric :-)

$ zcat /proc/config.gz | grep CONFIG_PM
# CONFIG_PM is not set

This is machine I use at home.

> We're saving 2 words and a bit of code,
> but only a case that not even the embedded guys use. 

Well, on my ARM machine, with CONFIG_PM=y vmlinux grows by 30KB, half
of that is in drivers/. 30KB is 1% of the vmlinux. Is it enough to
worth saving? I don't know.

On a x86 box, CONFIG_PM=y grows the vmlinux by 400KB (yeah, it's
including ACPI and stuff), though here I didn't count drivers'
suspend/resume hooks contribution share.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
