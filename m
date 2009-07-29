Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZG2Qk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZG2Qk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZG2Qk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:40:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45123 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbZG2QkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:40:25 -0400
X-Greylist: delayed 1058 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 12:40:24 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x/GDiJJx58swippukSqYPN3cvfjKRLWxCLPOSssBFVpi4NR5Vr5eOV4ufld9nC27kD
         PhO3AeURGtjIiUjhM1NNMFIXsMis6X4XJrgr52eVy1j1+4l6WMvB647DdhUoLFQKHVk9
         dTP7ZNgElYKkdJDDMLA9a0KVHH2oh6sUyt8II=
MIME-Version: 1.0
In-Reply-To: <1244461122-3303-1-git-send-email-alexander.shishckin@gmail.com>
References: <1244461122-3303-1-git-send-email-alexander.shishckin@gmail.com>
Date: Wed, 29 Jul 2009 19:17:00 +0300
Message-ID: <71a0d6ff0907290917u1f0c0e68p8036d53c69320392@mail.gmail.com>
Subject: Re: [PATCH] [RFC] List per-process file descriptor consumption when 
	hitting file-max
From: Alexander Shishkin <alexander.shishckin@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Shishkin <alexander.shishckin@gmail.com>,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6TGf07T031541

2009/6/8  <alexander.shishckin@gmail.com>:> From: Alexander Shishkin <alexander.shishckin@gmail.com>>> When a file descriptor limit is hit, it might be useful to see all the> users to be able to identify those that leak descriptors.Is there anything dramatically wrong with this one, or could someoneplease review this?
> Signed-off-by: Alexander Shishkin <alexander.shishckin@gmail.com>> --->  fs/file_table.c |   27 +++++++++++++++++++++++++++>  1 files changed, 27 insertions(+), 0 deletions(-)>> diff --git a/fs/file_table.c b/fs/file_table.c> index 54018fe..9e53167 100644> --- a/fs/file_table.c> +++ b/fs/file_table.c> @@ -136,8 +136,35 @@ struct file *get_empty_filp(void)>  over:>        /* Ran out of filps - report that */>        if (get_nr_files() > old_max) {> +               struct task_struct *p;> +               struct files_struct *files;> +               struct fdtable *fdt;> +               int i, count = 0;> +>                printk(KERN_INFO "VFS: file-max limit %d reached\n",>                                        get_max_files());> +> +               read_lock(&tasklist_lock);> +               for_each_process(p) {> +                       files = get_files_struct(p);> +                       if (!files)> +                               continue;> +> +                       spin_lock(&files->file_lock);> +                       fdt = files_fdtable(files);> +> +                       /* we have to actually *count* the fds */> +                       for (count = i = 0; i < fdt->max_fds; i++)> +                               count += !!fcheck_files(files, i);> +> +                       printk(KERN_INFO "=> %s [%d]: %d\n", p->comm,> +                                       p->pid, count);> +> +                       spin_unlock(&files->file_lock);> +                       put_files_struct(files);> +               }> +               read_unlock(&tasklist_lock);> +>                old_max = get_nr_files();>        }>        goto fail;> --> 1.6.1.3>>
TIA,--Alex���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
