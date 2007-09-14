Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbXINTD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbXINTD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXINTDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:03:21 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:44353 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXINTDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:03:20 -0400
X-Greylist: delayed 72833 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 15:03:20 EDT
Message-ID: <46EADB35.7000309@free.fr>
Date: Fri, 14 Sep 2007 21:04:21 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: 2.6.23-rc4-mm1: git-block.patch broke pktcdvd
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <46E5A6D1.3050704@free.fr> <46E9BEB1.3060504@free.fr> <20070914093358.GB25592@kernel.dk> <20070914110606.GJ25592@kernel.dk>
In-Reply-To: <20070914110606.GJ25592@kernel.dk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14.09.2007 13:06, Jens Axboe a écrit :
> On Fri, Sep 14 2007, Jens Axboe wrote:
>> On Fri, Sep 14 2007, Laurent Riffard wrote:
>>> Le 10.09.2007 22:19, Laurent Riffard a écrit :
>>>>
>>>> Jens,
>>>>
>>>> git-block.patch broke pktcdvd, I've got an Oops while syncing:
>>>>
[snip]
>>> I dig through git-block.patch and the culprit seems to be commit
>>> c94f1c4ac87862675c8d70941973bc3a69aff5d8 "bio: use memset() in
>>> bio_init()".
>>>
>>> Maybe the real bug is a bad bio initialization in pktcdvd driver,
>>> which is revealed by this commit ?
>> At least pktcdvd doesn't expect bio->bi_io_vec[] to be cleared, that's
>> why it's oopsing now. I'll revert this bit for now, thanks for the
>> report.
> 
> Rethinking this, I think bio_init() is doing the right thing, only
> pktcdvd seems to rely on it preserving some members. So I'd rather fixup
> pktcdvd instead.
> 
> Does this work for you?

Well, it's better: I was able to mount the DVD-RW, sync, and write data,
but kernel oopsed when I unmounted the drive:

[  529.295829] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  529.296490] printing eip: 00000000 *pde = 00000000 
[  529.297106] Oops: 0000 [#1] PREEMPT 
[  529.297702] last sysfs file: /block/pktcdvd0/range
[  529.298284] Modules linked in: udf binfmt_misc pktcdvd radeon drm lp nls_iso8859_1 nls_cp850 vfat fat reiser4 lzo_decompress lzo_compress eeprom w83781d hwmon_vid snd_ens1371 gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event firewire_ohci firewire_core snd_seq crc_itu_t sg snd_timer snd_seq_device 8250_pnp snd sr_mod cdrom rtc ohci1394 i2c_viapro 8250 serial_core uhci_hcd soundcore snd_page_alloc floppy pcspkr ne2k_pci 8390 parport_pc via686a ieee1394 usbcore parport ata_generic via_agp agpgart evdev reiserfs sd_mod pata_via libata scsi_mod dm_mirror dm_mod
[  529.302127] 
[  529.302785] Pid: 3718, comm: umount Not tainted (2.6.23-rc4-mm1 #73)
[  529.303493] EIP: 0060:[<00000000>] EFLAGS: 00010202 CPU: 0
[  529.304207] EIP is at _stext+0x3feff000/0x19
[  529.304911] EAX: c30ded90 EBX: cb110da8 ECX: 00000000 EDX: c30ded90
[  529.305640] ESI: 00000001 EDI: cb0c7748 EBP: cb1dfe98 ESP: cb1dfe90
[  529.306389]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  529.307136] Process umount (pid: 3718, ti=cb1df000 task=c27157b0 task.ti=cb1df000)
[  529.307213] Stack: c017b4bf 00000000 cb1dfeb0 e1c0e57a cb1115d8 cb0c7748 c1e4a828 c26663c8 
[  529.308122]        cb1dfec4 e1c0e650 cb1dfec4 c017c15f 00000000 cb1dfee4 c017c8f3 c1e4a834 
[  529.309040]        00000000 c1e4a8bc c1e4a828 e1f12ea0 00000000 cb1dfeec c017c9ab cb1dfef8 
[  529.309972] Call Trace:
[  529.311464]  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
[  529.312264]  [show_stack_log_lvl+155/163] show_stack_log_lvl+0x9b/0xa3
[  529.313056]  [show_registers+160/482] show_registers+0xa0/0x1e2
[  529.313840]  [die+261/567] die+0x105/0x237
[  529.314611]  [do_page_fault+1127/1349] do_page_fault+0x467/0x545
[  529.315396]  [error_code+106/112] error_code+0x6a/0x70
[  529.316186]  [<e1c0e57a>] pkt_shrink_pktlist+0x29/0x79 [pktcdvd]
[  529.317007]  [<e1c0e650>] pkt_close+0x86/0x97 [pktcdvd]
[  529.317816]  [__blkdev_put+95/269] __blkdev_put+0x5f/0x10d
[  529.318630]  [blkdev_put+10/12] blkdev_put+0xa/0xc
[  529.319436]  [close_bdev_excl+18/21] close_bdev_excl+0x12/0x15
[  529.320260]  [kill_block_super+29/32] kill_block_super+0x1d/0x20
[  529.321095]  [deactivate_super+63/81] deactivate_super+0x3f/0x51
[  529.321933]  [mntput_no_expire+73/102] mntput_no_expire+0x49/0x66
[  529.322782]  [path_release_on_umount+21/24] path_release_on_umount+0x15/0x18
[  529.323641]  [sys_umount+461/501] sys_umount+0x1cd/0x1f5
[  529.324499]  [sys_oldumount+25/27] sys_oldumount+0x19/0x1b
[  529.325361]  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
[  529.326248]  =======================
[  529.327094] Code:  Bad EIP value.
[  529.327969] EIP: [<00000000>] _stext+0x3feff000/0x19 SS:ESP 0068:cb1dfe90

> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index fadbfd8..98343a1 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -1142,16 +1142,20 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
>  	 * Schedule reads for missing parts of the packet.
>  	 */
>  	for (f = 0; f < pkt->frames; f++) {
> +		struct bio_vec *vec;
> +
>  		int p, offset;
>  		if (written[f])
>  			continue;
>  		bio = pkt->r_bios[f];
> +		vec = bio->bi_io_vec;
>  		bio_init(bio);
>  		bio->bi_max_vecs = 1;
>  		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
>  		bio->bi_bdev = pd->bdev;
>  		bio->bi_end_io = pkt_end_io_read;
>  		bio->bi_private = pkt;
> +		bio->bi_io_vec = vec;
>  
>  		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
>  		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
> @@ -1448,6 +1452,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
>  	pkt->w_bio->bi_bdev = pd->bdev;
>  	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
>  	pkt->w_bio->bi_private = pkt;
> +	pkt->w_bio->bi_io_vec = bvec;
>  	for (f = 0; f < pkt->frames; f++)
>  		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
>  			BUG();
> 
