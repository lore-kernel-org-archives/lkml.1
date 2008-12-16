Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYLPJcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYLPJcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYLPJcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:32:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbYLPJcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:32:46 -0500
Date: Tue, 16 Dec 2008 01:32:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Richter <robert.richter@amd.com>
Cc: oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] oprofile: set values to default when creating
 oprofilefs
Message-Id: <20081216013225.272a5fd1.akpm@linux-foundation.org>
In-Reply-To: <1229007886-14362-9-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
	<1229007886-14362-9-git-send-email-robert.richter@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 16:04:44 +0100 Robert Richter <robert.richter@amd.com> wrote:

> This patch restores default values for:
> 
> /dev/oprofile/cpu_buffer_size
> /dev/oprofile/buffer_watershed
> /dev/oprofile/buffer_size
> 
> when creating the oprofilefs:
> 
>  # opcontrol --deinit
>  # opcontrol --init
>  # cat /dev/oprofile/cpu_buffer_size
>  8192
>  # echo 5123 > /dev/oprofile/cpu_buffer_size
>  # cat /dev/oprofile/cpu_buffer_size
>  5123
>  # opcontrol --deinit
>  # opcontrol --init
>  # cat /dev/oprofile/cpu_buffer_size
>  8192
>  # opcontrol --deinit
> 
> This sets the values in a defined state. Before, there was no way to
> restore the defaults without rebooting the system or reloading the
> module.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  drivers/oprofile/oprofile_files.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
> index cc106d5..d820199 100644
> --- a/drivers/oprofile/oprofile_files.c
> +++ b/drivers/oprofile/oprofile_files.c
> @@ -14,9 +14,13 @@
>  #include "oprofile_stats.h"
>  #include "oprof.h"
>  
> -unsigned long fs_buffer_size = 131072;
> -unsigned long fs_cpu_buffer_size = 8192;
> -unsigned long fs_buffer_watershed = 32768; /* FIXME: tune */
> +#define FS_BUFFER_SIZE_DEFAULT		131072
> +#define FS_CPU_BUFFER_SIZE_DEFAULT	8192
> +#define FS_BUFFER_WATERSHED_DEFAULT	32768	/* FIXME: tune */
> +
> +unsigned long fs_buffer_size;
> +unsigned long fs_cpu_buffer_size;
> +unsigned long fs_buffer_watershed;

These were poorly chosen kernel-wide identifiers.

>  static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
>  {
> @@ -120,6 +124,11 @@ static const struct file_operations dump_fops = {
>  
>  void oprofile_create_files(struct super_block *sb, struct dentry *root)
>  {
> +	/* reinitialize default values */
> +	fs_buffer_size =	FS_BUFFER_SIZE_DEFAULT;
> +	fs_cpu_buffer_size =	FS_CPU_BUFFER_SIZE_DEFAULT;
> +	fs_buffer_watershed =	FS_BUFFER_WATERSHED_DEFAULT;
> +
>  	oprofilefs_create_file(sb, root, "enable", &enable_fops);
>  	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
>  	oprofilefs_create_file(sb, root, "buffer", &event_buffer_fops);

afacit oprofile_create_files() only gets run when the module is loaded,
so this patch is a no-op?


