Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYJGWjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYJGWjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYJGWjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:39:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:16725 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbYJGWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z1GmYpw1ZcFuQt8yH4ru1OXXXO2VjhlEy364PskYYSQ8Xfaw7SmbHj9pfJJV+fqQR7
         z0k4jlkt73Ywe0g4hIppthUd2m0f6T6RHI5UHEeu6tokkZA6b40KtYwXINeYkEGBlOUX
         Kr1r8mGqgYMGaHh85klzh9yabP2hgj9zsaWpg=
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <1223417543.7484.7.camel@localhost.localdomain>
References: <1223416391.8195.22.camel@brick>
	 <1223417543.7484.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 15:39:25 -0700
Message-Id: <1223419166.8195.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 18:12 -0400, James Bottomley wrote:
> On Tue, 2008-10-07 at 14:53 -0700, Harvey Harrison wrote:
> > [related question regarding the SCSI-private endian helper needs at the end]
> > 
> > Currently on the read side, we have (le16 as an example endianness)
> > 
> > le16_to_cpup(__le16 *)
> > get_unaligned_le16(void *)
> > 
> > And on the write side:
> > 
> > *(__le16)ptr = cpu_to_le16(u16)
> > put_unaligned_le16(u16, void *);
> > 
> > On the read side, Al said he would have preferred the unaligned version
> > take the same types as the aligned, rather than void *.  AKPM didn't think
> > the use of get_ was that great as get/put generally implies some kind of reference
> > taking in the kernel.
> > 
> > As the le16_to_cpup has been around for so long and is more recognizable, let's
> > make it the same for the unaligned case and typesafe:
> > 
> > le16_to_cpup(__le16 *)
> > unaligned_le16_to_cpup(__le16 *)
> > 
> > On the write side, the above get/put and type issues are still there, in addition AKPM felt
> > that the ordering of the put_unaligned parameters was opposite what was intuitive and that
> > the pointer should come first.
> > 
> > In this case, as there is currently no aligned helper (other than in some drivers defining macros)
> > define the api thusly:
> > 
> > Aligned:
> > write_le16(__le16 *ptr, u16 val)
> > 
> > Unaligned:
> > unaligned_write_le16(__le16 *ptr, u16 val)
> 
> Well, for us it would be even worse since now we'll have to do casting
> to __beX just to shut sparse up, which makes the code even more
> unreadable.

Well, there are so many sparse warnings in scsi already, would a few
more really hurt?

To avoid the casts, you could also define some annotated, packed structs
to avoid the casting.

As an example, in the write command handling in achba.c, a patch similar to the following
(assumes the existence of a __be24 type somewhere):

Somewhere in a scsi header:

struct scsi_cmd_write6 {
	u8	cmd;
	__be24	lba;
	u8	count;
} __packed

struct scsi_cmd_write16 {
	u16	cmd;
	__be64	lba;
	__be32	count;
} __packed

struct scsi_cmd_write12 {
	u16 cmd;
	__be32 lba;
	__be32 count;
	u16 (harvey doesn't know scsi);
} __packed

struct scsi_cmd_write10 {
	u16 cmd;
	__be32 lba;
	u8 (harvey doesn't know scsi);
	__be16 count;
} __packed

ANd then notice that you don't need any casts even if the unaligned helpers
have strict types...that and the code gets a whole lot easier to read.

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index aa4e77c..5363a45 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1786,41 +1786,24 @@ static int aac_synchronize(struct scsi_cmnd *scsicmd)
 			u32 cmnd_count;
 
 			if (cmd->cmnd[0] == WRITE_6) {
-				cmnd_lba = ((cmd->cmnd[1] & 0x1F) << 16) |
-					(cmd->cmnd[2] << 8) |
-					cmd->cmnd[3];
-				cmnd_count = cmd->cmnd[4];
+				const struct scsi_cmd_write_6 *tmp = cmd->cmnd;
+				cmnd_lba = unaligned_be24_to_cpup(&tmp->lba) & 0x001FFFFF;
+				cmnd_count = tmp->count;
+
 				if (cmnd_count == 0)
 					cmnd_count = 256;
 			} else if (cmd->cmnd[0] == WRITE_16) {
-				cmnd_lba = ((u64)cmd->cmnd[2] << 56) |
-					((u64)cmd->cmnd[3] << 48) |
-					((u64)cmd->cmnd[4] << 40) |
-					((u64)cmd->cmnd[5] << 32) |
-					((u64)cmd->cmnd[6] << 24) |
-					(cmd->cmnd[7] << 16) |
-					(cmd->cmnd[8] << 8) |
-					cmd->cmnd[9];
-				cmnd_count = (cmd->cmnd[10] << 24) |
-					(cmd->cmnd[11] << 16) |
-					(cmd->cmnd[12] << 8) |
-					cmd->cmnd[13];
+				const struct scsi_cmd_write_16 *tmp = cmd->cmnd;
+				cmnd_lba = unaligned_be64_to_cpup(&tmp->lba);
+				cmnd_count = unaligned_be32_to_cpup(&tmp->count);
 			} else if (cmd->cmnd[0] == WRITE_12) {
-				cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
-					(cmd->cmnd[3] << 16) |
-					(cmd->cmnd[4] << 8) |
-					cmd->cmnd[5];
-				cmnd_count = (cmd->cmnd[6] << 24) |
-					(cmd->cmnd[7] << 16) |
-					(cmd->cmnd[8] << 8) |
-					cmd->cmnd[9];
+				const struct scsi_cmd_write_12 *tmp = cmd->cmnd;
+				cmnd_lba = unaligned_be32_to_cpup(&tmp->lba);
+				cmnd_count = unaligned_be32_to_cpup(&tmp->count);
 			} else if (cmd->cmnd[0] == WRITE_10) {
-				cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
-					(cmd->cmnd[3] << 16) |
-					(cmd->cmnd[4] << 8) |
-					cmd->cmnd[5];
-				cmnd_count = (cmd->cmnd[7] << 8) |
-					cmd->cmnd[8];
+				const struct scsi_cmd_write_10 *tmp = cmd->cmnd;
+				cmnd_lba = unaligned_be32_to_cpup(&tmp->lba);
+				cmnd_count = unaligned_be16_to_cpup(&tmp->count);
 			} else
 				continue;
 			if (((cmnd_lba + cmnd_count) < lba) ||



