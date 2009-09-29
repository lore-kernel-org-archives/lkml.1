Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZI2AAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZI2AAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZI2AAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:00:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40352 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbZI2AAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:00:14 -0400
Subject: Re: linux-next: tree build failure
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, kvm-ppc@vger.kernel.org
In-Reply-To: <20090924152102.8d7d40cf.sfr@canb.auug.org.au>
References: <20090924152102.8d7d40cf.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 28 Sep 2009 17:00:09 -0700
Message-Id: <1254182409.15622.154.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 15:21 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
> 
> In file included from arch/powerpc/kvm/booke.c:31:
> arch/powerpc/kvm/timing.h: In function 'kvmppc_account_exit_stat':
> arch/powerpc/kvm/timing.h:51: error: bit-field '<anonymous>' width not an integer constant
> In file included from arch/powerpc/kvm/booke.h:26,
>                  from arch/powerpc/kvm/booke_emulate.c:23:
> arch/powerpc/kvm/timing.h: In function 'kvmppc_account_exit_stat':
> arch/powerpc/kvm/timing.h:51: error: bit-field '<anonymous>' width not an integer constant
> 
> Presumably caused by commit 8c87df457cb58fe75b9b893007917cf8095660a0
> ("BUILD_BUG_ON(): fix it and a couple of bogus uses of it").

First, I think there is a real bug here, and the code should read like
this (to match the comment):
 	/* type has to be known at build time for optimization */
-	BUILD_BUG_ON(__builtin_constant_p(type));
+	BUILD_BUG_ON(!__builtin_constant_p(type));

However, I get the same build error *both* ways, i.e.
__builtin_constant_p(type) evaluates to both 0 and 1? Either that, or
the new BUILD_BUG_ON() macro isn't working...

> I applied the following patch for today.  This inline function is
> only called from one place in one file ...

It's also called via kvmppc_account_exit() from a number of places.

-- 
Hollis Blanchard
IBM Linux Technology Center

