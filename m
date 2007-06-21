Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXFUVkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXFUVkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbXFUVkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:40:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbXFUVkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:40:46 -0400
Message-ID: <467AF044.1090306@redhat.com>
Date: Thu, 21 Jun 2007 17:40:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Aaron Porter <atporter@primate.net>
CC: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: Re: NFS Oops 2.6.20.14
References: <20070618200507.GS6601@primate.net>
In-Reply-To: <20070618200507.GS6601@primate.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2007 04:05 PM, Aaron Porter wrote:
> 	Reproducable, every time nfs-kernel-server exits:
> 
> nfsd: unexporting all filesystems
> BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
>  printing eip:
> f92a7751
> *pde = 6b6b6b6b
> Oops: 0000 [#1]
> PREEMPT SMP 
> Modules linked in: xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink ip_tables x_tables nfs nfsd exportfs lockd sunrpc capability commoncap ipv6 ohci_hcd usbcore amd_rng rng_core i2c_amd8111 generic amd74xx shpchp pci_hotplug ide_scsi w83627hf eeprom lm85 hwmon_vid i2c_isa i2c_amd756 i2c_core rtc unix
> CPU:    0
> EIP:    0060:[<f92a7751>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.20.14-20070612 #2)
> EIP is at cache_clean+0x101/0x1e6 [sunrpc]
> eax: 00000000   ebx: 6b6b6b6b   ecx: 00000001   edx: f92eb940
> esi: dfd9e800   edi: 00000000   ebp: efc7e000   esp: f56bbf84
> ds: 007b   es: 007b   ss: 0068
> Process nfsd (pid: 2856, ti=f56ba000 task=c74daaa0 task.ti=f56ba000)
> Stack: f92eb940 f70ddd50 00000000 f92a7880 f92a78aa f70ddd24 f92cae61 f92a1b8c 
>        f92a1fe1 00000009 00000000 00000009 00000000 f92c36b2 f92dd07d efc7e000 
>        fffffeff ffffffff fffffef8 ffffffff f92c3448 00000000 00000000 00000000 
> Call Trace:
>  [<f92a7880>] cache_flush+0xc/0x1f [sunrpc]
>  [<f92a78aa>] cache_purge+0x17/0x20 [sunrpc]
>  [<f92cae61>] nfsd_export_flush+0x14/0x28 [nfsd]
>  [<f92a1b8c>] svc_destroy+0x96/0x100 [sunrpc]
>  [<f92a1fe1>] svc_exit_thread+0x69/0x7d [sunrpc]
>  [<f92c36b2>] nfsd+0x26a/0x27b [nfsd]
>  [<f92c3448>] nfsd+0x0/0x27b [nfsd]
>  [<c010364b>] kernel_thread_helper+0x7/0x10

  25:   8b 15 60 ea 2b f9         mov    0xf92bea60,%edx
   0:   8b 43 04                  mov    0x4(%ebx),%eax   <=====
   3:   39 42 54                  cmp    %eax,0x54(%edx)
   6:   7e 04                     jle    c <_EIP+0xc>
   8:   40                        inc    %eax
   9:   89 42 54                  mov    %eax,0x54(%edx)

net/sunrpc/cache.c::cache_clean():
                cp = & current_detail->hash_table[current_index];
                ch = *cp;
                for (; ch; cp= & ch->next, ch= *cp) {
=> ch has been freed ==> if (current_detail->nextcheck > ch->expiry_time)
                                current_detail->nextcheck = ch->expiry_time+1;


