Return-Path: <linux-kernel-owner+w=401wt.eu-S1763919AbXIKMDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763919AbXIKMDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763171AbXIKMCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:02:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:26305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763758AbXIKMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:02:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=lS78DUro2WvcHXQX82qB9slQaukNgt+huwviKFBRZNlf/2xLfbwCr4idBOnsLeMbAFW/PyxOTKSIrXZagWouu1dNkngN6SkeRgSJe4lcXVi6jLGd9+ktEdcWxGc6kHbfDJ07DWBox+HweCqPr01rWWEAQEjmHInJGw9aKEQtWLg=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: mchehab@infradead.org
Subject: [BUG]: inverse lock depedency in video-buf.c
Date: Tue, 11 Sep 2007 15:01:19 +0300
User-Agent: KMail/1.9.6
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111501.19649.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found a serious bug in video-buf.c.
It was already reported long time ago but got unnoticed.
see: http://www.ussg.iu.edu/hypermail/linux/kernel/0608.2/1637.html

I reported this two days ago, but I am writing again, since I understand it a lot better.

So it is a lock inversion, between calling munmap()/mmap() on a video buffer, and caling VIDIOC_QBUF to activate it.

munmap takes current->mm->mmap_sem (and it has to), but then videobuf_vm_close has to take q->lock, since it modify buffer queue.
on the other hand videobuf_qbuf takes q->lock (and it has to take it) and then calls q->ops->buf_prepare which supposed to do 
some card-specific initialization, and it locks it in memory with videobuf_iolock, but that requires allocating user pages, 
so current->mm->mmap_sem is taken.

I don't yet see a simple solution.
What I thought about includes this:

1) take a current->mm->mmap_sem _before_ q->lock in all functions that might call q->ops->buf_prepare:
it works, but is ugly, and unreliable since q->ops->buf_prepare can be called directly by driver code (saa7134 does that)

2) move locking of current->mm->mmap_sem from videobuf_dma_init_user to videobuf_iolock, and just try to take it, 
if it is not aviable, unlock q->lock, wait for munmap/mmap to finish, and then recheck what munmap did:
works, but again not a good solution, since current->mm->mmap_sem can be taken by something else, and thus releasing q->lock will
allow a random videobuf function to complete, and this is incorrect.

3) Lock memory at mmap time:
Seems fine, but will allocate more memory (if app mmaps buffers, but don't use them), and at mmap time I dont know r/w direction,
but it seems to be unused
but that will help only with munmap case, but mmap will still race with VIDIOC_QBUF.

4) Your idea/patch goes here :-)


Best regards,
	Maxim Levitsky
