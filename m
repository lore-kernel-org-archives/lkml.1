Return-Path: <linux-kernel-owner+w=401wt.eu-S932315AbXK3HCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbXK3HCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 02:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbXK3HBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 02:01:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757374AbXK3HBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 02:01:47 -0500
Date: Thu, 29 Nov 2007 23:00:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@debian.org>
Subject: Re: [BUG] 2.6.24-rc3-git2 softlockup detected
Message-Id: <20071129230047.1b482562.akpm@linux-foundation.org>
In-Reply-To: <20071130063929.GD2754@fattire.cabal.ca>
References: <474D0AAC.5010005@linux.vnet.ibm.com>
	<20071127225328.9e3f3827.akpm@linux-foundation.org>
	<474D15FF.5080508@linux.vnet.ibm.com>
	<20071127232552.ad16e95c.akpm@linux-foundation.org>
	<474E5CAC.9000108@linux.vnet.ibm.com>
	<20071129003533.54b4b20e.akpm@linux-foundation.org>
	<20071130063929.GD2754@fattire.cabal.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 01:39:29 -0500 Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Thu, Nov 29, 2007 at 12:35:33AM -0800, Andrew Morton wrote:
> > ten million is close enough to infinity for me to assume that we broke the
> > driver and that's never going to terminate.
> > 
> 
> how about this? doesn't break things on my pa8800:
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
> index 463f119..ef01cb1 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
> @@ -1037,10 +1037,13 @@ restart_test:
>  	/*
>  	 *  Wait 'til done (with timeout)
>  	 */
> -	for (i=0; i<SYM_SNOOP_TIMEOUT; i++)
> +	do {	
>  		if (INB(np, nc_istat) & (INTF|SIP|DIP))
>  			break;
> -	if (i>=SYM_SNOOP_TIMEOUT) {
> +		msleep(10);
> +	} while (i++ < SYM_SNOOP_TIMEOUT);
> +
> +	if (i >= SYM_SNOOP_TIMEOUT) {
>  		printf ("CACHE TEST FAILED: timeout.\n");
>  		return (0x20);
>  	}
> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> index ad07880..85c483b 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> @@ -339,7 +339,7 @@
>  /*
>   *  Misc.
>   */
> -#define SYM_SNOOP_TIMEOUT (10000000)
> +#define SYM_SNOOP_TIMEOUT (1000)
>  #define BUS_8_BIT	0
>  #define BUS_16_BIT	1
>  

That might be the fix, but do we know what we're actually fixing?  afaik
2.6.24-rc3 doesn't get this timeout, 2.6.24-rc3-mm2 does get it and we
don't know why?


