Return-Path: <linux-kernel-owner+w=401wt.eu-S1031113AbXD1GBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031113AbXD1GBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031118AbXD1GBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:01:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:60718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031113AbXD1GBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:01:09 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@suse.de>,
       Shai Fultheim <shai@scalex86.org>,
       Ravikiran Thirumalai <kiran@scalex86.org>
Subject: Re: ACPI build problem (2.6.21 CONFIG_X86_64_ACPI_NUMA)
Date: Sat, 28 Apr 2007 01:59:46 -0400
User-Agent: KMail/1.9.5
References: <1177593963.5462.12.camel@quoit.chygwyn.com>
In-Reply-To: <1177593963.5462.12.camel@quoit.chygwyn.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280159.46337.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 09:26, you wrote:
> Hi,
> 
> With the attached kernel config I get the following build errors. They
> go away if I turn power management support on:
> 
> drivers/built-in.o: In function `acpi_bus_generate_event':
> /home/steve/gfs2-2.6-fixes.git/drivers/acpi/bus.c:294: undefined
> reference to `event_is_open'
> drivers/built-in.o: In function `acpi_bus_get_power':
> /home/steve/gfs2-2.6-fixes.git/drivers/acpi/bus.c:160: undefined
> reference to `acpi_power_get_inferred_state'
> drivers/built-in.o: In function `acpi_bus_set_power':
> /home/steve/gfs2-2.6-fixes.git/drivers/acpi/bus.c:230: undefined
> reference to `acpi_power_transition'
> /home/steve/gfs2-2.6-fixes.git/drivers/acpi/bus.c:252: undefined
> reference to `acpi_power_transition'
> make: *** [.tmp_vmlinux1] Error 1
> 
> This is with my gfs2 tree which is basically 2.6.21 plus a few patches
> which only affect gfs2/dlm, so its upstream to all intents and purposes.

CONFIG_ACPI depends on CONFIG_PM, yet this build fails because you have
CONFIG_ACPI=y and CONFIG_PM=n

Unfortunately kconfig doesn't trace dependencies when "select" is used,
making select sort of evil.  Ie. select can't target anything which
itself has dependencies.

In 2.6.15, b0bd35e622ffbda2c01dc67a0381c6a18817a29a added the select below,
and subsequently ACPI became dependent on PM, which broke your build.
Technically, this could have broken your build in other ways too
since ACPI already had other dependencies.

+# Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
+
+config X86_64_ACPI_NUMA
+       bool "ACPI NUMA detection"
+       depends on NUMA
+       select ACPI 
+       select ACPI_NUMA
+       default y
+       help
+	 Enable ACPI SRAT based node topology detection.

If you de-select CONFIG_X86_64_ACPI_NUMA then the select goes away
and kconfig should work properly.

It isn't immediately clear to me how the NUMA Kconfig patch is a step
forward, but perhaps the authors can comment.

-Len
