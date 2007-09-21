Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbXIUSqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbXIUSqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbXIUSql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:46:41 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:42017 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbXIUSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:46:40 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22.6] nfsd: fh_verify() `malloc failure' with lots of free memory leads to NFS hang
References: <874phtkk25.fsf@hades.wkstn.nix>
	<20070917223600.GA30350@fieldses.org> <87zlzkkfvk.fsf@hades.wkstn.nix>
	<20070918011257.GC2443@fieldses.org>
From: Nix <nix@esperi.org.uk>
Emacs: well, why *shouldn't* you pay property taxes on your editor?
Date: Fri, 21 Sep 2007 19:46:32 +0100
In-Reply-To: <20070918011257.GC2443@fieldses.org> (J. Bruce Fields's message of "Mon, 17 Sep 2007 21:12:57 -0400")
Message-ID: <873ax7ua9j.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Sep 2007, J. Bruce Fields told this:
> Also I suppose we should check which version of nfs-utils that fix is in
> and make sure distributions are getting the fixed nfs-utils before they
> get the new libc, or we're going to see this bug a lot....

Further info. This behaviour, although it is allowed by POSIX, is not
*specified*, as such, by it (ah! ambiguity! life would be so dull
without you!), and is not replicated by any other C library on the face
of the planet.

Further, it's not even the behaviour of glibc, as such.

It's the behaviour of glibc 2.6.x as patched with this Debian-specific
patch:

,----[ any/submitted-fileops-and-signals.diff ]
| Index: glibc-2.6/libio/fileops.c
| ===================================================================
| --- glibc-2.6.orig/libio/fileops.c
| +++ glibc-2.6/libio/fileops.c
| @@ -517,10 +517,19 @@
|      fp->_cur_column = INTUSE(_IO_adjust_column) (fp->_cur_column - 1, data,
|  						 count) + 1;
|    _IO_setg (fp, fp->_IO_buf_base, fp->_IO_buf_base, fp->_IO_buf_base);
| -  fp->_IO_write_base = fp->_IO_write_ptr = fp->_IO_buf_base;
| -  fp->_IO_write_end = (fp->_mode <= 0
| +  if (__builtin_expect (count == to_do, 1))
| +    {
| +      fp->_IO_write_base = fp->_IO_write_ptr = fp->_IO_buf_base;
| +      fp->_IO_write_end = (fp->_mode <= 0
|  		       && (fp->_flags & (_IO_LINE_BUF+_IO_UNBUFFERED))
|  		       ? fp->_IO_buf_base : fp->_IO_buf_end);
| +    }
| +  else if (count > 0 && fp->_IO_write_base == data)
| +    {
| +      memmove (data, data+count, 
| +               fp->_IO_write_ptr - fp->_IO_write_base - count);
| +      fp->_IO_write_ptr -= count;
| +    }
|    return count;
|  }
|  
`----

This patch also breaks at least bash and zsh as well as nfs-utils (see
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=429021>) and I sort of
suspect it's not long for this world as a result.

So this is much less nasty than we feared (well, and more nasty if you
happen to be a Debian unstable or testing user).

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
