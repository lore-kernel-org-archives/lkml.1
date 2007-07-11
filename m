Return-Path: <linux-kernel-owner+w=401wt.eu-S935565AbXGLAFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565AbXGLAFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932452AbXGKXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:46:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935344AbXGKXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:46:10 -0400
Date: Wed, 11 Jul 2007 16:45:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@frob.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
Message-Id: <20070711164531.aef1dcac.akpm@linux-foundation.org>
In-Reply-To: <20070711190434.D0F0C4D0555@magilla.localdomain>
References: <20070711190434.D0F0C4D0555@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 12:04:34 -0700 (PDT)
Roland McGrath <roland@frob.com> wrote:

> +/*
> + * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
> + */
> +extern const char __start_notes __attribute__((weak));
> +extern const char __stop_notes __attribute__((weak));
> +#define	notes_size (&__stop_notes - &__start_notes)
> +
> +static ssize_t notes_read(struct kobject *kobj,
> +			  char *buf, loff_t off, size_t count)
> +{
> +	memcpy(buf, &__start_notes + off, count);
> +	return count;
> +}
> +
> +static struct bin_attribute notes_attr = {
> +	.attr = {
> +		.name = "notes",
> +		.mode = S_IRUGO,
> +	},
> +	.read = &notes_read,
> +};
> +
>  decl_subsys(kernel, NULL, NULL);
>  EXPORT_SYMBOL_GPL(kernel_subsys);
>  
> @@ -88,6 +110,12 @@ static int __init ksysfs_init(void)
>  		error = sysfs_create_group(&kernel_subsys.kobj,
>  					   &kernel_attr_group);
>  
> +	if (!error && notes_size > 0) {
> +		notes_attr.size = notes_size;
> +		error = sysfs_create_bin_file(&kernel_subsys.kobj,
> +					      &notes_attr);
> +	}

I'm curios to know what happens if nobody defines __start_notes and
__end_notes.  We'll use the extern-attribute-weak thing, but those two
locations won't even get instantiated in vmlinux, I think.

And the code relies upon the difference between two non-existent
attribute-weak locations being zero.



akpm:/home/akpm> cat t.c

#include <stdio.h>

extern const char __start_notes __attribute__((weak));
extern const char __stop_notes __attribute__((weak));

main()
{
	int a = &__stop_notes - &__start_notes;
	
	printf("%d\n", a);
}

akpm:/home/akpm> gcc -g t.c
akpm:/home/akpm> ./a.out
0
akpm:/home/akpm> nm a.out|grep notes
         w __start_notes
         w __stop_notes

So it all works OK on this toolchain.  But is it _supposed_ to work?  Are
we venturing into unexplored binutils territory here?

