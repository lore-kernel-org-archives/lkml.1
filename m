Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXHFRDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXHFRDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbXHFRD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:03:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:61981 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbXHFRD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=SRKGFd2APROC+VEwzn+rMQ9YVw/Ba6pV6cKBgs1Zo68jF52BzdTJvh2Q+myWGML31f3Pqj8prgRTXbf1ZbfTWZyge+d/gLeTUayfw2rPywacu5jEctciffn3CMkgJAR3+BfQKIJT9+7qbWrqChX5LcpPgZwllo+Zm4wUUcuyaTI=
Message-ID: <46B75459.9020204@gmail.com>
Date: Tue, 07 Aug 2007 02:03:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Michael Sedkowski <sedmich@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <1186411815.4355.7.camel@nx6310> <20070806150159.GC31615@khazad-dum.debian.net> <200708061732.03425.rjw@sisk.pl>
In-Reply-To: <200708061732.03425.rjw@sisk.pl>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------050005050003000101000908"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050005050003000101000908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Rafael J. Wysocki wrote:
>>> Sidux is a Debian Unstable based distro with it's own set of patches
>>> including the shut down patch provided here:
>>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=426224
>> You'll probably have to ask Sidux what changes they made that could cause
>> the double spin down, even if halt(8) is never passed the -h flag.
> 
> Well, I've been observing the same behavior on nx6325 for some time and I
> use openSUSE 10.2.  I think this is kernel-related.

Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
pulling unnecessary stunt.  Please apply the attached patch and report
when the disk spins down and up.

Thanks.

-- 
tejun

--------------050005050003000101000908
Content-Type: text/x-patch;
 name="shutdown-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="shutdown-debug.patch"

diff --git a/kernel/sys.c b/kernel/sys.c
index 449b81b..9578e3f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -875,10 +875,20 @@ EXPORT_SYMBOL_GPL(kernel_halt);
  */
 void kernel_power_off(void)
 {
+	printk(KERN_EMERG "XXX: pre-shutdown prepare\n");
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
-	if (pm_power_off_prepare)
+	printk(KERN_EMERG "XXX: post-shutdown prepare, sleeping 5\n");
+	ssleep(5);
+	if (pm_power_off_prepare) {
+		printk(KERN_EMERG "XXX: pre-power_off_prepare\n");
 		pm_power_off_prepare();
+		printk(KERN_EMERG "XXX: post-power_off_prepare, sleeping 5\n");
+		ssleep(5);
+	}
+	printk(KERN_EMERG "XXX: pre-sysdev_shutdown\n");
 	sysdev_shutdown();
+	printk(KERN_EMERG "XXX: post-sysdev_shutdown, sleeping 5\n");
+	ssleep(5);
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
 }

--------------050005050003000101000908--
