Return-Path: <linux-kernel-owner+w=401wt.eu-S1422926AbXCGTRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422926AbXCGTRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422964AbXCGTRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:17:40 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:7302 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422926AbXCGTRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:17:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mbQ8uNh4RskPyTEBw82l+uUTTLCxwc8BuhNsqxgn1bq9heEQvPj075a7OfVRGwztKEHnDzYb3/qpu07QdFtEXrAA76+31ttZQrInyAjki20wyPisRkeluMb5+vgGny2D4DdKNSgZ85RxnMJ1w06Fx97U557NAZqIepr1in/0mU4=
Message-ID: <f2b55d220703071117n474f02f7rcc630f0415530aed@mail.gmail.com>
Date: Wed, 7 Mar 2007 11:17:36 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: f_owner.lock and file->pos updates
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose I want to create an atomic llseek+writev operation.  Is this
more or less sufficient:

    ssize_t ret = -EBADF;
    file = fget_light(fd, &fput_needed);
    if (file) {
            if (unlikely(origin > 2)) {
                    ret = -EINVAL;
            } else {
                    write_lock_irq(&file->f_owner.lock);
                    pos = vfs_llseek(file, ((loff_t) offset_high <<
32) | offset_low, origin);
                    ret = (ssize_t)pos;
                    if (likely(ret >= 0)) {
                            ret = vfs_writev(file, vec, vlen, &pos);
                            file_pos_write(file, pos);
                    }
                    write_unlock_irq(&file->f_owner.lock);
            }
            fput_light(file, fput_needed);
    }

Or is this the wrong sort of lock to be using to protect against
having file->pos altered by another thread executing through the same
code?

Cheers,
- Michael
