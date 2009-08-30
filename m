Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZH3NFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZH3NFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZH3NFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:05:41 -0400
Received: from www.tglx.de ([62.245.132.106]:56874 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbZH3NFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:05:40 -0400
Message-Id: <20090830122225.608718729@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:05:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 0/4] x86: Convert PCI init to x86_init to simplify
	Moorestown support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reviewing the Moorestown patches I noticed weird modifications
to the PCI code. The main point seems to be to use pcibios_irq_init
but override pci_enable_irq. This is currently not possible by
overriding pci_enable_irq before that function is called as
pcibios_irq_init returns when pci_enable_irq is set. Jacop proposed a
function pointer in x86_init to transport that information into
pcibios_irq_init but its just a another hack. I looked at the init
code in pci_subsys_init which calls various platform specific setup
functions which may or may not override pci_enable_irq. The most
confusing thing in that series of calls is the global variable
pcibios_scanned which is used to signal the functions in that call
chain that the should return. The visws pci quirk does not touch
pcibios_scanned so that pci_legacy_init is called to scan the
bus. Pretty non obvious. :)

In order to allow a cleaner override of pci_enable_irq while still
being able to call pcibios_irq_init I converted the code to use the
new x86_init infrastructure. 

Aside of this MRST needs another hook close to the existing #ifdef'ed
OLPC pci arch init call according to the moorestown support patch in
pci-2.6.git. I added a x86_init function for this as well.

The series applies on top of the x86/platform branch in
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

It's a bit painful to puzzle the bits and pieces for MRST together. Is
there some big patch which contains all of the evil hacks which are
necessary to get this puppies up and running. I don't care if they are
ugly but I'd really like to get the full picture of it.

Thanks,

	tglx

