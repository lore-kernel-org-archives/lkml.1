Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbYDVQYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbYDVQYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYDVQYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:24:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56327 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753380AbYDVQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:24:12 -0400
Message-ID: <480E1129.1020705@sgi.com>
Date: Tue, 22 Apr 2008 09:24:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 1/4] x86: cleanup early per cpu variables/accesses	v3-folded
References: <20080422013415.955439000@polaris-admin.engr.sgi.com> <20080422013416.483730000@polaris-admin.engr.sgi.com> <20080422135944.GA24966@elte.hu>
In-Reply-To: <20080422135944.GA24966@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>   * Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
>>     used by some per_cpu variables that are initialized and accessed
>>     before there are per_cpu areas allocated.
> 
> build fails with:
> 
> arch/x86/kernel/built-in.o: In function `flat_apic_id_registered':
> genapic_flat_64.c:(.text+0x13e1d): undefined reference to `phys_cpu_present_map'
> genapic_flat_64.c:(.text+0x13e24): undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `phys_cpu_present_map'
> [...]
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Tue_Apr_22_15_40_10_CEST_2008.bad
> 
> 	Ingo

Hi Ingo,

Which tree are you using?  I don't get that error at all.  I'm on sched-latest:

#> cat .git/config
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "linus"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/linus/*
[remote "sched-devel"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
        fetch = +refs/heads/*:refs/remotes/sched-devel/*
[branch "sched-latest"]
        remote = sched-devel
        merge = refs/heads/latest


Here's the change I made to arch/x86/kernel/setup.c.

From:

    physid_mask_t phys_cpu_present_map;

    DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
    EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);

    /* Bitmask of physically existing CPUs */
    physid_mask_t phys_cpu_present_map;

To:

    /* Bitmask of physically existing CPUs */
    physid_mask_t phys_cpu_present_map;


(Actually, I don't understand why it didn't generate a multiple
define error before?)

Here's the symbol in Bss space:

#> nm -Bo arch/x86/kernel/built-in.o | grep phys_cpu_present_map
arch/x86/kernel/built-in.o:00000000000009a0 B phys_cpu_present_map

#> grep phys_cpu_present_map System.map
ffffffff809792c0 B phys_cpu_present_map


Building using your config file I do get this error (with or without
my patches):

  CC [M]  net/netfilter/nf_conntrack_sip.o
.../linux-2.6.sched/net/netfilter/nf_conntrack_sip.c: In function 'set_expected_rtp_rtcp':
.../linux-2.6.sched/net/netfilter/nf_conntrack_sip.c:786: error: 'struct nf_conntrack_expect' has no member named 'saved_ip'
.../linux-2.6.sched/net/netfilter/nf_conntrack_sip.c:787: error: 'struct nf_conntrack_expect' has no member named 'saved_proto'
.../linux-2.6.sched/net/netfilter/nf_conntrack_sip.c:789: error: 'struct nf_conntrack_expect' has no member named 'saved_ip'
.../linux-2.6.sched/net/netfilter/nf_conntrack_sip.c:790: error: 'struct nf_conntrack_expect' has no member named 'saved_ip'
.../linux-2.6.sched/net/netfilter/nf_conntrack_sip.c:791: error: 'struct nf_conntrack_expect' has no member named 'saved_proto'

Turning off CONFIG_NF_CONNTRACK_SIP gets around the error and it builds ok.

Should I try x86/latest or the merge of sched/latest + x86/latest?

Or...?

Thanks,
Mike

