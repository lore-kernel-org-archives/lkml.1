Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYHHFhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYHHFhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 01:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYHHFhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 01:37:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:65447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYHHFhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 01:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eLzk3z5Fi/CIrEYe9CFJTmXilI6zurRU7mcbq/5WxPpnLYBxwlQrVaHLZZr8nUJIRu
         +q4brp+Lz8V2EAICsr5gMB3QhXugGhuAqFG3QyGRBLOsUveacR6H6ljJCH4tyYMm847C
         4K7wo4ekoS4xkstl+Bni4QIqmMt1QmryzokGM=
Date: Fri, 8 Aug 2008 09:37:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: writable packet CD mounting in 2.6.26.x?
Message-ID: <20080808053735.GA5274@martell.zuzino.mipt.ru>
References: <87ej52vtxq.fsf@hades.wkstn.nix> <20080808031437.GA14249@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808031437.GA14249@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 07:14:37AM +0400, Alexey Dobriyan wrote:
> On Wed, Aug 06, 2008 at 08:12:49PM +0100, Nix wrote:
> > It seems to be impossible to mount packet-written CD-RWs writably in
> > 2.6.26.x, even as root. Things worked in 2.6.25.x.
> > 
> > hades:/tmp# ls -l /dev/pktcdvd
> > total 0
> > brw-rw-rw- 1 root root  254,  0 2008-08-05 00:45 cdrw
> > crw-r--r-- 1 root root   10, 63 2008-08-05 00:44 control
> > brw-rw-rw- 1 root cdrom 254,  0 2008-08-05 00:45 pktcdvd0
> > 
> > 
> > hades:/tmp# mount -o rw /dev/pktcdvd/cdrw /mnt/pcdrw
> > mount: block device /dev/pktcdvd/cdrw is write-protected, mounting read-only
> > 
> > hades:/tmp# mount -o rw /dev/pktcdvd/pktcdvd0 /mnt/pcdrw
> > mount: block device /dev/pktcdvd/pktcdvd0 is write-protected, mounting read-only
> > 
> > The strace says that we get -EROFS always, now:
> > 
> > mount("/dev/pktcdvd/cdrw", "/mnt/pcdrw", "udf"..., MS_NOSUID|MS_NODEV|MS_NOEXEC|0x200000, NULL) = -1 EROFS (Read-only file system)
> > 
> > 
> > Anyone got any ideas? There are no suspicious-looking changes in
> > pktcdvd.c itself, so maybe this lies deeper in the block layer. Or
> > perhaps I'm mounting it wrong in some obscure way.

Ho-hum, I get ->mmc3_profile = 9 here in both .25 anf .26 kernel, so I
can't meaningfully debug it here. :-(

Does it -EROFS because of pkt_writable_disc()? If yes, apply this patch
too.

--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1934,6 +1934,7 @@ static int pkt_writable_track(struct pktcdvd_device *pd, track_information *ti)
  */
 static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 {
+	printk("%s: pd = %p, ->mmc3_profile = %u\n", __func__, pd, pd->mmc3_profile);
 	switch (pd->mmc3_profile) {
 		case 0x0a: /* CD-RW */
 		case 0xffff: /* MMC3 not supported */
@@ -1986,7 +1987,16 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
 	cgc.cmd[8] = 8;
 	ret = pkt_generic_packet(pd, &cgc);
+	{
+		int i;
+
+		printk("%s:", __func__);
+		for (i = 0; i < 12; i++)
+			printk(" %02x", buf[i]);
+		printk("\n");
+	}
 	pd->mmc3_profile = ret ? 0xffff : buf[6] << 8 | buf[7];
+	printk("%s: pd = %p, ->mmc3_profile = %u\n", __func__, pd, pd->mmc3_profile);
 
 	memset(&di, 0, sizeof(disc_information));
 	memset(&ti, 0, sizeof(track_information));

