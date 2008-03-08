Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYCHTFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYCHTFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYCHTFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:05:38 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:43430 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbYCHTFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:05:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gctgkqUiLHs44EhveFEd6TLu+Asl/v50Jx0LutSCcdo5x3RhzexZKO+ur3vmM6HWyzUbPUIrPX0vi0xnE/P0ahwl1daDAVox92FHXjazr0JMmcO1n/N+AopUnFjeXzi3HyxA/2f7fX8FjKHJRdY2bUraFqGV2GhkZMCsHSC2ZrQ=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Laurent Riffard <laurent.riffard@free.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: linux-next: Tree for March 7: slab corruptions
Date: Sun, 9 Mar 2008 00:29:48 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080307141856.b27d1725.sfr@canb.auug.org.au> <47D26E42.9020704@free.fr>
In-Reply-To: <47D26E42.9020704@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803090029.49180.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 March 2008 04:15:22 pm Laurent Riffard wrote:
> Le 07.03.2008 04:18, Stephen Rothwell a écrit :
> > Hi all,
> >
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
>
> I've got a lot of "Slab corruption" with next-20060307 (actually a
> continuous flow of warnings) whereas next-20060306 is fine.
>
> [    3.045882] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> [    3.045885] Last user: [<c022460e>](vc_allocate+0x5a/0x136)
> [    3.045890] 000: 03 00 00 00 a0 00 00 00 40 00 00 00 40 01 00 00
> [    3.045902] 010: 00 00 00 00 00 00 85 de 00 50 85 de 00 00 85 de
> [    3.055247] Slab corruption: size-512 start=defb5060, len=512
> [    3.056465] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> [    3.057363] Last user: [<c022789b>](device_release+0x36/0x58)
> [    3.058594] 0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
> [    3.060109] Single bit error detected. Probably bad RAM.
> [    3.061353] Run memtest86+ or a similar memory test tool.
> [    3.062501] Next obj: start=defb5278, len=512
> [    3.063596] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> [    3.064751] Last user: [<c022460e>](vc_allocate+0x5a/0x136)
> [    3.065447] 000: 04 00 00 00 a0 00 00 00 40 00 00 00 40 01 00 00
> [    3.066965] 010: 00 00 00 00 00 80 85 de 00 d0 85 de 00 80 85 de
> [    3.074109] Slab corruption: size-512 start=defb56a8, len=512
> [    3.075336] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> [    3.076510] Last user: [<c022789b>](device_release+0x36/0x58)
> [    3.077360] 0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
> [    3.078885] Single bit error detected. Probably bad RAM.
> [    3.080015] Run memtest86+ or a similar memory test tool.
>
> I did a bisection:
>
> 5a428808720b31026890d3ff71fbd891d9a94fd6 is first bad commit
> commit 5a428808720b31026890d3ff71fbd891d9a94fd6
> Author: Balaji Rao <balajirrao@gmail.com>
> Date:   Thu Mar 6 22:23:18 2008 +0530
>
>     kobjects: mark cleaned up kobjects as unitialized
>
>     When I remove only the kvm-intel module without removing the kvm module
>     itself, I get an error saying that a kobject is trying to be
>     reinitialized. Its because of the fact that kvm reuses a kobject in
>     kvm_init when calling sysdev_register.
>
>     This patch fixes kobject_cleanup by marking the kobject as
> uninitialized when we cleanup to allow kobjects to be reused.
>
>     Signed-off-by: Balaji Rao <balajirrao@gmail.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> :040000 040000 c15d08d966391dec783d137558fad66d9c2da57b
> : eddea2ec69c014370cf98cc2fc7e24a8dc301e70 M     lib
>
> .config attached
> ~~
> laurent
Hi greg,

Apparently, its the wrong place to mark the kobject as uninitialized as the 
kobject could be freed by then. I've now moved it to the top of 
kobject_cleanup(). This fixes the problem for me.

laurent, can you please revert the above commit , and apply this patch ? Does 
it help ?

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff --git a/lib/kobject.c b/lib/kobject.c
index d784dae..a1f87bd 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -548,6 +548,9 @@ static void kobject_cleanup(struct kobject *kobj)
        pr_debug("kobject: '%s' (%p): %s\n",
                 kobject_name(kobj), kobj, __FUNCTION__);
 
+       /* Set the state to uninitialized */
+       kobj->state_initialized = 0;
+
        if (t && !t->release)
                pr_debug("kobject: '%s' (%p): does not have a release() "
                         "function, it is broken and must be fixed.\n",


-- 
regards,
balaji rao
3rd year,
Dept. of Mechanical Engineering,
National Institute of Technology, Karnataka
