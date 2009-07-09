Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZGILOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZGILOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 07:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZGILOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 07:14:31 -0400
Received: from ozlabs.org ([203.10.76.45]:50494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbZGILOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 07:14:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] reduce export symbol CRC table size on 64-bit archs
Date: Thu, 9 Jul 2009 20:44:21 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: "Michal Marek" <mmarek@suse.cz>, "Ingo Molnar" <mingo@elte.hu>,
       tony.luck@intel.com, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-modules@vger.kernel.org, hpa@zytor.com,
       Jon Masters <jonathan@jonmasters.org>
References: <4A4A18780200007800008345@vpn.id2.novell.com> <4A4E671C.2090201@suse.cz> <4A51C71B0200007800008EE2@vpn.id2.novell.com>
In-Reply-To: <4A51C71B0200007800008EE2@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907092044.22108.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 05:12:51 pm Jan Beulich wrote:
> >Jan Beulich napsal(a):
> >> Since these CRCs are really only 32-bit quantities, there's no need to
> >> store them in 64-bit slots. Since, however, gcc doesn't allow
> >> respective initializations, asm() constructs get used to create the CRC
> >> tables (and its for that reason that the patch only makes x86-64 and
> >> ia64 utilize that functionality, as I can't verify this doesn't break
> >> in some subtle way elsewhere).
> >
> >...
> >
> >>  struct modversion_info
> >>  {
> >> -	unsigned long crc;
> >> +	ksym_crc_t crc;
> >>  	char name[MODULE_NAME_LEN];
> >>  };
> >
> >This change breaks module-init-tools:
> >Before:
> >$ /sbin/modprobe --dump-modversions _build/drivers/usb/core/usbcore.ko
> >
> >| head
> >
> >0xb49b735a      module_layout
> >0xdb7e6a70      bus_register
> >...
> >After:
> >$ /sbin/modprobe --dump-modversions
> >_build-crc-int/drivers/usb/core/usbcore.ko  | head
> >0x75646f6d91ea7b5c      le_layout
> >0x5f7375623e215f43      register
> >...
> >It also breaks the newly added depmod -E option (check symbol versions),
> >which also reads the struct modversion_info array (*). Is it possible
> >name the section differently (__versions2?) on those architectures where
> >the size changes, so that it is possible to fix m-i-t in a
> >backwards-compatible manner?
>
> First of all I'd view it as a design bug if user mode code assumptions
> prevent changes to the kernel.

Yes, but unfortunately it happens.  We do it much less than we used to, but 
there are limits.

> But taking this as an uncorrectable fact, I'd think that renaming the
> section would certainly be an option (though I'm unsure whether that would
> have other consequences - Rusty?), however I could also imagine other means
> to communicate to user land the width of a CRC value (e.g. adding an
> absolute symbol during the .ko linking stage).

No, just break it once.  And I still like the idea that we should do something 
more radical if we're going to break this anyway, rather than these nasty asm 
hacks.

Thanks,
Rusty.

