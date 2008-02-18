Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYBRKjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYBRKjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbYBRKjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:39:45 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39350
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751767AbYBRKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:39:45 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Roland McGrath <roland@redhat.com>
Subject: Re: Compiling with 2.6.25-rc2 with binutils 2.17 fails?
Date: Mon, 18 Feb 2008 04:39:41 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200802161727.21312.rob@landley.net> <20080218030910.C2CB1270195@magilla.localdomain>
In-Reply-To: <20080218030910.C2CB1270195@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802180439.41928.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008 21:09:10 Roland McGrath wrote:
> > Still trying to track down why, but it works on a toolchain built from
> > binutils 2.18 and gcc 4.1.3, but not with a toolchain from binutils 2.17
> > and gcc 4.1.2.  And considering where it's failing...
>
> I don't think the vdso magic should require so new a binutils.  Please try
> to figure out which of the steps is producing different results between the
> two tool setups.

I'm poking at it.  Something in my cross compiling setup is driving this bit 
screwy:

  i686-nm arch/x86/vdso/vdso32-sysenter.so.dbg | 
sed -n -e 's/^00*/0/' -e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$/ = 
0x;/p' | LC_ALL=C sort > arch/x86/vdso/vdso32-sysenter-syms.lds
        if LC_ALL=C sort -u arch/x86/vdso/vdso32-int80-syms.lds 
arch/x86/vdso/vdso32-sysenter-syms.lds > arch/x86/vdso/.tmp_vdso32-syms.lds 
&&  if grep -q VDSO32_SYSENTER_RETURN arch/x86/vdso/vdso32-int80-syms.lds; 
then diff -u arch/x86/vdso/.tmp_vdso32-syms.lds 
arch/x86/vdso/vdso32-int80-syms.lds; else sed /VDSO32_SYSENTER_RETURN/d 
arch/x86/vdso/.tmp_vdso32-syms.lds | diff -u - 
arch/x86/vdso/vdso32-int80-syms.lds; fi &&  if grep -q VDSO32_SYSENTER_RETURN 
arch/x86/vdso/vdso32-sysenter-syms.lds; then diff -u 
arch/x86/vdso/.tmp_vdso32-syms.lds arch/x86/vdso/vdso32-sysenter-syms.lds; 
else sed /VDSO32_SYSENTER_RETURN/d arch/x86/vdso/.tmp_vdso32-syms.lds | 
diff -u - arch/x86/vdso/vdso32-sysenter-syms.lds; fi && : ; then mv -f 
arch/x86/vdso/.tmp_vdso32-syms.lds arch/x86/vdso/vdso32-syms.lds; else rm -f 
arch/x86/vdso/.tmp_vdso32-syms.lds; exit 1; fi
--- -   Sun Feb 17 20:24:03 2008
+++ arch/x86/vdso/vdso32-int80-syms.lds Sun Feb 17 20:24:03 2008
@@ -0,0 +1,5 @@
+VDSO32_PRELINK = 0x0;
+VDSO32_rt_sigreturn = 0x040c;
+VDSO32_sigreturn = 0x0400;
+VDSO32_vsyscall = 0x0414;
+VDSO32_vsyscall_eh_frame_size = 0x040;
make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
make: *** [arch/x86/vdso] Error 2

If binutils is involved, it's due to i686-nm...

I'm still trying to puzzle out the "if thing && thing &&:; then" syntax above.  
Never encountered that one before...  A colon?  I'll try to bang on it some 
more tomorrow, it's gone 4am on me...

> Thanks,
> Roland

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
