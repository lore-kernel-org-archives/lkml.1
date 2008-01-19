Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYASQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYASQyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYASQyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:54:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:49676 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYASQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=lUS14tdchxlhFweXu1wAFcMJQebl26KcOaB5O2sk0CBEIhGiECRCdCE5TH9QH3wTRfcK9TccmT51UPwOHPA2lR+usRLn+lOXE3t3jNqZ84P4iLF3BAQdaCppFXDzlvdLuqDevoJw0Zv4Xie8+PeK/ocpVfay1lhp+9J11rduPFI=
Message-ID: <47922B2A.7070709@gmail.com>
Date: Sat, 19 Jan 2008 18:54:02 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] LatencyTop: make reason (blk_execute_rq+0x7a/0xd) known
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

One of the top reasons in latencytop is
Unknown reason (blk_execute_rq+0x7a/0xd)          152.3 msec        
49.0 msec

Its from hddtemp, hald-addon-storage, ...

I wrote a simple systemtap script [1] to find out where its called from,
and its definitely from the ioctl (see below).

1820322406
hddtemp(3999):                                                                                                      
<- latency of 153260223 ns
Returning from: 0xffffffff80311ab0 : blk_execute_rq+0x0/0xd0 []
Returning to  : 0xffffffff80315580 : sg_io+0x200/0x3c0 []
 0xffffffff80315a02 : scsi_cmd_ioctl+0x2c2/0x410 []
 0xffffffff80417153 : ip_queue_xmit+0x2b3/0x420 []
 0xffffffff880c3be9 : sd_ioctl+0x99/0xf0 [sd_mod]
 0xffffffff80313839 : blkdev_driver_ioctl+0x39/0x40 []
 0xffffffff80313ab8 : blkdev_ioctl+0x278/0x710 []
 0xffffffff803e540d : release_sock+0x8d/0xa0 []
 0xffffffff803e54b3 : lock_sock_nested+0x93/0xa0 []
 0xffffffff8029a4ff : d_alloc+0x6f/0x1a0 []
 0xffffffff802f102f : security_d_instantiate+0x1f/0x30 []
 0xffffffff803e540d : release_sock+0x8d/0xa0 []
 0xffffffff8043c8c8 : inet_accept+0x88/0xc0 []
 0xffffffff803e408e : move_addr_to_user+0x5e/0x70 []
 0xffffffff802f0bb1 : security_socket_post_accept+0x11/0x20 []
 0xffffffff803e472e : sys_accept+0x13e/0x1d0 []
 0xffffffff802af12b : block_ioctl+0x1b/0x20 []
 0xffffffff8029482b : do_ioctl+0x1b/0x70 []
 0xffffffff80294a6d : vfs_ioctl+0x1ed/0x290 []
 0xffffffff80296281 : sys_select+0x41/0x1b0 []
 0xffffffff80294b92 : sys_ioctl+0x82/0xa0 []
 0xffffffff8020c18e : system_call+0x7e/0x83 []


I suggest adding an annotation to make this reason known to latencytop
by annotating sd_ioctl/scsi_cmd_ioctl, see my patch below.
After my patch, instead of blk_execute_rq the real reason is showed:

Cause                                               Maximum          Average
SCSI device ioctl                                  34.2 msec        
14.4 msec

I noticed there's a similar annotation in sr.c for cdrom_ioctl, but sr.c
also has annotations for scsi_nonblockable_ioctl, and scsi_ioctl.
If they are needed for sd_block_ioctl too, maybe
scsi_nonblockable_ioctl/scsi_ioctl should have the annotation themselves.

I also noticed some unsigned overflows, my top latency was sometimes a
very large number (18................................), which
was probably -1, or some other negative number.  I haven't found a way
to reproduce it yet (it happens very rarely).

[1] Systemtap script:
#!/usr/bin/stap -v
global start
probe kernel.function("blk_execute_rq") {
        start[tid()] = gettimeofday_ns()
}

probe kernel.function("blk_execute_rq").return {
        # if we have not seen this before
        if (!([tid()] in start)) next
        delta = gettimeofday_ns() - start[tid()]
        # show backtraces for latencies over 1ms
        if(delta > 1000000) {
                printf("%s <- latency of %d ns\n", thread_indent(1), delta)
                print_backtrace ()
        }
        delete start[tid()]
}

P.S.: LatencyTop could have a feature to ask for more details on unknown
latency reasons, and it would generate a systemtap script itself, that
would show the backtraces to help figure out whats going on.

Best regards,
--Edwin

----

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a69b155..93ccfc0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -686,6 +687,7 @@ static int sd_ioctl(struct inode * inode, struct
file * filp,
     struct scsi_device *sdp = scsi_disk(disk)->device;
     void __user *p = (void __user *)arg;
     int error;
+    struct latency_entry reason;
    
     SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
                         disk->disk_name, cmd));
@@ -710,7 +712,9 @@ static int sd_ioctl(struct inode * inode, struct
file * filp,
         case SCSI_IOCTL_GET_BUS_NUMBER:
             return scsi_ioctl(sdp, cmd, p);
         default:
+            set_latency_reason("SCSI device ioctl", &reason);
             error = scsi_cmd_ioctl(filp, disk->queue, disk, cmd, p);
+            restore_latency_reason(&reason);
             if (error != -ENOTTY)
                 return error;
     }
