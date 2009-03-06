Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZCFG4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZCFG4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZCFG4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:56:12 -0500
Received: from ozlabs.org ([203.10.76.45]:45676 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZCFG4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:56:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: lguest: unhandled trap 13 in current -rc
Date: Fri, 6 Mar 2009 17:26:03 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4993CCCE.6040403@trash.net> <49AE8C57.4080502@trash.net>
In-Reply-To: <49AE8C57.4080502@trash.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200903061726.04101.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009 00:42:39 Patrick McHardy wrote:
> Patrick McHardy wrote:
> > When trying to run lguest in the current -rc, I get an "unhandled
> > trap 13" and it stops. The address resolves to the rdmsr intruction
> > in native_read_msr_safe(). -rc2 works fine, but I couldn't find
> > any changes that looks related.
> > 
> > .config is attached, more information available on request.
> 
> For the record, this is still broken in -rc7.

(Sorry, I missed the first mail to lkml).

Reproduced on one of my test machines (kvm doesn't show the problem here).

Subject: lguest: fix crash 'unhandled trap 13 at <native_read_msr_safe>'

Impact: fix lguest boot crash on modern Intel machines

The code in early_init_intel does:

	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
		u64 misc_enable;

		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);

And that rdmsr faults (not allowed from non-0 PL).  We can get around
this by mugging the family ID part of the cpuid.  5 seems like a good
number.

Of course, this is a hack (how very lguest!).  We could just indicate
that we don't support MSRs, or implement lguest_rdmst.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -343,6 +350,11 @@ static void lguest_cpuid(unsigned int *a
 		 * flush_tlb_user() for both user and kernel mappings unless
 		 * the Page Global Enable (PGE) feature bit is set. */
 		*dx |= 0x00002000;
+		/* We also lie, and say we're family id 5.  6 or greater
+		 * leads to a rdmsr in early_init_intel which we can't handle.
+		 * Family ID is returned as bits 8-12 in ax. */
+		*ax &= 0xFFFFF0FF;
+		*ax |= 0x00000500;
 		break;
 	case 0x80000000:
 		/* Futureproof this a little: if they ask how much extended
