Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbXJCJos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbXJCJos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXJCJok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:44:40 -0400
Received: from gw-lon-cluster.cmcnet.net ([195.20.122.6]:25433 "EHLO
	emearelay1.cmcmarkets.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751301AbXJCJok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:44:40 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 05:44:39 EDT
Subject: Re: [PATCH 5/5] lguest: loading bzImage directly
From: Chris Malley <mail@chrismalley.co.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, lguest <lguest@ozlabs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1191368457.17826.53.camel@localhost.localdomain>
References: <1191368052.17826.40.camel@localhost.localdomain>
	 <1191368106.17826.43.camel@localhost.localdomain>
	 <1191368154.17826.44.camel@localhost.localdomain>
	 <1191368217.17826.47.camel@localhost.localdomain>
	 <1191368399.17826.51.camel@localhost.localdomain>
	 <1191368457.17826.53.camel@localhost.localdomain>
Date: Wed, 03 Oct 2007 10:37:01 +0100
Message-Id: <1191404221.17247.15.camel@feisty>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-MIMETrack: Itemize by SMTP Server on smtp3/CMC(Release 7.0.2FP1|January 10, 2007) at
 10/03/2007 10:39:30 AM,
	Serialize by Router on emearelay1/UK/CMC(Release 7.0.2FP1|January 10, 2007) at
 03/10/2007 10:44:40 AM,
	Serialize complete at 03/10/2007 10:44:40 AM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys

Would it not be clearer to #include <asm/bootparam.h> and use 
the relevant named members of struct setup_header / struct boot_params
rather than the hard-coded values 0x202, 0x1F1, 0x214 ?

--
Chris


On Wed, 2007-10-03 at 09:40 +1000, Rusty Russell wrote:
[snip]
> +	u8 hdr[1024];
> +	int r;
> +	/* Modern bzImages get loaded at 1M. */
> +	void *p = from_guest_phys(0x100000);
> +
> +	/* Go back to the start of the file and read the header.  It should be
> +	 * a Linux boot header (see Documentation/i386/boot.txt) */
> +	lseek(fd, 0, SEEK_SET);
> +	read(fd, hdr, sizeof(hdr));
> +
> +	/* At offset 0x202, we expect the magic "HdrS" */
> +	if (memcmp(hdr + 0x202, "HdrS", 4) != 0)
> +		errx(1, "This doesn't look like a bzImage to me");
> +
> +	/* The byte at 0x1F1 tells us how many extra sectors of
> +	 * header: skip over them all. */
> +	lseek(fd, (unsigned long)(hdr[0x1F1]+1) * 512, SEEK_SET);
> +
> +	/* Now read everything into memory. in nice big chunks. */
> +	while ((r = read(fd, p, 65536)) > 0)
> +		p += r;
> +
> +	/* Finally, 0x214 tells us where to start the kernel. */
> +	return *(unsigned long *)&hdr[0x214];
>  }
>  
>  /*L:140 Loading the kernel is easy when it's a "vmlinux", but most kernels
> 


