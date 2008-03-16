Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYCPIYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYCPIYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 04:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYCPIYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 04:24:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:27919 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYCPIYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 04:24:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ujqp/r17WlNIQCa8j+ioTYv0YGb43Py4H1vuAoCMp+QtSIqdMtoWJQgRSJjrevDRfH9X31CdRnA6uedqH4+f9mZv5OnWFfgF6l23yCmmRt+8XNBXWX5FZUbyw57wmf3ww6N/MIjgzm5ZZvLATICvO8WAGq/YuDkUYDEXvhmdZFo=
Message-ID: <804dabb00803160124p1240abe1v842821e988fdeca7@mail.gmail.com>
Date: Sun, 16 Mar 2008 16:24:02 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: spin_lock after get_cpu_var()
Cc: htmldeveloper@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find it quite puzzling (no where else in kernel source is this
found) that you would want to apply spin_lock() after get_cpu_var().
The fddef is already percpu, so there is no need to lock it, right?

I submitted this patch before, but got no response, just trying my
luck this time :-).

void free_fdtable_rcu(struct rcu_head *rcu)
{
        struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
        struct fdtable_defer *fddef;

        BUG_ON(!fdt);

        if (fdt->max_fds <= NR_OPEN_DEFAULT) {
                /*
                 * This fdtable is embedded in the files structure and that
                 * structure itself is getting destroyed.
                 */
                kmem_cache_free(files_cachep,
                                container_of(fdt, struct files_struct, fdtab));
                return;
        }
        if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
                kfree(fdt->fd);
                kfree(fdt->open_fds);
                kfree(fdt);
        } else {
                fddef = &get_cpu_var(fdtable_defer_list);=============> here
                spin_lock(&fddef->lock);==========================>here
                fdt->next = fddef->next;
                fddef->next = fdt;
                /* vmallocs are handled from the workqueue context */
                schedule_work(&fddef->wq);
                spin_unlock(&fddef->lock);
                put_cpu_var(fdtable_defer_list);
        }
}
