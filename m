Return-Path: <linux-kernel-owner+w=401wt.eu-S1765482AbXIMFd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765482AbXIMFd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXIMFdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:33:19 -0400
Received: from [212.12.190.184] ([212.12.190.184]:32839 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082AbXIMFdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:33:18 -0400
From: Al Boldi <a1426z@gawab.com>
To: hooanon05@yahoo.co.jp, Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] Union Mount: Readdir approaches
Date: Thu, 13 Sep 2007 08:32:09 +0300
User-Agent: KMail/1.5
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
References: <20070907054618.GD1692@in.ibm.com> <Pine.LNX.4.64.0709122024500.22467@fbirervta.pbzchgretzou.qr> <E1IVeEx-0000rJ-1R@jroun>
In-Reply-To: <E1IVeEx-0000rJ-1R@jroun>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709130832.09330.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote:
> Jan Engelhardt:
> > On Sep 12 2007 13:46, Al Boldi wrote:
> > >This is way too complicated, but I tried it anyway, only to find it
> > > doesn't compile:
> >
> > cvs up -D 2007-08-07
> >
> > that one works ;-)
>
> Jan, do you mean that only the one month old version could be compiled?
> It it rather surprise since I know some users compiled the newer
> versions. Won't you tell me how did you 'make' it? I think a personal
> mail for me is pereferable to ML.
>
> To Al Boldi,
> Will you send me directly the message which is quoted by Jan? Since it
> was not delivered to me.
>
> Thanks in advance.
> Junjiro Okajima

It turns out that the problem was this in dentry.c:

627-            if (unlikely(do_udba
628-                         && !is_root
629-                         && (unhashed != d_unhashed(h_dentry)
630://#if 1
631-                             || name->len != h_dentry->d_name.len
632-                             || memcmp(name->name, h_dentry->d_name.name,
633-                                       name->len)
634-//#endif
635-                                 ))) {
636-                    LKTRTrace("unhash 0x%x 0x%x, %.*s %.*s\n",
637-                              unhashed, d_unhashed(h_dentry),
638-                              DLNPair(dentry), DLNPair(h_dentry));
639-                    goto err;
640-            }

Commenting the #if block makes it compile now.

Works great too.  Even performance wise.  Needs more testing though.

You really need to post a cleaned up version for review and possible 
inclusion into mainline.  It definitely looks solid.


Thanks!

--
Al

----------  Original Message  ----------

Subject: Re: [RFC] Union Mount: Readdir approaches
Date: Wednesday 12 September 2007 01:46 pm
From: Al Boldi <a1426z@gawab.com>
To: hooanon05@yahoo.co.jp
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, 
linux-fsdevel@vger.kernel.org, hch@infradead.org, Jan Blunck 
<jblunck@suse.de>, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

hooanon05@yahoo.co.jp wrote:
> But if you really want to read or try it, you can get all source files
> from sourceforge. Read http://aufs.sf.net and try,
> $ cvs -d:pserver:anonymous@aufs.cvs.sourceforge.net:/cvsroot/aufs login
> (CVS password is empty)
> $ cvs -z3 -d:pserver:anonymous@aufs.cvs.sourceforge.net:/cvsroot/aufs co
> aufs

This is way too complicated, but I tried it anyway, only to find it doesn't
compile:

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      fs/aufs/dentry.o
fs/aufs/dentry.c:630:1: directives may not be used inside a macro argument
fs/aufs/dentry.c:629:65: unterminated argument list invoking macro
 "unlikely" fs/aufs/dentry.c: In function `h_d_revalidate':
fs/aufs/dentry.c:631: `unlikely' undeclared (first use in this function)
fs/aufs/dentry.c:631: (Each undeclared identifier is reported only once
fs/aufs/dentry.c:631: for each function it appears in.)
fs/aufs/dentry.c:635: parse error before ')' token
fs/aufs/dentry.c:571: warning: unused variable `h_plus'
fs/aufs/dentry.c:571: warning: unused variable `is_nfs'
fs/aufs/dentry.c:572: warning: unused variable `p'
fs/aufs/dentry.c:575: warning: unused variable `h_inode'
fs/aufs/dentry.c:575: warning: unused variable `h_cached_inode'
fs/aufs/dentry.c:576: warning: unused variable `h_mode'
fs/aufs/dentry.c:578: warning: unused variable `reval'
fs/aufs/dentry.c:639: label `err' used but not defined
fs/aufs/dentry.c: At top level:
fs/aufs/dentry.c:642: warning: type defaults to `int' in declaration of
`reval'
fs/aufs/dentry.c:642: warning: initialization makes integer from pointer
without a cast
fs/aufs/dentry.c:642: warning: data definition has no type or storage class
fs/aufs/dentry.c:643: parse error before "if"
fs/aufs/dentry.c:649: warning: type defaults to `int' in declaration of
 `err' fs/aufs/dentry.c:649: `h_dentry' undeclared here (not in a function)
 fs/aufs/dentry.c:649: `p' undeclared here (not in a function)
fs/aufs/dentry.c:649: called object is not a function
fs/aufs/dentry.c:649: warning: data definition has no type or storage class
fs/aufs/dentry.c:650: parse error before "if"
fs/aufs/dentry.c:653: warning: type defaults to `int' in declaration of
`fake_dm_release'
fs/aufs/dentry.c:653: warning: parameter names (without types) in function
declaration
fs/aufs/dentry.c:653: conflicting types for `fake_dm_release'

...and more...


It would make matters much easier if you could just publish a link to a
combo-patch against at least the latest stable kernel, like 2.6.22.


Thanks!

--
Al

