Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbZIYJs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbZIYJs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZIYJs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:48:56 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14345 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZIYJsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:48:54 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z34a4jz1432R98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQITX4-01-2O2-02
X-M-MSG: 
Date: Fri, 25 Sep 2009 11:48:55 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925094855.GA29551@aftab>
References: <20090924192727.212ce46f@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090924192727.212ce46f@pedra.chehab.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Sep 2009 09:48:39.0488 (UTC) FILETIME=[5C00AC00:01CA3DC5]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

On Thu, Sep 24, 2009 at 07:27:27PM -0300, Mauro Carvalho Chehab wrote:
> edac_mce module is an interface module that gets mcelog data and
> forwards to any registered edac module that expects to receive data via
> mce.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++
>  drivers/edac/Kconfig             |    8 ++++-
>  drivers/edac/Makefile            |    3 +-
>  drivers/edac/edac_mce.c          |   58 ++++++++++++++++++++++++++++++++++++++
>  include/linux/edac_mce.h         |   31 ++++++++++++++++++++
>  5 files changed, 110 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/edac/edac_mce.c
>  create mode 100644 include/linux/edac_mce.h
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 2f5aab2..fefbb7c 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -35,6 +35,7 @@
>  #include <linux/fs.h>
>  #include <linux/mm.h>
>  #include <linux/debugfs.h>
> +#include <linux/edac_mce.h>
>  
>  #include <asm/processor.h>
>  #include <asm/hw_irq.h>
> @@ -135,6 +136,15 @@ void mce_log(struct mce *mce)
>  		entry = rcu_dereference(mcelog.next);
>  		for (;;) {
>  			/*
> +			 * If edac_mce is enabled, it will check the error type
> +			 * and will process it, if it is a known error.
> +			 * Otherwise, the error will be sent through mcelog
> +			 * interface
> +			 */
> +			if (edac_mce_parse(mce))
> +				return;

for the third time (!): this may run in NMI context and as such does not
obey to normal kernel locking rules and you cannot safely use almost any
kernel resources involving locking. This way, your hook calls into a
module, which is a very bad idea. Please remove that hook and put in the
polling routine or somewhere more appropriate.

> +
> +			/*
>  			 * When the buffer fills up discard new entries.
>  			 * Assume that the earlier errors are the more
>  			 * interesting ones:
> @@ -193,6 +203,8 @@ static void print_mce(struct mce *m)
>  			m->cpuvendor, m->cpuid, m->time, m->socketid,
>  			m->apicid);
>  
> +	edac_mce_parse(m);
> +
>  	decode_mce(m);
>  }

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

