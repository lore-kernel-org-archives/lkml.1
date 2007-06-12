Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXFLWRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXFLWRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXFLWRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:17:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbXFLWRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:17:38 -0400
Date: Tue, 12 Jun 2007 18:16:29 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, avi@qumranet.com,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
Message-ID: <20070612221629.GA24252@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, avi@qumranet.com,
	linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070612000718.GS3588@stusta.de> <20070612032224.GA19293@redhat.com> <20070612150357.1685c622.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612150357.1685c622.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 03:03:57PM -0700, Andrew Morton wrote:
 > On Mon, 11 Jun 2007 23:22:24 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > Add -Werror-implicit-function-declaration
 > > This makes builds fail sooner if something is implicitly defined instead
 > > of having to wait half an hour for it to fail at the linking stage.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > 
 > > --- linux-2.6/Makefile~	2007-06-04 16:46:24.000000000 -0400
 > > +++ linux-2.6/Makefile	2007-06-04 16:46:53.000000000 -0400
 > > @@ -313,7 +313,8 @@ LINUXINCLUDE    := -Iinclude \
 > >  CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 > >  
 > >  CFLAGS          := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 > > -                   -fno-strict-aliasing -fno-common
 > > +		   -fno-strict-aliasing -fno-common \
 > > +		   -Werror-implicit-function-declaration
 > >  AFLAGS          := -D__ASSEMBLY__
 > >  
 > >  # Read KERNELRELEASE from include/config/kernel.release (if it exists)
 > 
 > This causes the i386 allmodconfig build to fail:

Seems to be doing its job rather effectively.

 > include/linux/uaccess.h: In function 'pagefault_disable':
 > include/linux/uaccess.h:23: error: implicit declaration of function '__memory_barrier'
 > 
 > I didn't look to see why...

include/linux/compiler.h ..

/* Optimization barrier */
#ifndef barrier
# define barrier() __memory_barrier()
#endif

We shouldn't be hitting this, because barrier should be getting defined
in the compiler specific headers above..

#if __GNUC__ >= 4
# include <linux/compiler-gcc4.h>
#elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
# include <linux/compiler-gcc3.h>
#else
# error Sorry, your compiler is too old/not recognized.
#endif

both of those include linux/compiler-gcc.h, which defines barrier.
How strange.  What compiler version is this?

	Dave

-- 
http://www.codemonkey.org.uk
