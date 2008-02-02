Return-Path: <linux-kernel-owner+w=401wt.eu-S1765950AbYBBQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765950AbYBBQ0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBBQ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:26:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33770 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYBBQ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:26:08 -0500
Date: Sat, 2 Feb 2008 17:26:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [scsi bug] spurious build failures in aic7xxx
Message-ID: <20080202162611.GA24765@uranus.ravnborg.org>
References: <20080201225056.GA18302@elte.hu> <20080202135935.GA23838@uranus.ravnborg.org> <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu> <20080202141857.GA8635@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202141857.GA8635@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 03:18:57PM +0100, Ingo Molnar wrote:
> 
> i should also specify the build environment:
> 
> it's a distcc setup with 5-10 hosts active at a time, so highly parallel 
> with large, networking related delays. It's make -j130:
> 
> nice -15 /usr/bin/time make -j130 bzImage ARCH=i386 \
> CROSS_COMPILE='distcc \
> /opt/crosstool/gcc-4.2.2-glibc-2.3.6/i686-unknown-linux-gnu-'
> 
> the build host is a 64-bit quad CPU box, so highly parallel as well.

Impressive setup - I was until now quite satisfied with my new
quad box that Intel has sponsored (thanks to Greg) :-)

I could not reproduce the bug myself but I think I spotted it.
We had a missing dependency to the _reg.h file.
Try following patch and let me now if it continue to break.

	Sam

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index e4f70c5..8065590 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -44,13 +44,8 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
 
 # Dependencies for generated files need to be listed explicitly
 
-$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_seq.h
-$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_reg.h
-$(obj)/aic79xx_core.o: $(obj)/aic79xx_seq.h
-$(obj)/aic79xx_core.o: $(obj)/aic79xx_reg.h
-
-$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h
-$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h
+$(addprefix $(obj)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
+$(addprefix $(obj)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
 
 aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h
 aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+= $(obj)/aic7xxx_reg_print.c
