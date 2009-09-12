Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZILQn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZILQn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 12:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZILQnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 12:43:55 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:21493 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZILQny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 12:43:54 -0400
Date: Sat, 12 Sep 2009 09:43:56 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       Ravi Anand <ravi.anand@qlogic.com>,
       Lalit Chandivade <lalit.chandivade@qlogic.com>
Subject: [PATCHv3] qla2xxx: Correct compilation issues when
 CONFIG_MODULES=n.
Message-ID: <20090912164356.GA19451@plap4-2.local>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
 <20090908182541.GB44157@plap4-2.local>
 <20090911175341.GH710@plap4-2.local>
 <1252708951.13282.151.camel@mulgrave.site>
 <20090912000742.GB12098@plap4-2.local>
 <20090912001752.GC12098@plap4-2.local>
 <20090912003808.GD12098@plap4-2.local>
 <1252728393.13282.485.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252728393.13282.485.camel@mulgrave.site>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Sep 2009 16:43:26.0216 (UTC) FILETIME=[26474080:01CA33C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap noted:

  when CONFIG_MODULES=n:

	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type

  in

	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
		KOBJ_CHANGE, envp);

Trigger kobject event on the 'struct device' hanging off the pci_dev.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

	On Fri, 11 Sep 2009, James Bottomley wrote:

	> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
	> > index 29396c0..369a270 100644
	> > --- a/drivers/scsi/qla2xxx/qla_os.c
	> > +++ b/drivers/scsi/qla2xxx/qla_os.c
	> > @@ -2683,8 +2683,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
	> >  		/* do nothing */
	> >  		break;
	> >  	}
	> > -	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
	> > -	    KOBJ_CHANGE, envp);
	> > +	kobject_uevent_env(&(&vha->hw->pdev->dev)->kobj, KOBJ_CHANGE, envp);
	> 
	> Much better.  Of course to be perfect, you might like to remember that
	> (&x)->y is actually x.y
	> 
	> so 
	> 
	> kobject_uevent_env(&vha->hw->pdev->dev.kobj, ...

	Ahh, of course...  Perfection...the enemy of progress...

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 29396c0..86f337f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2683,8 +2683,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
 		/* do nothing */
 		break;
 	}
-	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
-	    KOBJ_CHANGE, envp);
+	kobject_uevent_env(&vha->hw->pdev->dev.kobj, KOBJ_CHANGE, envp);
 }
 
 void
