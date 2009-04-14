Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZDNRIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZDNRIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbZDNRIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:08:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:43668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZDNRIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:08:24 -0400
Subject: Re: [PATCH -tip] x86: k8.h reference to node in node_to_k8_nb_misc
 for !CONFIG_K8_NB
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>
In-Reply-To: <20090414165241.GB2089@elte.hu>
References: <1239727500.2966.16.camel@ht.satnam>
	 <20090414165241.GB2089@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Apr 2009 22:37:56 +0530
Message-Id: <1239728876.2966.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 18:52 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Add reference to node in node_to_k8_nb_misc for !CONFIG_K8_NB to make compiler happy.
> > 
> > So fixes compiler warnings:
> >   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
> >   arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
> >   arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
> >   arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/include/asm/k8.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
> > index c23b3d1..c81e4ee 100644
> > --- a/arch/x86/include/asm/k8.h
> > +++ b/arch/x86/include/asm/k8.h
> > @@ -16,7 +16,7 @@ extern int k8_scan_nodes(unsigned long start, unsigned long end);
> >  #define node_to_k8_nb_misc(node) \
> >  	(node < num_k8_northbridges) ? k8_northbridges[node] : NULL
> >  #else
> > -#define node_to_k8_nb_misc(node) NULL
> > +#define node_to_k8_nb_misc(node) (node) ? NULL : NULL
> >  #endif
> 
> Ugh, that's very ugly. I gave you a proper solution:
> 
> >> The typical way to solve this is to add a dummy:
> >> 
> >> 	(void)(cpu)
> >> 
> >> use to the 'cpu' parameter to the macro definition - or, 
> >> (which is a much better solution), to convert it to an 
> >> inline function.
> 

Subject: [PATCH] x86: cpu/cacheinfo.c reference to node for node_to_k8_nb_misc for !CONFIG_K8_NB

Add reference to node for node_to_k8_nb_misc for !CONFIG_K8_NB to make compiler happy.

And fixes:
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..4414c92 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -719,6 +719,7 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 	if (!dev)
 		return -EINVAL;
 
+	(void)(node);
 	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
 	return sprintf(buf, "%x\n", reg);
 }
@@ -755,6 +756,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 	val |= 0xc0000000;
 
+	(void)(node);
 	pci_read_config_dword(dev, 0x58, &scrubber);
 	scrubber &= ~0x1f000000;
 	pci_write_config_dword(dev, 0x58, scrubber);
-- 
1.6.0.6



