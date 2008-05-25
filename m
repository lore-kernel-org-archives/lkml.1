Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbYEXWVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbYEXWVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762849AbYEXWV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:21:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:39711 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762787AbYEXWVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=VxJmP8JYo7mIypjXBU9P8Ltd6QJTnQSZehq9AiLbygqddTikCtWN029mbque5a8Vtk035aSakiegUmgiqVK3F6ZZVraJP6bDNvCNdkvZcvzU8fUve6SfiWi/lW9kt0RyOn3O++U3j42I2sPtYhC+nShZ48vdMglLk6ApaDWBv6c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10749] the system doesn't shutdown
Date: Mon, 26 May 2008 00:19:09 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Riccardo" <goric@trivenet.it>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.w4C.BeIOIB@albercik>
In-Reply-To: <TW_YzGo9TFP.A.w4C.BeIOIB@albercik>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805260019.09846.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 24 May 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10749
> Subject		: the system doesn't shutdown
> Submitter	: Riccardo <goric@trivenet.it>
> Date		: 2008-05-19 09:00 (6 days old)

Riccardo, thanks for bisecting the problem.  Could you also attach dmesgs
for "good" and "bad" kernels at bugzilla entry (so we can see if there are
any clues for solving the regression in messages printed by the driver)?

Also does the following patch help (we should always setup PCI device
with pci_enable_device() before using it, my patch changed it)?

---
 drivers/ide/pci/sis5513.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -569,6 +569,11 @@ static int __devinit sis5513_init_one(st
 {
 	struct ide_port_info d = sis5513_chipset;
 	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
+	int rc;
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		return rc;
 
 	if (sis_find_family(dev) == 0)
 		return -ENOTSUPP;

