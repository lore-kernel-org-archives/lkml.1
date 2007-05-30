Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXE3K1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXE3K1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXE3K1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:27:00 -0400
Received: from ic0245.upco.es ([130.206.70.245]:49967 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXE3K07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:26:59 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Romano Giannetti <romanol@upcomillas.es>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Chris Wright <chrisw@sous-sol.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <alpine.LFD.0.98.0705290752190.26602@woody.linux-foundation.org>
References: <1180008394.15600.26.camel@localhost>
	 <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org>
	 <20070527164300.GA20355@srcf.ucam.org> <200705272032.15971.rjw@sisk.pl>
	 <20070527184402.GA21161@srcf.ucam.org> <1180427492.21686.9.camel@localhost>
	 <alpine.LFD.0.98.0705290752190.26602@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 May 2007 12:26:57 +0200
Message-Id: <1180520817.16962.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-05-29 at 07:55 -0700, Linus Torvalds wrote:
> 
> On Tue, 29 May 2007, Romano Giannetti wrote:
> >
> > - The good (?) news. I have made 7 suspend/resume cycle (to ram, I
> > haven't tested hibernation) with a 2.6.21.2 with that patch, applied
> > manually. The system did suspend and resume nicely even compiling a
> > kernel and opening openoffice. Normally (le me stress _normally_) no
> > delay was apparent on resume. I do not know how dangerous is this... :-)
> > 
> > - The bad (?) news. One time out of 7 I had the 60 seconds delay.
> 
> Interesting. If you can re-create it, please do the sysrq-T thing again, 
> to see what's up. (Also, you might do "sysrq-p", which gives the current 
> process data, which sysrq-T does not).


I've got it, but I had a problem: I filled the dmesg buffer. I will try
to find where to enlarge it. I have posted the partial result to: 

http://www.dea.icai.upcomillas.es/romano/linux/info/dmesg-resume-nofreeze.txt

in the hope that something can be used. I am running 2.6.21.2, with the
"no freeze kthreads at all" patch from Matthew Garrett, with this
add-on:

--- drivers/base/firmware_class.c.orig	2007-05-30 12:19:59.000000000 +0200
+++ drivers/base/firmware_class.c	2007-05-29 19:39:56.000000000 +0200
@@ -471,7 +471,11 @@
                  struct device *device)
 {
         int uevent = 1;
-        return _request_firmware(firmware_p, name, device, uevent);
+        int rval;
+        printk(KERN_ERR "FW: requesting firmware (sync) for %s\n", name);
+        rval = _request_firmware(firmware_p, name, device, uevent);
+        printk(KERN_ERR "FW: return %d\n", rval);
+        return rval;
 }
 
 /**
@@ -545,7 +549,9 @@
 	struct task_struct *task;
 	struct firmware_work *fw_work = kmalloc(sizeof (struct firmware_work),
 						GFP_ATOMIC);
-
+        
+        printk(KERN_ERR "FW: requesting firmware (async) for %s\n", name);
+        
 	if (!fw_work)
 		return -ENOMEM;
 	if (!try_module_get(module)) {
@@ -569,8 +575,12 @@
 		fw_work->cont(NULL, fw_work->context);
 		module_put(fw_work->module);
 		kfree(fw_work);
+                printk(KERN_ERR "FW: failing return %d\n", PTR_ERR(task));
 		return PTR_ERR(task);
 	}
+        
+        printk(KERN_ERR "FW: normal return\n");
+
 	return 0;
 }
 




-- 
Romano Giannetti --- romano.giannetti@gmail.com
Sorry for the following disclaimer, it's attached by our otugoing server
and I cannot shut it up.
 


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
