Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbXHQVAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbXHQVAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbXHQVAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:00:31 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:15358 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbXHQVAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:00:30 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="48698873:sNHT92735797"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Gerd Hoffmann" <kraxel@redhat.com>
Subject: Re: Early printk behaviour
Date: Fri, 17 Aug 2007 17:00:29 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <8bd0f97a0708160947x3bd308abmc4f3b523e2444586@mail.gmail.com> <46C552FB.4000508@redhat.com>
In-Reply-To: <46C552FB.4000508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171700.29647.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Aug 2007 21:00:29.0035 (UTC) FILETIME=[A449EBB0:01C7E111]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17 Aug 2007 03:49, Gerd Hoffmann pondered:
> Mike Frysinger wrote:
> >> Hmm, sort of, although I didn't think about the case of no real console
> >> replacing the early console.  The intention of the patch is to have a
> >> smooth handover from the boot console to the real console.  And, yes, if
> >> no real console is ever registered the boot console keeps running ...
> > 
> > i think it also occurs in the case where real console != early console
> 
> No.  At least not of the boot console has the CON_BOOT flag set as it
> should.  Last message you'll see on the boot console is the handover
> printk, telling you which real console device prints the following
> messages.  Whenever early and real console go to the physical device or
> not doesn't matter.
> 
> >> So you can either let it running and *not* mark it __init, so it can
> >> keep on going without breaking.  Or you can explicitly unregister your
> >> boot console at some point, maybe using a late_initcall.
> > 
> > wouldnt a common kernel late_initcall() be more appropriate ?  if
> > early console hasnt switched over (for whatever reason), then kill it
> 
> Hmm, yes, should be doable in generic code.  Check whenever the current
> console has CON_BOOT set and if so unregister it.

Something like:

Index: kernel/printk.c
===================================================================
--- kernel/printk.c     (revision 3568)
+++ kernel/printk.c     (working copy)
@@ -1104,6 +1104,22 @@
 }
 EXPORT_SYMBOL(unregister_console);

+int __init disable_boot_consoles(void)
+{
+       struct console *con;
+
+       for (con = console_drivers; con; con = con->next) {
+               if (con->flags & CON_BOOT) {
+                       printk(KERN_INFO "Unregister BootConsole %s%d\n",
+                               con->name, con->index);
+                       unregister_console(con);
+               }
+       }
+       return 0;
+}
+late_initcall(disable_boot_consoles);
+
+
 /**
  * tty_write_message - write a message to a certain tty, not just the console.
  * @tty: the destination tty_struct
