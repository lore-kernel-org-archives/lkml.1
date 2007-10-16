Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXJPICr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXJPICr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXJPICb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:02:31 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:35872 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753873AbXJPICa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:02:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g4lJeOPy7hau54SHaunwusH1x5qgZ9gU9jRGp7gm45KrMjW6Krz92Xd16CjmoWSLguSnj8HccmUU+SFftcS3eEntGNj3QE26ii66WMdvpM5mwpIHzFfXir7BlB9yxZk4HoVpYPrX4s4i9jYifFloEfhfimCdi8bdVFRxH7P7/Kg=  ;
X-YMail-OSG: DaRtrU0VM1kQlxZcgD0JUB0xVFd0J2dZZ1Y0Auj6g5CNlAMzVJ2IP08ddwUcYV6FnGvoerPhoA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [patch][rfc] rewrite ramdisk
Date: Tue, 16 Oct 2007 18:07:40 +1000
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710161747.12968.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710160945110.10197@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710160945110.10197@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161807.41157.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 17:52, Jan Engelhardt wrote:
> On Oct 16 2007 17:47, Nick Piggin wrote:
> >Here's a quick first hack...
>
> Inline patches preferred ;-)

Thanks for reviewing it anyway ;)


> >+config BLK_DEV_BRD
> >+	tristate "RAM block device support"
> >+	---help---
> >+	  This is a new  based block driver that replaces BLK_DEV_RAM.
>
> based on what?         -^

RAM based.


> >+	  To compile this driver as a module, choose M here: the
> >+	  module will be called rd.
>
> called brd.ko.

Changed. But it will hopefully just completely replace rd.c,
so I will probably just rename it to rd.c at some point (and
change .config options to stay compatible). Unless someone
sees a problem with that?


> >+/*
> >+ * And now the modules code and kernel interface.
> >+ */
> >+static int rd_nr;
> >+static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
>
> Perhaps unsigned?
> Perhaps even long for rd_size?

I've taken most of that stuff out of rd.c in an effort to stay
back compatible. I don't know if it really matters to use long?


> >+module_param(rd_nr, int, 0);
> >+MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
> >+module_param(rd_size, int, 0);
> >+MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
> >+MODULE_LICENSE("GPL");
> >+MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
> >+
> >+/* options - nonmodular */
> >+#ifndef MODULE
> >+static int __init ramdisk_size(char *str)
> >+{
> >+	rd_size = simple_strtol(str,NULL,0);
> >+	return 1;
> >+}
>
> Is this, besides for compatibility, really needed?
>
> >+static int __init ramdisk_size2(char *str)
> >+{
> >+	return ramdisk_size(str);
> >+}
> >+static int __init rd_nr(char *str)
>
> Err! Overlapping symbols! The rd_nr() function collides with the rd_nr
> variable.

Thanks... %s gone awry. Fixed to the expected names.


> It also does not seem needed, since it did not exist before. 
> It should go, you can set the variable with brd.rd_nr=XXX (same
> goes for ramdisk_size).

But only if it's a module?


> What's the point of ramdisk_size2()? 

Back compat. When rewriting the internals, I want to try avoid
changing any externals if possible. Whether this is the Right
Way to do it or not, I don't know :P


> >+{
> >+	rd_nr = simple_strtol(str, NULL, 0);
> >+	return 1;
> >+}
> >+__setup("ramdisk=", ramdisk_size);
> >+__setup("ramdisk_size=", ramdisk_size2);
>
> __setup("ramdisk_size=", ramdisk_size); maybe, or does not that work?

Didn't try it, but the rd.c code does the same thing so I guess it
doesn't (or didn't, when it was written).

