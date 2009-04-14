Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZDNCdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZDNCdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZDNCdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:33:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:26331 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZDNCdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-4-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-5-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com>
Date: Mon, 13 Apr 2009 22:33:04 -0400
Message-ID: <f73f7ab80904131933q516227f3j608c6d3ea7245859@mail.gmail.com>
Subject: Re: [PATCH 06/14] DRBD: userspace_interface
From: Kyle Moffett <kyle@moffetthome.net>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, first of all you should probably run all this through checkpatch
and fix all the errors it reports and most of the warnings, then
provide a log of the output indicating any false warnings.  That will
help you fix a lot of codingstyle quirks that tend to annoy ordinary
reviewers when they are going over your code, which helps make them
much more productive.


On Fri, Apr 10, 2009 at 8:12 AM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> +/* Altough the Linux source code makes a difference between
> +   generic endiness and the bitfields' endianess, there is no
> +   architecture as of Linux-2.6.24-rc4 where the bitfileds' endianess
> +   does not match the generic endianess. */
> +
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
> +#define __LITTLE_ENDIAN_BITFIELD
> +#elif __BYTE_ORDER == __BIG_ENDIAN
> +#define __BIG_ENDIAN_BITFIELD
> +#else
> +# error "sorry, weird endianness on this box"
> +#endif

I think there's a standard macro for this?  On the other hand, it's
generally recommended that you avoid using C-level bitfields for
network-transport things... masking with explicit constants is
preferred.


> +enum io_error_handler {
> +       PassOn, /* FIXME should the better be named "Ignore"? */
> +       CallIOEHelper,
> +       Detach
> +};
> [...]

CamelCase is discouraged for constants, codingstyle encourages ALL_CAPS.


