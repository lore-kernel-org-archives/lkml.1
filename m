Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbXGTDdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbXGTDdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbXGTDdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:33:08 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:52302 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbXGTDdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:33:06 -0400
Message-ID: <46A02CED.7000309@us.ibm.com>
Date: Thu, 19 Jul 2007 23:33:01 -0400
From: Reiner Sailer <sailer@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: jesper.juhl@gmail.com, kjhall@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Seiji Munetoh <munetoh@jp.ibm.com>,
       Reiner Sailer <sailer@watson.ibm.com>, stefanb@us.ibm.com
Subject: Re: [PATCH] Memory leak in tpm_ascii_bios_measurements_open() fix.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper,

thank you very much for finding this error and for posting a patch 
proposal. Since Kylene is not online, I am responding. Please see my 
inlines and an alternative patch proposal below.

Jesper Juhl <jesper.juhl@gmail.com> wrote on 07/18/2007 07:11:54 PM:

 > Ehlo,
 >
 > Coverity found a memory leak in tpm_ascii_bios_measurements_open().
 >
 > If "read_log(log)" fails, then we may leak 'log' and
 > 'log->bios_event_log'.
 >
 > This patch should fix it, but please double check it. I don't know
 > this code very well and the patch has only been compile tested.
 >
 >
 > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
 > ---
 >
 >  drivers/char/tpm/tpm_bios.c |   11 ++++++++---
 >  1 files changed, 8 insertions(+), 3 deletions(-)
 >
 > diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
 > index 4eba32b..4b26ce4 100644
 > --- a/drivers/char/tpm/tpm_bios.c
 > +++ b/drivers/char/tpm/tpm_bios.c
 > @@ -427,7 +427,7 @@ static int
 > tpm_ascii_bios_measurements_open(struct inode *inode,
 >        return -ENOMEM;
 >  
 >     if ((err = read_log(log)))
 > -      return err;
 > +      goto out_free;


log->bios_event_log should not be pointing to allocated memory here
(seems cleaner if read_log cleans its allocated memory in the error case)
---> just free log


 >
 >     /* now register seq file */
 >     err = seq_open(file, &tpm_ascii_b_measurments_seqops);
 > @@ -435,10 +435,15 @@ static int
 > tpm_ascii_bios_measurements_open(struct inode *inode,
 >        seq = file->private_data;
 >        seq->private = log;
 >     } else {
 > -      kfree(log->bios_event_log);
 > -      kfree(log);
 > +      goto out_free;
 >     }
 > +
 > +out:
 >     return err;
 > +out_free:
 > +   kfree(log->bios_event_log);
 > +   kfree(log);
 > +   goto out;
 >  }
 >  
 >  const struct file_operations tpm_ascii_bios_measurements_ops = {
 >
 >

The following patch should be sufficient to fix the problem you discovered:
---
 drivers/char/tpm/tpm_bios.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc7/drivers/char/tpm/tpm_bios.c
===================================================================
--- linux-2.6.22-rc7.orig/drivers/char/tpm/tpm_bios.c
+++ linux-2.6.22-rc7/drivers/char/tpm/tpm_bios.c
@@ -426,9 +426,10 @@ static int tpm_ascii_bios_measurements_o
     if (!log)
         return -ENOMEM;
 
-    if ((err = read_log(log)))
+    if ((err = read_log(log))) {
+        kfree(log);
         return err;
-
+    }
     /* now register seq file */
     err = seq_open(file, &tpm_ascii_b_measurments_seqops);
     if (!err) {

Do you agree?

Greetings
Reiner

