Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0BCGMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 01:12:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:11625 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0BCGMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 01:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=xlu1zCKJAzcW63fJrdLS6/6COFRCETPffx3GN0JmOR2TvrK+0MIoT4muoW59IoBqfx
         Hty2e58i2YvQpFyVshDEHAjM8SQErp/SgM8YV1ORj3955gNCTAbbCorOhOIjWrqN6tUd
         qTmGzsgrQczrLBvfMqioTBiRcWW/b4NkctGkE=
Date: Wed, 3 Feb 2010 09:12:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Darren Jenkins <darrenrjenkins@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/acpi/ec.c fix a small memory leak
Message-ID: <20100203061225.GB32535@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alexey Starikovskiy <astarikovskiy@suse.de>,
	Darren Jenkins <darrenrjenkins@gmail.com>,
	Kernel Janitors <kernel-janitors@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux ACPI <linux-acpi@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1265112730.4804.8.camel@ICE-BOX> <4B684650.9070807@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B684650.9070807@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 06:35:44PM +0300, Alexey Starikovskiy wrote:
> NAK
> 
> saved_ec is allocated if flag EC_FLAGS_VALIDATE_ECDT is true.
> EC_FLAGS_SKIP_DSDT_SCAN have no sense in such case, thus this new code path
> is never executed.
> On the other hand, unconditionally freeing pointer, which is might be NULL, is not
> right either.

As near as I can tell you are right that the code cannot leak memory.  But Darren 
is right to think that it's calling kfree() on a NULL pointer is OK.  His patch does 
not introduce any errors.

The logic here is basically spaghetti.  Every person who looks at it is going to 
think it's a leak.  Lots of people are going to look at it, because the static
checkers all think it's a leak too.  Someone could send a cleanup patch that makes it
readable.

regards,
dan carpenter

> So, this patch introduced more problems as it tries to solve...
> 
> Regards,
> Alex.
> 
> Darren Jenkins пишет:
> > Plug a very small leak in acpi_ec_ecdt_probe()
> > 
> > Coverity CID: 13319
> > 
> > Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com> 
> > 
> > diff --git drivers/acpi/ec.c drivers/acpi/ec.c
> > index d6471bb..13061dc 100644
> > --- drivers/acpi/ec.c
> > +++ drivers/acpi/ec.c
> > @@ -1009,8 +1009,10 @@ int __init acpi_ec_ecdt_probe(void)
> >  	/* fall through */
> >  	}
> >  
> > -	if (EC_FLAGS_SKIP_DSDT_SCAN)
> > +	if (EC_FLAGS_SKIP_DSDT_SCAN) {
> > +		kfree(saved_ec);
> >  		return -ENODEV;
> > +	}
> >  
> >  	/* This workaround is needed only on some broken machines,
> >  	 * which require early EC, but fail to provide ECDT */
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
