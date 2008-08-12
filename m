Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYHLPtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYHLPtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYHLPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:48:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYHLPsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:48:51 -0400
Message-ID: <48A1B0CB.9050908@redhat.com>
Date: Tue, 12 Aug 2008 17:48:27 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60 (bisected)
References: <20080806090246.GA1572@elf.ucw.cz> <48A1779B.5020303@redhat.com> <20080812115530.GB8806@elf.ucw.cz> <200808121634.34634.rjw@sisk.pl> <48A1A4F6.9080706@redhat.com>
In-Reply-To: <48A1A4F6.9080706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> yes. maybe some userspace tool controlling frequency is involved, no idea yet.
>>>> But it is 2.6.26 tree for sure.
>>>>         
>>> So it definitely is in 2.6.26.2, and it definitely is in 2.6.26?
>>>       
>
>
> The bug is _not_ in 2.6.26, it was introduced in 2.6.26.1.
>
> The problem is, that now the CPU frequency doesn't decrease at some
> temperature level and fan is unable to cool it properly.
>
> bisect on 2.6.26.y tree finished in this patch:
> (I expect similar patch in 2.6.27-rc)
>
> commit 04f496871e8af87a1e40c504371a206fd7389193
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Wed Jul 30 18:20:10 2008 +0000
>
>   
and this seems to fix it for me:
--

Do not use unsigned int if there is test for negative number...

See drivers/acpi/processor_perflib.c
  static unsigned int ignore_ppc = -1;
...
  if (event == CPUFREQ_START && ignore_ppc <= 0) {
       ignore_ppc = 0;
...

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/acpi/processor_perflib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26.y/drivers/acpi/processor_perflib.c
===================================================================
--- linux-2.6.26.y.orig/drivers/acpi/processor_perflib.c	2008-08-12 17:20:07.000000000 +0200
+++ linux-2.6.26.y/drivers/acpi/processor_perflib.c	2008-08-12 17:35:53.000000000 +0200
@@ -70,7 +70,7 @@ static DEFINE_MUTEX(performance_mutex);
  *  0 -> cpufreq low level drivers initialized -> consider _PPC values
  *  1 -> ignore _PPC totally -> forced by user through boot param
  */
-static unsigned int ignore_ppc = -1;
+static int ignore_ppc = -1;
 module_param(ignore_ppc, uint, 0644);
 MODULE_PARM_DESC(ignore_ppc, "If the frequency of your machine gets wrongly" \
 		 "limited by BIOS, this should help");


