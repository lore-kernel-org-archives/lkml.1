Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZJVKzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZJVKzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZJVKzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:55:10 -0400
Received: from nox.protox.org ([88.191.38.29]:38314 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbZJVKzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:55:09 -0400
Subject: Re: Changing radeon KMS cs+gem ioctl to merge read & write domain
From: Jerome Glisse <glisse@freedesktop.org>
To: Corbin Simpson <mostawesomedude@gmail.com>
Cc: DRI Development Mailing List <dri-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4ADFBA3E.40700@gmail.com>
References: <1256165349.15474.17.camel@localhost> <4ADFBA3E.40700@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Oct 2009 12:52:35 +0200
Message-Id: <1256208755.2020.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 18:49 -0700, Corbin Simpson wrote:
> On 10/21/2009 03:49 PM, Jerome Glisse wrote:
> > Hi,
> > 
> > I think we should merge the read & write domain of radeon KMS
> > into a single domains information. I don't think there is a
> > good reason for separate read & write domain, we did copy intel
> > model for that and intel use this mostly for cache coherency &
> > cache flushing as far as i understand. We make no good use of
> > this inside the kernel. In order to make this change less disruptive
> > and easier to introduce i propose we keep libdrm-radeon api
> > intact thus userspace xf86video-ati & mesa 3d driver doesn't
> > need a single line patch to adapt. Attached is a proof of concept,
> > a patch against libdrm which merge read & write domain and only
> > use the read domain to communicate with the kernel. I am still
> > in process of stress testing this patch but so far neither X
> > or 3D had any glitches.
> > 
> > I want to take advantage of this change to the cs reloc to the
> > following:
> > struct drm_radeon_cs_reloc {
> > »·······uint32_t»·······»·······handle;
> > »·······uint32_t»·······»·······domains;
> > »·······uint32_t»·······»·······unused;
> > »·······uint32_t»·······»·······flags;
> > };
> > 
> > With the following rules: a domain is a 4bit value (more than
> > enough i believe). Userspace can then provide domain preference
> > for each relocation. For instance :
> > 0 Invalid|CPU
> > 1 VRAM
> > 2 GTT
> > 
> > domains = (VRAM << 0) | (GTT << 4)
> > would mean try to place object in VRAM first, if not enough
> > VRAM place it in GTT.
> > 
> > domains = (GTT << 0)
> > object can only be in GTT
> > ...
> > 
> > I believe this would be a lot more useful information that
> > read|write domain. We would also now assume that userspace
> > knows what it's doing inside a single submited cs and that
> > userspace issue necessary flush if a bo is used in different
> > way. Which is what the ddx does.
> > 
> > I believe the only argument in favor of read & write split
> > is broken AGP chipset where GPU can't write to GART. So far
> > we don't use this information to work around the issue,
> > we don't even always test AGP writeback. Thus i believe this
> > change won't impact current user. Note that i am working on
> > code to work around bad AGP chipset (fallback to PCI GART
> > for GPU write + detection of broken writeback).
> > 
> > I really think we should take advantage of being in staging
> > driver to get the ioctl right before we have to freeze them.
> 
> No objections from me. If you have further ioctl changes, raising them
> sooner rather than later would be *greatly* appreciated since I'm
> probably the only person touching them in Gallium.
> 
> ~ C.

This change should work without any update to gallium code. But
to take advantages of the placement list you would need to use
a new libdrm-radeon API for reloc.

Beside this merge i don't have in mind any other API change. Others
things i am working on are mostly kernel side only.

Cheers,
Jerome

