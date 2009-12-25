Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZLYNhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZLYNhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 08:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZLYNhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 08:37:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:55161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZLYNhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 08:37:51 -0500
Message-ID: <4B34C097.1000206@kernel.org>
Date: Fri, 25 Dec 2009 22:39:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: fengxiangjun <fengxiangjun@neusoft.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net> <4B30134C.1050609@gmail.com> <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net> <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com> <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net> <4B31DB17.4050509@kernel.org> <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net> <4B331957.7030906@kernel.org> <alpine.LNX.2.00.0912241535340.1682@darkstar.example.net> <4B331D93.2010000@kernel.org> <alpine.LNX.2.00.0912241557170.1682@darkstar.example.net> <alpine.LNX.2.00.0912242010350.1691@darkstar.example.net> <4B336153.8090206@kernel.org> <alpine.LNX.2.00.0912250931510.1680@darkstar.example.net>
In-Reply-To: <alpine.LNX.2.00.0912250931510.1680@darkstar.example.net>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020907090206090802010204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020907090206090802010204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/25/2009 10:35 AM, fengxiangjun wrote:
>> Hmmm... SControl DET hasn't been cleared.  Does the attached patch
>> make any difference?
> 
> After 5 successful reboots, I think the patch does fix the problem.
> Thank you very much.

Can you please try this one?  Retry logic was wrong in the original
patch.  With this patch, you should see one "link resume succeeded
after %d retries" message when the original kernel would have failed
probe.  Can you please test this patch and post boot log with such
message?

Thanks.

-- 
tejun

--------------020907090206090802010204
Content-Type: text/x-patch;
 name="retry-link-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="retry-link-resume.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 22ff51b..40940dd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3790,21 +3790,40 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 int sata_link_resume(struct ata_link *link, const unsigned long *params,
 		     unsigned long deadline)
 {
+	int tries = ATA_LINK_RESUME_TRIES;
 	u32 scontrol, serror;
 	int rc;
 
 	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
 		return rc;
 
-	scontrol = (scontrol & 0x0f0) | 0x300;
+	do {
+		scontrol = (scontrol & 0x0f0) | 0x300;
+		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
+			return rc;
+		/*
+		 * Some PHYs react badly if SStatus is pounded
+		 * immediately after resuming.  Delay 200ms before
+		 * debouncing.
+		 */
+		msleep(200);
 
-	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
-		return rc;
+		/* is SControl restored correctly? */
+		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+			return rc;
+	} while ((scontrol & 0xf0f) != 0x300 && --tries);
 
-	/* Some PHYs react badly if SStatus is pounded immediately
-	 * after resuming.  Delay 200ms before debouncing.
-	 */
-	msleep(200);
+	if ((scontrol & 0xf0f) != 0x300) {
+		ata_link_printk(link, KERN_ERR,
+				"failed to resume link (SControl %X)\n",
+				scontrol);
+		return 0;
+	}
+
+	if (tries < ATA_LINK_RESUME_TRIES)
+		ata_link_printk(link, KERN_WARNING,
+				"link resume succeeded after %d retries\n",
+				ATA_LINK_RESUME_TRIES - tries);
 
 	if ((rc = sata_link_debounce(link, params, deadline)))
 		return rc;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6a9c4dd..7311225 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -354,6 +354,9 @@ enum {
 	/* max tries if error condition is still set after ->error_handler */
 	ATA_EH_MAX_TRIES	= 5,
 
+	/* sometimes resuming a link requires several retries */
+	ATA_LINK_RESUME_TRIES	= 5,
+
 	/* how hard are we gonna try to probe/recover devices */
 	ATA_PROBE_MAX_TRIES	= 3,
 	ATA_EH_DEV_TRIES	= 3,

--------------020907090206090802010204--
