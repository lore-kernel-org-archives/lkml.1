Return-Path: <linux-kernel-owner+w=401wt.eu-S947649AbXHMO5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947649AbXHMO5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970349AbXHMMUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:20:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45502 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970316AbXHMMUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:20:07 -0400
Date: Mon, 13 Aug 2007 13:19:31 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Chris Snook <csnook@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 3/23] make atomic_read() and atomic_set() behavior consistent on arm
Message-ID: <20070813121931.GA9165@flint.arm.linux.org.uk>
Mail-Followup-To: Chris Snook <csnook@redhat.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
	Segher Boessenkool <segher@kernel.crashing.org>,
	"Luck, Tony" <tony.luck@intel.com>,
	Chris Friesen <cfriesen@nortel.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>
References: <46C03885.7000109@redhat.com> <20070813110946.GC24018@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813110946.GC24018@shell.boston.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 07:09:46AM -0400, Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Use volatile consistently in atomic.h on arm.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>
> 
> --- linux-2.6.23-rc3-orig/include/asm-arm/atomic.h	2007-07-08 19:32:17.000000000 -0400
> +++ linux-2.6.23-rc3/include/asm-arm/atomic.h	2007-08-13 04:44:50.000000000 -0400
> @@ -14,13 +14,16 @@
>  #include <linux/compiler.h>
>  #include <asm/system.h>
>  
> -typedef struct { volatile int counter; } atomic_t;
> +typedef struct { int counter; } atomic_t;
>  
>  #define ATOMIC_INIT(i)	{ (i) }
>  
>  #ifdef __KERNEL__
>  
> -#define atomic_read(v)	((v)->counter)
> +static inline int atomic_read(atomic_t *v)
> +{
> +        return *(volatile int *)&v->counter;
> +}
>  
>  #if __LINUX_ARM_ARCH__ >= 6
>  

...
In the first email of the series:
> By popular demand, I've redone the patchset to include volatile casts in
> atomic_set as well.  I've also converted the macros to inline functions, to
> help catch type mismatches at compile time.

and in the rest of include/asm-arm/atomic.h:

#else /* ARM_ARCH_6 */

#include <asm/system.h>

#ifdef CONFIG_SMP
#error SMP not supported on pre-ARMv6 CPUs
#endif

#define atomic_set(v,i) (((v)->counter) = (i))

Seems you missed that.  Grep is a wonderful tool.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
