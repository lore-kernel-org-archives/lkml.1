Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbYEIAvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbYEIAvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYEIAvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:51:35 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:38482 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756984AbYEIAvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:51:33 -0400
Date: Fri, 9 May 2008 09:50:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Travis <travis@sgi.com>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sh migor_defconfig build breakage
Message-ID: <20080509005006.GA29869@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Travis <travis@sgi.com>, Adrian Bunk <bunk@kernel.org>,
	Ingo Molnar <mingo@elte.hu>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080508203949.GC22887@cs181133002.pp.htv.fi> <48236E59.8070400@sgi.com> <4823711D.70401@sgi.com> <482376BC.2000404@sgi.com> <48237ADE.3090703@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48237ADE.3090703@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 03:12:46PM -0700, Mike Travis wrote:
> Mike Travis wrote:
> > Because some arch's have it defined as an inline function.  Perhaps the
> > easiest would be to add to include/asm-sh/topology.h a simple define of
> > cpu_to_node()?
> 
> Ahh, this is what caused the error.  In include/asm-generic/topology.h
> cpu_to_node is only defined now if NUMA is turned off.
> 
> #ifndef CONFIG_NUMA
> 
> /* Other architectures wishing to use this simple topology API should fill
>    in the below functions as appropriate in their own <asm/topology.h> file. */
> #ifndef cpu_to_node
> #define cpu_to_node(cpu)        ((void)(cpu),0)
> #endif
> ...
> 
> So before my change arch 'sh' used the default define whether NUMA was
> set or not.
> 
The dependency here is a bit vague in the first place. For UP NUMA the
asm-generic definitions are perfectly fine, it's only the CONFIG_NUMA &&
CONFIG_SMP cases where there is any point in doing anything more
fine-grained. So while it would be trivial to add a CONFIG_SMP test here
too, that's likely to break all of the other NUMA platforms.

So while sh can use the asm-generic definitions in the UP case, it
obviously can't on SMP. The easiest option for now is to just stub the
asm-generic bits in to asm-sh/topology.h under a CONFIG_NUMA ifdef and
then add more reasonable definitions for the SMP cases.
