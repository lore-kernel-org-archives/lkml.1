Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYCKPsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYCKPsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYCKPsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:48:06 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33030 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYCKPsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:48:05 -0400
Message-ID: <47D6A99F.4040408@panasas.com>
Date: Tue, 11 Mar 2008 17:47:43 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sven Schnelle <svens@bitebene.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer
 dereference
References: <867igc3w8r.fsf@deprecated.bitebene.org>	<47D551B8.9080807@panasas.com>	<1205183577.2941.38.camel@localhost.localdomain> <86zlt68d0z.fsf@deprecated.bitebene.org>
In-Reply-To: <86zlt68d0z.fsf@deprecated.bitebene.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10 2008 at 23:50 +0200, Sven Schnelle <svens@bitebene.org> wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
>> On Mon, 2008-03-10 at 17:20 +0200, Boaz Harrosh wrote:
>>> James and linux-scsi CCed.
>> Looks fine .. could someone send the patch in an applyable form (i.e.
>> not quoted).
> 
> Sure:
> 
> Fix NULL pointer dereference during execution of Internal commands,
> where gdth only allocates scp, but not scp->sense_buffer. The rest of
> the code assumes that sense_buffer is allocated, which leads to a kernel
> oops e.g. on reboot (during cache flush).
> 
> Signed-off-by: Sven Schnelle <svens@stackframe.org>
> ---
<snip>

Hi Sven.

Do you have gdth HW for testing patches?
I'm anticipating more scsi-ml changes in that regard in near future and would like
a more permanent solution for gdth. Could you please try below patch in place of
your patch and see if it works.

Thanks in advance

James Hi
do you think we should keep Sven's patch for the rc-fixes and my solution
for the next kernel? For the reason that my patch might be theoretically dangerous 
in regard to locking, queue-life-time, and such side effects?

Boaz
--- 
>From 1795a2063eabf326c4fba49af4db6572bdd642b6 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 11 Mar 2008 17:42:06 +0200
Subject: [PATCH] gdth: Use scsi_get_command for gdth internal commands

As found by: Sven Schnelle <svens@bitebene.org>
NULL pointer dereference bug during execution of Internal commands,
where gdth only allocates scp, but not scp->sense_buffer. The rest of
the code assumes that sense_buffer is allocated, which leads to a kernel
oops e.g. on reboot (during cache flush).

Fix this by leting scsi-ml allocate the command for us, in anticipation
of future changes to commands allocation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 4560e39..643e7d6 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -448,7 +448,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
-    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
+    scp = scsi_get_command(sdev, GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
 
@@ -472,7 +472,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     rval = cmndinfo.status;
     if (info)
         *info = cmndinfo.info;
-    kfree(scp);
+    scsi_put_command(scp);
     return rval;
 }
 
-- 
1.5.3.3



