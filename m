Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXGPKsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXGPKsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXGPKso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:48:44 -0400
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:37994 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbXGPKsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:48:43 -0400
Date: Mon, 16 Jul 2007 13:48:28 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
cc: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
In-Reply-To: <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local>
Message-ID: <Pine.LNX.4.64.0707161327470.4941@kai.makisara.local>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
 <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Kai Makisara wrote:

> On Sun, 8 Jul 2007, Bruce Allen wrote:
> 
> > Mark, David, Doug, Tejin, Alan, Jeff, LKML,
> > 
> > I'm afraid that there may be some problem with SMART + libata in the 2.6.22
> > kernel.  An hour ago I discovered that I missed a month of correspondence
> > (some LKML, some private) about this problem which Alan, Tejun, Jeff, Mark and
> > others copied to me -- it was automatically shoved into one of my mailboxes by
> > my mail client.  Sorry about that.  So I am trying to catch up to see if there
> > is some real problem or not.
> > 
...
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/0849.html
> 
> I have done some more debugging on this one. An easy way to reproduce the 
> problem is to use 'smartctl -H /dev/sdb'. If I enable debugging with '-r 
> ioctl,2', I find the following difference between outputs using 2.6.21.1 
> (works OK) and 2.6.22 (fails):
> 
...
> The log shows that the sense data returned by the commands differ: with 
> 2.6.22 the bytes 4f and 2c (tf.lbam and tf.lbah) are not returned. Both of 
> the status commands fail to return these bytes but the tests in smartctl 
> are more strict for the second case. This is why the second status command 
> seems to be failing.
> 
> Next I added printks to the function ata_qc_complete() in libata-core.c. 
> The changed code from 2.6.22 at line 5222 looked like this:
> 
...
> The output from 2.6.21.6 looks like this:
> 
> Jul  9 18:37:44 kai kernel: [  193.443874] ata_qc_complete before: 00 00 00 40
> Jul  9 18:37:44 kai kernel: [  193.443880] ata_qc_complete 16: 00 4f c2 50
> Jul  9 18:37:44 kai kernel: [  193.462802] ata_qc_complete before: 00 4f c2 40
> Jul  9 18:37:44 kai kernel: [  193.462807] ata_qc_complete 16: 00 4f c2 50
> 
> i.e., the bytes are returned.
> 
> The output from 2.6.22 is different:
> 
> Jul  9 18:44:35 kai kernel: [  147.765965] ata_qc_complete before: 00 00 00 40
> Jul  9 18:44:35 kai kernel: [  147.765970] ata_qc_complete 16: 00 00 00 50
> Jul  9 18:44:35 kai kernel: [  147.784890] ata_qc_complete before: 00 00 00 40
> Jul  9 18:44:35 kai kernel: [  147.784894] ata_qc_complete 16: 00 00 00 50
> 
> The lbam and lbah bytes are not returned but the command byte is.
> 
The other system with the Maxtor disk fails in a slightly different way 
(it correctly returns the c2 byte but not in the correct location):

[  162.896173] ata_qc_complete before: 00 00 00 40
[  162.896179] ata_qc_complete 16: 00 c2 00 50



My earlier 'git bisect' suggested that this problem surfaced after the 
patch

1e999736cafdffc374f22eed37b291129ef82e4e is first bad commit
commit 1e999736cafdffc374f22eed37b291129ef82e4e
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Wed Apr 11 00:23:13 2007 +0100

    libata: HPA support

I have now done some further tests to see what is happening. 
It turned out that after commenting the call (at line 1956 in 
drivers/ata/libata-core.c in 2.6.22)

                        if (ata_id_hpa_enabled(dev->id))
                           dev->n_sectors = ata_hpa_resize(dev);

'smartctl -H' worked again without problems. This applied to both of the 
systems where I see the problem. The disks in both systems support hpa but 
nothing is hidden. Next I commented only the call to 
ata_read_native_max_address_ext() in ata_hpa_resize(). This was enough 
to remove the problem (as was expected).

So, the question is: why does calling ata_read_native_max_address_ext() 
when booting the system cause the SMART RETURN STATUS fail much later?

-- 
Kai
