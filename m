Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZEHMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZEHMsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZEHMsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:48:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:63663 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZEHMsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:48:08 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 08:48:08 EDT
X-IronPort-AV: E=Sophos;i="4.40,317,1238990400"; 
   d="scan'208";a="50481805"
Subject: Re: [PATCH 06/16] xen: disable PAT
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <20090508111432.GF11596@elte.hu>
References: <1241730653-4688-1-git-send-email-jeremy@goop.org>
	 <1241730653-4688-7-git-send-email-jeremy@goop.org>
	 <20090508111432.GF11596@elte.hu>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 8 May 2009 13:38:31 +0100
Message-ID: <1241786311.16804.56.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 07:14 -0400, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > From: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Impact: disable PAT under Xen
> > 
> > Xen imposes a particular PAT layout on all paravirtual guests which
> > does not match the layout Linux would like to use.
> > 
> > Force PAT to be disabled until this is resolved.
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> hm, what will the resolution be?

Roughly speaking the kernel needs to cope with different values written
to MSR_IA32_CR_PAT than the single hard coded value it would write
itself if given the chance. Essentially _PAGE_CACHE_* need to become
dynamic (or I guess we could change the native layout to match Xen's, I
don't know why native differs from the initial state, I guess just to
avoid using the PAT bit for some reason).

The various mappings used are:
	PAT PCD PWT	NATIVE	XEN	BIOS	INIT
        0   0   0	WB	WB	WB	WB
        0   0   1	WC	WT	WT	WT
        0   1   0	UC-	UC-	UC-	UC-
        0   1   1	UC	UC	-	UC
        1   0   0	-	WC	WB	WB
        1   0   1	-	WP	WT	WT
        1   1   0	-	-	UC-	UC-
        1   1   1	-	-	-	UC-
(INIT is the processors initial state and BIOS is apparently commonly
set by the BIOS).

At the time this changeset was originally written using the actual PAT
bit (required by Xen's layout to get at WC) led to strange errors (to do
with swap masking various bits IIRC) but I believe those have been fixed
since by Jan Beulich.

I'm not sure how _PAGE_PAT_LARGE fits in -- native cunning avoids having
to worry about it by not using the PAT bit at all.

Ian.


