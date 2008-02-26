Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYBZENa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYBZENa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYBZENU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:13:20 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:9102 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYBZENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:13:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=BPC4eZmoU5UsgF7def/h6qnSA4EQP6262RmUWEEU0PbNGoZEzJbVZ9eQXDIN2Mmadr9P62Uj2DcvSP8ZNrsikvC3mRohCxJ1flQnNrePTIwzVNM0qMCBQcajwq7Lwp65l7XT4A5OWgpvBrRfnRYJc/RW8cBaMLgv+9pz1m0Esg8=
Date: Tue, 26 Feb 2008 12:13:19 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Jesse B, arnes"@localhost.corp.fedex.com, jesse.barnes@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jeff Garzik <jeff@garzik.org>
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on
 thinkpad T61p - resume hang
Message-ID: <Pine.LNX.4.64.0802261210080.3332@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Feb 26, 2008 at 4:45 AM, Michael S. Tsirkin 
<m.s.tsirkin@gmail.com> wrote:
> On Mon, Feb 25, 2008 at 9:46 PM, Andrew Morton 
<akpm@linux-foundation.org> wrote:
> > On Mon, 25 Feb 2008 21:19:24 +0200 "Michael S. Tsirkin" 
<m.s.tsirkin@gmail.com> wrote:
>  >  You mean suspend-to-ram works correctly on your t61p?
>  >  Mine suspends, then five seconds later magically resumes itself and 
the
>  >  screen is all black.
>  Sorry, have not noticed what you were asking about.
>  Yes, rc2 seems to suspend/resume fine.
>  And after reverting
>      revert commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.

commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
Author: Pavel Machek <pavel@ucw.cz>
Date:   Thu Feb 21 13:56:55 2008 +0100

     power_state: get rid of write-only variable in SATA

     power_state is scheduled for removal, and libata uses it in write-only
     mode. Remove it.

     Signed-off-by: Pavel Machek <pavel@suse.cz>
     Signed-off-by: Jeff Garzik <jeff@garzik.org>


I'm experiencing hang after resume from STR with the latest Linus's git 
tree. Reverting the above patch solved the problem.


Thanks,
Jeff


Here's the patch for reference ...


diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4cf8662..9812bbf 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6560,8 +6560,6 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
  	ata_lpm_enable(host);

  	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
-	if (rc == 0)
-		host->dev->power.power_state = mesg;
  	return rc;
  }

@@ -6580,7 +6578,6 @@ void ata_host_resume(struct ata_host *host)
  {
  	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
  			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
-	host->dev->power.power_state = PMSG_ON;

  	/* reenable link pm */
  	ata_lpm_disable(host);
