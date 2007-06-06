Return-Path: <linux-kernel-owner+w=401wt.eu-S936189AbXFFX52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936189AbXFFX52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935353AbXFFX5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:57:19 -0400
Received: from gw.goop.org ([64.81.55.164]:52551 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331AbXFFX5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:57:19 -0400
Message-ID: <466749C8.2010700@goop.org>
Date: Wed, 06 Jun 2007 16:56:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com>
In-Reply-To: <4667462A.2010404@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I still believe that we should provide, in effect, vmlinux as a
> (compressed) ELF file rather than provide the intermediate stage.  It
> would reduce the complexity of testing (all information provided about a
> stage have to be both guaranteed to even make sense in the future as
> well as be tested to conform to such information

I'm not sure I follow you.  Sure, you're right that the Phdr info
contained within the bzImage needs to be tested for correctness.  This
wouldn't normally happen when booting native, but when booting under the
most constrained environment - Xen - it will be tested (and I intend
making the Xen loader as strict as possible).  Of course, it won't help
if the Phdrs are overmap too much, but I don't think that matters too
much, so long as the mappings are not excessively large.

I'm not sure what you mean about "make sense in the future".  If you're
booting the kernel in a new paravirtualized environment, you've
presumably modified the kernel to understand that environment, and
perhaps had to update the boot image format a bit to deal with its
requirements.  I agree that updating the bzImage format may require
retesting in all the other environments, but I think that's probably
true for your scheme as well.

After all, you're assuming that the vmlinux itself provides all
necessary information to be loaded in any environment, which is not
necessarily true (it may need extra ELF notes, for example).  But if
there are any major structural changes needed in the vmlinux, then that
will be equally problematic for both directly using vmlinux and using
ELF-in-bzImage.  So I don't think your argument convincingly sways in
any particular direction.

> ) as well as cover a
> larger number of environments -- any environment where injecting data
> into memory is cheaper than execution is quite unhappy about the current
> system.  Such environments include heterogeneous embedded systems (think
> a slow CPU on a PCI card where the host CPU has direct access to the
> memory on the card) as well as simulators/emulators.
>   

Well, nothing in this scheme precludes the ELF file from being a plain
uncompressed kernel image.  If that's what these environments want, its
easy to provide with a small update to the Makefiles.

> For environments where so is appropriate it would even be possible to
> run the setup, invoke the code32_setup hook to do the decompression (and
> relocation, if appropriate) in host space.
>   

Well, that's what we currently have, and we can't break backwards
compatibility.

> This makes vmlinux (normally stripped) recoverable from the bzImage file
> and so anything that is currently booting vmlinux would be serviced by
> this scheme.
>   

I'm not sure I fully understand the mechanism you're proposing.  You
have the 16-bit setup code, the 32-bit decompressor, and an ELF.gz. Once
the decompressor has extracted the actual ELF file, are you proposing
that it properly parse the ELF file and follow its instuctions to put
the segments in the appropriate places, or are you assuming that the
decompressor can just skip that part and plonk the ELF file where it wants?

In other words, do you see the Phdrs as being descriptive or prescriptive?

    J
