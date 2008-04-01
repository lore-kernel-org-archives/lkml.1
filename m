Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbYDAOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbYDAOzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYDAOzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:55:03 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:11514 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYDAOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Numhex6MXjQ4VKvfeNP0/OkjO3D773wqSR+t+rtxBRqiwtlylYBW4GgBvkRiPkfH8oGV3MSSLOcdYTo+WiQdAcX2FERc8yyqNiLkFZ2/ZloYNpmm5/Mg8obRKdm1VVmC9zJPCKK0dgrMglUbB9it3p+3e55qP7c2Gzttj0xQqcE=
Date: Tue, 1 Apr 2008 10:54:54 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jaya Kumar <jayakumar.lkml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Clarifying platform_device_unregister
Message-ID: <20080401104533.ZZRA012@mailhub.coreip.homeip.net>
References: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com> <20080401051947.GD18041@anvil.corenet.prv> <45a44e480804010047m36a9b8e3p97910308ed5677fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45a44e480804010047m36a9b8e3p97910308ed5677fb@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 12:47:54AM -0700, Jaya Kumar wrote:
> On Mon, Mar 31, 2008 at 10:19 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >  On Mon, Mar 31, 2008 at 09:14:35PM -0400, Jaya Kumar wrote:
> >  >         mytest_device->dev.platform_data = &mydata;
> >
> >  Platform device code does kfree(pdev->dev.platform_data) unpon
> >  unregistration, so it is not a good idea to assign address of
> >  statically-allocated variable here. You should be using:
> >
> >         platform_device_add_data(mytest_device, &mydata, sizeof(mydata));
> >
> 
> That's interesting. I noticed though that a lot of platform device
> code assigns a statically allocated structure to platform_data. For
> example:
> 
> arch/arm/mach-pxa/corgi_pm.c
> static struct sharpsl_charger_machinfo corgi_pm_machinfo = {
> ...
> }
>         corgipm_device->dev.platform_data = &corgi_pm_machinfo;
> 
> same with spitz_pm.c.
> 
> egrep "platform_data.*=.*\&" *.c shows quite a lot of users doing
> that. I guess most of these below are probably okay since these
> drivers can't be rmmoded.
> 

Hmm, are you sure they can't be removed? Why do they all have
module_exit methods?

Even if they can't be unloaded the whole thing will blow to pieces
if registration fails. Consider this:

static int __devinit spitzpm_init(void)
{
        int ret;

        spitzpm_device = platform_device_alloc("sharpsl-pm", -1);
        if (!spitzpm_device)
                return -ENOMEM;

        spitzpm_device->dev.platform_data = &spitz_pm_machinfo;
        ret = platform_device_add(spitzpm_device);

        if (ret)
                platform_device_put(spitzpm_device);
		^^^^^^^^^^^
This will try to kfree(spitzpm_device->dev.platform_data) and it gonna
blow. We need to do spitzpm_device->dev.platform_data = NULL before doing
put.

Also  spitzpm_init() shoudl be marked __init, not __devinit and
spitzpm_exit() should be __exit() if it is event needed at all.

Richard, I think you work with spitz and corgi, any comments?

-- 
Dmitry
