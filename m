Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYAYN6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYAYN6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYAYN6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:58:37 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:7703 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbYAYN6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:58:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K3Qv+aqdrJmOSSeOXYcDh3i4uUSd95VowUKoCC6s0IH5qxum+j2NhKzNNjHOg77sxQLfId1cI6mXBDTzbpdVOX1FEFKbaKBQt35lsYck1jvzx2fMwnqWzLrrCWyTEdMGLKgd0mUknV5E97alnMUr57DcYwNX/0tbr8+xes8cQdU=
Message-ID: <851fc09e0801250558g2d7f50akf1b7ad1f58bcf970@mail.gmail.com>
Date: Fri, 25 Jan 2008 21:58:34 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/6] x86: fixes some bugs about EFI memory map handling
Cc: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080125095016.GI23708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201240507.15972.48.camel@caritas-dev.intel.com>
	 <20080125093131.GG23708@elte.hu>
	 <1201254015.15972.66.camel@caritas-dev.intel.com>
	 <20080125095016.GI23708@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 5:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Huang, Ying <ying.huang@intel.com> wrote:
>
> > On Fri, 2008-01-25 at 10:31 +0100, Ingo Molnar wrote:
> > > * Huang, Ying <ying.huang@intel.com> wrote:
> > >
> > > > This patch fixes some bugs of EFI memory handing code.
> > > >
> > > > - On x86_64, it is possible that EFI memory map can not be mapped via
> > > >   identity map, so efi_map_memmap is removed, just use early_ioremap.
> > > >
> > > > - On i386, the EFI memory map mapping take effect cross paging_init,
> > > >   so it is not necessary to use efi_map_memmap.
> > > >
> > > > - EFI memory map is unmapped in efi_enter_virtual_mode to avoid
> > > >   early_ioremap leak.
> > >
> > > thanks, applied.
> > >
> > > btw., it would be nice to consolidate this some more. Why is there a
> > > separate efi_ioremap(), which is mapped to ioremap() on 32-bit, and
> > > which is mapped to a fixmap based special mapper on 64-bit?
> > >
> > > To me it appears this wants to be ioremap() on both 64-bit and
> > > 32-bit, and we could remove efi_ioremap() altogether. Hm?
> >
> > To support kexec, I want to map the EFI memory area on same virtual
> > address on different boot of different version of kernel. Then, the
> > EFI runtime service will always get the same execution environment.
> > This is because a weakness of EFI runtime service, it can not reset
> > its execution environment, except reboot.
>
> so this basically means that on 32-bit kexec wont work right - i.e. only
> 64-bit has been enhanced this way? What am i missing?

Strictly, I should say on 32-bit, EFI runtime service won't work in
kexeced kernel. That is, on EFI 32 platform, it is possible that:

- Boot kernel A with EFI runtime service
- kexec kernel B without EFI runtime service (such as with noefi in
kernel command line)

I suspect this method can be used on 32-bit platform. Because the
fixmap area on 32-bit is more limited than 64-bit. And because
identity map area on 32-bit is too limited, it is possible that all
EFI runtime code, data, IO areas need to be mapped via  fixmap.

Best Regards,
Huang Ying
