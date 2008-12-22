Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYLVMEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYLVMEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYLVMEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:04:13 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48698 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbYLVMEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:04:12 -0500
Subject: Re: [PATCH 11/14] kmemleak: Remove some of the kmemleak false
	positives
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <84144f020812191215i432fd70fq3248d9feb981d4cf@mail.gmail.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081219181357.7778.9552.stgit@pc1117.cambridge.arm.com>
	 <84144f020812191215i432fd70fq3248d9feb981d4cf@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 12:04:07 +0000
Message-Id: <1229947447.3182.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2008 12:04:08.0208 (UTC) FILETIME=[64AC2900:01C9642D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 22:15 +0200, Pekka Enberg wrote:
> On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > There are allocations for which the main pointer cannot be found but
> > they are not memory leaks. This patch fixes some of them. For more
> > information on false positives, see Documentation/kmemleak.txt.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> > @@ -2882,6 +2883,12 @@ static int __init con_init(void)
> >         */
> >        for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
> >                vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
> > +               /*
> > +                * Kmemleak does not track the memory allocated via
> > +                * alloc_bootmem() but this block contains pointers to
> > +                * other blocks allocated via kmalloc.
> > +                */
> > +               kmemleak_alloc(vc, sizeof(struct vc_data), 1, GFP_ATOMIC);
> >                INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
> >                visual_init(vc, currcons, 1);
> >                vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
> 
> I think there was some discussion about adding hooks to the bootmem
> allocator. Didn't that work out?

I had a look but the combination of alloc_bootmem, reserve_bootmem and
free_bootmem doesn't seem feasible for kmemleak since calling these
functions doesn't always come in alloc/free pairs (unless I
misunderstand it).

-- 
Catalin

