Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYD2Sic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYD2Sic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYD2SiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:38:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810AbYD2SiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:38:23 -0400
Date: Tue, 29 Apr 2008 11:38:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: den@openvz.org, adobriyan@gmail.com, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-Id: <20080429113800.8f8100b0.akpm@linux-foundation.org>
In-Reply-To: <20080429182709.GB2898@cs181133002.pp.htv.fi>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 21:27:10 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
> came through -mm that contains a patch implementing the overdue removal 
> of the PCMCIA control ioctl that did not yet make it into Linus' tree:
> 
> <---  snip  -->
> 
> ...
>   CC      drivers/pcmcia/pcmcia_ioctl.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c: In function ___pcmcia_setup_ioctl___:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:790: error: ___proc_bus___ undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:790: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:790: error: for each function it appears in.)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c: In function ___pcmcia_cleanup_ioctl___:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:801: error: ___proc_bus___ undeclared (first use in this function)
> make[3]: *** [drivers/pcmcia/pcmcia_ioctl.o] Error 1
> 
> <--  snip  -->
> 

Yes, I fixed it but then fumbled the fix :(

I sent Linus the below an hour or so ago.

--- a/drivers/pcmcia/pcmcia_ioctl.c~drivers-pcmcia-pcmcia_ioctlc-fix-build
+++ a/drivers/pcmcia/pcmcia_ioctl.c
@@ -787,7 +787,7 @@ void __init pcmcia_setup_ioctl(void) {
 		major_dev = i;
 
 #ifdef CONFIG_PROC_FS
-	proc_pccard = proc_mkdir("pccard", proc_bus);
+	proc_pccard = proc_mkdir("bus/pccard", NULL);
 	if (proc_pccard)
 		create_proc_read_entry("drivers",0,proc_pccard,proc_read_drivers,NULL);
 #endif
@@ -798,7 +798,7 @@ void __exit pcmcia_cleanup_ioctl(void) {
 #ifdef CONFIG_PROC_FS
 	if (proc_pccard) {
 		remove_proc_entry("drivers", proc_pccard);
-		remove_proc_entry("pccard", proc_bus);
+		remove_proc_entry("bus/pccard", NULL);
 	}
 #endif
 	if (major_dev != -1)
_

