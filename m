Return-Path: <linux-kernel-owner+w=401wt.eu-S935830AbYCFVcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935830AbYCFVcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbYCFVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:32:13 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47899 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765080AbYCFVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:32:11 -0500
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080306203558.GA7430@tree.beaverton.ibm.com>
References: <200803062009.20309.toralf.foerster@gmx.de>
	 <20080306202246.GB5259@cs181133002.pp.htv.fi>
	 <20080306203558.GA7430@tree.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 06 Mar 2008 15:32:06 -0600
Message-Id: <1204839126.3062.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 12:35 -0800, Darrick J. Wong wrote:
> On Thu, Mar 06, 2008 at 10:22:46PM +0200, Adrian Bunk wrote:
> > This patch fixes the following build error reported by Toralf Förster:
> > 
> > <--  snip  -->
> > 
> > ...
> >   MODPOST 243 modules
> > ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!
> 
> <snip>
> 
> > --- a/drivers/scsi/aic94xx/Kconfig
> > +++ b/drivers/scsi/aic94xx/Kconfig
> 
> Maybe I'm missing something here, but how does patching aic94xx Kconfig
> fix an mvsas build problem?

Actually, it's a dependency chain fault.  The config this was generated
from has

CONFIG_SCSI=m

CONFIG_SCSI_AIC94XX=y

the latter then forces

CONFIG_SCSI_SAS_LIBSAS=y

I think the error reported is wrong: the kernel just should have failed
to link, since both the built in aic94xx and libsas have scsi
dependencies.

We have a few other drivers in this category (like ibmvscsi).  The root
cause seems to be that SCSI_LOWLEVEL doesn't act as a tristate.  I think
a fix that will prevent all of these issues from recurring is this one.

James


---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c46666a..b9d3740 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -325,7 +325,7 @@ menuconfig SCSI_LOWLEVEL
 	depends on SCSI!=n
 	default y
 
-if SCSI_LOWLEVEL
+if SCSI_LOWLEVEL && SCSI
 
 config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"


