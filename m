Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZCDVqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZCDVqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCDVp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:45:56 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:60409 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZCDVpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:45:55 -0500
Date: Wed, 4 Mar 2009 18:45:42 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Tony Breeds <tony@bakeyournoodle.com>,
       Kumar Gala <galak@kernel.crashing.org>, torvalds@linux-foundation.org,
       rbrito@ime.usp.br
Subject: Re: [PATCH] powerpc: fix the defaults for the linkstation MTD
	device
Message-ID: <20090304214541.GA2917@ime.usp.br>
References: <20090302094303.GA29819@ime.usp.br> <20090303024837.GC24834@bilbo.ozlabs.org> <20090303083455.GA22397@ime.usp.br> <Pine.LNX.4.64.0903040828150.4864@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0903040828150.4864@axis700.grange>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 04 2009, Guennadi Liakhovetski wrote:
> On Tue, 3 Mar 2009, Rogério Brito wrote:
> > Please, note that it wasn't sufficient to only to define
> > CONFIG_MTD_PHYSMAP_COMPAT. 
> > 
> > The default values for CONFIG_MTD_PHYSMAP_{START,LEN,BANKWIDTH} weren't
> > correct (and, as a result, no MTD was detected on my kurobox and this
> > was a regression regarding 2.6.28).
> > 
> > This patch makes the compilation succeed and the MTD device work again.
> > Already tested and in production.
> 
> No, I don't think this is a proper fix.

Indeed. I agree completely. I just don't know if the changes to 2.6.29
would be a good thing at this point in time. I guess that a proper fix
can be made by the next merge window.

> Remember, the kernel has to at least compile not only with defconfigs,
> but with all valid configurations.

That is, of course, the right thing to do.  Unfortunately, the programs
are not exactly in that good shape. :-(

We all know that the kernel is a critical part of the operating system,
but it probably fails with "valid configurations" (how do we tell one?)
if we issue a randconfig or something like that.

Proving correctness is something that we should do, but it gets quite
hard with very big projects like the kernel (no, this isn't an excuse
for not doing it), and, as a consequence, We have to draw the line
somewhere and do quite a good amount of regression testing.

That's the easiest path to achieve something slightly closer to being
correct (emphasis on the "easiest" part) and I humbly think that it is a
good thing that lusers (me! me! me!) are testing less widely used kernel
settings.

> So, at the very least you would also have to
> 
>  static void __init linkstation_setup_arch(void)
>  {
>  	struct device_node *np;
> -#ifdef CONFIG_MTD_PHYSMAP
> +#ifdef CONFIG_MTD_PHYSMAP_COMPAT
>  	physmap_set_partitions(linkstation_physmap_partitions,
>  			       ARRAY_SIZE(linkstation_physmap_partitions));
>  #endif
> 
> in linkstation.c. In fact, this is a fix, not changing defconfig, which 
> actually strictly speaking is not necessary. If only it fixes a 
> regression, that defconfig used to provide mtd devices, now it no longer 
> does.

Right.

> But even this I don't think is a proper fix.

Agreed.

> A proper fix would be to remove flash definitions from linkstation.c
> completely.  Maybe we should add them to kuroboxH?.dts, similar to
> mgcoge.dts and define CONFIG_MTD_PHYSMAP_OF, or we can define
> CONFIG_MTD_CMDLINE_PARTS and rely on the user providing a map on the
> command line. I don't know what is the currently preferred way, Kumar?
> Notice, while fixing linkstation, one should also fix storcenter.

I know nothing about the storcenter, owning just a Kurobox HD.

But, yes, I'm not exactly sure where to hardcode the settings. If on the
C code (is linkstation.c used by any other hardware?), if in the config
file or in the device tree file. It sounds to me like the most
reasonable choice would be to:

* have it in the device tree file, if the data is fixed for each type of
  machine.

* have it in the .config file, if those data change among the same
  type of hardware, so that the user doesn't have to mess with the
  device tree sources (which can break parsing them etc).


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
