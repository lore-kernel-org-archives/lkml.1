Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYEWROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYEWROh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYEWROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:14:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53160 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYEWROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:14:04 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080523164108.GA31545@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 18:13:57 +0100
Message-Id: <1211562837.28967.51.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 18:41 +0200, Sam Ravnborg wrote:
> > +FIRMWARE_BINS := $(subst ",,$(CONFIG_BUILTIN_FIRMWARE))
> > +FIRMWARE_OBJS := $(patsubst %,%.o, $(FIRMWARE_BINS))
> > +FIRMWARE_SRCS := $(patsubst %,$(obj)/%.c, $(FIRMWARE_BINS))
> 
> My personal rule-of-thumb is to use lower case for
> all local variables and UPPER case for global variables.
> 
> I know that outside the kernel everyone use UPPER case
> for Makefile variables but that just not readable.
> So in this code snippet I would have used lower case.

OK, I'll do that.

> > +
> > +
> > +quiet_cmd_fwbin = MK_FW   $@
> > +      cmd_fwbin = echo '/* File automatically generated */' > $@ ;	 \
> > +		  echo '\#include <linux/firmware.h>' >> $@ ;		 \
> > +		  echo 'static const unsigned char fw[] = {' >> $@ ;	 \
> > +		  od -t x1 -A none -v $(srctree)/$(patsubst %.c,%,$@) | \
> > +		   sed -e 's/ /, 0x/g' -e 's/^,//' -e 's/$$/,/' >> $@ ; \
> > +		  echo '};' >> $@ ;					 \
> > +		  echo 'DECLARE_BUILTIN_FIRMWARE("$(patsubst firmware/%.c,%,$@)",fw);' >> $@

> A small comment is justified here.
> Do not consider everyone to know od.

Isn't the context enough? Some comments are just superfluous :)

> If you choose a deciaml output you do not need to add 0x

Hm, that's true -- force of habit, I suppose. But it doesn't really
matter, and if anyone _does_ have cause to look at the generated file,
it's probably nicer in hex.

Actually, it would be nicer to do it in assembly and use .incbin -- but
then we'd have to deal with potential struct alignment issues for the
'struct builtin_fw'. Again, that's an improvement for later. But it's
why I used 'unsigned long' for the size, instead of 'size_t'.

> > +
> > +$(FIRMWARE_SRCS): $(obj)/%.c: $(srctree)/$(obj)/%
> > +	$(call cmd,fwbin)
> > +
> > +obj-y := $(FIRMWARE_OBJS)
> 
> Assignment to targets i smiisng so generated files are not cleaned
> by "make clean".
> 
> targets := $(FIRMWARE_OBJS)

OK, thanks.

-- 
dwmw2