> +/* KEEP the order, do not delete or insert!
> + * Or change the API_VERSION, too. */
> +enum ret_codes {
> +       RetCodeBase = 100,
> +       NoError,         /* 101 ... */
> +       LAAlreadyInUse,
> [...]

The best documentation that the values of an enum should not be
rearranged is to explicitly assign all of the enum values.
Specifically it makes it a pain in the rear for somebody to try to
break binary compatibility, which is a good coding practice in
general.



> +union drbd_state_t {

CodingStyle: Drop the _t and just use "union drbd_state".


> +/* According to gcc's docs is the ...
> + * The order of allocation of bit-fields within a unit (C90 6.5.2.1, C99 6.7.2.1).
> + * Determined by ABI.
> + * pointed out by Maxim Uvarov q<muvarov@ru.mvista.com>
> + * even though we transmit as "cpu_to_be32(state)",
> + * the offsets of the bitfields still need to be swapped
> + * on different endianess.
> + */
> +       struct {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +               unsigned role:2 ;   /* 3/4       primary/secondary/unknown */
> +               unsigned peer:2 ;   /* 3/4       primary/secondary/unknown */
> +               unsigned conn:5 ;   /* 17/32     cstates */
> [...]

Yeah, this is kinda ugly... just use shift and mask like most other places do.


> +#define MDF_Consistent      (1<<__MDF_Consistent)
> +#define MDF_PrimaryInd      (1<<__MDF_PrimaryInd)
> +#define MDF_ConnectedInd    (1<<__MDF_ConnectedInd)
> +#define MDF_FullSync        (1<<__MDF_FullSync)
> +#define MDF_WasUpToDate     (1<<__MDF_WasUpToDate)
> +#define MDF_PeerOutDated    (1<<__MDF_PeerOutDated)
> +#define MDF_CrashedPrimary  (1<<__MDF_CrashedPrimary)

CodingStyle: Your #defines should be ALL_CAPS


> +enum UuidIndex {
> [...]
> +enum UseTimeout {
> [...]

CodingStyle: Your type names should be all_lower_case


> +STATIC void nl_trace_packet(void *data)
> +{
> +       struct cn_msg *req = data;
> +       struct drbd_nl_cfg_req *nlp = (struct drbd_nl_cfg_req *)req->data;
> +
> +       printk(KERN_INFO "drbd%d: "
> +              "Netlink: << %s (%d) - seq: %x, ack: %x, len: %x\n",
> +              nlp->drbd_minor,
> +              nl_packet_name(nlp->packet_type),
> +              nlp->packet_type,
> +              req->seq, req->ack, req->len);
> +}

Instead of cobbling together your own tracing code, why not use the
fancy tracing infrastructure that Ingo, et. al. have been getting
merged?  Look at the blktrace patches that have been going by on LKML
today for some examples.

> +int drbd_khelper(struct drbd_conf *mdev, char *cmd)
> +{
> +       char mb[12];
> +       char *argv[] = {usermode_helper, cmd, mb, NULL };
> +       int ret;
> +       static char *envp[] = { "HOME=/",
> +                               "TERM=linux",
> +                               "PATH=/sbin:/usr/sbin:/bin:/usr/bin",
> +                               NULL };
> +
> +       snprintf(mb, 12, "minor-%d", mdev_to_minor(mdev));

This looks like it should perhaps be implemented by sending uevents on
your drbd device, instead of running a separate userland helper.
Specifically that way you don't trigger an exec for every single
event; uevents support a persistent daemon handling various tasks.


> +STATIC int drbd_nl_primary(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
> +                          struct drbd_nl_cfg_reply *reply)

CodingStyle:  s/STATIC/static/g
Also remove that #define STATIC static macro and associated #ifdefs


> +char *ppsize(char *buf, unsigned long long size)
> +{
> +       /* Needs 9 bytes at max. */
> +       static char units[] = { 'K', 'M', 'G', 'T', 'P', 'E' };
> +       int base = 0;
> +       while (size >= 10000) {
> +               /* shift + round */
> +               size = (size >> 10) + !!(size & (1<<9));
> +               base++;
> +       }
> +       sprintf(buf, "%lu %cB", (long)size, units[base]);
> +
> +       return buf;
> +}

Perhaps you should just export a raw 64-bit number of bytes to
userspace via sysfs/etc and let userspace decode it?


> +enum determin_dev_size_enum drbd_determin_dev_size(struct drbd_conf *mdev) __must_hold(local)

Spelling/clarity fix: change "enum determin_dev_size_enum" to "enum
determine_dev_size"


> +               INFO("Writing the whole bitmap, size changed\n");

Please use the existing dev_warn()-style macros instead of writing
your own set.  We're trying to get rid of those superfluous macros all
over the place, not add more!


> +       MTRACE(TraceTypeRq, TraceLvlSummary,
> +              DUMPI(b->max_sectors);
> +              DUMPI(b->max_phys_segments);
> +              DUMPI(b->max_hw_segments);
> +              DUMPI(b->max_segment_size);
> +              DUMPI(b->hardsect_size);
> +              DUMPI(b->seg_boundary_mask);
> +              );

Again, this looks like an excellent candidate for the standardized
tracing macros.


> +       /* KERNEL BUG. in ll_rw_blk.c ??
> +        * t->max_segment_size = min(t->max_segment_size,b->max_segment_size);
> +        * should be
> +        * t->max_segment_size = min_not_zero(...,...)
> +        * workaround here: */
> +       if (q->max_segment_size == 0)
> +               q->max_segment_size = max_seg_s;

If this is a real bug, please submit a patch to fix it as a prereq for
the drbd patch.  If not, please remove this comment.


> +       D_ASSERT(mdev->bc == NULL);

Yet more custom macros... use standard stuff like BUG_ON() please?


> +#define M_ADDR(A) (((struct sockaddr_in *)&A->my_addr)->sin_addr.s_addr)
> +#define M_PORT(A) (((struct sockaddr_in *)&A->my_addr)->sin_port)
> +#define O_ADDR(A) (((struct sockaddr_in *)&A->peer_addr)->sin_addr.s_addr)
> +#define O_PORT(A) (((struct sockaddr_in *)&A->peer_addr)->sin_port)
> +       retcode = NoError;
> +       for (i = 0; i < minor_count; i++) {
> +               odev = minor_to_mdev(i);
> +               if (!odev || odev == mdev)
> +                       continue;
> +               if (inc_net(odev)) {
> +                       if (M_ADDR(new_conf) == M_ADDR(odev->net_conf) &&
> +                           M_PORT(new_conf) == M_PORT(odev->net_conf))
> +                               retcode = LAAlreadyInUse;
> +
> +                       if (O_ADDR(new_conf) == O_ADDR(odev->net_conf) &&
> +                           O_PORT(new_conf) == O_PORT(odev->net_conf))
> +                               retcode = OAAlreadyInUse;
> +
> +                       dec_net(odev);
> +                       if (retcode != NoError)
> +                               goto fail;
> +               }
> +       }
> +#undef M_ADDR
> +#undef M_PORT
> +#undef O_ADDR
> +#undef O_PORT

Ewww....  Either those should be static inlines or you should just
declare some local variables and reference them instead.

> +#if 0
> +       /* for the connection loss logic in drbd_recv
> +        * I _need_ the resulting timeo in jiffies to be
> +        * non-zero and different
> +        *
> +        * XXX maybe rather store the value scaled to jiffies?
> +        * Note: MAX_SCHEDULE_TIMEOUT/HZ*HZ != MAX_SCHEDULE_TIMEOUT
> +        *       and HZ > 10; which is unlikely to change...
> +        *       Thus, if interrupted by a signal,
> +        *       sock_{send,recv}msg returns -EINTR,
> +        *       if the timeout expires, -EAGAIN.
> +        */
> +       /* unlikely: someone disabled the timeouts ...
> +        * just put some huge values in there. */
> +       if (!new_conf->ping_int)
> +               new_conf->ping_int = MAX_SCHEDULE_TIMEOUT/HZ;
> +       if (!new_conf->timeout)
> +               new_conf->timeout = MAX_SCHEDULE_TIMEOUT/HZ*10;
> +       if (new_conf->ping_int*10 < new_conf->timeout)
> +               new_conf->timeout = new_conf->ping_int*10/6;
> +       if (new_conf->ping_int*10 == new_conf->timeout)
> +               new_conf->ping_int = new_conf->ping_int+1;
> +#endif

Either fix this code or remove it.

Cheers,
Kyle Moffett
