Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYEWRtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYEWRtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYEWRtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:49:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47083 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYEWRtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:49:42 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel image
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080523162101.GA31107@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <20080523162101.GA31107@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 18:49:37 +0100
Message-Id: <1211564977.28967.70.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 18:21 +0200, Sam Ravnborg wrote:
> Hi David.
> 
> > +extern struct builtin_fw __start_builtin_fw[];
> > +extern struct builtin_fw __end_builtin_fw[];
> 
> Could have these in include/linux/sections.h where we
> collect other linker symbols?

Hm. But they're not 'extern char' like the other things in
asm-generic/sections.h; they're 'struct builtin_fw'. So I'd want to
include <linux/firmware.h> from asm-generic/sections.h in order to make
that work... I think the simple answer is 'no'.

We don't do this for PCI fixups either.

> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index f054778..8d71a40 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -86,6 +86,13 @@
> >  		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
> >  	}								\
> >  									\
> > +	/* Built-in firmware blobs */					\
> > +	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
> > +		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
> > +		*(.builtin_fw)						\
> > +		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
> > +	}								\
> > +									\
> Looks good.
> But do we need the firmware after init?
> In other owrds could it be inside a discard after init block?

If we don't want the firmware in-kernel at all times, stick it an
initrd :)

> 
> > +
> > +#define DECLARE_BUILTIN_FIRMWARE_SIZE(name, blob, size)			     \
> > +	static const struct builtin_fw __fw_concat(__builtin_fw,__COUNTER__) \
> > +	__used __attribute__((__section__(".builtin_fw"))) =		     \
> 
> Use __section():
> 
> > +	__used __section(.builtin_fw))) =		     \
> (See compiler.h IIRC).

Done. Thanks.

-- 
dwmw2

