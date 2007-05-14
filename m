Return-Path: <linux-kernel-owner+w=401wt.eu-S966028AbXENJft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966028AbXENJft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762038AbXENJfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:35:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:23076 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804AbXENJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fVs3Cxeq9nRb5LPLGQhw3MccYHofc62/etb7OzT36lCV5xvIYU4jL+FkAnCiD1u9lg9LKgjwfdAcaSDbxCKyN1n6AudvcjnU5WzKSWUfKWN57jENN0jASoUwKNAqnEHTXHdMAGP19fJtfIj1tPY3IFZRJCnLeEhDnQFyC7PR58c=
Message-ID: <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
Date: Mon, 14 May 2007 15:05:16 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "James Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Cc: "Dave Jones" <davej@redhat.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/13/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Sun, 2007-05-13 at 11:10 -0500, James Bottomley wrote:
> > > -   depends on SCSI
> > > +   depends on SCSI_SCAN_ASYNC

This is incorrect, alright, but not because of any of the reasons James
mentions below.

The only reason why some module (or Kconfig option) should _depend_
on some other Kconfig option is if (*and only if*) it re-uses _code_
exported by said dependency.

In this particular case, SCSI_SCAN_ASYNC=y/n only controls the
default value of some variable somewhere in SCSI, so no other code
can meaningfully "depend" on it.

> > No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
> > wait scan to be built in, which isn't the idea at all.

Umm, this isn't true, actually.

> Plus SCSI_SCAN_ASYNC only sets the *default* for async scanning.  You
> can alter this at boot time, so you could need the wait scan module even
> with it set to N.

I think the _correct_ way to handle this situation (and which would make
everyone happy here; Robert can get his module-free builds with defconfig,
James gets his SCSI_WAIT_SCAN module even if nobody asked for it
explicitly) would be as follows:

---

Clean up Kconfig entry for CONFIG_SCSI_WAIT_SCAN.

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

 drivers/scsi/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

diff -ruNp a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2007-05-10 23:19:32.000000000 +0530
+++ b/drivers/scsi/Kconfig	2007-05-14 15:12:46.000000000 +0530
@@ -243,9 +243,8 @@ config SCSI_SCAN_ASYNC

 config SCSI_WAIT_SCAN
 	tristate
-	default m
-	depends on SCSI
-	depends on MODULES
+	default m if SCSI=m
+	default n

 menu "SCSI Transports"
 	depends on SCSI
