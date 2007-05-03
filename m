Return-Path: <linux-kernel-owner+w=401wt.eu-S1767381AbXECEul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767381AbXECEul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767386AbXECEul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:50:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58593 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767381AbXECEuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:50:40 -0400
Date: Thu, 3 May 2007 10:20:31 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Gerd Hoffmann <kraxel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Message-ID: <20070503045031.GA5794@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <4634483E.9030307@goop.org> <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org> <463909AF.9040205@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463909AF.9040205@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 02:59:11PM -0700, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> > 
> > So the bzImage structure is currently:
> > 
> >    1. old-style boot sector
> >    2. old-style boot info, followed by 0xaa55 at the end of the sector
> >    3. the HdrS boot param block
> >    4. setup.S boot code
> >    5. the self-decompressing kernel
> > 
> > If we make 5 actually an ELF file, containing properly formed Ehdr,
> > Phdrs (for all the mappings required), and the actual kernel
> > decompressor, relocator and compressed kernel data, then it would be
> > easy for the Xen domain builder to find that and use it as a basis for
> > loading.  I think it would just require the bzImage boot param block to
> > contain an offset of the start of the ELF file.  The contents of the ELF
> > file would be in a form where the normal boot code could just jump over
> > the ELF headers, directly into the segment data itself.
> > 
> > ie:
> > 
> >    1. old-style boot sector
> >    2. old-style boot info, followed by 0xaa55 at the end of the sector
> >    3. the HdrS boot param block
> >    4. setup.S boot code (jumps directly into 5.3)
> >    5. 32-bit self-decompressing kernel:
> >          1. Ehdr
> >          2. Phdrs for all necessary mappings
> >          3. decompressor/relocator .text
> >          4. compressed kernel data
> > 
> > Does that sound reasonable?
> > 
> 
> I don't know if that would break any programs that are currently
> bypassing the setup.

I think kexec bzImage loader will break. It bypasses the setup code and
directly jumps to the code present after setup sectors(decompressor).

> The existing setup protocol definitely allows
> invoking an entry point which isn't 0x100000 (rather, the 32-bit
> entrypoint is defined by code32_start); I'm not sure how Eric's
> relocatable kernel patches (2.05 protocol) affect that, mostly because I
> haven't seen any boot loaders which actually use it so I can't comment
> on what their code looks like.

With relocatable patches, if a boot loader decides to load protected mode
component at non-1MB address, then it shall have to modify code32_start to
reflect the new location of protected mode code.

Thanks
Vivek
