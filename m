Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZIKRxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZIKRxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZIKRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:53:40 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:19108 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZIKRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:53:38 -0400
Date: Fri, 11 Sep 2009 10:53:41 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: qla2xxx: Correct compilation issues when CONFIG_MOUDLES=n (was:
 Re: linux-next: Tree for September 7 (scsi/qla2x))
Message-ID: <20090911175341.GH710@plap4-2.local>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
 <20090908182541.GB44157@plap4-2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908182541.GB44157@plap4-2.local>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Sep 2009 17:53:11.0382 (UTC) FILETIME=[BA6B2760:01CA3308]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap noted:

  when CONFIG_MODULES=n:

	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type

  in
	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
		KOBJ_CHANGE, envp);

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

On Tue, 08 Sep 2009, Andrew Vasquez wrote:

> On Mon, 07 Sep 2009, Randy Dunlap wrote:
> 
> > On Mon, 7 Sep 2009 21:02:06 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20090904:
> > 
> > 
> > when CONFIG_MODULES=n:
> > 
> > drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> > 
> > in
> > 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> > 	    KOBJ_CHANGE, envp);
> 
> Argg...  Some history here...  During several unwelcome
> hardware/firmware events (ISP system error, mailbox command timeouts,
> etc), the qla2xxx driver can store a 'firmware-dump' (essentially a
> snapshot of the current state of the ISP firmware).  This snapshot is
> then captured via a user-space tool querying a driver sysfs-node
> hanging off of a scsi_host's device tree:
> 
> 	/sys/class/scsi_host/host4/device/fw_dump
> 
> The dump is then used by our firmware engineering group to help triage
> the issue.
> 
> This recent change:
> 
> 	commit 10a71b40153a19279428053ad9743e15ef414148
> 	Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 	Date:   Tue Aug 25 11:36:15 2009 -0700
> 
> 	    [SCSI] qla2xxx: Add firmware-dump kobject uevent notification.
> 
> 	    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 	    Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 	    Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> 
> attempted to help 'automate' the task of retrieval by signaling udev
> to automatically run the 'retrieval' script anytime the driver
> captured the firmware-dump.  Here's a snippet of the udev rule:
> 
> 	# qla2xxx driver
> 	KERNEL=="qla2xxx", SUBSYSTEM=="module", ACTION=="change", RUN+="qla2xxx_udev.sh"
> 
> Any suggestions here on an alternate driver-specific kobject an LLD
> can/should use for something like this?  I looked previously at other
> callers of kobject_uevent_env(), but didn't really see a simlar
> usage-pattern of a driver wanting to signal events to userspace...
> 
> Thanks, AV

Ok, So any strong objections to just having the functionality present
when module support is enabled?

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 29396c0..3887adb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2671,6 +2671,7 @@ qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
 static void
 qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
 {
+#ifdef CONFIG_MODULES
 	char event_string[40];
 	char *envp[] = { event_string, NULL };
 
@@ -2685,6 +2686,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
 	}
 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
 	    KOBJ_CHANGE, envp);
+#endif
 }
 
 void

