Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYHWVth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYHWVth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 17:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYHWVta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 17:49:30 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:36158 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYHWVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 17:49:29 -0400
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Writable packet CD-RW mounting broken in 2.6.26 by your commit 68154e90c9d1492d570671ae181d9a8f8530da55
References: <87ej52vtxq.fsf@hades.wkstn.nix>
	<20080808031437.GA14249@martell.zuzino.mipt.ru>
	<20080808053735.GA5274@martell.zuzino.mipt.ru>
From: Nix <nix@esperi.org.uk>
Emacs: (setq software-quality (/ 1 number-of-authors))
Date: Sat, 23 Aug 2008 22:48:55 +0100
In-Reply-To: <20080808053735.GA5274@martell.zuzino.mipt.ru> (Alexey Dobriyan's message of "Fri, 8 Aug 2008 09:37:35 +0400")
Message-ID: <8763pr1jy0.fsf_-_@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Aug 2008, Alexey Dobriyan told this:

> On Fri, Aug 08, 2008 at 07:14:37AM +0400, Alexey Dobriyan wrote:
>> On Wed, Aug 06, 2008 at 08:12:49PM +0100, Nix wrote:
>> > It seems to be impossible to mount packet-written CD-RWs writably in
>> > 2.6.26.x, even as root. Things worked in 2.6.25.x.

Bisected. The bug starts here:

commit 68154e90c9d1492d570671ae181d9a8f8530da55
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Fri Apr 25 12:47:50 2008 +0200

    block: add dma alignment and padding support to blk_rq_map_kern

    This patch adds bio_copy_kern similar to
    bio_copy_user. blk_rq_map_kern uses bio_copy_kern instead of
    bio_map_kern if necessary.

    bio_copy_kern uses temporary pages and the bi_end_io callback frees
    these pages. bio_copy_kern saves the original kernel buffer at
    bio->bi_private it doesn't use something like struct bio_map_data to
    store the information about the caller.

    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Cc: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

With this patch from Alexey applied for diagnostics:

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

We see output upon packet-written CD-RW mount going from the expected:

Aug 23 22:15:24 hades warning: kernel: pkt_probe_settings: 00 00 00 ac 00 00 00 0a 00 00 00 00
Aug 23 22:15:24 hades warning: kernel: pkt_probe_settings: pd = efce7ec0, ->mmc3_profile = 10
Aug 23 22:15:24 hades warning: kernel: pkt_writable_disc: pd = efce7ec0, ->mmc3_profile = 10

(i.e. `this is a CD-RW'), to the incorrect-by-one-byte

Aug 23 22:06:41 hades warning: kernel: pkt_probe_settings: 00 00 00 ac 00 00 00 00 00 00 00 00
                                                                                ^^
Aug 23 22:06:41 hades warning: kernel: pkt_probe_settings: pd = efc97dc0, ->mmc3_profile = 0
Aug 23 22:06:41 hades warning: kernel: pkt_writable_disc: pd = efc97dc0, ->mmc3_profile = 0

i.e., not a CD-RW, writable mounts impossible.

So something in this patch seems to be corrupting the results of at
least some ATAPI sg requests going to or from the block layer: and
indeed blk_rq_map_kern(), called by pkt_generic_packet(), is changed by
this patch.

Tomonori, Jens, can you see any immediate cause of this? It seems to me
that the alignment check in blk_rq_map_kern() *must* be going wrong,
somehow: this can't be an unaligned buffer or the code wouldn't have
worked before the patch, yet if the buffer was aligned, we should be
calling bio_map_kern(), which this patch hasn't changed. Perhaps the
buffer length of 12 is leading it to believe that it should go via a
bounce buffer and is calling the new code (and tripping some bug in it,
since presumably even the new code isn't expected to corrupt the data in
flight ;) )

Further investigations soon but I've had enough of rebooting my desktop
for tonight.

-- 
`Not even vi uses vi key bindings for its command line.' --- PdS
