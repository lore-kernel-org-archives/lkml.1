Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZKINXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZKINXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZKINXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:23:22 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:32641
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752118AbZKINXV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:23:21 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zba6lz1432R98dN1447Rzz1202hzzz32i176h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KSUFUS-03-DTF-02
X-M-MSG: 
Date: Mon, 9 Nov 2009 14:23:38 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] x86: under bios control, restore AP's APIC_LVTTHMR
 to the BSP value
Message-ID: <20091109132338.GB32321@aftab>
References: <20091109114752.GA3896@ywang-moblin2.bj.intel.com>
 <20091109122919.GA32321@aftab>
 <20091109121005.GB3896@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20091109121005.GB3896@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 09 Nov 2009 13:23:15.0553 (UTC) FILETIME=[CB530510:01CA613F]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 08:10:05PM +0800, Yong Wang wrote:
> > > +	mcheck_init();
> > 
> > I think you need
> > 
> > #ifdef CONFIG_X86_MCE
> > ...
> > #endif
> > 
> > here for cases where mcheck is config-disabled, no?
> > 
> 
> Petkov, thanks for the review. Part of my patch is as below. Does this
> resolve your concern?

Sorry, my comment was wrong. I remember seeing "#ifdef CONFIG_X86_MCE...
#endif" around mcheck_cpu_init(), that's why I asked. Anyways, with
CONFIG_X86_MCE disabled I still get

...
/home/boris/kernel/linux-2.6/arch/x86/include/asm/mce.h:126: warning: ‘mcheck_init’ defined but not used
  CC      arch/x86/ia32/audit.o
  AS      arch/x86/kernel/entry_64.o
  CC      arch/x86/kernel/traps.o
  LD      arch/x86/ia32/built-in.o
  LD      arch/x86/kvm/built-in.o
  CC [M]  arch/x86/kvm/svm.o
/home/boris/kernel/linux-2.6/arch/x86/include/asm/mce.h:126: warning: ‘mcheck_init’ defined but not used
  CC      arch/x86/kernel/irq.o
/home/boris/kernel/linux-2.6/arch/x86/include/asm/mce.h:126: warning: ‘mcheck_init’ defined but not used
...


which should be fixed IMHO by inlining mcheck_init() like
mcheck_cpu_init(). And while we're at it, we should remove the #ifdef's
around mcheck_cpu_init() in identify_cpu() since they're not needed.

> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 161485d..41d8e42 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -120,8 +120,10 @@ extern int mce_disabled;
>  extern int mce_p5_enabled;
> 
>  #ifdef CONFIG_X86_MCE
> +int mcheck_init(void);
>  void mcheck_cpu_init(struct cpuinfo_x86 *c);
>  #else
> +static int mcheck_init(void) { return 0; }
>  static inline void mcheck_cpu_init(struct cpuinfo_x86 *c) {}
>  #endif

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

