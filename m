Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbYDBB5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbYDBB5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 21:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYDBB5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 21:57:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:3024 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYDBB5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 21:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BRd5fRWWdNi86lyRO/l62y85UsLVfYq6l3Dq2XYQ6REdb/JJZuZjSNRFSLRDoVz3qhtpPEFvjQPbPCFe9JzUyHBLpOoPZyCmvBGaKhpl0owJpswFJwBrQdfjmerj+3mgKI2TiB/fKuwy28uQqmaxQEXSs1ucmPhDZ+OWHAsy/gg=
Message-ID: <45a44e480804011857v39e00f3ck53803cd43c34c7b0@mail.gmail.com>
Date: Tue, 1 Apr 2008 21:57:10 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: Clarifying platform_device_unregister
Cc: "Richard Purdie" <rpurdie@rpsys.net>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080401104533.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com>
	 <20080401051947.GD18041@anvil.corenet.prv>
	 <45a44e480804010047m36a9b8e3p97910308ed5677fb@mail.gmail.com>
	 <20080401104533.ZZRA012@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2008 at 10:54 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Apr 01, 2008 at 12:47:54AM -0700, Jaya Kumar wrote:
>  > On Mon, Mar 31, 2008 at 10:19 PM, Dmitry Torokhov
>  > <dmitry.torokhov@gmail.com> wrote:
>  > >  On Mon, Mar 31, 2008 at 09:14:35PM -0400, Jaya Kumar wrote:
>  > >  >         mytest_device->dev.platform_data = &mydata;
>  > >
>  > >  Platform device code does kfree(pdev->dev.platform_data) unpon
>  > >  unregistration, so it is not a good idea to assign address of
>  > >  statically-allocated variable here. You should be using:
>  > >
>  > >         platform_device_add_data(mytest_device, &mydata, sizeof(mydata));
>  > >
>  >
>  > That's interesting. I noticed though that a lot of platform device
>  > code assigns a statically allocated structure to platform_data. For
>  > example:
>  >
>  > arch/arm/mach-pxa/corgi_pm.c
>  > static struct sharpsl_charger_machinfo corgi_pm_machinfo = {
>  > ...
>  > }
>  >         corgipm_device->dev.platform_data = &corgi_pm_machinfo;
>  >
>  > same with spitz_pm.c.
>  >
>  > egrep "platform_data.*=.*\&" *.c shows quite a lot of users doing
>  > that. I guess most of these below are probably okay since these
>  > drivers can't be rmmoded.
>  >
>
>  Hmm, are you sure they can't be removed? Why do they all have
>  module_exit methods?

Sorry, I was unclear. I agree that corgi_pm and spitz_pm are suspect
because they are unloadable. The others that I listed such as lpd270,
lubbock, and mainstone are machine definitions (is that the right term
for me to use?) and can't be unloaded.

>
>  Even if they can't be unloaded the whole thing will blow to pieces
>  if registration fails. Consider this:
>
>  static int __devinit spitzpm_init(void)
>  {
>         int ret;
>
>         spitzpm_device = platform_device_alloc("sharpsl-pm", -1);
>         if (!spitzpm_device)
>                 return -ENOMEM;
>
>
>         spitzpm_device->dev.platform_data = &spitz_pm_machinfo;
>         ret = platform_device_add(spitzpm_device);
>
>         if (ret)
>                 platform_device_put(spitzpm_device);
>                 ^^^^^^^^^^^
>  This will try to kfree(spitzpm_device->dev.platform_data) and it gonna
>  blow. We need to do spitzpm_device->dev.platform_data = NULL before doing
>  put.
>
>  Also  spitzpm_init() shoudl be marked __init, not __devinit and
>  spitzpm_exit() should be __exit() if it is event needed at all.
>
>  Richard, I think you work with spitz and corgi, any comments?

I also have a followup. Does corgi/spitz_pm need to manage the module
refcount of sharpsl-pm? I couldn't find any platform device code that
manages the refcount of the platform driver that it binds them to. So
I suspect this means that platform devices must do the try_module_get
stuff themselves. Out of curiosity, what's the reason for not doing
this inside the base/platform.c code?

Thanks,
jaya
