Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXJQToK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXJQToK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXJQTnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:43:55 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:41740 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753535AbXJQTny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:43:54 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 15:43:54 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=5ZuZ2jzReo7iOU1jNqRhSa7CnmKFMkLi0CnZLN2kHhEGpNmE4vlTRL2I3vIt1niamH4+fOUp7H37ewq87D1QDWRU5B5f933CohlKkFBKMmukp74rPejyxhqBF2nX6pR7kH+9fwpckUr6NzRUH1q3yg4Z/ntlugFECL4tSb0VUZU=  ;
X-YMail-OSG: cmdu8LMVM1n9_XuL4.Zit5GGsb7QFk2Z41Skb53R11_WtJZ_Xy3pCPcXat3yo8s4mw9c3NIRgA--
Date: Wed, 17 Oct 2007 12:37:13 -0700
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org, drzeus-list@drzeus.cx
Subject: Re: mmc_spi stopped working
References: <20071017211923.31fde15e@poseidon.drzeus.cx>
In-Reply-To: <20071017211923.31fde15e@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I just tried out mmc_spi on Linux HEAD and it no longer works. :/

I noticed that too.  I've got a patch for one bug (appended), and
will be looking at a fix for the second.


> It seems to be caused by changes in the SPI core on how to handled bus
> sharing. All I'm getting in dmesg is this:
>
> [17179577.832000] mmc_spi spi1.0: can't share SPI bus
> [17179577.836000] mmc_spi: probe of spi1.0 failed with error -31

That issue is 49dce689ad4ef0fd1f970ef762168e4bd46f69a3, the
classdev-elimination patch from Tony Jones.  It broke the
"does this bus have more than one device" test by relocating
the relevant sysfs nodes.

Quick workaround for that one is to disable the fault return
after that test.

- Dave

==========	CUT HERE
When enumerating MMC cards using SPI, don't support the "just probe"
mechanism since it doesn't always work.  Instead, always wait for the
reset to complete before issuing the next request.

This is a regression ... this SanDisk MMC card used to enumerate with
no trouble, despite this particular spec violation.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/drivers/mmc/core/mmc_ops.c	2007-10-13 17:44:43.000000000 -0700
+++ b/drivers/mmc/core/mmc_ops.c	2007-10-16 18:54:38.000000000 -0700
@@ -115,8 +115,11 @@ int mmc_send_op_cond(struct mmc_host *ho
 		if (err)
 			break;
 
-		/* if we're just probing, do a single pass */
-		if (ocr == 0)
+		/* if we're just probing, do a single pass ... except,
+		 * accomodate cards which don't behave right until a
+		 * SPI reset completes.
+		 */
+		if (ocr == 0 && !mmc_host_is_spi(host))
 			break;
 
 		/* otherwise wait until reset completes */
