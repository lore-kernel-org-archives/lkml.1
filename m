Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYHLQBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYHLQBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYHLQBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:01:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:58918 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbYHLQBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:01:23 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Milan Broz <mbroz@redhat.com>
Subject: Re: 2.6.27-rc1 and 2.6.26.1: critical thermal shutdown on thinkpad x60 (bisected)
Date: Tue, 12 Aug 2008 18:01:18 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Greg Kroah-Hartman" <gregkh@novell.com>, stable@kernel.org
References: <20080806090246.GA1572@elf.ucw.cz> <48A1A4F6.9080706@redhat.com> <48A1B0CB.9050908@redhat.com>
In-Reply-To: <48A1B0CB.9050908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121801.21374.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 17:48:27 Milan Broz wrote:
> >>>> yes. maybe some userspace tool controlling frequency is involved, no
> >>>> idea yet. But it is 2.6.26 tree for sure.
> >>>
> >>> So it definitely is in 2.6.26.2, and it definitely is in 2.6.26?
> >
> > The bug is _not_ in 2.6.26, it was introduced in 2.6.26.1.
> >
> > The problem is, that now the CPU frequency doesn't decrease at some
> > temperature level and fan is unable to cool it properly.
Hmm, the machine should still not shut down. We need the virtual
passive trip point...
> >
> > bisect on 2.6.26.y tree finished in this patch:
> > (I expect similar patch in 2.6.27-rc)
> >
> > commit 04f496871e8af87a1e40c504371a206fd7389193
> > Author: Thomas Renninger <trenn@suse.de>
> > Date:   Wed Jul 30 18:20:10 2008 +0000
>
> and this seems to fix it for me:
> --
>
> Do not use unsigned int if there is test for negative number...
>
> See drivers/acpi/processor_perflib.c
>   static unsigned int ignore_ppc = -1;
> ...
>   if (event == CPUFREQ_START && ignore_ppc <= 0) {
>        ignore_ppc = 0;
> ...
>
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  drivers/acpi/processor_perflib.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.26.y/drivers/acpi/processor_perflib.c
> ===================================================================
> --- linux-2.6.26.y.orig/drivers/acpi/processor_perflib.c	2008-08-12
> 17:20:07.000000000 +0200 +++
> linux-2.6.26.y/drivers/acpi/processor_perflib.c	2008-08-12
> 17:35:53.000000000 +0200 @@ -70,7 +70,7 @@ static
> DEFINE_MUTEX(performance_mutex);
>   *  0 -> cpufreq low level drivers initialized -> consider _PPC values
>   *  1 -> ignore _PPC totally -> forced by user through boot param
>   */
> -static unsigned int ignore_ppc = -1;
> +static int ignore_ppc = -1;
Ohh dear..., what kind of obvious bug have I introduced.

Thanks a lot!

         Thomas
