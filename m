Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbYLJSiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbYLJSiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYLJShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:37:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYLJSho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:37:44 -0500
Message-ID: <49400C81.3010801@vlnb.net>
Date: Wed, 10 Dec 2008 21:37:53 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH][RFC 5/23]: SCST /proc interface
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1917JRQvFmnFSymSAkAG2VSwluw4J3EyY71fW+
 vcp/sF0fPBYM1Wvr1OHaznq3+Hijt08/hbAawTMzhLtULn0P2c
 Yw/1pIKaPHzL8YIZ+6ZfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains SCST the /proc interface.

A description of this interface can be found in the patch with the
SCST core documentation.

Since a procfs-based configuration interface is unacceptable for new 
kernel modules, in the next review iteration SCST's configuration 
interface will be replaced by a sysfs-based configuration interface. 
This patch is not intended to be included in the Linux kernel, but is 
posted here, because as of today this configuration interface is 
necessary when using SCST.

Unfortunately, configfs is not (yet) suited for configuring SCST. This 
is, because configfs is user space driven, so kernel can't create 
subdirectories on it, and all files on configfs are limited to 4K in 
size. It makes impossible for kernel to show, e.g., a list of connected 
initiators. Hence, with configfs it is necessary to have one more 
interface to show such data, e.g. sysfs-based. It would lead to 2 
interfaces in two different places for configuring SCSI targets: 
configfs and sysfs based. Definitely, it is better to have only one, 
sysfs-based interface, than 2 interfaces. From other side, sysfs in what 
SCST needs provides basically the same possibilities as configfs. And 
it's widely used in the kernel to configure various its parameters. See, 
for instance, bonding devices or IO schedulers.

The proposed /sys interface would be very similar to the current /proc 
layout intact, except cases, where output >PAGE_SIZE is needed. For such 
cases each entry, i.e. line, in such files would be presented as a 
subdirectory with name the first element in that line and each other 
element in it would be presented as a separate file (attribute). For 
instance, /proc/scsi_tgt/sessions, which lists connected sessions, would 
be converted to:

/sys/scsi_tgt/
    /sys/scsi_tgt/sessions/
      /sys/scsi_tgt/sessions/session1_name/
        /sys/scsi_tgt/sessions/session1_name/target_name
        /sys/scsi_tgt/sessions/session1_name/initiator_name
        /sys/scsi_tgt/sessions/session1_name/acl -> ../../acls/aclX
        /sys/scsi_tgt/sessions/session1_name/commands
    /sys/scsi_tgt/sessions/session2_name/
        /sys/scsi_tgt/sessions/session2_name/target_name
        /sys/scsi_tgt/sessions/session2_name/initiator_name
        /sys/scsi_tgt/sessions/session2_name/acl -> ../../acls/aclY
        /sys/scsi_tgt/sessions/session2_name/commands
.
.
.

Addition of new, e.g. vdisk devices, would be done via echo'ing commands 
to, in this example, /sys/scsi_tgt/vdisk/mgmt file similarly as it's 
currently done with /proc/scsi_tgt/vdisk/vdisk (same commands, actually).

Any comments and suggestions will be greatly appreciated.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/scst_proc.c | 2196 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  1 file changed, 2196 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_proc.diff



