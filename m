Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZCDWzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZCDWzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZCDWyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:54:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:44973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZCDWyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:54:53 -0500
Date: Wed, 4 Mar 2009 23:54:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel.CUELLA@supinfo.com, adaplas@gmail.com, linux-kernel@vger.kernel.org,
       trivial@kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.28 ] i810: kernel crash fix when  struct fb_var_screeninfo
 is supplied
In-Reply-To: <20090304142006.20ad72fe.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.0903042353350.4971@jikos.suse.cz>
References: <02E43B9E8855E74E886358B5184B4CC9104620C0@mail2-aub1fr.esi-supinfo.com> <alpine.LNX.2.00.0903041108470.4971@jikos.suse.cz> <20090304142006.20ad72fe.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Andrew Morton wrote:

> > This is not appropriate for trivial tree. CCing akpm and lkml.
> I don't have a copy of the original patch.

This is what I got from Samuel (and rejected it for trivial tree, not 
being trivial enough :) )



From: Samuel CUELLA <samuel.cuella@supinfo.com>

This patch prevents the kernel from being crashed by a divide-by-zero 
operation when supplied an incorrectly filled 'struct fb_var_screeninfo' 
from userland.

Previously i810_main.c:1005 (i810_check_params) was using the global 
'yres' symbol previously defined at i810_main.c:145 as a module parameter 
value holder (i810_main.c:2174). If i810fb is compiled-in or if this param 
doesn't get a default value, this direct usage leads to a divide-by-zero 
at i810_main.c:1005 (i810_check_params). The patch simply replace the 
'yres' global, perhaps undefined symbol usage by a given parameter 
structure lookup.

This problem occurs with directfb, mplayer -vo fbdev, SDL library.
It was also reported ( but non solved ) at : http://mail.directfb.org/pipermail/directfb-dev/2008-March/004050.html
Sample code to reproduce :
/*Comile with gcc crashfb.c -o crashfb*/
#include <fcntl.h>
#include <linux/fb.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <string.h>
#include <stdlib.h>


#define FB "/dev/fb0"

int main(){
        int fd;
        int rv;
        struct fb_var_screeninfo vinfo;

        fd = open(FB,O_RDWR);
        if( fd ){
                vinfo.xres = 800;
                vinfo.yres = 600;
                rv =ioctl(fd, FBIOPUT_VSCREENINFO, &vinfo);
        }
        return(rv);
}
Leads to this crash dump:
divide error: 0000 [#1]
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in:

Pid: 4058, comm: crashfb Not tainted (2.6.28 #4)
EIP: 0060:[<c02558c8>] EFLAGS: 00010202 CPU: 0
EIP is at i810fb_check_var+0x428/0x520
EAX: 00400000 EBX: ce9d5e44 ECX: 001209a0 EDX: 00000000
ESI: 00000020 EDI: 00000004 EBP: 00000000 ESP: ce9d5d0c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process crashfb (pid: 4058, ti=ce9d4000 task=cf8af0e0 task.ti=ce9d4000)
Stack:
 c014f993 00000000 00000001 00000000 00000000 00400000 0000001a cf811000
 08048268 cf81123c 00000258 00000320 ffffffed cf811015 ce9d5e45 cf811000
 c0224821 ce9d5e44 ce9b09a0 00000000 00012000 00000000 c0111a89 00000001
Call Trace:
 [<c014f993>] handle_mm_fault+0x5c3/0x650
 [<c0224821>] fb_set_var+0x61/0x2d0
 [<c0111a89>] do_page_fault+0x3a9/0x8b0
 [<c016c935>] do_lookup+0x65/0x1a0
 [<c02257aa>] fb_ioctl+0x21a/0x3c0
 [<c014f577>] handle_mm_fault+0x1a7/0x650
 [<c0225590>] fb_ioctl+0x0/0x3c0
 [<c017077f>] vfs_ioctl+0x1f/0x70
 [<c017096c>] do_vfs_ioctl+0x5c/0x430
 [<c0111a89>] do_page_fault+0x3a9/0x8b0
 [<c0170d7d>] sys_ioctl+0x3d/0x70
 [<c0103af9>] sysenter_do_call+0x12/0x25
Code: c0 0f 44 d0 89 54 24 04 e8 b6 5a ec ff b8 ea ff ff ff 83 c4 30 5b 5e 5f 5d c3 8b 2d ac 0e 4a c0 31 d2 89 f7 8b 44 24 14 c1 ef 03 <f7> f5 31 d2 f7 f7 3b 03 89 c7 0f 83 3c fd ff ff 89 c2 89 f1 89
EIP: [<c02558c8>] i810fb_check_var+0x428/0x520 SS:ESP 0068:ce9d5d0c
---[ end trace 1840767f449d222e ]---

Despite this dump says that EIP was in 'i810fb_check_var' the divide by zero truly occurs in 'i810_check_params' called by 'i810fb_check_var' (i810_main.c:1466).

Signed-off-by: Samuel CUELLA <samuel.cuella@supinfo.com>

--- linux-2.6.28/drivers/video/i810/i810_main.c.orig    2009-02-26 15:23:03.000000000 +0100
+++ linux-2.6.28/drivers/video/i810/i810_main.c 2009-02-26 14:50:06.000000000 +0100
@@ -993,6 +993,8 @@ static int i810_check_params(struct fb_v
        struct i810fb_par *par = info->par;
        int line_length, vidmem, mode_valid = 0, retval = 0;
        u32 vyres = var->yres_virtual, vxres = var->xres_virtual;
+       u32 yres = info->var.yres;
+
        /*
         *  Memory limit
         */
