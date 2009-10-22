Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZJVBve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZJVBve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 21:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZJVBve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 21:51:34 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37499 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZJVBvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 21:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FVGS5IDGM5z9kvw7UL0++D2t9R4aOlrEewAwjcicw7emn0RnAcI7bm/VFBABwM5xOX
         JHbj4ADCxY5eDgjkGer1zRY4UuabHgMtSeYKx1P5nAxfpQdsCgQw8xxJkwrHdH5f8Ybs
         Tj6v6MP4Si2uCMI24ex8pbKP/MDv5lGX+ZTao=
Message-ID: <4ADFBA3E.40700@gmail.com>
Date: Wed, 21 Oct 2009 18:49:50 -0700
From: Corbin Simpson <mostawesomedude@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jerome Glisse <glisse@freedesktop.org>
CC: DRI Development Mailing List <dri-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Changing radeon KMS cs+gem ioctl to merge read & write domain
References: <1256165349.15474.17.camel@localhost>
In-Reply-To: <1256165349.15474.17.camel@localhost>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2009 03:49 PM, Jerome Glisse wrote:
> Hi,
> 
> I think we should merge the read & write domain of radeon KMS
> into a single domains information. I don't think there is a
> good reason for separate read & write domain, we did copy intel
> model for that and intel use this mostly for cache coherency &
> cache flushing as far as i understand. We make no good use of
> this inside the kernel. In order to make this change less disruptive
> and easier to introduce i propose we keep libdrm-radeon api
> intact thus userspace xf86video-ati & mesa 3d driver doesn't
> need a single line patch to adapt. Attached is a proof of concept,
> a patch against libdrm which merge read & write domain and only
> use the read domain to communicate with the kernel. I am still
> in process of stress testing this patch but so far neither X
> or 3D had any glitches.
> 
> I want to take advantage of this change to the cs reloc to the
> following:
> struct drm_radeon_cs_reloc {
> »·······uint32_t»·······»·······handle;
> »·······uint32_t»·······»·······domains;
> »·······uint32_t»·······»·······unused;
> »·······uint32_t»·······»·······flags;
> };
> 
> With the following rules: a domain is a 4bit value (more than
> enough i believe). Userspace can then provide domain preference
> for each relocation. For instance :
> 0 Invalid|CPU
> 1 VRAM
> 2 GTT
> 
> domains = (VRAM << 0) | (GTT << 4)
> would mean try to place object in VRAM first, if not enough
> VRAM place it in GTT.
> 
> domains = (GTT << 0)
> object can only be in GTT
> ...
> 
> I believe this would be a lot more useful information that
> read|write domain. We would also now assume that userspace
> knows what it's doing inside a single submited cs and that
> userspace issue necessary flush if a bo is used in different
> way. Which is what the ddx does.
> 
> I believe the only argument in favor of read & write split
> is broken AGP chipset where GPU can't write to GART. So far
> we don't use this information to work around the issue,
> we don't even always test AGP writeback. Thus i believe this
> change won't impact current user. Note that i am working on
> code to work around bad AGP chipset (fallback to PCI GART
> for GPU write + detection of broken writeback).
> 
> I really think we should take advantage of being in staging
> driver to get the ioctl right before we have to freeze them.

No objections from me. If you have further ioctl changes, raising them
sooner rather than later would be *greatly* appreciated since I'm
probably the only person touching them in Gallium.

~ C.
