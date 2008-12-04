Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYLDQPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYLDQPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYLDQPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:15:30 -0500
Received: from mail.transmode.se ([83.241.175.147]:5307 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYLDQP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:15:29 -0500
X-Greylist: delayed 931 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2008 11:15:29 EST
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Organization: Transmode AB
X-Mailer: Evolution 2.22.3.1 
In-Reply-To: <20081204154044.GC18293@elte.hu>
content-class: urn:content-classes:message
Subject: Re: [PATCH] Allow times and time system calls to return smallnegative values
Date: Thu, 4 Dec 2008 17:01:58 +0100
Message-ID: <1228406394.21348.40.camel@gentoo-jocke.transmode.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Allow times and time system calls to return smallnegative values
Thread-Index: AclWKaLot6tZ/oGXQtWUGCJNW78yvg==
References: <18743.25968.602602.875295@drongo.ozlabs.ibm.com> <20081204075751.GA32594@elte.hu> <18743.46549.833800.667962@cargo.ozlabs.ibm.com> <20081204154044.GC18293@elte.hu>
From: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Paul Mackerras" <paulus@samba.org>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Reply-To: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 16:40 +0100, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Ingo Molnar writes:
> > 
> > > > +	force_successful_syscall_return();
> > > >  	return compat_jiffies_to_clock_t(jiffies);
> > > 
> > > just curious: what code does force_successful_syscall_return() actually 
> > > run in the powerpc case - those bits are missing from this patch. I 
> > > suspect it sets some sort of flag?
> > 
> > It sets the TIF_NOERROR thread flag, which is tested in the syscall 
> > exit path along with various other thread flags.
> > 
> > force_successful_syscall_return() is defined for powerpc in 
> > arch/powerpc/include/asm/ptrace.h.  It's nothing new, it has existed 
> > for ages and is used in a few other places already.  It has existing 
> > non-null definitions on alpha, ia64, powerpc, and sparc64.
> 
> ok, was just curious. To make this code nicer, we could keep the time 
> syscalls from returning small negative numbers.
> 
> the core issue is probably:
> 
>  jiffies.h:#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> the thing is, we did INITIAL_JIFFIES to find _in kernel_ jiffies 
> wraparoudn bugs (hung timers, broken drivers, etc.) - we did not want to 
> confuse userspace with it.
> 
> So how about adding INITIAL_JIFFIES to the sys_times() return value?

Na, that will just hide the bug for some 497 days(or 49 days on alpha).
In user space on have to use this workaround(and I think some variation
is in glibc already):

static unsigned long quagga_times(void)
{
#if defined(GNU_LINUX)
  unsigned long ret;

  errno = 0;
  ret = times(NULL); /* Linux can handle NULL */
  /* Workaround broken syscall impl.
   * A bugfix exists for the kernel, hopefully
   * it will make it into 2.6.29
   */
  if (errno)
    ret = (unsigned long) (-errno);
  return ret;
#else
  struct tms dummy; /* Only return value is used */

  return times(&dummy);
#endif
}


