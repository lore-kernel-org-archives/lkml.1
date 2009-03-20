Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbZCTTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbZCTTdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZCTTdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:33:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:10740 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZCTTdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D+RCHESs5l6K+6Bay++3c3TW5bWD6mCHWXQusk7WvI0nUcLN8zz5m++ZlAI+23PmHQ
         G243JF33nF7R8a+U74gbwkzWGqxPgSngRD3UFc2yvxNZ9jQZeOIHGplIrtNcRhWi6eeT
         s65Gj03+SY+CEa3s7NkAf0HZ5Ps1oZMxmZxwE=
Date: Fri, 20 Mar 2009 22:33:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Bartlett <ajb.stxsl@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix IO APIC resource allocation error message
Message-ID: <20090320193341.GG7453@localhost>
References: <200903202012.41344.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903202012.41344.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Bartlomiej Zolnierkiewicz - Fri, Mar 20, 2009 at 08:12:41PM +0100]
| From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
| Subject: [PATCH] x86: fix IO APIC resource allocation error message
| 
| Impact: fix incorrect error message
| 
| - IO APIC resource allocation error message contains one too many "be".
| 
| - Print the error message iff there are IO APICs in the system.
| 
| Cc: Alan Bartlett <ajb.stxsl@googlemail.com>
| Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
| ---
| I've seen this error message for some time on my x86-32 laptop...
| 
|  arch/x86/kernel/io_apic.c |    4 ++--
|  1 file changed, 2 insertions(+), 2 deletions(-)
| 
| Index: b/arch/x86/kernel/io_apic.c
| ===================================================================
| --- a/arch/x86/kernel/io_apic.c
| +++ b/arch/x86/kernel/io_apic.c
| @@ -4150,9 +4150,9 @@ static int __init ioapic_insert_resource
|  	int i;
|  	struct resource *r = ioapic_resources;
|  
| -	if (!r) {
| +	if (!r && nr_ioapics > 0) {
|  		printk(KERN_ERR
| -		       "IO APIC resources could be not be allocated.\n");
| +		       "IO APIC resources couldn't be allocated.\n");
|  		return -1;
|  	}
|  
| 

Hi Bartlomiej,

until I miss something I guess you could even make it simplier :)
Something like

---
static int __init ioapic_insert_resources(void)
{
	struct resource *r = ioapic_resources;
	int err;
	int i;

	for (i = 0; i < nr_ioapics; i++) {
		err = insert_resource(&iomem_resource, r);
		if (err) {
			pr_err("IO APIC resources could not be allocated.\n");
			return err;
		}
		r++;
	}

	return 0;
}
---

Now we would have 'err' here and get out only on conflicting resource.
Did I miss something?

	- Cyrill -
