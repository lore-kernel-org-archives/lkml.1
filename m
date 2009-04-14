Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZDNL7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZDNL7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZDNL7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:59:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbZDNL7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:59:13 -0400
Date: Tue, 14 Apr 2009 13:58:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, akpm@linux-foundation.org,
       mark.langsdorf@amd.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86: cacheinfo: replace sysfs interface for
	cache_disable feature
Message-ID: <20090414115805.GW3558@elte.hu>
References: <20090409131849.GJ31527@alberich.amd.com> <tip-f8b201fc7110c3673437254e8ba02451461ece0b@git.kernel.org> <1239598324.2983.2.camel@ht.satnam> <1239598612.2983.4.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239598612.2983.4.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Mon, 2009-04-13 at 10:22 +0530, Jaswinder Singh Rajput wrote:
> > Hello Mark,
> > 
> > On Fri, 2009-04-10 at 12:37 +0000, Mark Langsdorf wrote:
> > > Commit-ID:  f8b201fc7110c3673437254e8ba02451461ece0b
> > > Gitweb:     http://git.kernel.org/tip/f8b201fc7110c3673437254e8ba02451461ece0b
> > > Author:     Mark Langsdorf <mark.langsdorf@amd.com>
> > > AuthorDate: Thu, 9 Apr 2009 15:18:49 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Fri, 10 Apr 2009 14:21:53 +0200
> > > 
> > > x86: cacheinfo: replace sysfs interface for cache_disable feature
> > > 
> > > Impact: replace sysfs attribute
> > > 
> > > Current interface violates against "one-value-per-sysfs-attribute
> > > rule". This patch replaces current attribute with two attributes --
> > > one for each L3 Cache Index Disable register.
> > > 
> > > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > LKML-Reference: <20090409131849.GJ31527@alberich.amd.com>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > 
> > > ---
> > >  arch/x86/kernel/cpu/intel_cacheinfo.c |   90 ++++++++++++++++----------------
> > >  1 files changed, 45 insertions(+), 45 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > > index 0cde071..fc28291 100644
> > > --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> > > +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > > @@ -697,73 +697,69 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
> > >  #define to_object(k)	container_of(k, struct _index_kobject, kobj)
> > >  #define to_attr(a)	container_of(a, struct _cache_attr, attr)
> > >  
> > > -static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
> > > +static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
> > > +				  unsigned int index)
> > >  {
> > > -	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
> > > -	int node = cpu_to_node(cpumask_first(mask));
> > > -	struct pci_dev *dev = NULL;
> > > -	ssize_t ret = 0;
> > > -	int i;
> > > +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> > > +	int node = cpu_to_node(cpu);
> > > +	struct pci_dev *dev = node_to_k8_nb_misc(node);
> > > +	unsigned int reg = 0;
> > 
> > This leads to compilation warnings:
> >   CC      arch/x86/kernel/cpu/intel_cacheinfo.o
> > arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
> > arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
> > 
> > >  
> > > -static ssize_t
> > > -store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
> > > -		    size_t count)
> > > +static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
> > > +	const char *buf, size_t count, unsigned int index)
> > >  {
> > > -	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
> > > -	int node = cpu_to_node(cpumask_first(mask));
> > > -	struct pci_dev *dev = NULL;
> > > -	unsigned int ret, index, val;
> > > +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> > > +	int node = cpu_to_node(cpu);
> > > +	struct pci_dev *dev = node_to_k8_nb_misc(node);
> > > +	unsigned long val = 0;
> > >  
> > 
> >   CC      arch/x86/kernel/cpu/intel_cacheinfo.o
> > arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
> > arch/x86/kernel/cpu/intel_cacheinfo.c:737: warning: unused variable ‘cpu’
> 
> Oops it is also pointing to node:
> 
> arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
> arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’

Mind sending a fix? We really dont want warnings noise in the x86 
tree.

I was also thinking about adopting the Sparc trick: adding -Werror 
to arch/x86/ files only, fixing all the fallout and ensuring no new 
warnings from a flag day on. Anyone interested in doing that?

	Ingo
