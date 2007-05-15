Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXEOKEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXEOKEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 06:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbXEOKDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 06:03:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:32182 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141AbXEOKDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 06:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PnF++NPL12Cmo4Zkx5tGbYHKNoAmWi9yvrR0uYNx0+NLqTwszrwP96cHBIw6iM7Xw8jKt9PUzAjLVS3KpE8Dg2wPKV5U+ithvHqa9Ce0l7CBezFs5yxFy7M5UwzY/p14Eske9GYtqxk6iUjik+1rp3dcTaF5P0T4ONrB+BLe86s=
Message-ID: <a781481a0705150303y587ea18dt435f2fc45a671226@mail.gmail.com>
Date: Tue, 15 May 2007 15:33:50 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Li Yang-r58472" <LeoLi@freescale.com>
Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Cc: "Kumar Gala" <galak@kernel.crashing.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       Linus <torvalds@linux-foundation.org>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <989B956029373F45A0B8AF0297081890B76040@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705141717v2669805aoa590bfd54da7856b@mail.gmail.com>
	 <989B956029373F45A0B8AF0297081890B76040@zch01exm26.fsl.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Li Yang-r58472 <LeoLi@freescale.com> wrote:
> > [...]
> > Actually, once __init_refok comes in, would we need any other
> > whitelisting mechanism at all? I think the exception patterns in
> > secref_whitelist() and those two other whitelisting functions
> > (init_section_ref_ok and exit_section_ref_ok) could all be
> > subsumed and made redundant if / when __init_refok is used
> > in the actual sources.
>
> I don't think so.  __init_refok can be used to mark special functions
> which are legitimate to reference .init.text/.init.data

But I have slightly different (reversed) semantics for __init_refok
in mind. Basically, we use __init_refok to annotate _callees_
and not _callers_. In short, __init_refok is a _type_ of __init
section that other sections can freely reference to, without
modpost complaining about this. [ had suggested this in some
previous thread earlier ]

The __init_refok-for-callees mechanism could be useful to
reduce duplication, having to mark lesser number of functions,
and also make most of those exception patterns in modpost.c
redundant.

Ultimately, we want modpost to shut up for some known false
positives. Currently we have 9 exception patterns, 'n' number
of special sections hard-coded in modpost.c, 3 whitelisting
functions and also the __init_refok thing that can be used
directly to mark functions in the sources. But modpost
doesn't really care _how_ a particular case got whitelisted.

Using _only_ the __init_refok (easily greppable in the sources)
annotation for callees could help keep all such special cases
manageable and in control, compared to several different ways
to dodge modpost warnings.

> but cannot be used to mark special sections.

Yes, so mark the special _callees_ as __init_refok.
