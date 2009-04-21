Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZDUTBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZDUTBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZDUTA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:00:58 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47591 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZDUTAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IMBfiOQ0HnL+rm71QAfmBXqBXHb6VxK8QQUTuL7D6og0mrNtdFFqNS8kRF4pbV0sIl
         aKcGHIezjTaua0YADQypvA/snO8I9llk6NYp3Jd/YgouTz77VBF5hJ7BMKL7RRqqdPP9
         a0Bqv0AYMFt0sQ19uFH1ImBK6QFhTDJNpapU4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: subrata@linux.vnet.ibm.com
Subject: Re: [BUILD FAILURE 07/12] Next April 14 : PPC64 randconfig [drivers/ide/pmac.c]
Date: Tue, 21 Apr 2009 21:04:37 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, Greg KH <greg@kroah.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next" <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
References: <1239733759.5344.79.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1239733759.5344.79.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904212104.38664.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 20:29:19 Subrata Modak wrote:
> Observed the following build error:
> ---
> CC [M]  drivers/ide/pmac.o
> drivers/ide/pmac.c: In function ‘pmac_ide_init_dev’:
> drivers/ide/pmac.c:955: error: implicit declaration of function
> ‘check_media_bay_by_base’
> drivers/ide/pmac.c: In function ‘pmac_ide_setup_device’:
> drivers/ide/pmac.c:1090: error: implicit declaration of function
> ‘media_bay_set_ide_infos’
> make[2]: *** [drivers/ide/pmac.o] Error 1
> make[1]: *** [drivers/ide] Error 2
> make: *** [drivers] Error 2
> ---

Should be fixed by:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-pmac: fix modular build for CONFIG_PMAC_MEDIABAY=y

On Tuesday 14 April 2009 20:29:19 Subrata Modak wrote:
> Observed the following build error:
> ---
> CC [M]  drivers/ide/pmac.o
> drivers/ide/pmac.c: In function ‘pmac_ide_init_dev’:
> drivers/ide/pmac.c:955: error: implicit declaration of function
> ‘check_media_bay_by_base’
> drivers/ide/pmac.c: In function ‘pmac_ide_setup_device’:
> drivers/ide/pmac.c:1090: error: implicit declaration of function
> ‘media_bay_set_ide_infos’
> make[2]: *** [drivers/ide/pmac.o] Error 1
> make[1]: *** [drivers/ide] Error 2
> make: *** [drivers] Error 2
> ---

IDE PMAC host driver can be modular now so we need to export
check_media_bay_by_base() and media_bay_set_ide_infos().

Reported-by: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/macintosh/mediabay.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/macintosh/mediabay.c
===================================================================
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -447,6 +447,7 @@ int check_media_bay_by_base(unsigned lon
 
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(check_media_bay_by_base);
 
 int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
 			    int irq, ide_hwif_t *hwif)
@@ -486,6 +487,7 @@ int media_bay_set_ide_infos(struct devic
 
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(media_bay_set_ide_infos);
 #endif /* CONFIG_BLK_DEV_IDE_PMAC */
 
 static void media_bay_step(int i)

