Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820Ab0AEFsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0AEFsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326Ab0AEFsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:48:47 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:53951 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0AEFsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:48:45 -0500
Date: Tue, 05 Jan 2010 00:48:07 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: tty_io.c  - disassociate_ctty attempted to write to tty = NULL
 question/problem?
In-reply-to: <20100105001205.7e8f131b@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-id: <4B42D297.5010702@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B42733D.6050704@majjas.com>
 <20100105001205.7e8f131b@lxorguk.ukuu.org.uk>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/2010 7:12 PM, Alan Cox wrote:
>> do_exit ->  disassocate_ctty(1) (for tty1).
>> disassociate->vhangup->do_tty_hangup
>>
>> In do_tty_hangup, p->signal->tty is set to NULL, where p==current.
>>      
> Perfectly reasonable so far - the current process gave up having a
> controlling tty.
>
>    
>> On return, the aforementioned error message is generated.
>>      
>  From where - the backtrace on the write to NULL tty is the important bit
> here. User space interfaces cache tty in filp->private_data so its not
> going to be coming from there unless there was a memory scribble which
> would imply a refcounting bug - and I'd expect people to hit that
> reliably.
>
> Some kernel stuff does take a peek at p->signal->tty for direct printk
> type stuff and that sounds more likely - the backtraceon the write to
> NULL tty is going to provide the needed info.
>
> Alan
>    
Ok - thanks - added a WARN_ON(!tty) right after the second call to 
get_current_tty() in disassociate_ctty()

Oddly, for the first time in a long while, I didn't get the NULL error 
message during boot. I was able to force it with initctl stop tty1.

Note that the error does not occur for any other tty.

The resulting oops:
Jan  5 00:34:44 mail kernel: ------------[ cut here ]------------
Jan  5 00:34:44 mail kernel: WARNING: at drivers/char/tty_io.c:819 
disassociate_ctty+0x29a/0x33c()
Jan  5 00:34:44 mail kernel: Hardware name: System Product Name
Jan  5 00:34:44 mail kernel: Modules linked in: ip6table_filter 
ip6table_mangle ip6_tables ipt_MASQUERADE iptable_nat nf_nat 
iptable_mangle iptable_raw bridge stp appletalk psnap llc nfsd lockd 
nfs_acl auth_rpcgss exportfs sunrpc hwmon_vid coretemp acpi_cpufreq sit 
tunnel4 ipt_LOG nf_conntrack_netbios_ns nf_conntrack_ftp xt_DSCP xt_dscp 
xt_MARK nf_conntrack_ipv6 xt_multiport ipv6 dm_multipath kvm_intel kvm 
snd_hda_codec_analog snd_ens1371 gameport snd_rawmidi snd_ac97_codec 
snd_hda_intel snd_hda_codec ac97_bus snd_hwdep snd_seq snd_seq_device 
gspca_spca505 snd_pcm gspca_main videodev firewire_ohci iTCO_wdt 
i2c_i801 snd_timer firewire_core pcspkr snd v4l1_compat 
iTCO_vendor_support crc_itu_t v4l2_compat_ioctl32 sky2 wmi soundcore 
snd_page_alloc asus_atk0110 hwmon fbcon tileblit font bitblit softcursor 
raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy 
async_tx raid1 ata_generic pata_acpi pata_marvell nouveau ttm 
drm_kms_helper drm agpgart fb i2c_algo_bit cfbcopyarea i2c_core 
cfbimgblt cfbfil
Jan  5 00:34:44 mail kernel: lrect [last unloaded: microcode]
Jan  5 00:34:44 mail kernel: Pid: 6019, comm: mingetty Tainted: G        
W  2.6.32-00839-g92238e5-dirty #32
Jan  5 00:34:44 mail kernel: Call Trace:
Jan  5 00:34:44 mail kernel: [<ffffffff8105365a>] 
warn_slowpath_common+0x7c/0x94
Jan  5 00:34:44 mail kernel: [<ffffffff81053686>] 
warn_slowpath_null+0x14/0x16
Jan  5 00:34:44 mail kernel: [<ffffffff812db827>] 
disassociate_ctty+0x29a/0x33c
Jan  5 00:34:44 mail kernel: [<ffffffff8105754a>] do_exit+0x267/0x6cb
Jan  5 00:34:44 mail kernel: [<ffffffff81057a26>] do_group_exit+0x78/0xa1
Jan  5 00:34:44 mail kernel: [<ffffffff810683f4>] 
get_signal_to_deliver+0x2e6/0x306
Jan  5 00:34:44 mail kernel: [<ffffffff81011056>] do_signal+0x72/0x697
Jan  5 00:34:44 mail kernel: [<ffffffff812e0dbd>] ? tty_ldisc_deref+0xe/0x10
Jan  5 00:34:44 mail kernel: [<ffffffff812d96fe>] ? tty_read+0x8c/0xc5
Jan  5 00:34:44 mail kernel: [<ffffffff810116a7>] do_notify_resume+0x2c/0x64
Jan  5 00:34:44 mail kernel: [<ffffffff81469fb5>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Jan  5 00:34:44 mail kernel: [<ffffffff81011f66>] int_signal+0x12/0x17
Jan  5 00:34:44 mail kernel: ---[ end trace 57f7151f6a5def07 ]---


