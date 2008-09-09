Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYIIMIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYIIMIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYIIMI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:08:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:33584 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbYIIMIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:08:25 -0400
Message-ID: <48C66727.9090600@windriver.com>
Date: Tue, 09 Sep 2008 07:08:07 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: sonic zhang <sonic.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH][kgdb] Make mem access function weak in kgdb.c.
References: <1220940220.30906.6.camel@eight.analog.com>
In-Reply-To: <1220940220.30906.6.camel@eight.analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2008 12:08:07.0869 (UTC) FILETIME=[B88F86D0:01C91274]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sonic zhang wrote:
> L1 instruction memory and MMR memory on blackfin can not be accessed by
> common functions probe_kernel_read() and probe_kernel_write().
> Blackfin asks for 2/4 byte align access to MMR memory and DMA access to L1
> instruction memory. These functions need to be reimplemented in
> architecture specific kgdb.c.
>

This patch is a reasonable change if you are looking to use the common
kgdb code, however your patch needs some further work in that the
documentation and prototypes in include/linux/kgdb.h file need to be
updated as well.

--- functions from your patch ---
>
> -int kgdb_mem2hex(char *mem, char *buf, int count)
> +int __weak kgdb_mem2hex(char *mem, char *buf, int count)


> -static int kgdb_ebin2mem(char *buf, char *mem, int count)
> +int __weak kgdb_ebin2mem(char *buf, char *mem, int count)


> -int kgdb_hex2mem(char *buf, char *mem, int count)
> +int __weak kgdb_hex2mem(char *buf, char *mem, int count)
--------------------

In include/linux/kgdb.h you have:
    270 extern int kgdb_mem2hex(char *mem, char *buf, int count);
    271 extern int kgdb_hex2mem(char *buf, char *mem, int count);

The above two lines need to be changed by your patch, as well as
adding a definition for the ebin2mem, because we do not want to make
new sparse warnings run have something link to the wrong function with
the various revs of gcc out there.

To fix the documentation, you add some extra information to the
comments preceding the functions prototype in include/linux/kgdb.h,
there are other examples in the same file. IE:

/**
 *      kgdb_mem2hex - (optional arch overide) traslate bin to hex chars
 *      @mem: source buffer
 *	@buf: target buffer
 *      @count: number of bytes in mem
 *
 *      Archictures which do not support probe_kernel_(read|write), 
 *	can make an alternate implmentation of this function.
 *	This function safely reads memory to into hex
 *	characters for use with the kgdb protocol.
 */
int __weak kgdb_mem2hex(char *mem, char *buf, int count);



The other approach here would be to consider changing the
probe_kernel_write() and probe_kernel_read() to work safely on the
black fin architecture, then you would not need to have an
architecture specific override for these kgdb internals.  In the long
run, I suspect other kernel functionality may use the probe_kernel_*
functions so you might consider this.  Regardless of the direction you
choose, I have no strong objection to accepting your patch if you make
the requested changes.

Thanks,
Jason.
