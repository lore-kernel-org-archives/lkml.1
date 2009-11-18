Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZKRKSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZKRKSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZKRKSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:18:48 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:36612 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZKRKSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:18:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Gh7Oi3/TemMkGV8fgPzL07X4Mtf7Oxb1b3Z2vmF0L3xJ8Mb967jgAQMwbDNwTV0/Fg
         RmY8yJz0p7rbAT3T/C7gt3j55TViFTskBvU5HqIwWz1W9unuDbLJKr+zCHdecDt0eOGF
         4JUKnUXtcY9jI2nJ1iYXhv1PH9eoqnwDbf5Do=
MIME-Version: 1.0
In-Reply-To: <20091112134554.GA30272@elte.hu>
References: <4AFB2C0B.50605@gmail.com>
	 <20091111134730.a0da9e38.akpm@linux-foundation.org>
	 <25d66d860911120531u6a9cd40dmf3056fd99bd97f4e@mail.gmail.com>
	 <20091112134554.GA30272@elte.hu>
Date: Wed, 18 Nov 2009 05:18:53 -0500
X-Google-Sender-Auth: a16636e07d0c23bb
Message-ID: <c0c067900911180218h466bec13m5f8ec8713617b11a@mail.gmail.com>
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
From: Dan Merillat <dan.merillat@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rostedt@goodmis.org, Mike Miller <mike.miller@hp.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       iss_storagedev@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 8:45 AM, Ingo Molnar <mingo@elte.hu> wrote:

> Even in filesystems, ~80% of the cases use proper negative values:
>
>  $ git grep 'return -E' fs/ | wc -l
>  4540
>  $ git grep 'return E' fs/ | wc -l
>  895

Except....
fs/9p/fid.c:                            return ERR_PTR(-EPERM);

try this:

$ git grep "return E[A-Z]*;" | grep -v EOF | grep -v ERROR | wc -l
138
$ git grep "return -E[A-Z]*;"| wc -l
57285

2 of those are in Documentation/ and 2 are comments from a quick
glance.   134 uses of positive error returns, _74_ of which are in
fs/xfs, 24 in bluetooth, and the rest scattered randomly around the
kernel.

134 positive error returns  vs 57881 negative?  The style is so
strongly ingrained in the kernel (And I'd bet an audit of those
remaning 134 would find at least one bug) that it'd be a good janitor
task to go through and switch them.


This is one example - a function that returns either ENXIO or 0, and
the lone caller explicitly tests and flips the sign.

(Not signing off on this!!!!  but CCing the relevant people for this driver)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6399e50..79867d6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -428,7 +428,7 @@ cciss_proc_write(struct file *file, const char __user *buf,

                rc = cciss_engage_scsi(h->ctlr);
                if (rc != 0)
-                       err = -rc;
+                       err = rc;
                else
                        err = length;
        } else
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 3315268..4af3085 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1547,7 +1547,7 @@ cciss_engage_scsi(int ctlr)
        if (sa->registered) {
                printk("cciss%d: SCSI subsystem already engaged.\n", ctlr);
                spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-               return ENXIO;
+               return -ENXIO;
        }
        sa->registered = 1;
        spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
