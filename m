Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZFPPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZFPPxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZFPPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:53:45 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:48718 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZFPPxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ws5uei/L6XeRcsb5KixSjQy5jsIx3bJhxavX+CacF+b3dq2gkMcsJ4v3LEp64SyaQ4
         7l8KZ3xx5+YLqGH/1loUwGCd3zA0wbBnJ+ukBCTiVWsxwM5mWrvES9Y8DWw339jktDfQ
         pNuE8oiUbhEXr2OyJUfZWk1J0Y5mAkia9d+cA=
MIME-Version: 1.0
In-Reply-To: <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>
	 <20090615022235.GA12905@kroah.com>
	 <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>
Date: Tue, 16 Jun 2009 11:53:46 -0400
Message-ID: <48f7fe350906160853m41f43fe5i892a4057b5eae319@mail.gmail.com>
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
From: Ryan Hope <rmh3093@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <greg@kroah.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, you mentioned that you were going to pull in the TTM Kconfig fix
that I submitted (the one that allows TTM to be built into the kernel
instead of just a module). What are you going to do about the hardlock
that occurs when drm/radeon/fbcon are all built into the kernel. It
seems like fbcon does not get initialized before radeon and as a
result, there is a hardlock. My fix was to init radeon later which
works fine for me. Maybe it would be better to init fbcon earlier if
possible? Either way, I am not sure if you missed that patch so I am
going to resubmit it here as a reminder that this bug exists if you
build everything into the kernel..

diff --git a/85adafcf5d18e58c60d9fdbb718abe9149661736:drivers/gpu/drm/radeon/radeon_drv.c
b/093f1cb1a1850951f86244ada018672885ec4ace:drivers/gpu/drm/radeon/radeon_drv.c
index f70c351bb43e5770b9d18f76ad2a6fc1a2c7d1d4..ff4e052f997deaaa87081069d17d2026d925eabb
100644
--- a/85adafcf5d18e58c60d9fdbb718abe9149661736:drivers/gpu/drm/radeon/radeon_drv.c
+++ b/093f1cb1a1850951f86244ada018672885ec4ace:drivers/gpu/drm/radeon/radeon_drv.c
@@ -345,7 +345,11 @@ static void __exit radeon_exit(void)
 	drm_exit(driver);
 }

+#ifdef MODULE
 module_init(radeon_init);
+#else
+late_initcall(radeon_init);
+#endif
 module_exit(radeon_exit);

 MODULE_AUTHOR(DRIVER_AUTHOR);


On Sun, Jun 14, 2009 at 10:43 PM, Dave Airlie<airlied@gmail.com> wrote:
> On Mon, Jun 15, 2009 at 12:22 PM, Greg KH<greg@kroah.com> wrote:
>> On Mon, Jun 15, 2009 at 03:08:56AM +0100, Dave Airlie wrote:
>>>
>>> Hi Linus,
>>>
>>> Please pull the 'drm-linus' branch from
>>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>>>
>>> This is big. It contains the initial TTM memory manager + ATI radeon KMS
>>> support. Currently the KMS code is part of the DRM radeon driver however
>>> it is very clearly separated internally from the old codepaths. We've
>>> elected to keep the radeon KMS Kconfig build/enable under staging for now
>>> since we may have some ABI tweaks to sort out in this release cycle,
>>> however the code is all in the drm. I don't think this enables crap
>>> tainting, but at least no-one will find kms by accident.
>>
>> No, the module loader looks for stuff in drivers/staging/ to cause a
>> "taint".
>>
>> But why not just keep the Kconfig stuff in your own directory, and
>> depend on CONFIG_STAGING if you want to not have it show up for "normal"
>> users?  It seems odd to put anything in drivers/staging/Kconfig for
>> something that is not in drivers/staging.
>>
>> I'm guessing this Kconfig change was not in linux-next?  Or had it been
>> there and I just missed it somehow?
>>
>
> No since I was on holidays until the just before the merge window
> opened, the patches
> did get posted to lkml but missed your cc.
>
> Well we'd like to make sure people go via the staging menus to get at
> the kconfig option
> for now, granted it probably doesn't matter whether it goes in staging
> menus or in drm depends
> on CONFIG_STAGING. Up to you I can post a patch after this merge to
> move it to drm.
>
> Since its only temporary I'm not hugely pushed about taint.
>
> Dave.
>
> ------------------------------------------------------------------------------
> Crystal Reports - New Free Runtime and 30 Day Trial
> Check out the new simplified licensing option that enables unlimited
> royalty-free distribution of the report engine for externally facing
> server and web deployment.
> http://p.sf.net/sfu/businessobjects
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
