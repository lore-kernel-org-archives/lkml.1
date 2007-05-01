Return-Path: <linux-kernel-owner+w=401wt.eu-S1423627AbXEAOZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423627AbXEAOZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423625AbXEAOZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:25:42 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:47886 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423627AbXEAOZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iKPNagSUNgdabbv/6p3oDf0YpP2/hNq8mCEMh8/oW8BdDezWp9mgSEBgo/u74f8d1DNlR/c0i+lzgZFw2o4ojNSqHisYYLDONo3DVGGEcRgDqpPny/a5wHieGEEpNjh5Ae7BWtS5KWHv2etE8G7yfPcZfsklNXbhX97okypUSLk=
Message-ID: <a781481a0705010725t310ecb31yde475412f620d6d6@mail.gmail.com>
Date: Tue, 1 May 2007 19:55:38 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH 16/21] sysfs: implement bin_buffer
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1177767582628-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11777675753460-git-send-email-htejun@gmail.com>
	 <1177767582628-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, Tejun Heo <htejun@gmail.com> wrote:
> Implement bin_buffer which contains a mutex and pointer to PAGE_SIZE
> buffer to properly synchronize accesses to per-openfile buffer and
> prepare for immediate-kobj-disconnect.
>
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> [...]
> @@ -135,14 +160,22 @@ static int open(struct inode * inode, struct file * file)
>                 goto Error;
>
>         error = -ENOMEM;
> -       file->private_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -       if (!file->private_data)
> +       bb = kzalloc(sizeof(*bb), GFP_KERNEL);
> +       if (!bb)
>                 goto Error;
>
> +       bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);

You could simply do a __get_free_page() here instead of a kmalloc(PAGE_SIZE).

> @@ -155,11 +188,12 @@ static int release(struct inode * inode, struct file * file)
>         struct kobject * kobj = to_kobj(file->f_path.dentry->d_parent);
>         struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
>         struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
> -       u8 * buffer = file->private_data;
> +       struct bin_buffer *bb = file->private_data;
>
>         kobject_put(kobj);
>         module_put(attr->attr.owner);
> -       kfree(buffer);
> +       kfree(bb->buffer);

And so this would become free_page().
