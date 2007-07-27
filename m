Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXG0EAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXG0EAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXG0EAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:00:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56292 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXG0EAl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:00:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kylene Hall <kjhall@us.ibm.com>, linux-kernel@vger.kernel.org,
       tpm@selhorst.net
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
In-Reply-To: Your message of "Wed, 25 Jul 2007 20:37:37 PDT."
             <20070725203737.85871711.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org> <23659.1185400994@turing-police.cc.vt.edu>
            <20070725203737.85871711.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185508832_3307P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Jul 2007 00:00:32 -0400
Message-ID: <5208.1185508832@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185508832_3307P
Content-Type: multipart/mixed ;
	boundary="==_Exmh_1185507681_33070"

This is a multipart MIME message.

--==_Exmh_1185507681_33070
Content-Type: text/plain; charset=us-ascii

On Wed, 25 Jul 2007 20:37:37 PDT, Andrew Morton said:

> I can't imagine what we did to break tpm_tis, sorry.  Nothing has changed
> in there for ages.
> 
> Perhaps something broke at the bus level.  It would be useful to add

OK, so I made a more intrusive printk-all-over patch to track what it was
doing, and got several tests in under 2.6.22-rc6-mm1 and 2.6.23-rc1-mm1.

I've attached:

debug.22-rc6-mm1 - things apparently working under the previous kernel.
debug.rc1-a      - this one complained but didn't time out for long times. I've
                 only seen 23-rc1-mm1 *not* take timeouts this one time. Oddness.
debug.rc1-b      - this one complained, and took 2 120-second waits
debug.patch      - the printf's I added, for those who want to follow along..

Apparently, things go pear-shaped in tis_tpm_send(), when they get to the
'if (chip->vendor.irq)' - under 22-rc6-mm1, we never got into this code,
because earlier initialization complained it couldn't get IRQ8.  Now, we
get IRQ3, and apparently get into this if statement, and then spend 120
seconds while wait_for_stat() times out.  So the root cause does look like
it's this IRQ8/IRQ3 issue.

I'll try to find time to do a bisect on -rc1-mm1 tomorrow to track down
what exactly did this.

