Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbZDQNZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbZDQNZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDQNYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:24:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41704 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZDQNYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:24:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 06/14] DRBD: userspace_interface
Date: Fri, 17 Apr 2009 15:24:27 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com> <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com> <e2e108260904120923q639d036drb04b55b1e653ebf1@mail.gmail.com>
In-Reply-To: <e2e108260904120923q639d036drb04b55b1e653ebf1@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904171524.28960.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 April 2009 18:23:43 Bart Van Assche wrote:
> On Fri, Apr 10, 2009 at 2:12 PM, Philipp Reisner
>
> <philipp.reisner@linbit.com> wrote:
> > diff -uNrp linux-2.6.30-rc1/include/linux/drbd.h
> > linux-2.6.30-rc1-drbd/include/linux/drbd.h ---
> > linux-2.6.30-rc1/include/linux/drbd.h       1970-01-01 01:00:00.000000000
> > +0100 +++ linux-2.6.30-rc1-drbd/include/linux/drbd.h  2009-03-26
> > 15:53:46.520275000 +0100
>
> ...
>
> > +#include <linux/drbd_config.h>
>
> By including drbd_config.h in drbd.h all definitions in the former
> header file become visible in user space. Several definitions in
> drbd_config.h only make sense inside the kernel. Either the above
> #include directive should be removed or drbd_config.h should be
> cleaned up.

Without comments and boilerplate, drbd_config.h has 7 defines. 
REL_VERSION and API_VERSION are used by the kernel code and drbdsetup,
the others are used only by the kernel.

Ack, I have removed it from drbd.h

>
> > +/* Altough the Linux source code makes a difference between
> > +   generic endiness and the bitfields' endianess, there is no
> > +   architecture as of Linux-2.6.24-rc4 where the bitfileds' endianess
> > +   does not match the generic endianess. */
>
> I assume this should have been four times "endianness", just like below ?

Right. Changed.

> > +/* KEEP the order, do not delete or insert!
> > + * Or change the API_VERSION, too. */
> > +enum ret_codes {
> > +       RetCodeBase = 100,
> > +       NoError,         /* 101 ... */
> > +       LAAlreadyInUse,
>
> How will backwards compatibility for return codes be ensured ? The
> comment before the enum probably has to be changed to "KEEP the order,
> do not delete or insert!" only ?
>

Comment adjusted. New error codes should be appended to enum. When a
old userspace programm sees an error code greater than AfterLastRetCode
it suggests the user that he should update the userspace tools.

> ...
>
> > +union drbd_state_t {
> > +/* According to gcc's docs is the ...
> > + * The order of allocation of bit-fields within a unit (C90 6.5.2.1, C99
> > 6.7.2.1). + * Determined by ABI.
> > + * pointed out by Maxim Uvarov q<muvarov@ru.mvista.com>
> > + * even though we transmit as "cpu_to_be32(state)",
> > + * the offsets of the bitfields still need to be swapped
> > + * on different endianess.
> > + */
>
> The above comment really looks strange. Is it still up to date ?
>

The comment might be strange, but the content is true.

> > +/* from drbd_strings.c */
> > +extern const char *conns_to_name(enum drbd_conns);
> > +extern const char *roles_to_name(enum drbd_role);
> > +extern const char *disks_to_name(enum drbd_disk_state);
> > +extern const char *set_st_err_name(enum set_st_err);
>
> Should declarations of kernel functions really be present in a user
> space interface header ?
>

Well, we actually compile and link the same source file (drbd_strings.c) 
into the kernel code and into unser space (drbdsetup). It just has
functions to map those numbers to strings. -- Nothing fancy.

So yes, you are right, they are not part of the interface, they are
just used in both contexts. It just seemed ridiculous to me to have 
even a dedicated header file defining those 4 external functions.

As usual, I have pushed the changes to git.drbd.org

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

