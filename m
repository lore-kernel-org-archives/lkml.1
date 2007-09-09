Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXIIVKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXIIVKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759906AbXIIVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:09:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:5994 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759860AbXIIVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VtvvLPNbAocwUNHDMTNXQfhgoPVfOWqTy8UrWTCmIeOVclRFIBd1Hctnaf78d49RVqRvEz0UH7/CoLnv5KIUAiMMZj0reOB69npJZEHSGSd1vADogB7BT/9H4N8lgVNOYoUXDZjbWWL9p1iRoVzIYFJT0ZCSYXm+wjyrLZ6ggDc=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: mchehab@infradead.org
Subject: [BUG]: circular locking depedency in videobuf code
Date: Mon, 10 Sep 2007 00:08:19 +0300
User-Agent: KMail/1.9.6
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709100008.19992.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found a bug (circular lock dependency) in generic videobuf code:


Suppose app has two threads, and one calls munmap() on a video buffer , and second calls VIDIOC_QBUF ioctl.
(The actual app that does that is kdetv on exit)


thread1:  takes current->mm->mmap_sem, then takes q->lock 
thread2:  takes q->lock then takes  current->mm->mmap_sem

Explanation:

thread 1: munmap takes  current->mm->mmap_sem,    and calls videobuf_vm_close which tries to take q->lock 
thread2:  videobuf_qbuf takes q->lock and calls q->ops->buf_prepare(q,buf,field), 
that is driver specific, but most(if not all) implementations call videobuf_iolock, that calls videobuf_dma_init_user, and 
that function takes  current->mm->mmap_sem.

Since buffer queue is the same, as well as current->mm, a deadlock can occur. It happens almost always on my system
Since mm->mmap_sem for kdetv is down forever, commands like ps/top hang, and reboot doesn't work for same reason.
I have FlyVideo2000 card (saa7130HL based), so saa7134 driver is used.

It is a bit difficult for me to fix that bug, so can you help me?
Maybe I should take current->mm->mmap_sem in beginning of videobuf_qbuf and release it immediately, is this a right way?

Looking for your comments,
	Best regards,
		Maxim Levitsky

PS:

this is a call trace of both threads after the hang (with frame pointers enabled):

<4>[18681.072790] kdetv         D c1ef3900     0  8137   4821
<4>[18681.072794]        df0b1ee4 00200046 00000818 c1ef3900 00000002 df0b1ecc 6f504f76 00000cd3
<4>[18681.072801]        df00e000 c1f3ed40 00000000 00200046 00d269ab 00000001 000187f7 00000000
<4>[18681.072809]        000000ff 00000000 00000000 00000818 f722f5dc 00200246 df00e000 df0b1f24
<4>[18681.072816] Call Trace:
<4>[18681.072818]  [<c03aba38>] __mutex_lock_slowpath+0xf8/0x350
<4>[18681.072822]  [<c03abcac>] mutex_lock+0x1c/0x20
<4>[18681.072825]  [<f940f78d>] videobuf_vm_close+0x9d/0x140 [video_buf]
<4>[18681.072835]  [<c0179a3b>] remove_vma+0x2b/0x50
<4>[18681.072839]  [<c017a55a>] do_munmap+0x18a/0x1f0
<4>[18681.072843]  [<c017a5f0>] sys_munmap+0x30/0x50
<4>[18681.072847]  [<c01084ca>] sysenter_past_esp+0x6b/0xb5
<4>[18681.072851]  =======================
<4>[18681.072853] kdetv         D c1f45900     0  8139   4821
<4>[18681.072857]        dc12fd08 00200046 00000a18 c1f45900 00000002 dc12fcf0 6f4ec99b 00000cd3
<4>[18681.072864]        c3e26d00 c1f90d40 00000001 00000002 00d269b4 00000001 000144f6 00000000
<4>[18681.072872]        000000ff 00000000 00000000 00000a18 00000002 e48f0b34 c3e26d00 dc12fd30
<4>[18681.072879] Call Trace:
<4>[18681.072881]  [<c0224b25>] rwsem_down_failed_common+0x75/0x190
<4>[18681.072885]  [<c03acdcd>] rwsem_down_read_failed+0x1d/0x28
<4>[18681.072889]  [<c03ace53>] call_rwsem_down_read_failed+0x7/0xc
<4>[18681.072894]  [<f940df34>] videobuf_dma_init_user+0xb4/0x150 [video_buf]
<4>[18681.072901]  [<f940e2e7>] videobuf_iolock+0xd7/0xe0 [video_buf]
<4>[18681.072907]  [<f943de82>] buffer_prepare+0x1b2/0x200 [saa7134]
<4>[18681.072919]  [<f940e87d>] videobuf_qbuf+0x20d/0x440 [video_buf]
<4>[18681.072926]  [<f943f0a2>] video_do_ioctl+0x562/0x1110 [saa7134]
<4>[18681.072937]  [<f93e028a>] video_usercopy+0xda/0x250 [videodev]
<4>[18681.072943]  [<f943ccda>] video_ioctl+0x1a/0x20 [saa7134]
<4>[18681.072954]  [<c0199f2b>] do_ioctl+0x6b/0x80
<4>[18681.072957]  [<c0199f97>] vfs_ioctl+0x57/0x290
<4>[18681.072961]  [<c019a209>] sys_ioctl+0x39/0x60
<4>[18681.072964]  [<c01084ca>] sysenter_past_esp+0x6b/0xb5
<4>[18681.072969]  =======================

