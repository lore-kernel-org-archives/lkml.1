Return-Path: <linux-kernel-owner+w=401wt.eu-S1763254AbZLPWyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763254AbZLPWyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763109AbZLPWyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:54:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:45190 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbZLPWyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:54:33 -0500
Subject: Re: [PATCH] cardbus: Add a fixup hook and fix powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, blofeldus@yahoo.com,
       Olof Johansson <olof@lixom.net>
In-Reply-To: <20091216140128.16afbeb7@jbarnes-piketon>
References: <1260341533.16132.20.camel@pasglop>
	 <20091216140128.16afbeb7@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 09:54:23 +1100
Message-ID: <1261004063.20129.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 14:01 -0800, Jesse Barnes wrote:

> > Olof, once that's in you should be able to remove the hack you have in
> > the PA-Semi code to work around this.
> > 
> 
> Oops, looks like this fails for the modular case?  I get an unresolved
> symbol error when building this with my default config...
> 
> Care to resend with the fix against my for-linus branch?

Care to send a log ? I fail to see where the problem is since the patch
has:

--- linux-work.orig/drivers/pci/pci.c   2009-12-09 17:33:24.000000000 +1100
+++ linux-work/drivers/pci/pci.c        2009-12-09 17:34:16.000000000 +1100
@@ -2723,6 +2723,11 @@ int __attribute__ ((weak)) pci_ext_cfg_a
        return 1;
 }
 
+void __weak pci_fixup_cardbus(struct pci_bus *bus)
+{
+}
+EXPORT_SYMBOL(pci_fixup_cardbus);

Or is that broken in some way ?

I'm starting to regret trying to use weak stuff :-) I may turn it into a good
old:

#ifndef pcibios_fixup_cardbus
static inline void pcibios_fixup_cardbus(struct pci_bus *bus) { }
#define pcibios_fixup_cardbus
#endif

In a header and have ppc define it.

(And call it pcibios_ instead of pci_ which matches better what other arch
fixups are called :-)

Cheers,
Ben.


