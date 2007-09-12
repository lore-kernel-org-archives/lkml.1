Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbXIMPd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbXIMPd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXIMPdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:33:35 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36928 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756343AbXIMPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:33:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=EZD+atTkpHAO8dIfRLdm+E1Lbautzu2blqP52x+KRtvScHbVBBHCire0EPEO1BvGLVzLMXXcSIJbn0UZj7p35Y0oSA/QRkhgQW4RCptSz1nO0oRIPJ/KOUr/zjuJUzr2T3GugrWWHRPBB0aofHIanazoNsLV1iGf5tdUQSj3ktU=  ;
X-YMail-OSG: XQEQb_oVM1m5XkymGmY7plSlSo0lV7Wc1gjk2ZX2kNrh0G6oaVSdRAfaWDGq5kg3YP3SgxL6gw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Soeren Sonnenburg <kernel@nn7.de>, linux-fsdevel@vger.kernel.org
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
Date: Thu, 13 Sep 2007 09:51:47 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <1189675222.5352.10.camel@localhost>
In-Reply-To: <1189675222.5352.10.camel@localhost>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_UuH6GIqq+3o2COp"
Message-Id: <200709130951.48194.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_UuH6GIqq+3o2COp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 13 September 2007 19:20, Soeren Sonnenburg wrote:
> Dear all,
>
> I've just seen this in dmesg on a AMD K7 / kernel 2.6.22.6 machine
> (config attached).
>
> Any ideas / which further information needed ?

Thanks for the report. Is it reproduceable? It seems like the
locks_free_lock call that's oopsing is coming from __posix_lock_file.
The actual function looks fine, but the lock being freed could have
been corrupted if there was slab corruption, or a hardware corruption.

You could: try running memtest86+ overnight. And try the following
patch and turn on slab debugging then try to reproduce the problem.


