Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYJOCHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYJOCHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYJOCHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:07:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYJOCHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:07:32 -0400
Message-ID: <48F5505B.7030408@cn.fujitsu.com>
Date: Wed, 15 Oct 2008 10:07:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: perex@perex.cz
CC: LKML <linux-kernel@vger.kernel.org>, fzu@wemgehoertderstaat.de
Subject: [PATCH] ALSA: us122l: fix missing unlock in usb_stream_hwdep_vm_fault()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should unlock us122l->mutex before returning VM_FAULT_SIGBUS.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 sound/usb/usx2y/us122l.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index b441fe2..c2515b6 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -118,12 +118,11 @@ static int usb_stream_hwdep_vm_fault(struct vm_area_struct *area,
 	void *vaddr;
 	struct us122l *us122l = area->vm_private_data;
 	struct usb_stream *s;
-	int vm_f = VM_FAULT_SIGBUS;
 
 	mutex_lock(&us122l->mutex);
 	s = us122l->sk.s;
 	if (!s)
-		goto out;
+		goto unlock;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset < PAGE_ALIGN(s->read_size))
@@ -131,7 +130,7 @@ static int usb_stream_hwdep_vm_fault(struct vm_area_struct *area,
 	else {
 		offset -= PAGE_ALIGN(s->read_size);
 		if (offset >= PAGE_ALIGN(s->write_size))
-			goto out;
+			goto unlock;
 
 		vaddr = us122l->sk.write_page + offset;
 	}
@@ -141,9 +140,11 @@ static int usb_stream_hwdep_vm_fault(struct vm_area_struct *area,
 	mutex_unlock(&us122l->mutex);
 
 	vmf->page = page;
-	vm_f = 0;
-out:
-	return vm_f;
+
+	return 0;
+unlock:
+	mutex_unlock(&us122l->mutex);
+	return VM_FAULT_SIGBUS;
 }
 
 static void usb_stream_hwdep_vm_close(struct vm_area_struct *area)
-- 
1.5.4.rc3

