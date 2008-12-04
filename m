Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYLDFex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYLDFex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYLDFen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:34:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:41712 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYLDFem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YGbgaIT3tWErt7MnhGRNGTaGH4KeSdwrLyFv/R4jkUbiGLw17nxtmcyIJY1AVHYgw/
         mZTpQIt+rIpkZLjiPqowAPxACb+cGCus0Ce9NdTqdmaK+s//jvyntEAog4E110kHgDRc
         aNLZyq7r/HE1MpJUJBEl2citGaQ/PgPOJiuRc=
Message-ID: <208aa0f00812032134l5d0df1d9pa1359aba6e719e26@mail.gmail.com>
Date: Wed, 3 Dec 2008 21:34:40 -0800
From: "Edward Estabrook" <edward.estabrook.lkml@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA (corrected)
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hjk@linutronix.de,
       edward.estabrook@gmail.com, edward_estabrook@agilent.com
In-Reply-To: <20081204041739.GA16329@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
	 <20081204041739.GA16329@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, what about 64bit processors?  What happens if they try to use a
> valid address in this range?
>
> Is this value always an "invalid" value for all arches that Linux runs
> on?

Yes. I have run this on 64-bit systems.

The offset parameter in UIO is used to specify the memory-mapping index
of interest, where offset = N * getpagesize().

In include/linux/uio_driver.h we had:
#define MAX_UIO_MAPS 5

so assuming a page size of 4k the maximum legal value was 0x5000.

This logic is equally true on in any architecture.

With the dynamic DMA allocation one can now have an arbitrarily large
number of mappings.  This magic number simply reduces the theoretical limit
to the number of distinct mappings to of 1,048,574.

Note that even if the in-kernel driver-stub choose to overload the mmap method
both the original code and these modifications would error out on any value
which did not correlate with a valid memory-mapping index number before
handing control to the overloaded implementation.
