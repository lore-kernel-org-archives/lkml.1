Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXCTP2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXCTP2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXCTP2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:28:12 -0400
Received: from waste.org ([66.93.16.53]:44613 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXCTP2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:28:11 -0400
Date: Tue, 20 Mar 2007 10:15:30 -0500
From: Matt Mackall <mpm@selenic.com>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version 2.6.20.1)
Message-ID: <20070320151530.GD4892@waste.org>
References: <45FEB8B7.7020200@sciensis.com> <20070319225858.GK10459@waste.org> <003501c76afe$3c797a20$0864a8c0@scs1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003501c76afe$3c797a20$0864a8c0@scs1>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 04:44:01PM +0200, Tasos Parisinos wrote:
> >>+    /* Pre-allocate some auxilliary mpis */
> >>+    rsa_echo("Preallocating %lu bytes for auxilliary operands\n",
> >>+         RSA_AUX_SIZE * RSA_AUX_COUNT * sizeof(_u32));
> >
> >And printk.
> 
> i made such a printk wrapper not to mess with all the printk instances when 
> i needed to
> does this hurt, to be left as is?

It's not horrible, but it's not pretty either.

> >>+    memset(&aux, 0, sizeof(aux));
> >>+    for(i = 0; i < RSA_AUX_COUNT; i++) {
> >>+        retval = rsa_mpi_alloc(&aux[i], RSA_AUX_SIZE);
> >
> >kmalloc, please? RSA_AUX_SIZE appears to be in bytes.
> 
> I need such a wrapper because there are other things done in rsa_mpi_alloc
> than kmalloc

Did you see my comment about removing all the rsa_ prefixes from the
MPI functions?

> >>+    /* Copy the data */
> >>+    for(i = size - 1, j = 0; i >= 0; i--, j++)
> >>+        buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
> >
> >Ew.
> 
> not obvious eh? ok will break it apart

You probably want to do it using ntohl.

> >>+        buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
> >
> >That mess looks familiar.
> >
> 
> not obvious as well, will break it apart

Well, it probably wants a function call.

> 
> >>+#define RSA_AUX_COUNT         CONFIG_RSA_AUXCOUNT
> >>+#define RSA_AUX_SIZE         CONFIG_RSA_AUXSIZE
> >
> >Just use the config value.
> >
> >>+#define RSA_MAX_U32        0xFFFFFFFF
> >
> >I'm sure we've got this somewhere.
> 
> if you could tell me i will fix it

Hmmm, odd. I can't find one. There are plenty of things that roll
their own though.

> >>+/* Mpi utility functions */
> >>+static _err        rsa_mpi_alloc(mpi **, _i32);
> >>+static void         rsa_mpi_free(mpi *);
> >>+static _err         rsa_mpi_init(mpi **, _u8 *, _u32, _u32);
> >>+static _err         rsa_mpi_resize(mpi **, _i32, _u8);
> >>+static _err         rsa_mpi_set(mpi **, _u8 *, _u32);
> >>+static inline _err     rsa_mpi_copy(mpi **, mpi *);
> >>+static void         rsa_mpi_print(mpi *, _u8);
> >
> >Why are you declaring a bunch of static functions in a header file?
> >
> 
> i think the compiler will disagree if i dont, but i will give it a try

static at the global level marks something as internal to a
compilation unit. We generally put these sorts of private declarations
straight into the .c file.

And we often skip such prototypes entirely if the .c file can be
ordered such that no forward declarations are necessary.

-- 
Mathematics is the supreme nostalgia of our time.
