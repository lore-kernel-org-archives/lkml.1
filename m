Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbZCTUAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbZCTUAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbZCTUAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:00:05 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51724 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZCTUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=oDAb161PgZ3WZWVcOKbu7cl89ManK+0Ubf0L5rKxGXmQ52MOiilRSByDvfgCY/lIjk
         jb4eobgMgAvPseqMGeXNJFlp5e/bDPaSNAkiMlYf4oiaWMCOAPMv2QsSaj+OEh8Zlmor
         +yZa78x9a2/m6hjVay025bnve1Kj+6M9rwsmQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix IO APIC resource allocation error message
Date: Fri, 20 Mar 2009 21:00:30 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-next-20090319; KDE/4.2.1; i686; ; )
Cc: Alan Bartlett <ajb.stxsl@googlemail.com>, linux-kernel@vger.kernel.org
References: <200903202012.41344.bzolnier@gmail.com> <20090320192323.GG6224@elte.hu>
In-Reply-To: <20090320192323.GG6224@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903202100.30789.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 March 2009, Ingo Molnar wrote:
> 
> * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] x86: fix IO APIC resource allocation error message
> > 
> > Impact: fix incorrect error message
> > 
> > - IO APIC resource allocation error message contains one too many "be".
> > 
> > - Print the error message iff there are IO APICs in the system.
> > 
> > Cc: Alan Bartlett <ajb.stxsl@googlemail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > I've seen this error message for some time on my x86-32 laptop...
> > 
> >  arch/x86/kernel/io_apic.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: b/arch/x86/kernel/io_apic.c
> > ===================================================================
> > --- a/arch/x86/kernel/io_apic.c
> > +++ b/arch/x86/kernel/io_apic.c
> > @@ -4150,9 +4150,9 @@ static int __init ioapic_insert_resource
> >  	int i;
> >  	struct resource *r = ioapic_resources;
> >  
> > -	if (!r) {
> > +	if (!r && nr_ioapics > 0) {
> >  		printk(KERN_ERR
> > -		       "IO APIC resources could be not be allocated.\n");
> > +		       "IO APIC resources couldn't be allocated.\n");
> >  		return -1;
> >  	}
> 
> looks good, but there's one weirdness:
> 
> so if nr_ioapics == 0 && !r we'll drop into this codepath:
> 
>         for (i = 0; i < nr_ioapics; i++) {
>                 insert_resource(&iomem_resource, r);
>                 r++;
>         }
> 
>         return 0;
> 
> we survive the loop by luck, and then return 0 - which we'll survive 

s/by luck/by design/ -- we want to return 0 and thus have the correct
return value of the initcall

> too but still it's a bit unexpected and hence fragile.

agreed on this one

> So i think we should rather add a standalone:
> 
> 	if (nr_ioapics > 0)
>   		printk(KERN_ERR
> 
> check to the printk only. That wont affect the remaining code flow.

here is the revised version

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] x86: fix IO APIC resource allocation error message (take 2)

Impact: fix incorrect error message

- IO APIC resource allocation error message contains one too many "be".

- Print the error message iff there are IO APICs in the system.

Cc: Alan Bartlett <ajb.stxsl@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I've seen this error message for some time on my x86-32 laptop...

 arch/x86/kernel/io_apic.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: b/arch/x86/kernel/io_apic.c
===================================================================
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -4151,9 +4151,12 @@ static int __init ioapic_insert_resource
 	struct resource *r = ioapic_resources;
 
 	if (!r) {
-		printk(KERN_ERR
-		       "IO APIC resources could be not be allocated.\n");
-		return -1;
+		if (nr_ioapics > 0) {
+			printk(KERN_ERR
+				"IO APIC resources couldn't be allocated.\n");
+			return -1;
+		}
+		return 0;
 	}
 
 	for (i = 0; i < nr_ioapics; i++) {
