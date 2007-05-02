Return-Path: <linux-kernel-owner+w=401wt.eu-S2993166AbXEBV70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993166AbXEBV70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993168AbXEBV70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:59:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993166AbXEBV7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:59:25 -0400
Message-ID: <463909AF.9040205@zytor.com>
Date: Wed, 02 May 2007 14:59:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Gerd Hoffmann <kraxel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de>	<46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>	<4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org>
In-Reply-To: <46390523.5010809@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> So the bzImage structure is currently:
> 
>    1. old-style boot sector
>    2. old-style boot info, followed by 0xaa55 at the end of the sector
>    3. the HdrS boot param block
>    4. setup.S boot code
>    5. the self-decompressing kernel
> 
> If we make 5 actually an ELF file, containing properly formed Ehdr,
> Phdrs (for all the mappings required), and the actual kernel
> decompressor, relocator and compressed kernel data, then it would be
> easy for the Xen domain builder to find that and use it as a basis for
> loading.  I think it would just require the bzImage boot param block to
> contain an offset of the start of the ELF file.  The contents of the ELF
> file would be in a form where the normal boot code could just jump over
> the ELF headers, directly into the segment data itself.
> 
> ie:
> 
>    1. old-style boot sector
>    2. old-style boot info, followed by 0xaa55 at the end of the sector
>    3. the HdrS boot param block
>    4. setup.S boot code (jumps directly into 5.3)
>    5. 32-bit self-decompressing kernel:
>          1. Ehdr
>          2. Phdrs for all necessary mappings
>          3. decompressor/relocator .text
>          4. compressed kernel data
> 
> Does that sound reasonable?
> 

I don't know if that would break any programs that are currently
bypassing the setup.  The existing setup protocol definitely allows
invoking an entry point which isn't 0x100000 (rather, the 32-bit
entrypoint is defined by code32_start); I'm not sure how Eric's
relocatable kernel patches (2.05 protocol) affect that, mostly because I
haven't seen any boot loaders which actually use it so I can't comment
on what their code looks like.

	-hpa