(And remember to keep in mind the very real possibility that in fact, both
releases are broken in different ways - I've never actually *done* anything
with the chip further than "the driver loads".  Anybody got a very basic
userspace program to test-harness /dev/tpm0 (open, do a few test calls, close)?

--==_Exmh_1185507681_33070
Content-Type: text/plain ; name="debug.22-rc6-mm1"; charset=us-ascii
Content-Description: debug.22-rc6-mm1
Content-Disposition: attachment; filename="debug.22-rc6-mm1"

[   32.324000] tpm_tis_pnp_init: start=4275306496, len=20480
[   32.324000] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[   32.324000] tpm_tis 00:0f: TPM interface capabilities (0x97):
[   32.324000] tpm_tis 00:0f: 	Command Ready Int Support
[   32.324000] tpm_tis 00:0f: 	Interrupt Level Low
[   32.324000] tpm_tis 00:0f: 	Locality Change Int Support
[   32.324000] tpm_tis 00:0f: 	Sts Valid Int Support
[   32.324000] tpm_tis 00:0f: 	Data Avail Int Support
[   32.324000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.324000] tis_send ready_for_command
[   32.324000] tis_send wait for tis_ready
[   32.330000] tis_send ready to go
[   32.330000] tis_send after iowrite8 loop
[   32.330000] tis_send after second wait_for_stat
[   32.330000] tis_send after second tis_status
[   32.330000] tis_send after last iowrite8
[   32.330000] tis_send after 3rd wait_for_stat
[   32.330000] tis_send after 3rd tis_status
[   32.330000] tis_send after STS_GO
[   32.336000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.336000] tis_send ready_for_command
[   32.336000] tis_send wait for tis_ready
[   32.342000] tis_send ready to go
[   32.342000] tis_send after iowrite8 loop
[   32.342000] tis_send after second wait_for_stat
[   32.342000] tis_send after second tis_status
[   32.342000] tis_send after last iowrite8
[   32.342000] tis_send after 3rd wait_for_stat
[   32.342000] tis_send after 3rd tis_status
[   32.342000] tis_send after STS_GO
[   32.348000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.348000] tis_send ready_for_command
[   32.348000] tis_send wait for tis_ready
[   32.354000] tis_send ready to go
[   32.354000] tis_send after iowrite8 loop
[   32.354000] tis_send after second wait_for_stat
[   32.354000] tis_send after second tis_status
[   32.354000] tis_send after last iowrite8
[   32.354000] tis_send after 3rd wait_for_stat
[   32.354000] tis_send after 3rd tis_status
[   32.354000] tis_send after STS_GO
[   32.360000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.360000] tis_send ready_for_command
[   32.360000] tis_send wait for tis_ready
[   32.366000] tis_send ready to go
[   32.366000] tis_send after iowrite8 loop
[   32.366000] tis_send after second wait_for_stat
[   32.366000] tis_send after second tis_status
[   32.366000] tis_send after last iowrite8
[   32.366000] tis_send after 3rd wait_for_stat
[   32.366000] tis_send after 3rd tis_status
[   32.366000] tis_send after STS_GO
[   32.372000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.372000] tis_send ready_for_command
[   32.372000] tis_send wait for tis_ready
[   32.378000] tis_send ready to go
[   32.378000] tis_send after iowrite8 loop
[   32.378000] tis_send after second wait_for_stat
[   32.378000] tis_send after second tis_status
[   32.378000] tis_send after last iowrite8
[   32.378000] tis_send after 3rd wait_for_stat
[   32.378000] tis_send after 3rd tis_status
[   32.378000] tis_send after STS_GO
[   32.384000] tpm_tis 00:0f: Unable to request irq: 8 for probe
[   32.384000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.384000] tis_send ready_for_command
[   32.384000] tis_send wait for tis_ready
[   32.390000] tis_send ready to go
[   32.390000] tis_send after iowrite8 loop
[   32.390000] tis_send after second wait_for_stat
[   32.390000] tis_send after second tis_status
[   32.390000] tis_send after last iowrite8
[   32.390000] tis_send after 3rd wait_for_stat
[   32.390000] tis_send after 3rd tis_status
[   32.390000] tis_send after STS_GO
[   32.396000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.396000] tis_send ready_for_command
[   32.396000] tis_send wait for tis_ready
[   32.402000] tis_send ready to go
[   32.402000] tis_send after iowrite8 loop
[   32.402000] tis_send after second wait_for_stat
[   32.402000] tis_send after second tis_status
[   32.402000] tis_send after last iowrite8
[   32.402000] tis_send after 3rd wait_for_stat
[   32.402000] tis_send after 3rd tis_status
[   32.402000] tis_send after STS_GO
[   32.408000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.408000] tis_send ready_for_command
[   32.408000] tis_send wait for tis_ready
[   32.414000] tis_send ready to go
[   32.414000] tis_send after iowrite8 loop
[   32.414000] tis_send after second wait_for_stat
[   32.414000] tis_send after second tis_status
[   32.414000] tis_send after last iowrite8
[   32.414000] tis_send after 3rd wait_for_stat
[   32.414000] tis_send after 3rd tis_status
[   32.414000] tis_send after STS_GO
[   32.420000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.420000] tis_send ready_for_command
[   32.420000] tis_send wait for tis_ready
[   32.426000] tis_send ready to go
[   32.426000] tis_send after iowrite8 loop
[   32.426000] tis_send after second wait_for_stat
[   32.426000] tis_send after second tis_status
[   32.426000] tis_send after last iowrite8
[   32.426000] tis_send after 3rd wait_for_stat
[   32.426000] tis_send after 3rd tis_status
[   32.426000] tis_send after STS_GO
[   32.432000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.432000] tis_send ready_for_command
[   32.432000] tis_send wait for tis_ready
[   32.438000] tis_send ready to go
[   32.438000] tis_send after iowrite8 loop
[   32.438000] tis_send after second wait_for_stat
[   32.438000] tis_send after second tis_status
[   32.438000] tis_send after last iowrite8
[   32.438000] tis_send after 3rd wait_for_stat
[   32.438000] tis_send after 3rd tis_status
[   32.438000] tis_send after STS_GO
[   32.444000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.444000] tis_send ready_for_command
[   32.444000] tis_send wait for tis_ready
[   32.450000] tis_send ready to go
[   32.450000] tis_send after iowrite8 loop
[   32.450000] tis_send after second wait_for_stat
[   32.450000] tis_send after second tis_status
[   32.450000] tis_send after last iowrite8
[   32.450000] tis_send after 3rd wait_for_stat
[   32.450000] tis_send after 3rd tis_status
[   32.450000] tis_send after STS_GO
[   32.456000] in tpm_tis_send buffer=18446604435840957488 len=22
[   32.456000] tis_send ready_for_command
[   32.456000] tis_send wait for tis_ready
[   32.462000] tis_send ready to go
[   32.462000] tis_send after iowrite8 loop
[   32.462000] tis_send after second wait_for_stat
[   32.462000] tis_send after second tis_status
[   32.462000] tis_send after last iowrite8
[   32.462000] tis_send after 3rd wait_for_stat
[   32.462000] tis_send after 3rd tis_status
[   32.462000] tis_send after STS_GO
[   32.468000] in tpm_tis_send buffer=18446604435840957472 len=22
[   32.468000] tis_send ready_for_command
[   32.468000] tis_send wait for tis_ready
[   32.474000] tis_send ready to go
[   32.474000] tis_send after iowrite8 loop
[   32.474000] tis_send after second wait_for_stat
[   32.474000] tis_send after second tis_status
[   32.474000] tis_send after last iowrite8
[   32.474000] tis_send after 3rd wait_for_stat
[   32.474000] tis_send after 3rd tis_status
[   32.474000] tis_send after STS_GO
[   32.480000] in tpm_tis_send buffer=18446604435840957472 len=22
[   32.480000] tis_send ready_for_command
[   32.480000] tis_send wait for tis_ready
[   32.486000] tis_send ready to go
[   32.486000] tis_send after iowrite8 loop
[   32.486000] tis_send after second wait_for_stat
[   32.486000] tis_send after second tis_status
[   32.486000] tis_send after last iowrite8
[   32.486000] tis_send after 3rd wait_for_stat
[   32.486000] tis_send after 3rd tis_status
[   32.486000] tis_send after STS_GO
[   32.492000] in tpm_tis_send buffer=18446604435840957528 len=10
[   32.492000] tis_send ready_for_command
[   32.492000] tis_send wait for tis_ready
[   32.498000] tis_send ready to go
[   32.498000] tis_send after iowrite8 loop
[   32.498000] tis_send after second wait_for_stat
[   32.498000] tis_send after second tis_status
[   32.498000] tis_send after last iowrite8
[   32.498000] tis_send after 3rd wait_for_stat
[   32.498000] tis_send after 3rd tis_status
[   32.498000] tis_send after STS_GO

--==_Exmh_1185507681_33070
Content-Type: text/plain ; name="debug.rc1-a"; charset=us-ascii
Content-Description: debug.rc1-a
Content-Disposition: attachment; filename="debug.rc1-a"

[ 1357.392943] tpm_tis_pnp_init: start=4275306496, len=20480
[ 1357.394579] SELinux: initialized (dev securityfs, type securityfs), not configured for labeling
[ 1357.394615] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[ 1357.394620] tpm_tis 00:0f: TPM interface capabilities (0x97):
[ 1357.394622] tpm_tis 00:0f: 	Command Ready Int Support
[ 1357.394624] tpm_tis 00:0f: 	Interrupt Level Low
[ 1357.394625] tpm_tis 00:0f: 	Locality Change Int Support
[ 1357.394627] tpm_tis 00:0f: 	Sts Valid Int Support
[ 1357.394628] tpm_tis 00:0f: 	Data Avail Int Support
[ 1357.394652] tpm0 (IRQ 3) handled a spurious interrupt
[ 1357.394669] in tpm_tis_send buffer=18446604435799350304 len=22
[ 1357.394675] tis_send ready_for_command
[ 1357.394677] tis_send wait for tis_ready
[ 1357.394680] tis_send ready to go
[ 1357.394696] tis_send after iowrite8 loop
[ 1357.394701] tis_send after second wait_for_stat
[ 1357.394704] tis_send after second tis_status
[ 1357.394705] tis_send after last iowrite8
[ 1357.394709] tis_send after 3rd wait_for_stat
[ 1357.394712] tis_send after 3rd tis_status
[ 1357.394713] tis_send after STS_GO
[ 1357.394714] tis_send before last wait_for_stat
[ 1358.966290] in tpm_tis_send buffer=18446604435799350304 len=22
[ 1358.966296] tis_send ready_for_command
[ 1358.966298] tis_send wait for tis_ready
[ 1358.966303] tis_send ready to go
[ 1358.966319] tis_send after iowrite8 loop
[ 1358.966324] tis_send after second wait_for_stat
[ 1358.966327] tis_send after second tis_status
[ 1358.966328] tis_send after last iowrite8
[ 1358.966331] tis_send after 3rd wait_for_stat
[ 1358.966334] tis_send after 3rd tis_status
[ 1358.966336] tis_send after STS_GO
[ 1358.966337] tis_send before last wait_for_stat
[ 1358.966345] tis_send after last wait_for_stat
[ 1358.966347] tis_send before last tis_ready
[ 1358.966348] tis_send after last tis_ready
[ 1358.966354] tis_send after release_locality
[ 1358.966357] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62
[ 1358.966359] in tpm_tis_send buffer=18446604435799350360 len=10
[ 1358.966364] tis_send ready_for_command
[ 1358.966365] tis_send wait for tis_ready
[ 1358.966373] tis_send timed out waiting for command_ready
[ 1358.966374] tis_send before last tis_ready
[ 1358.966375] tis_send after last tis_ready
[ 1358.966379] tis_send after release_locality
[ 1358.966380] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62

--==_Exmh_1185507681_33070
Content-Type: text/plain ; name="debug.rc1-b"; charset=us-ascii
Content-Description: debug.rc1-b
Content-Disposition: attachment; filename="debug.rc1-b"

[20013.799019] tpm_tis_pnp_init: start=4275306496, len=20480
[20013.804544] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[20013.804701] tpm_tis 00:0f: TPM interface capabilities (0x97):
[20013.804761] tpm_tis 00:0f: 	Command Ready Int Support
[20013.804820] tpm_tis 00:0f: 	Interrupt Level Low
[20013.804875] tpm_tis 00:0f: 	Locality Change Int Support
[20013.804948] tpm_tis 00:0f: 	Sts Valid Int Support
[20013.805005] tpm_tis 00:0f: 	Data Avail Int Support
[20013.805083] tpm0 (IRQ 3) handled a spurious interrupt
[20013.805203] in tpm_tis_send buffer=18446604435978689568 len=22
[20013.805267] tis_send ready to go
[20013.805334] tis_send after iowrite8 loop
[20013.805390] tis_send after second wait_for_stat
[20013.805446] tis_send after second tis_status
[20013.805499] tis_send after last iowrite8
[20013.805553] tis_send after 3rd wait_for_stat
[20013.805608] tis_send after 3rd tis_status
[20013.805661] tis_send after STS_GO
[20013.805712] tis_send before last wait_for_stat
[20133.740241] tis_send after last wait_for_stat
[20133.740251] tis_send before last tis_ready
[20133.740256] tis_send after last tis_ready
[20133.740261] tis_send after release_locality
[20133.740267] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62
[20133.740274] in tpm_tis_send buffer=18446604435978689568 len=22
[20133.740282] tis_send ready_for_command
[20133.740285] tis_send wait for tis_ready
[20135.739111] tis_send timed out waiting for command_ready
[20135.739121] tis_send before last tis_ready
[20135.739127] tis_send after last tis_ready
[20135.739132] tis_send after release_locality
[20135.739138] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62
[20135.739144] in tpm_tis_send buffer=18446604435978689624 len=10
[20135.739153] tis_send ready to go
[20135.739162] tis_send after iowrite8 loop
[20135.739167] tis_send after second wait_for_stat
[20135.739172] tis_send after second tis_status
[20135.739175] tis_send after last iowrite8
[20135.739179] tis_send after 3rd wait_for_stat
[20135.739184] tis_send after 3rd tis_status
[20135.739189] tis_send after STS_GO
[20135.739193] tis_send before last wait_for_stat
[20255.671378] tis_send after last wait_for_stat
[20255.671387] tis_send before last tis_ready
[20255.671394] tis_send after last tis_ready
[20255.671399] tis_send after release_locality
[20255.671405] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62

--==_Exmh_1185507681_33070
Content-Type: application/x-patch ; name="debug.patch"
Content-Description: debug.patch
Content-Disposition: attachment; filename="debug.patch"

--- linux-2.6.23-rc1-mm1/drivers/char/tpm/tpm_tis.c.tis-pim1	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc1-mm1/drivers/char/tpm/tpm_tis.c	2007-07-26 17:51:35.000000000 -0400
@@ -16,6 +16,7 @@
  * published by the Free Software Foundation, version 2 of the
  * License.
  */
+#define DEBUG
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -266,20 +267,25 @@ static int tpm_tis_send(struct tpm_chip 
 	size_t count = 0;
 	u32 ordinal;
 
+printk(KERN_DEBUG "in tpm_tis_send buffer=%llu len=%d\n",buf,len);
 	if (request_locality(chip, 0) < 0)
 		return -EBUSY;
 
 	status = tpm_tis_status(chip);
 	if ((status & TPM_STS_COMMAND_READY) == 0) {
+printk(KERN_DEBUG "tis_send ready_for_command\n");
 		tpm_tis_ready(chip);
+printk(KERN_DEBUG "tis_send wait for tis_ready\n");
 		if (wait_for_stat
 		    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
 		     &chip->vendor.int_queue) < 0) {
+printk(KERN_DEBUG "tis_send timed out waiting for command_ready\n");
 			rc = -ETIME;
 			goto out_err;
 		}
 	}
 
+printk(KERN_DEBUG "tis_send ready to go\n");
 	while (count < len - 1) {
 		burstcnt = get_burstcount(chip);
 		for (; burstcnt > 0 && count < len - 1; burstcnt--) {
@@ -288,9 +294,12 @@ static int tpm_tis_send(struct tpm_chip 
 			count++;
 		}
 
+printk(KERN_DEBUG "tis_send after iowrite8 loop\n");
 		wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
 			      &chip->vendor.int_queue);
+printk(KERN_DEBUG "tis_send after second wait_for_stat\n");
 		status = tpm_tis_status(chip);
+printk(KERN_DEBUG "tis_send after second tis_status\n");
 		if ((status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
 			goto out_err;
@@ -301,9 +310,12 @@ static int tpm_tis_send(struct tpm_chip 
 	iowrite8(buf[count],
 		 chip->vendor.iobase +
 		 TPM_DATA_FIFO(chip->vendor.locality));
+printk(KERN_DEBUG "tis_send after last iowrite8\n");
 	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
 		      &chip->vendor.int_queue);
+printk(KERN_DEBUG "tis_send after 3rd wait_for_stat\n");
 	status = tpm_tis_status(chip);
+printk(KERN_DEBUG "tis_send after 3rd tis_status\n");
 	if ((status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
 		goto out_err;
@@ -313,20 +325,26 @@ static int tpm_tis_send(struct tpm_chip 
 	iowrite8(TPM_STS_GO,
 		 chip->vendor.iobase + TPM_STS(chip->vendor.locality));
 
+printk(KERN_DEBUG "tis_send after STS_GO\n");
 	if (chip->vendor.irq) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+printk(KERN_DEBUG "tis_send before last wait_for_stat\n");
 		if (wait_for_stat
 		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 		     tpm_calc_ordinal_duration(chip, ordinal),
 		     &chip->vendor.read_queue) < 0) {
+printk(KERN_DEBUG "tis_send after last wait_for_stat\n");
 			rc = -ETIME;
 			goto out_err;
 		}
 	}
 	return len;
 out_err:
+printk(KERN_DEBUG "tis_send before last tis_ready\n");
 	tpm_tis_ready(chip);
+printk(KERN_DEBUG "tis_send after last tis_ready\n");
 	release_locality(chip, chip->vendor.locality, 0);
+printk(KERN_DEBUG "tis_send after release_locality\n");
 	return rc;
 }
 
@@ -595,9 +613,11 @@ static int __devinit tpm_tis_pnp_init(st
 				      const struct pnp_device_id *pnp_id)
 {
 	resource_size_t start, len;
+
 	start = pnp_mem_start(pnp_dev, 0);
 	len = pnp_mem_len(pnp_dev, 0);
-
+	printk(KERN_DEBUG "tpm_tis_pnp_init: start=%llu, len=%llu\n",
+		(unsigned long long)start, (unsigned long long)len);
 	return tpm_tis_init(&pnp_dev->dev, start, len);
 }
 

--==_Exmh_1185507681_33070--


--==_Exmh_1185508832_3307P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGqW3gcC3lWbTT17ARAhxAAKDE89E9e5MH43ov3Tg/jAwQUWrQcACgi6he
o8RBRMiMEtXm4ScB5f1pdKk=
=3LLX
-----END PGP SIGNATURE-----

--==_Exmh_1185508832_3307P--
