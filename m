Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZIPOnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZIPOnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZIPOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:43:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:62539 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZIPOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:43:03 -0400
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Steve Chen <schen@mvista.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <m3ljkfoywm.fsf@intrepid.localdomain>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu>
	 <200909151541.08852.marek.vasut@gmail.com>
	 <1253032210.3273.128.camel@linux-1lbu>
	 <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com>
	 <1253043875.3273.131.camel@linux-1lbu>
	 <m3k4zzdimy.fsf@intrepid.localdomain>
	 <1253053609.3273.139.camel@linux-1lbu>
	 <m33a6nddvd.fsf@intrepid.localdomain>
	 <1253089566.3273.152.camel@linux-1lbu>
	 <m3ljkfoywm.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 09:49:14 -0500
Message-Id: <1253112555.3273.164.camel@linux-1lbu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 14:30 +0200, Krzysztof Halasa wrote:
> Steve Chen <schen@mvista.com> writes:
> 
> > +config OLD_CPU_DELAY
> > +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> > +	bool "Accurate delays for some older CPUs"
> > +	def_bool n
> > +	help
> > +	  Try enable this if observing longer than expected delays and need
> > +	  more accuracy.  May cause instability in some CPUs.
> > +
> 
> There is still this uncertain "accurate" in the text. Why don't just
> 
> +	bool "Different delay() code for some older CPUs"

Sounds good.  I also update text under help to better quantify
"accuracy".  Updated patch below.  Separately, as Russel pointed out,
this should only be done by experienced people, so we even bother with
this patch since the only people should touch this are the people who
knows all the details.

Document #if 0 code block in delay.S and make it selectable for compile.

Signed-off-by: Steve Chen <schen@mvista.com>

---

 arch/arm/Kconfig     |    8 ++++++++
 arch/arm/lib/delay.S |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index aef63c8..ca8d535 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -813,6 +813,14 @@ config ARM_ERRATA_460075
 	  ACTLR register. Note that setting specific bits in the ACTLR
register
 	  may not be available in non-secure mode.
 
+config OLD_CPU_DELAY
+	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
+	bool "Different delay() code for some older CPUs"
+	def_bool n
+	help
+	  Try enable this if observing longer than expected delays.  This code
+	  improves accuracy for some CPUs while cause instability in others.
+
 endmenu
 
 source "arch/arm/common/Kconfig"
diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
index 8d6a876..67e679b 100644
--- a/arch/arm/lib/delay.S
+++ b/arch/arm/lib/delay.S
@@ -42,7 +42,7 @@ ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
 @ Delay routine
 ENTRY(__delay)
 		subs	r0, r0, #1
-#if 0
+#ifdef CONFIG_OLD_CPU_DELAY
 		movls	pc, lr
 		subs	r0, r0, #1
 		movls	pc, lr


