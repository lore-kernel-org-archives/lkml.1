Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYDRGqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYDRGqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYDRGp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:45:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbYDRGp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:45:57 -0400
Date: Thu, 17 Apr 2008 23:45:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH][RFC] Add default CPU topology information
Message-Id: <20080417234513.367c9ddc.akpm@linux-foundation.org>
In-Reply-To: <20080331114412.GH21637@solarflare.com>
References: <20080331114412.GH21637@solarflare.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 12:44:13 +0100 Ben Hutchings <bhutchings@solarflare.com> wrote:

> Not all architectures and configurations define CPU topology information.
> This can result in an empty topology directory in sysfs, and requires
> in-kernel users to protect all uses with #ifdef - see
> <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> 
> The documentation of CPU topology specifies what the defaults should be
> if only partial information is available from the hardware.  So we can
> provide these defaults as a fallback.

powerpc allmodconfig:

arch/powerpc/kernel/pci_64.c:655: error: expected identifier or '(' before 'void'
arch/powerpc/kernel/pci_64.c:655: error: expected ')' before '(' token

Because this:

#ifdef CONFIG_NUMA
int pcibus_to_node(struct pci_bus *bus)
{
	struct pci_controller *phb = pci_bus_to_host(bus);
	return phb->node;
}
#endif

is expanding to

int ((void)(bus), -1)(struct pci_bus *bus)

which the compiler has trouble with.

This:

+++ a/include/asm-powerpc/topology.h
@@ -109,6 +109,8 @@ static inline void sysfs_remove_device_f
 #endif
 #endif
 
+#define pcibus_to_node pcibus_to_node
+
 #include <asm-generic/topology.h>
 
 #endif /* __KERNEL__ */
_

gets it working, by tricking the preprocessor into expanding pcibus_to_node
to itself, but it isn't exactly pleasing.

