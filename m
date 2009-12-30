Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbZL3Llt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbZL3Llt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZL3Lls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:41:48 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52859 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZL3Llr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:from:date:message-id:user-agent:mime-version
         :content-type;
        b=eGgGn6QCKkU8wsVXPSKcqNUEYc92DLEVDNinBLwmvCM9DtxhNIxMAKyo0/dIcwcfLI
         mawulotvEkZkybOsE0ROUqM7KboyKWju5haY8eM0KC+wgbNAstWXjHyATSqVcwABJcHt
         QRVYVQy84C/Ka2aI7ap+ciYz0y8uxJ8zQ8Qsw=
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
       Helge Deller <deller@gmx.de>, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
       roland@redhat.com, dave@hiauly1.hia.nrc.ca
Subject: regression: crash from 'ls /sys/modules/wl1251_spi/notes'
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 30 Dec 2009 13:41:38 +0200
Message-ID: <87k4w4wux9.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed weird crashes related to wl1251_spi notes sysfs directory
with current wireless-testing (2.6.33-rc2 plus some wireless patches).
The simplest way to reproduce the problem is to do this on a nokia n900
(arm/omap 3430):

# ls /sys/module/wl1251_spi/notes/
[ 4776.503234] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[ 4776.511596] pgd = cce88000
[ 4776.514343] [00000000] *pgd=8f04a031, *pte=00000000, *ppte=00000000
[ 4776.520812] Internal error: Oops: 17 [#1]
[ 4776.524871] last sysfs file: /sys/class/net/wlan0/flags
[ 4776.530151] Modules linked in: wl1251_spi wl1251 mac80211 cfg80211
[ 4776.536468] CPU: 0    Not tainted  (2.6.33-rc2-wl-47091-g981eb84
#12)
[ 4776.542999] PC is at strlen+0xc/0x20
[ 4776.546630] LR is at sysfs_readdir+0x15c/0x1e0
[ 4776.551116] pc : [<c01476ac>]    lr : [<c00f5e6c>]    psr: a0000013
[ 4776.551147] sp : cce87f28  ip : 22222222  fp : be99961c
[ 4776.562744] r10: cce87f80  r9 : 00000000  r8 : 00000000
[ 4776.568023] r7 : c00b9540  r6 : cce87f80  r5 : ccec4458  r4 :
ce808980
[ 4776.574615] r3 : 00000000  r2 : 00000002  r1 : 22222222  r0 :
00000000
[ 4776.581207] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment user
[ 4776.588409] Control: 10c5387d  Table: 8ce88019  DAC: 00000015
[ 4776.594238] Process ls (pid: 1148, stack limit = 0xcce862e8)
[ 4776.599945] Stack: (0xcce87f28 to 0xcce88000)
[ 4776.604370] 7f20:                   00000001 00000000 00000e16
00000000 00000004 22222222
[ 4776.612640] 7f40: ce808980 ce808980 cf79e34c c00b9540 00000000
cf79e2b8 cce86000 c00b982c
[ 4776.620910] 7f60: 00000001 00000000 00001000 000690d0 ce808980
c002bae4 00000000 c00b98c4
[ 4776.629180] 7f80: 00069100 000690e8 00000fd0 ffffffea 00000000
00000000 00000000 00000000
[ 4776.637451] 7fa0: 000000d9 c002b940 00000000 00000000 00000003
000690d0 00001000 00000000
[ 4776.645721] 7fc0: 00000000 00000000 00000000 000000d9 000690c8
00000001 00000000 be99961c
[ 4776.654022] 7fe0: 400ef954 be999614 400efa10 400ef908 60000010
00000003 80c69021 80c69421
[ 4776.662292] [<c01476ac>] (strlen+0xc/0x20) from [<c00f5e6c>]
(sysfs_readdir+0x15c/0x1e0)
[ 4776.670501] [<c00f5e6c>] (sysfs_readdir+0x15c/0x1e0) from
[<c00b982c>] (vfs_readdir+0x80/0xb4)
[ 4776.679229] [<c00b982c>] (vfs_readdir+0x80/0xb4) from [<c00b98c4>]
(sys_getdents64+0x64/0xb4)
[ 4776.687866] [<c00b98c4>] (sys_getdents64+0x64/0xb4) from
[<c002b940>] (ret_fast_syscall+0x0/0x38)
[ 4776.696838] Code: c027700c e1a03000 ea000000 e2833001 (e5d32000) 
[ 4776.703063] ---[ end trace 6a3b0fdf4e9def99 ]---
[ 4776.707794] Kernel panic - not syncing: Fatal exception

Also removing wl1251_spi causes a crash. The reason for this is that a
sysfs file with a null string as name is trying to be removed from the
notes directory.

I found out that reverting this patch solves the problem:

  commit 35dead4235e2b67da7275b4122fed37099c2f462
  Author: Helge Deller <deller@gmx.de>
  Date:   Thu Dec 3 00:29:15 2009 +0100

    modules: don't export section names of empty sections via sysfs
    
    On the parisc architecture we face for each and every loaded
    kernel module this kernel "badness warning":

      sysfs: cannot create duplicate filename
    '/module/ac97_bus/sections/.text'
      Badness at fs/sysfs/dir.c:487
    
    Reason for that is, that on parisc all kernel modules do have
    multiple .text sections due to the usage of the
    -ffunction-sections compiler flag which is needed to reach all
    jump targets on this platform.

    An objdump on such a kernel module gives:
    Sections:
    Idx Name          Size      VMA       LMA       File off  Algn
      0 .note.gnu.build-id 00000024  00000000  00000000  00000034
    2**2
                      CONTENTS, ALLOC, LOAD, READONLY, DATA
      1 .text         00000000  00000000  00000000  00000058  2**0
                      CONTENTS, ALLOC, LOAD, READONLY, CODE
      2 .text.ac97_bus_match 0000001c  00000000  00000000  00000058
    2**2
                      CONTENTS, ALLOC, LOAD, READONLY, CODE
      3 .text         00000000  00000000  00000000  000000d4  2**0
                      CONTENTS, ALLOC, LOAD, READONLY, CODE
    ...
    Since the .text sections are empty (size of 0 bytes) and won't be
    loaded by the kernel module loader anyway, I don't see a reason
    why such sections need to be listed under
    /sys/module/<module_name>/sections/<section_name> either.
    
    The attached patch does solve this issue by not exporting section
    names which are empty.
    
    This fixes bugzilla
    http://bugzilla.kernel.org/show_bug.cgi?id=14703
    
    Signed-off-by: Helge Deller <deller@gmx.de>
    CC: rusty@rustcorp.com.au
    CC: akpm@linux-foundation.org
    CC: James.Bottomley@HansenPartnership.com
    CC: roland@redhat.com
    CC: dave@hiauly1.hia.nrc.ca
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I was also able to reproduce the problem with vanilla 2.6.32. I'm
pretty sure (but haven't tested) that 2.6.32-rc8 does not have this
problem.

My original mail containing more info:

http://www.spinics.net/lists/linux-wireless/msg44863.html

Simple bandaid patch below fixes the problem. I know it's not a proper
solution, but hopefully makes it easier to understand the problem.
Unfortunately my knowledge about ELF is too limited to fix this
properly, but I can provide more information as needed. Or even try to
fix it myself if someone else holds my hand :)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1189,10 +1189,13 @@ static void add_notes_attrs(struct module
*mod, unsigned int nsect,
        if (!notes_attrs->dir)
                goto out;
 
-       for (i = 0; i < notes; ++i)
+       for (i = 0; i < notes; ++i) {
+               if (WARN_ON(!notes_attrs->attrs[i].attr.name))
+                       continue;
                if (sysfs_create_bin_file(notes_attrs->dir,
                                          &notes_attrs->attrs[i]))
                        goto out;
+       }
 
        mod->notes_attrs = notes_attrs;
        return;
