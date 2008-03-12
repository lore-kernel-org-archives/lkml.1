Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbYCLQRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbYCLQRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYCLQRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:17:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:22796 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYCLQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=xQPYlvMqp6FaiFk9nNfvdoDd/uzOyM6swvM1zoAR4X+pXUJoLnd7thz0bF1H6dhQgf3/S22sl2vl3xNAIy+EyO0szsyNsIHbGin1kYhbq/4WvDL50mosugoLMBy2KquGrZKEUwNm2E6bxUW4mK8+6dObn/DuRgAXCcs48BA5/6w=
Message-ID: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>
Date: Thu, 13 Mar 2008 00:17:28 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: per cpun+ spin locks coexistence?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Help me out this one - in fs/file.c, there is a function free_fdtable_rcu():

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
                               container_of(fdt, struct files_struct,
fdtab));
               return;
       }
       if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
               kfree(fdt->fd);
               kfree(fdt->open_fds);
               kfree(fdt);
       } else {
               fddef = &get_cpu_var(fdtable_defer_list);
               spin_lock(&fddef->lock);
               fdt->next = fddef->next;
               fddef->next = fdt;
               /* vmallocs are handled from the workqueue context */
               schedule_work(&fddef->wq);
               spin_unlock(&fddef->lock);
               put_cpu_var(fdtable_defer_list);
       }
}

Notice above that get_cpu_var() is followed by spin_lock().   Does this
make sense?   get_cpu_var() will return a variable that is only
accessible by the current CPU - guaranteed it will not be touch (read or
write) by another CPU, right?   so why do we need to spin_lock() it?

Thanks.

-- 
Regards,
Peter Teoh
