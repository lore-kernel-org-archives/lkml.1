Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbZKYE7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbZKYE7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 23:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934548AbZKYE7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 23:59:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42040 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509AbZKYE7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 23:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nKGpT7796bEOdblxexBksZFxCI8jXrwdMD0e9UJdf4DtiQ1HL2nE3mE7x5njnxD1a3
         GWb94OQxU/zFqyiQ5iamc979wJWgUCWDroliF+v2DWuJb2Au/tdrepgKOMHWngA5hNkq
         8R3SlmaIRWsFo/iiV84YPlReixFz5oAamdFuA=
Date: Wed, 25 Nov 2009 07:59:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, mac@melware.de,
       tilman@imap.cc
Subject: Re: [PATCH] proc_fops: convert drivers/isdn/ to seq_file
Message-ID: <20091125045914.GA3528@x200.malnet.ru>
References: <20091123015625.GA32088@x200.localdomain>
 <20091124162541.03e7e375.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124162541.03e7e375.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 04:25:41PM -0800, Andrew Morton wrote:
> On Mon, 23 Nov 2009 04:56:25 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:

> linux-next collision:
> 
> drivers/isdn/gigaset/capi.c: In function 'gigaset_isdn_register':
> drivers/isdn/gigaset/capi.c:2259: error: 'struct capi_ctr' has no member named 'ctr_read_proc'

Please, fold into my patch:

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -2106,35 +2106,22 @@ static char *gigaset_procinfo(struct capi_ctr *ctr)
 	return ctr->name;	/* ToDo: more? */
 }
 
-/**
- * gigaset_ctr_read_proc() - build controller proc file entry
- * @page:	buffer of PAGE_SIZE bytes for receiving the entry.
- * @start:	unused.
- * @off:	unused.
- * @count:	unused.
- * @eof:	unused.
- * @ctr:	controller descriptor structure.
- *
- * Return value: length of generated entry
- */
-static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
-			  int count, int *eof, struct capi_ctr *ctr)
+static int gigaset_proc_show(struct seq_file *m, void *v)
 {
+	struct capi_ctr *ctr = m->private;
 	struct cardstate *cs = ctr->driverdata;
 	char *s;
 	int i;
-	int len = 0;
-	len += sprintf(page+len, "%-16s %s\n", "name", ctr->name);
-	len += sprintf(page+len, "%-16s %s %s\n", "dev",
+
+	seq_printf(m, "%-16s %s\n", "name", ctr->name);
+	seq_printf(m, "%-16s %s %s\n", "dev",
 			dev_driver_string(cs->dev), dev_name(cs->dev));
-	len += sprintf(page+len, "%-16s %d\n", "id", cs->myid);
+	seq_printf(m, "%-16s %d\n", "id", cs->myid);
 	if (cs->gotfwver)
-		len += sprintf(page+len, "%-16s %d.%d.%d.%d\n", "firmware",
+		seq_printf(m, "%-16s %d.%d.%d.%d\n", "firmware",
 			cs->fwver[0], cs->fwver[1], cs->fwver[2], cs->fwver[3]);
-	len += sprintf(page+len, "%-16s %d\n", "channels",
-			cs->channels);
-	len += sprintf(page+len, "%-16s %s\n", "onechannel",
-			cs->onechannel ? "yes" : "no");
+	seq_printf(m, "%-16s %d\n", "channels", cs->channels);
+	seq_printf(m, "%-16s %s\n", "onechannel", cs->onechannel ? "yes" : "no");
 
 	switch (cs->mode) {
 	case M_UNKNOWN:
@@ -2152,7 +2139,7 @@ static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
 	default:
 		s = "??";
 	}
-	len += sprintf(page+len, "%-16s %s\n", "mode", s);
+	seq_printf(m, "%-16s %s\n", "mode", s);
 
 	switch (cs->mstate) {
 	case MS_UNINITIALIZED:
@@ -2176,25 +2163,25 @@ static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
 	default:
 		s = "??";
 	}
-	len += sprintf(page+len, "%-16s %s\n", "mstate", s);
+	seq_printf(m, "%-16s %s\n", "mstate", s);
 
-	len += sprintf(page+len, "%-16s %s\n", "running",
+	seq_printf(m, "%-16s %s\n", "running",
 			cs->running ? "yes" : "no");
-	len += sprintf(page+len, "%-16s %s\n", "connected",
+	seq_printf(m, "%-16s %s\n", "connected",
 			cs->connected ? "yes" : "no");
-	len += sprintf(page+len, "%-16s %s\n", "isdn_up",
+	seq_printf(m, "%-16s %s\n", "isdn_up",
 			cs->isdn_up ? "yes" : "no");
-	len += sprintf(page+len, "%-16s %s\n", "cidmode",
+	seq_printf(m, "%-16s %s\n", "cidmode",
 			cs->cidmode ? "yes" : "no");
 
 	for (i = 0; i < cs->channels; i++) {
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "corrupted",
+		seq_printf(m, "[%d]%-13s %d\n", i, "corrupted",
 				cs->bcs[i].corrupted);
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "trans_down",
+		seq_printf(m, "[%d]%-13s %d\n", i, "trans_down",
 				cs->bcs[i].trans_down);
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "trans_up",
+		seq_printf(m, "[%d]%-13s %d\n", i, "trans_up",
 				cs->bcs[i].trans_up);
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "chstate",
+		seq_printf(m, "[%d]%-13s %d\n", i, "chstate",
 				cs->bcs[i].chstate);
 		switch (cs->bcs[i].proto2) {
 		case L2_BITSYNC:
@@ -2209,11 +2196,24 @@ static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
 		default:
 			s = "??";
 		}
-		len += sprintf(page+len, "[%d]%-13s %s\n", i, "proto2", s);
+		seq_printf(m, "[%d]%-13s %s\n", i, "proto2", s);
 	}
-	return len;
+	return 0;
 }
 
+static int gigaset_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, gigaset_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations gigaset_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= gigaset_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 
 static struct capi_driver capi_driver_gigaset = {
 	.name		= "gigaset",
@@ -2256,7 +2256,7 @@ int gigaset_isdn_register(struct cardstate *cs, const char *isdnid)
 	iif->ctr.release_appl  = gigaset_release_appl;
 	iif->ctr.send_message  = gigaset_send_message;
 	iif->ctr.procinfo      = gigaset_procinfo;
-	iif->ctr.ctr_read_proc = gigaset_ctr_read_proc;
+	iif->ctr.proc_fops = &gigaset_proc_fops;
 	INIT_LIST_HEAD(&iif->appls);
 	skb_queue_head_init(&iif->sendqueue);
 	atomic_set(&iif->sendqlen, 0);
