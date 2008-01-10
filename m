Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYAJTTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYAJTTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYAJTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:19:33 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:31412 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYAJTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:19:31 -0500
Date: Thu, 10 Jan 2008 11:19:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Help needed to fix section mismatch warnings
Message-Id: <20080110111918.42e4fa0b.randy.dunlap@oracle.com>
In-Reply-To: <20080109222542.422c90e0.randy.dunlap@oracle.com>
References: <20080106140728.GA3504@uranus.ravnborg.org>
	<20080109222542.422c90e0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 22:25:42 -0800 Randy Dunlap wrote:

> On Sun, 6 Jan 2008 15:07:28 +0100 Sam Ravnborg wrote:
> 
> 
> > This is the current list of warnings
> 
> Sam,
> 
> Several of these are due to driver variable names not matching
> the whitelisted names in modpost.  I have patches for the ones
> that I have identified so far.  And I have patches for a few of
> the others that are true section mismatch problems (total of 8
> patches ready for now).
> 
> The whitelisted names will always be a (small) problem.
> Can __init_refok be used in these cases.. or some other new
> attribute, instead of forever adding to the whitelist or
> modifying variable names?

Sam (or anyone :),

I guess that I'm a little confused.  Instead of changing
variable names to match the modpost whitelist, I tested adding
__init_refok or __initdata_refok to these (driver) structs that
generated the modpost warnings.

Example:  drivers/char/tpm/tpm_infineon.c

--- linux-2.6.24-rc7-git1.orig/drivers/char/tpm/tpm_infineon.c
+++ linux-2.6.24-rc7-git1/drivers/char/tpm/tpm_infineon.c
@@ -611,7 +611,7 @@ static __devexit void tpm_inf_pnp_remove
 	}
 }
 
-static struct pnp_driver tpm_inf_pnp = {
+static struct pnp_driver __init_refok tpm_inf_pnp = {
 	.name = "tpm_inf_pnp",
 	.driver = {
 		.owner = THIS_MODULE,

This has a build warning with my toolchain:

  CC      drivers/char/tpm/tpm_infineon.o
linux-2.6.24-rc7-git1/drivers/char/tpm/tpm_infineon.c:614: warning: 'noinline' attribute ignored
{standard input}: Assembler messages:
{standard input}:2315: Warning: setting incorrect section attributes for .text.init.refok

but otherwise no section mismatch warning.

OTOH, using __initdata_refok has no build warning and no section
mismatch warning... but it (__initdata_refok) doesn't make sense
to me.  Should it (make sense/be used)?
Is there a __refok that should be used here, instead of having
to modify variable names?


> > WARNING: vmlinux.o(.data+0x7e9b8): Section mismatch: reference to .init.text:tpm_inf_pnp_probe (between 'tpm_inf_pnp' and 'cn_idx')

Thanks,
---
~Randy
