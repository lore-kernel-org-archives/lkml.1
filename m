Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbYJ0XrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbYJ0XrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYJ0Xq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:46:57 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1611 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJ0Xq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:46:56 -0400
Subject: Re: [PATCH 1/8] Add scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       randy.dunlap@oracle.com, pavel@suse.cz, ukleinek@strlen.de
In-Reply-To: <20081027155254.a710c779.akpm@linux-foundation.org>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
	 <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
	 <20081027155254.a710c779.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Oct 2008 16:46:45 -0700
Message-Id: <1225151205.5269.102.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 15:52 -0700, Andrew Morton wrote:
> On Thu, 23 Oct 2008 16:09:19 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > A script to parse file pattern information in MAINTAINERS
> > and return selected information about a file or patch
> > 
> > $ scripts/get_maintainer.pl
> > usage: ./scripts/get_maintainer.pl [options] patchfile
> >        ./scripts/get_maintainer.pl [options] -f file
> > version: 0.12
> 
> Example output would be nice to see.  Hopefully it is in the
> 
> 	Joe Perches <joe@perches.com>
> 
> form, ready to be pasted into an email client?

Yes.  It's also suitable for use with git-send-email --cc-cmd

Some examples picking a random file (drivers/net/b44.c):

Get maintainers for a single file
(this includes git -by: signatories and the script does a
sort | uniq so the maintainer is not listed first)

$ ./scripts/get_maintainer.pl -f drivers/net/b44.c
"Miguel Botón" <mboton@gmail.com>
Gary Zambrano <zambrano@broadcom.com>
Jeff Garzik <jeff@garzik.org>
Jeff Garzik <jgarzik@pobox.com>
John W. Linville <linville@tuxdriver.com>
Larry Finger <Larry.Finger@lwfinger.net>
Michael Buesch <mb@bu3sch.de>
netdev@vger.kernel.org

without -git signators

$ ./scripts/get_maintainer.pl -f --nogit drivers/net/b44.c
Gary Zambrano <zambrano@broadcom.com>
Jeff Garzik <jgarzik@pobox.com>
netdev@vger.kernel.org

or without mailing lists

$ ./scripts/get_maintainer.pl -f --nogit --no-l drivers/net/b44.c
Gary Zambrano <zambrano@broadcom.com>
Jeff Garzik <jgarzik@pobox.com>

or without the maintainers, just mailing lists

$ ./scripts/get_maintainer.pl -f --nogit --no-m drivers/net/b44.c
netdev@vger.kernel.org

or get the scm entry

$ ./scripts/get_maintainer.pl -f --nogit --no-email --scm drivers/net/b44.c
git git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

> otoh, we'll sometimes also want the
> 
> 	joe@perches.com,akpm@linux-foundation.org
> 
> form for use by scripts.

That's the --no-multiline option

$ ./scripts/get_maintainer.pl -f --nogit --no-multiline drivers/net/b44.c
Gary Zambrano <zambrano@broadcom.com>, Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org

Another possibility is to use a patch file: (random old patch file)

$ cat pad.d
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index c666b4e..1d7c328 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -251,7 +251,7 @@ static struct crypto_alg sha256_alg = {
 
 static int __init padlock_init(void)
 {
-	int rc = -ENODEV;
+	int rc;
 
 	if (!cpu_has_phe) {
 		printk(KERN_ERR PFX "VIA PadLock Hash Engine not detected.\n");
$ ./scripts/get_maintainer.pl pad.d
Herbert Xu <herbert@gondor.apana.org.au>
Jeremy Katz <katzj@redhat.com>
Suresh Siddha <suresh.b.siddha@intel.com>
Wolfgang Walter <wolfgang.walter@stwm.de>

>  MAINTAINERS | 1096 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 1094 insertions(+), 2 deletions(-)
> 
> isn't practical for me or Stephen to carry, I'm afraid.  That's
> probably the most-patched file in the kernel.  This will need to be a
> direct you->Linus thing.

I also think it has to be picked up directly by Linus.

MAINTAINERS is not just probably the most patched file.
It _is_ the most patched file.

$ git log --pretty=oneline --stat | \
  grep -vP "^[a-f0-9]{40,40}" | \
  grep -vP "changed.*insertion.*deletion" | \
  cut -f1 -d"|" | sed -e 's/ //g' | \
  sort | uniq -c | sort -nr | head -5
    733 MAINTAINERS
    718 kernel/sched.c
    440 include/linux/sched.h
    411 include/linux/libata.h
    407 include/linux/ide.h

> I think the feature is sorely needed and will prove useful.

thanks...

cheers, Joe

