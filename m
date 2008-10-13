Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYJMTU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYJMTU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbYJMTUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 15:20:13 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59832 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755921AbYJMTUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 15:20:11 -0400
Subject: Re: [GIT PATCH] intermediate SCSI updates
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
References: <1223909115.5566.13.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 13 Oct 2008 15:20:06 -0400
Message-Id: <1223925606.5566.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 10:22 -0700, Linus Torvalds wrote:
> 
> On Mon, 13 Oct 2008, James Bottomley wrote:
> >
> > This represents all the pieces of SCSI which were depending on the
> > already merged block tree.
> 
> Grr. And it doesn't actually compile.
> 
>   drivers/scsi/sd.c:579:27: error: macro "sd_dif_op" passed 4 arguments, but takes just 3
>   drivers/scsi/sd.c: In function ‘sd_prep_fn’:
>   drivers/scsi/sd.c:578: error: ‘sd_dif_op’ undeclared (first use in this function)
>   drivers/scsi/sd.c:578: error: (Each undeclared identifier is reported only once
>   drivers/scsi/sd.c:578: error: for each function it appears in.)
> 
> Hmm? Was this testedt AT ALL? It can never compile unless that idiotic 
> CONFIG_BLK_DEV_INTEGRITY option is set that no sane person would set right 
> now, and which is even documented to not be enabled by default:
> 
>   If in doubt, say N.
> 
> yet it looks like it has not compiled since a commit that was put in in 
> the middle of September!
> 
> What part of "This is total untested crap" are we missing here?

OK, you caught me; I'm relying on linux-next to test randomly built
configs because I don't have a compile farm available to me where I can
test every permutation of the options (and obviously, I usually compile
with them all on to test the actual feature code).

> Yeah, I'm grumpy. I expect to not be fed shit like this. It has apparently 
> been rebased several times, and all apparently with no testing 
> what-so-ever!

Not exactly.  It has to be rebased to run as a postmerge tree, but it
does get tested by me (admittedly on my limited set of machines, which
don't include any actual devices that do block integrity) every time I
rebase.

However, does this work for you?  It fixes the problem for me.

James

---

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index a92b991..75638e7 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -97,7 +97,7 @@ struct sd_dif_tuple {
        __be32 ref_tag;		/* Target LBA or indirect LBA */
 };
 
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
+#ifdef CONFIG_BLK_DEV_INTEGRITY
 
 extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int, unsigned int);
 extern void sd_dif_config_host(struct scsi_disk *);
@@ -106,10 +106,19 @@ extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-#define sd_dif_op(a, b, c)			do { } while (0)
-#define sd_dif_config_host(a)			do { } while (0)
-#define sd_dif_prepare(a, b, c)			(0)
-#define sd_dif_complete(a, b)			(0)
+static inline void sd_dif_op(struct scsi_cmnd *cmd, unsigned int a, unsigned int b, unsigned int c)
+{
+}
+static inline void sd_dif_config_host(struct scsi_disk *disk)
+{
+}
+static inline int sd_dif_prepare(struct request *rq, sector_t s, unsigned int a)
+{
+	return 0;
+}
+static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
+{
+}
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 


