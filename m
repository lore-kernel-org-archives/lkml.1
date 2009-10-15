Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbZJODaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbZJODaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZJODaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:30:23 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:48008 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZJODaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:30:22 -0400
MIME-Version: 1.0
Message-ID: <0be3e26b-76b6-47c9-b7ab-51ed72b72b69@default>
Date: Wed, 14 Oct 2009 20:26:48 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
Subject: RE: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
In-Reply-To: <1255548516-15260-6-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AD696DA.0087:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Other tsc-based clocksources add a monotonicity test to make 
> sure there's
> no regression in the returned cycles.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/time.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 0a5aa44..00f06cc 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -213,9 +213,14 @@ cycle_t xen_clocksource_read(void)
>  	return ret;
>  }
>  
> +static struct clocksource xen_clocksource;
> +
>  static cycle_t xen_clocksource_get_cycles(struct clocksource *cs)
>  {
> -	return xen_clocksource_read();
> +	cycle_t ret = xen_clocksource_read();
> +
> +	return ret >= xen_clocksource.cycle_last ?
> +		ret : xen_clocksource.cycle_last;

As long as we are going through the trouble of making
this monotonic, shouldn't it be monotonically increasing
(rather than just monotonically non-decreasing)?  The
rdtsc instruction and any suitably high-precision
hardware timer will never return the same value
on subsequent uses so this might be a reasonable
precedent to obey.  E.g.

+	return ret > xen_clocksource.cycle_last ?
+		ret : ++xen_clocksource.cycle_last;
