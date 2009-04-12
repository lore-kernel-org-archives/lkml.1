Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZDLQX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZDLQX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbZDLQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:23:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34099 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZDLQXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dQBKVmDz9TR1ifguyT8UQs/sDOJEA1yHQae69DaIYUixNApNm/pdptjXvH3q2bsosV
         Pfu2jfkQJzTHU1/vhO7V9xGtA3fYJJv1ndpbSPeXpEomtu3Rw/66AGaOD4tv3xyGcn3e
         DVkfr8XvYSTVl8MFgxlZ+8mHYs0PNdZL5cD9c=
MIME-Version: 1.0
In-Reply-To: <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-4-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-5-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com>
Date: Sun, 12 Apr 2009 18:23:43 +0200
Message-ID: <e2e108260904120923q639d036drb04b55b1e653ebf1@mail.gmail.com>
Subject: Re: [PATCH 06/14] DRBD: userspace_interface
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 2:12 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> diff -uNrp linux-2.6.30-rc1/include/linux/drbd.h linux-2.6.30-rc1-drbd/include/linux/drbd.h
> --- linux-2.6.30-rc1/include/linux/drbd.h       1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.30-rc1-drbd/include/linux/drbd.h  2009-03-26 15:53:46.520275000 +0100

...

> +#include <linux/drbd_config.h>

By including drbd_config.h in drbd.h all definitions in the former
header file become visible in user space. Several definitions in
drbd_config.h only make sense inside the kernel. Either the above
#include directive should be removed or drbd_config.h should be
cleaned up.

...

> +/* Altough the Linux source code makes a difference between
> +   generic endiness and the bitfields' endianess, there is no
> +   architecture as of Linux-2.6.24-rc4 where the bitfileds' endianess
> +   does not match the generic endianess. */

I assume this should have been four times "endianness", just like below ?

> +
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
> +#define __LITTLE_ENDIAN_BITFIELD
> +#elif __BYTE_ORDER == __BIG_ENDIAN
> +#define __BIG_ENDIAN_BITFIELD
> +#else
> +# error "sorry, weird endianness on this box"
> +#endif

...

> +/* KEEP the order, do not delete or insert!
> + * Or change the API_VERSION, too. */
> +enum ret_codes {
> +       RetCodeBase = 100,
> +       NoError,         /* 101 ... */
> +       LAAlreadyInUse,

How will backwards compatibility for return codes be ensured ? The
comment before the enum probably has to be changed to "KEEP the order,
do not delete or insert!" only ?

...

> +union drbd_state_t {
> +/* According to gcc's docs is the ...
> + * The order of allocation of bit-fields within a unit (C90 6.5.2.1, C99 6.7.2.1).
> + * Determined by ABI.
> + * pointed out by Maxim Uvarov q<muvarov@ru.mvista.com>
> + * even though we transmit as "cpu_to_be32(state)",
> + * the offsets of the bitfields still need to be swapped
> + * on different endianess.
> + */

The above comment really looks strange. Is it still up to date ?

...

> +/* from drbd_strings.c */
> +extern const char *conns_to_name(enum drbd_conns);
> +extern const char *roles_to_name(enum drbd_role);
> +extern const char *disks_to_name(enum drbd_disk_state);
> +extern const char *set_st_err_name(enum set_st_err);

Should declarations of kernel functions really be present in a user
space interface header ?

Bart.
