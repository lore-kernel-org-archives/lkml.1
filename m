Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZDME7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZDME7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 00:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZDME65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 00:58:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:52264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZDME64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 00:58:56 -0400
Subject: Re: [tip:x86/cpu] x86: cacheinfo: replace sysfs interface for
 cache_disable feature
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com,
       akpm@linux-foundation.org, mark.langsdorf@amd.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1239598324.2983.2.camel@ht.satnam>
References: <20090409131849.GJ31527@alberich.amd.com>
	 <tip-f8b201fc7110c3673437254e8ba02451461ece0b@git.kernel.org>
	 <1239598324.2983.2.camel@ht.satnam>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Apr 2009 10:26:52 +0530
Message-Id: <1239598612.2983.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 10:22 +0530, Jaswinder Singh Rajput wrote:
> Hello Mark,
> 
> On Fri, 2009-04-10 at 12:37 +0000, Mark Langsdorf wrote:
> > Commit-ID:  f8b201fc7110c3673437254e8ba02451461ece0b
> > Gitweb:     http://git.kernel.org/tip/f8b201fc7110c3673437254e8ba02451461ece0b
> > Author:     Mark Langsdorf <mark.langsdorf@amd.com>
> > AuthorDate: Thu, 9 Apr 2009 15:18:49 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 10 Apr 2009 14:21:53 +0200
> > 
> > x86: cacheinfo: replace sysfs interface for cache_disable feature
> > 
> > Impact: replace sysfs attribute
> > 
> > Current interface violates against "one-value-per-sysfs-attribute
> > rule". This patch replaces current attribute with two attributes --
> > one for each L3 Cache Index Disable register.
> > 
> > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > LKML-Reference: <20090409131849.GJ31527@alberich.amd.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  arch/x86/kernel/cpu/intel_cacheinfo.c |   90 ++++++++++++++++----------------
> >  1 files changed, 45 insertions(+), 45 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > index 0cde071..fc28291 100644
> > --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> > +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > @@ -697,73 +697,69 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
> >  #define to_object(k)	container_of(k, struct _index_kobject, kobj)
> >  #define to_attr(a)	container_of(a, struct _cache_attr, attr)
> >  
> > -static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
> > +static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
> > +				  unsigned int index)
> >  {
> > -	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
> > -	int node = cpu_to_node(cpumask_first(mask));
> > -	struct pci_dev *dev = NULL;
> > -	ssize_t ret = 0;
> > -	int i;
> > +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> > +	int node = cpu_to_node(cpu);
> > +	struct pci_dev *dev = node_to_k8_nb_misc(node);
> > +	unsigned int reg = 0;
> 
> This leads to compilation warnings:
>   CC      arch/x86/kernel/cpu/intel_cacheinfo.o
> arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
> arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
> 
> >  
> > -static ssize_t
> > -store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
> > -		    size_t count)
> > +static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
> > +	const char *buf, size_t count, unsigned int index)
> >  {
> > -	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
> > -	int node = cpu_to_node(cpumask_first(mask));
> > -	struct pci_dev *dev = NULL;
> > -	unsigned int ret, index, val;
> > +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> > +	int node = cpu_to_node(cpu);
> > +	struct pci_dev *dev = node_to_k8_nb_misc(node);
> > +	unsigned long val = 0;
> >  
> 
>   CC      arch/x86/kernel/cpu/intel_cacheinfo.o
> arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
> arch/x86/kernel/cpu/intel_cacheinfo.c:737: warning: unused variable ‘cpu’

Oops it is also pointing to node:

arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’

--
JSR

