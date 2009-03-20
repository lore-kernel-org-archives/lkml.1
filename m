Return-Path: <linux-kernel-owner+w=401wt.eu-S1761088AbZCTUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761088AbZCTUAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbZCTUAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:00:07 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41804 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZCTUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=T7vuwH7WUAZvhtPfL0boRdqq0HtMvEwIIsQld21ck17gpHMPWORB0CNkJ8tMeF+cer
         Z0ckBsjLOWguJ1V51orzi7KiL7qhS+XEmKJmDuwhUKtomfXmptOs3Z26yANF0w0oQ5G8
         NYkadIZkCKa3kxIg41mncB63cg1WVkVjQ7Nzg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: fix IO APIC resource allocation error message
Date: Fri, 20 Mar 2009 21:02:28 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-next-20090319; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Alan Bartlett <ajb.stxsl@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <200903202012.41344.bzolnier@gmail.com> <20090320193341.GG7453@localhost>
In-Reply-To: <20090320193341.GG7453@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903202102.28585.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 March 2009, Cyrill Gorcunov wrote:
> [Bartlomiej Zolnierkiewicz - Fri, Mar 20, 2009 at 08:12:41PM +0100]
> | From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> | Subject: [PATCH] x86: fix IO APIC resource allocation error message
> | 
> | Impact: fix incorrect error message
> | 
> | - IO APIC resource allocation error message contains one too many "be".
> | 
> | - Print the error message iff there are IO APICs in the system.
> | 
> | Cc: Alan Bartlett <ajb.stxsl@googlemail.com>
> | Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> | ---
> | I've seen this error message for some time on my x86-32 laptop...
> | 
> |  arch/x86/kernel/io_apic.c |    4 ++--
> |  1 file changed, 2 insertions(+), 2 deletions(-)
> | 
> | Index: b/arch/x86/kernel/io_apic.c
> | ===================================================================
> | --- a/arch/x86/kernel/io_apic.c
> | +++ b/arch/x86/kernel/io_apic.c
> | @@ -4150,9 +4150,9 @@ static int __init ioapic_insert_resource
> |  	int i;
> |  	struct resource *r = ioapic_resources;
> |  
> | -	if (!r) {
> | +	if (!r && nr_ioapics > 0) {
> |  		printk(KERN_ERR
> | -		       "IO APIC resources could be not be allocated.\n");
> | +		       "IO APIC resources couldn't be allocated.\n");
> |  		return -1;
> |  	}
> |  
> | 
> 
> Hi Bartlomiej,
> 
> until I miss something I guess you could even make it simplier :)
> Something like
> 
> ---
> static int __init ioapic_insert_resources(void)
> {
> 	struct resource *r = ioapic_resources;
> 	int err;
> 	int i;
> 
> 	for (i = 0; i < nr_ioapics; i++) {
> 		err = insert_resource(&iomem_resource, r);
> 		if (err) {
> 			pr_err("IO APIC resources could not be allocated.\n");
> 			return err;
> 		}
> 		r++;
> 	}
> 
> 	return 0;
> }
> ---
> 
> Now we would have 'err' here and get out only on conflicting resource.
> Did I miss something?

nr_ioapics > 0 && r == NULL ?
