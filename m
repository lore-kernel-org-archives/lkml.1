Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYLJBPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYLJBPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYLJBPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:15:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:22841 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbYLJBPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:15:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IcEizuFoGo+iiuW9HbKC610FRDem1NRmc2jReaGzjagVy9wsCeAtqT0qokCuLWYQuB
         E2RW47S5pDijI8iVw0173gs0xXeko/FobupDqjPDdlIpbTjay1YHu2phLQYUFMI5NKN6
         FYZjRDooJaDdG3WR489fLpWT9YK5Eabz6pToc=
Message-ID: <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
Date: Tue, 9 Dec 2008 17:15:05 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Zachary Amsden" <zach@vmware.com>, "Huang Ying" <ying.huang@intel.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
Cc: norman@thebacks.co.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Alok Kataria" <alokkataria1@gmail.com>,
       "=?ISO-8859-1?Q?Bruno_Pr=E9mont?=" <"bruno .premont"@restena.lu>,
       xl@xlsigned.net, dsd@gentoo.org
In-Reply-To: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
X-Google-Sender-Auth: 3f14d5fae25f7051
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 4:50 PM, Zachary Amsden <zach@vmware.com> wrote:
> Patches backported into 2.6.27.4 caused a regression with VMI kernels
> running on VMware which ends in a page fault during boot.  I have a fix
> which still allows DMI checks to be done early.
>
> The best fix is perhaps to move early_ioremap_init() after vmi_init().
> The only things done before VMI init are basic memory access, things
> like collating the memory map, collecting boot CPUID capabilities, and
> parsing the early command line options... which vmi_init needs.
>
> Since this went back into 2.6.27, it needs to go to both 2.6.28 and
> eventually to stable.  I didn't add any comments or anything as there
> could be some debate what the proper ordering should be.  In case that
> becomes an interesting discussion, there are two relevant facts in git
> today:
>
> 1) no clients of early_ioremap occur before DMI.
> 2) VMI requires access to early boot params.
>
> If any can suggest a better ordering, I am certainly open to that as
> well.

VMI initialiation can relocate the fixmap, causing early_ioremap
to malfunction if it is initialized before the relocation.  The
ioremap area is low enough in virtual address space that no actual
collision occurs, however, because the pagetables for it were not
allocated under VMI mode, the pagetable updates are dropped by
the hypervisor as irrelevant, resulting in a crash on boot.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..9627753 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -795,7 +795,6 @@ void __init setup_arch(char **cmdline_p)
 #endif

 	early_cpu_init();
-	early_ioremap_init();

 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
@@ -888,6 +887,8 @@ void __init setup_arch(char **cmdline_p)
 	vmi_init();
 #endif

+	early_ioremap_init();
+
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();


you can not move that late,

parse_setup_data==>early_memremap==>__early_ioremap

YH
