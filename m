Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZHaANm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZHaANm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 20:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZHaANl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 20:13:41 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:33590 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbZHaANk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 20:13:40 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2009 20:13:40 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=WpJh3/T3gf3qC/FX6z/2nmi0BQ9XGwu2bapwPTg946w5S96cVc9TcBN4Zn5HmaHH5T
         x1Z01aamWdXzcxUc9OowgTfb2m+4nq+FN8pk9TjHKL1XKYQObNzPIDes+sUCY8ckjcRR
         tl60W8Akzns4rxQ6U7YQGQSif07w+k2LbPgWY=
Date: Sun, 30 Aug 2009 20:06:56 -0400
From: Celejar <celejar@gmail.com>
To: Sebastian Andrzej Siewior <sebastian@ml.breakpoint.cc>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Jonas Meurer <jonas@freesources.org>, 541835@bugs.debian.org,
       lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
 dependencies broken
Message-Id: <20090830200656.dbd56f89.celejar@gmail.com>
In-Reply-To: <20090830153722.GA28497@Chamillionaire.breakpoint.cc>
References: <20090825195852.1dfacb6c.celejar@gmail.com>
	<20090827095516.6817be1e.randy.dunlap@oracle.com>
	<20090827183500.GC24973@resivo.wgnet.de>
	<20090827123401.86cd4319.randy.dunlap@oracle.com>
	<20090828080056.GA3204@Chamillionaire.breakpoint.cc>
	<20090830153722.GA28497@Chamillionaire.breakpoint.cc>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Aug 2009 17:37:22 +0200
Sebastian Andrzej Siewior <sebastian@ml.breakpoint.cc> wrote:

> * Sebastian Andrzej Siewior | 2009-08-28 10:00:56 [+0200]:
> 
> >>> the problem is not reproducible with a debian/unstable 2.6.30.6 kernel,
> >>> even though it has cbc compiled as module as well. but if I recompile
> >>> the same kernel sources with Celejars kernel .config, the problem
> >>> occurs. thus it must be related to the kernel config in some way.
> >It must be the kernel confing since I run .30.stable and it works. I try
> >to look at it later.
> 
> Your kernel config is fine, the problem is that the initramfs tools do
> not copy all of the required modules into the initramfs. The missing
> modles are:
> - cryptomgr: that one is responsible to load the cbc and aes module and
>   bind them to cbc(aes)
> - chainiv: that one creates IVs if the "user" does not specify one.
>   dm-crypt probably does not use that one but is required due to the way
>   crypto works atm.
> - krng: provides random numbers and is required by chainiv.
> 
> If you add those three to /etc/initramfs/modules than it should work.

Right your are!  It now works, thanks very much.  I guess the catch was
that the working (stock Debian) kernel config built cryptomgr
(CRYPTO_MANAGER and CRYPTO_MANAGER2) and krng (CRYPTO_RNG2, although
not CRYPTO_RNG) and chainiv (CRYPTO_BLKCIPHER2, although not
CRYPTO_BLKCIPHER - I have the impression that chainiv is now
controlled by the BLKCIPHER options?) into the kernel, not as modules,
so I wasn't hit by the initramfs failure until I built them as modules
(I have a bit of a fetish for building everything as a module,
especially when using initrd's :/).

> Could someone please look at initramfs to figure out why those three
> modules are not copied in this reduced setup?

Celejar
-- 
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

