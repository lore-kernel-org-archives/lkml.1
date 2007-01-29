Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXA2FG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXA2FG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933117AbXA2FG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:06:26 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37113 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbXA2FGZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:06:25 -0500
Message-Id: <200701290249.l0T2nZt8003676@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
In-Reply-To: Your message of "Sat, 27 Jan 2007 21:41:02 EST."
             <200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com> <45BBC444.8090109@imap.cc> <20070127134116.06bdadd8.akpm@osdl.org>
            <200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170038975_3335P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 28 Jan 2007 21:49:35 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170038975_3335P
Content-Type: text/plain; charset=us-ascii

On Sat, 27 Jan 2007 13:41:16 PST, Andrew Morton said:
> > > >> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> > > >>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 
> > I have everything compiling now, mostly.  The number of fixes which were
> > needed was just extraordinary.  I'm thinking about making changes...

Aliens ate my brain, part 1:

I tried building an out-of-tree ipfilters (ipt_osf) that worked fine under
2.6.20-rc4-mm1.  After much scratching my head and adding debugging info,
I discovered that this code was failing:

        p = create_proc_entry("sys/net/ipv4/osf", S_IFREG | 0644, NULL);
        if (!p) {
                ipt_unregister_match(&osf_match);
                return -ENXIO;
        }

After much *more* head-scratching, and adding of printk's, I tracked it down
into fs/proc/generic.c, in xlate_proc_name:

                len = next - cp;
                for (de = de->subdir; de ; de = de->next) {
                        if (proc_match(len, cp, de))
                                break;
                }
                if (!de) {
                        rtn = -ENOENT;
                        goto out;

It appears that syssctl-reimplement-the-sysctl-proc-support.patch doesn't
bother setting the de->subdir, so xlate_proc_name isn't able to find sys/net.

What's the intended semantics of create_proc_entry and xlate_proc_name in
this new regime of no subdir pointers? Or am I just (yet again) one of the
first to trip over a bug?


--==_Exmh_1170038975_3335P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFvWC/cC3lWbTT17ARAgoSAKDen2ynr4/rHTW7gu4cw2UFISRPJgCfffur
GLwS/m87OuZkt5TPtpoqSzo=
=LzZa
-----END PGP SIGNATURE-----

--==_Exmh_1170038975_3335P--