>
> Soeren
>
> ------------[ cut here ]------------
> kernel BUG at fs/locks.c:171!
> invalid opcode: 0000 [#1]
> Modules linked in: ipt_iprange ipt_REDIRECT capi kernelcapi capifs
> ipt_REJECT xt_tcpudp xt_state xt_limit ipt_LOG ipt_MASQUERADE
> iptable_mangle iptable_nat nf_conntrack_ipv4 iptable_filter ip_tables
> x_tables b44 ohci1394 ieee1394 nf_nat_ftp nf_nat nf_conntrack_ftp
> nf_conntrack lcd tda827x saa7134_dvb dvb_pll video_buf_dvb tuner tda1004x
> ves1820 usb_storage usblp saa7134 compat_ioctl32 budget_ci budget_core
> dvb_ttpci dvb_core saa7146_vv video_buf saa7146 ttpci_eeprom via_agp
> ir_kbd_i2c videodev v4l2_common v4l1_compat ir_common agpgart CPU:    0
> EIP:    0060:[<c0158f59>]    Not tainted VLI
> EFLAGS: 00010206   (2.6.22.6 #1)
> EIP is at locks_free_lock+0xb/0x3b
> eax: e1d07f9c   ebx: e1d07f80   ecx: f5f5e2f0   edx: 00000000
> esi: 00000000   edi: 00000000   ebp: 00000000   esp: da3d7f04
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process mrtg-load (pid: 19688, ti=da3d6000 task=f5e3a030 task.ti=da3d6000)
> Stack: 00000000 c015972b 00000002 c04889c8 c012b920 f5f5e290 c048541c
> f0ed3ca0 01485414 00000000 e1d07f80 00000000 f0f39f58 44ef35f1 f62fc2ac
> 00000000 00000000 f5f5e290 00000000 d23106c0 c015a891 00000000 00000007
> 00000004 Call Trace:
>  [<c015972b>] __posix_lock_file+0x44e/0x47f
>  [<c012b920>] getnstimeofday+0x2b/0xaf
>  [<c015a891>] fcntl_setlk+0xff/0x1f6
>  [<c011d836>] do_setitimer+0xfa/0x226
>  [<c0156b87>] sys_fcntl64+0x74/0x85
>  [<c0103ade>] syscall_call+0x7/0xb
>  =======================
> Code: 74 1b 8b 15 30 93 48 c0 8d 43 04 89 53 04 89 42 04 a3 30 93 48 c0 c7
> 40 04 30 93 48 c0 5b 5e c3 53 89 c3 8d 40 1c 39 43 1c 74 04 <0f> 0b eb fe
> 8d 43 0c 39 43 0c 74 04 0f 0b eb fe 8d 43 04 39 43 EIP: [<c0158f59>]
> locks_free_lock+0xb/0x3b SS:ESP 0068:da3d7f04
> BUG: unable to handle kernel paging request at virtual address 9ee420b0
>  printing eip:
> c014ab7d
> *pde = 00000000
> Oops: 0002 [#2]
> Modules linked in: ipt_iprange ipt_REDIRECT capi kernelcapi capifs
> ipt_REJECT xt_tcpudp xt_state xt_limit ipt_LOG ipt_MASQUERADE
> iptable_mangle iptable_nat nf_conntrack_ipv4 iptable_filter ip_tables
> x_tables b44 ohci1394 ieee1394 nf_nat_ftp nf_nat nf_conntrack_ftp
> nf_conntrack lcd tda827x saa7134_dvb dvb_pll video_buf_dvb tuner tda1004x
> ves1820 usb_storage usblp saa7134 compat_ioctl32 budget_ci budget_core
> dvb_ttpci dvb_core saa7146_vv video_buf saa7146 ttpci_eeprom via_agp
> ir_kbd_i2c videodev v4l2_common v4l1_compat ir_common agpgart CPU:    0
> EIP:    0060:[<c014ab7d>]    Not tainted VLI
> EFLAGS: 00010082   (2.6.22.6 #1)
> EIP is at free_block+0x61/0xfb
> eax: a75b2c19   ebx: c1cf6c10   ecx: e1d070c4   edx: 9ee420ac
> esi: e1d07000   edi: dfde6960   ebp: dfde7620   esp: dfd87f44
> ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> Process events/0 (pid: 4, ti=dfd86000 task=dfdc4a50 task.ti=dfd86000)
> Stack: 00000012 00000000 00000018 00000000 c1cf6c10 c1cf6c10 00000018
> c1cf6c00 dfde7620 c014ac86 00000000 dfde6960 dfde7620 c0521d20 00000000
> c014b869 00000000 00000000 dfde69e0 c0521d20 c014b827 c0125955 dfdc4b5c
> 8f0c99c0 Call Trace:
>  [<c014ac86>] drain_array+0x6f/0x89
>  [<c014b869>] cache_reap+0x42/0xde
>  [<c014b827>] cache_reap+0x0/0xde
>  [<c0125955>] run_workqueue+0x6b/0xdf
>  [<c0125ec7>] worker_thread+0x0/0xbd
>  [<c0125f79>] worker_thread+0xb2/0xbd
>  [<c0128221>] autoremove_wake_function+0x0/0x35
>  [<c01280cc>] kthread+0x36/0x5a
>  [<c0128096>] kthread+0x0/0x5a
>  [<c0104607>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: 8b 02 25 00 40 02 00 3d 00 40 02 00 75 03 8b 52 0c 8b 02 84 c0 78 04
> 0f 0b eb fe 8b 72 1c 8b 54 24 28 8b 46 04 8b 7c 95 4c 8b 16 <89> 42 04 89
> 10 2b 4e 0c c7 06 00 01 10 00 c7 46 04 00 02 20 00 EIP: [<c014ab7d>]
> free_block+0x61/0xfb SS:ESP 0068:dfd87f44
> ------------[ cut here ]------------
> kernel BUG at fs/locks.c:171!
> invalid opcode: 0000 [#3]
> Modules linked in: ipt_iprange ipt_REDIRECT capi kernelcapi capifs
> ipt_REJECT xt_tcpudp xt_state xt_limit ipt_LOG ipt_MASQUERADE
> iptable_mangle iptable_nat nf_conntrack_ipv4 iptable_filter ip_tables
> x_tables b44 ohci1394 ieee1394 nf_nat_ftp nf_nat nf_conntrack_ftp
> nf_conntrack lcd tda827x saa7134_dvb dvb_pll video_buf_dvb tuner tda1004x
> ves1820 usb_storage usblp saa7134 compat_ioctl32 budget_ci budget_core
> dvb_ttpci dvb_core saa7146_vv video_buf saa7146 ttpci_eeprom via_agp
> ir_kbd_i2c videodev v4l2_common v4l1_compat ir_common agpgart CPU:    0
> EIP:    0060:[<c0158f59>]    Not tainted VLI
> EFLAGS: 00010287   (2.6.22.6 #1)
> EIP is at locks_free_lock+0xb/0x3b
> eax: e1d07f40   ebx: e1d07f24   ecx: dfde7620   edx: c16bebc0
> esi: 00000000   edi: 00000000   ebp: f5f5e0c4   esp: f1309efc
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process nmbd (pid: 3522, ti=f1308000 task=f12ba590 task.ti=f1308000)
> Stack: 00000000 c015972b f10b8d4c c1f0d380 02e58f5c f5f5e3a4 000007e8
> 00000000 010b8d4c f5f5e120 e1d07f24 00000001 000000a8 00000000 f5f5eca0
> 00000000 00000000 f5f5e3a4 00000000 f635a260 c015a13f 00000000 0000000e
> 0000000a Call Trace:
>  [<c015972b>] __posix_lock_file+0x44e/0x47f
>  [<c015a13f>] fcntl_setlk64+0xff/0x1f4
>  [<c0156b75>] sys_fcntl64+0x62/0x85
>  [<c0103ade>] syscall_call+0x7/0xb
>  =======================
> Code: 74 1b 8b 15 30 93 48 c0 8d 43 04 89 53 04 89 42 04 a3 30 93 48 c0 c7
> 40 04 30 93 48 c0 5b 5e c3 53 89 c3 8d 40 1c 39 43 1c 74 04 <0f> 0b eb fe
> 8d 43 0c 39 43 0c 74 04 0f 0b eb fe 8d 43 04 39 43 EIP: [<c0158f59>]
> locks_free_lock+0xb/0x3b SS:ESP 0068:f1309efc

--Boundary-00=_UuH6GIqq+3o2COp
Content-Type: text/x-diff;
  charset="utf-8";
  name="fs-lock-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fs-lock-debug.patch"

Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c
+++ linux-2.6/fs/locks.c
@@ -147,7 +147,14 @@ static struct kmem_cache *filelock_cache
 /* Allocate an empty lock structure. */
 static struct file_lock *locks_alloc_lock(void)
 {
-	return kmem_cache_alloc(filelock_cache, GFP_KERNEL);
+	struct file_lock *fl;
+	fl = kmem_cache_alloc(filelock_cache, GFP_KERNEL);
+	if (fl) {
+		BUG_ON(waitqueue_active(&fl->fl_wait));
+		BUG_ON(!list_empty(&fl->fl_block));
+		BUG_ON(!list_empty(&fl->fl_link));
+	}
+	return fl;
 }
 
 static void locks_release_private(struct file_lock *fl)

--Boundary-00=_UuH6GIqq+3o2COp--
