Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbZGHFvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbZGHFvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbZGHFvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:51:10 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:49388 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbZGHFvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=t3X6CLi5HdneIFnKQY3YaQFdHMUmOnlD1OQVZm6RM5KYKIggfqWiD3/w4eQ3u6eNWs
         CMt58jO4PNI6NENPNX8pJLfntMFlEYyyPLY9RfbE0QFVr6Ivzz74UpbWvuN4XIBhMyj9
         8P/B0twYAoCKSSorxHOT/ODkDRHHlfxZcaVIY=
MIME-Version: 1.0
Date: Wed, 8 Jul 2009 02:51:06 -0300
X-Google-Sender-Auth: 2dba746dbcdfaee2
Message-ID: <2c03f9590907072251q4d6b17fan7c7bb391b9d2f70a@mail.gmail.com>
Subject: Resolving executable name / reading vma->vm_flags
From: "Lucas C. Villa Real" <lucasvr@gobolinux.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

I'm currently running into an issue which seems to have started after
I introduced a change to Audit which is still under testing.
audit_filter_syscall() was modified to also collect the process'
executable name and use that to perform extra comparisons.

The problem is that sometimes, during reboots, I get general
protection failures in _spin_lock+0 which never appeared before.
Verifying the processor context through the Crash utility I see that
the spinlock structure provided to _spin_lock is valid and contains a
reasonable value (lock->slock == 1).

However, I always see that new function listed in the backtrace in
another processor, so I must believe that has something to do with the
failure.

My question is: is there a chance that something can go wrong when
calling d_path() on vma->vm_file, even though mm->mmap_sem is held?
Any conditions, restrictions or calling conventions that I may not be
aware of?

The function is listed below. Please note that this function is called
from process context during system calls and the contexts in which
it's called allow the caller to sleep. It returns a pointer to the
offset in kfree_ptr where the resolved path starts.


static char *audit_get_task_exe(char **kfree_ptr, struct task_struct *tsk)
{
        struct mm_struct *mm = get_task_mm(tsk);
        struct vm_area_struct *vma;
        char *path, *name_ptr = NULL;

        if (! mm) {
                /* Task has no mm or is a kernel thread which is doing
async I/O */
                return NULL;
        }

        path = kmalloc(PATH_MAX, GFP_KERNEL);
        if (!path) {
                mmput(mm);
                return NULL;
        }

        /* Look for the executable name in the task's list of mmap'd areas */
        down_read(&mm->mmap_sem);
        vma = mm->mmap;
        while (vma) {
                if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
                        name_ptr = d_path(&vma->vm_file->f_path, path,
PATH_MAX);
                        if (IS_ERR(name_ptr)) {
                                name_ptr = NULL;
                                goto out;
                        }
                        *kfree_ptr = path;
                        break;
                }
                vma = vma->vm_next;
        }

out:
        up_read(&mm->mmap_sem);
        mmput(mm);
        if (unlikely(!name_ptr))
                kfree(path);
        return name_ptr;
}

Any comments are greatly appreciated. Thanks!

Lucas
