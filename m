Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYL3RMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYL3RMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYL3RMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:12:10 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60647 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYL3RMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:12:08 -0500
Subject: Re: linux-next: Tree for December 29 (fcoe/libfc)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Robert Love <robert.w.love@intel.com>
In-Reply-To: <495A5259.2080208@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229195358.6a239657.randy.dunlap@oracle.com>
	 <1230651870.3296.2.camel@localhost.localdomain>
	 <495A5259.2080208@oracle.com>
Content-Type: text/plain
Date: Tue, 30 Dec 2008 17:12:04 +0000
Message-Id: <1230657124.3296.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-30 at 08:54 -0800, Randy Dunlap wrote:
> James Bottomley wrote:
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index 0e5e084..9f4cc8e 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -607,13 +607,12 @@ config SCSI_FLASHPOINT
> >  
> >  config LIBFC
> >  	tristate "LibFC module"
> > -	depends on SCSI && SCSI_FC_ATTRS
> > +	select SCSI_FC_ATTRS
> >  	---help---
> >  	  Fibre Channel library module
> >  
> >  config FCOE
> >  	tristate "FCoE module"
> > -	depends on SCSI
> >  	select LIBFC
> >  	---help---
> >  	  Fibre Channel over Ethernet module
> > 
> > 
> 
> This still has a build error when CONFIG_PCI=n:
> 
> 
> linux-next-20081229/drivers/scsi/fcoe/fc_transport_fcoe.c: In function 'fcoe_load_transport_driver':
> linux-next-20081229/drivers/scsi/fcoe/fc_transport_fcoe.c:324: error: 'pci_bus_type' undeclared (first use in this function)
> make[4]: *** [drivers/scsi/fcoe/fc_transport_fcoe.o] Error 1

OK, so take two would make FCOE depend on SCSI, like this.

James

---

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [SCSI] fcoe: fix configuration problems

fcoe selects libfc and requires SCSI and PCI (the SCSI requirement is
implicitly covered by an enclosing if).  Fix them both up so they
cannot be configured in an invalid state: make LIBFC select
SCSI_FC_ATTRS and make FCOE depend on PCI and select LIBFC.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 0e5e084..152d4aa 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -607,13 +607,13 @@ config SCSI_FLASHPOINT
 
 config LIBFC
 	tristate "LibFC module"
-	depends on SCSI && SCSI_FC_ATTRS
+	select SCSI_FC_ATTRS
 	---help---
 	  Fibre Channel library module
 
 config FCOE
 	tristate "FCoE module"
-	depends on SCSI
+	depends on PCI
 	select LIBFC
 	---help---
 	  Fibre Channel over Ethernet module
-- 
1.5.6.6



