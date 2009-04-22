Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZDVKcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZDVKcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZDVKc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:32:26 -0400
Received: from [212.69.161.110] ([212.69.161.110]:46671 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZDVKcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:32:24 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 06/14] DRBD: userspace_interface
Date: Wed, 22 Apr 2009 12:31:25 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com> <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com> <f73f7ab80904131933q516227f3j608c6d3ea7245859@mail.gmail.com>
In-Reply-To: <f73f7ab80904131933q516227f3j608c6d3ea7245859@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904221231.26631.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 04:33:04 Kyle Moffett wrote:
> Ok, first of all you should probably run all this through checkpatch
> and fix all the errors it reports and most of the warnings, then
> provide a log of the output indicating any false warnings.  That will
> help you fix a lot of codingstyle quirks that tend to annoy ordinary
> reviewers when they are going over your code, which helps make them
> much more productive.
>

Actually I had checkpatch run over this, but I ignored the 80
character a line limit. 

>
> On Fri, Apr 10, 2009 at 8:12 AM, Philipp Reisner
>
> <philipp.reisner@linbit.com> wrote:
> > +/* Altough the Linux source code makes a difference between
> > +   generic endiness and the bitfields' endianess, there is no
> > +   architecture as of Linux-2.6.24-rc4 where the bitfileds' endianess
> > +   does not match the generic endianess. */
> > +
> > +#if __BYTE_ORDER == __LITTLE_ENDIAN
> > +#define __LITTLE_ENDIAN_BITFIELD
> > +#elif __BYTE_ORDER == __BIG_ENDIAN
> > +#define __BIG_ENDIAN_BITFIELD
> > +#else
> > +# error "sorry, weird endianness on this box"
> > +#endif
>
> I think there's a standard macro for this?  On the other hand, it's
> generally recommended that you avoid using C-level bitfields for
> network-transport things... masking with explicit constants is
> preferred.

> CamelCase is discouraged for constants, codingstyle encourages ALL_CAPS.

Ok, I changed that.

> > +/* KEEP the order, do not delete or insert!
> > + * Or change the API_VERSION, too. */
> > +enum ret_codes {
> > +       RetCodeBase = 100,
> > +       NoError,         /* 101 ... */
> > +       LAAlreadyInUse,
> > [...]
>
> The best documentation that the values of an enum should not be
> rearranged is to explicitly assign all of the enum values.
> Specifically it makes it a pain in the rear for somebody to try to
> break binary compatibility, which is a good coding practice in
> general.

Ok, the got explicit numbers. While doing that I removed the old
unused from that enum definition.

> > +union drbd_state_t {
>
> CodingStyle: Drop the _t and just use "union drbd_state".
>

Done.

> > +/* According to gcc's docs is the ...
> > + * The order of allocation of bit-fields within a unit (C90 6.5.2.1, C99
> > 6.7.2.1). + * Determined by ABI.
> > + * pointed out by Maxim Uvarov q<muvarov@ru.mvista.com>
> > + * even though we transmit as "cpu_to_be32(state)",
> > + * the offsets of the bitfields still need to be swapped
> > + * on different endianess.
> > + */
> > +       struct {
> > +#if defined(__LITTLE_ENDIAN_BITFIELD)
> > +               unsigned role:2 ;   /* 3/4      
> > primary/secondary/unknown */ +               unsigned peer:2 ;   /* 3/4  
> >     primary/secondary/unknown */ +               unsigned conn:5 ;   /*
> > 17/32     cstates */
> > [...]
>
> Yeah, this is kinda ugly... just use shift and mask like most other places
> do.

Well, the thing is, it works as it is. There is at least one other place
in the kernel where the same trick is used. Anything else would be more code,
so in my humble opinion one gets more quickly what is going on when reading
this, rather two longish encoding-decoding functions. 

>
> > +enum UuidIndex {
> > [...]
> > +enum UseTimeout {
> > [...]
>
> CodingStyle: Your type names should be all_lower_case

Done.

>
> > +STATIC void nl_trace_packet(void *data)
> > +{
> > +       struct cn_msg *req = data;
> > +       struct drbd_nl_cfg_req *nlp = (struct drbd_nl_cfg_req
> > *)req->data; +
> > +       printk(KERN_INFO "drbd%d: "
> > +              "Netlink: << %s (%d) - seq: %x, ack: %x, len: %x\n",
> > +              nlp->drbd_minor,
> > +              nl_packet_name(nlp->packet_type),
> > +              nlp->packet_type,
> > +              req->seq, req->ack, req->len);
> > +}
>
> Instead of cobbling together your own tracing code, why not use the
> fancy tracing infrastructure that Ingo, et. al. have been getting
> merged?  Look at the blktrace patches that have been going by on LKML
> today for some examples.
>

Will do so. That home grown tracing code exists because we had that
before the kernel had its own tracing code. -- I will clean this up, but
it will take a few days...

> > +int drbd_khelper(struct drbd_conf *mdev, char *cmd)
> > +{
> > +       char mb[12];
> > +       char *argv[] = {usermode_helper, cmd, mb, NULL };
> > +       int ret;
> > +       static char *envp[] = { "HOME=/",
> > +                               "TERM=linux",
> > +                               "PATH=/sbin:/usr/sbin:/bin:/usr/bin",
> > +                               NULL };
> > +
> > +       snprintf(mb, 12, "minor-%d", mdev_to_minor(mdev));
>
> This looks like it should perhaps be implemented by sending uevents on
> your drbd device, instead of running a separate userland helper.
> Specifically that way you don't trigger an exec for every single
> event; uevents support a persistent daemon handling various tasks.
>

We where inspired by the module loading mechanism of course. We use that only
for a very small number of events, like: "Userspace: Please outdate the
peer node, I am primary and I just lost contact to the peer". 
Nowadays we broadcast these explicit events besides all state changes
by means of netlink (connector) messages. Our current userspace implementation
requires that older interface, and I know that this interface is used by most 
of the corporate users, that have their custom cluster management stuff.

I understand your point, but I can not easily remove this right now.

> > +char *ppsize(char *buf, unsigned long long size)
> > +{
> > +       /* Needs 9 bytes at max. */
> > +       static char units[] = { 'K', 'M', 'G', 'T', 'P', 'E' };
> > +       int base = 0;
> > +       while (size >= 10000) {
> > +               /* shift + round */
> > +               size = (size >> 10) + !!(size & (1<<9));
> > +               base++;
> > +       }
> > +       sprintf(buf, "%lu %cB", (long)size, units[base]);
> > +
> > +       return buf;
> > +}
>
> Perhaps you should just export a raw 64-bit number of bytes to
> userspace via sysfs/etc and let userspace decode it?
>

That is used for convenient log messages.

[...]
>
> > +       /* KERNEL BUG. in ll_rw_blk.c ??
> > +        * t->max_segment_size =
> > min(t->max_segment_size,b->max_segment_size); +        * should be
> > +        * t->max_segment_size = min_not_zero(...,...)
> > +        * workaround here: */
> > +       if (q->max_segment_size == 0)
> > +               q->max_segment_size = max_seg_s;
>
> If this is a real bug, please submit a patch to fix it as a prereq for
> the drbd patch.  If not, please remove this comment.
>

That got fixed! I removed the comment and the workaround code from
the DRBD patch.

> > +       D_ASSERT(mdev->bc == NULL);
>
> Yet more custom macros... use standard stuff like BUG_ON() please?
>
> > +#define M_ADDR(A) (((struct sockaddr_in *)&A->my_addr)->sin_addr.s_addr)
> > +#define M_PORT(A) (((struct sockaddr_in *)&A->my_addr)->sin_port)
> > +#define O_ADDR(A) (((struct sockaddr_in
> > *)&A->peer_addr)->sin_addr.s_addr) +#define O_PORT(A) (((struct
> > sockaddr_in *)&A->peer_addr)->sin_port) +       retcode = NoError;
> > +       for (i = 0; i < minor_count; i++) {
> > +               odev = minor_to_mdev(i);
> > +               if (!odev || odev == mdev)
> > +                       continue;
> > +               if (inc_net(odev)) {
> > +                       if (M_ADDR(new_conf) == M_ADDR(odev->net_conf) &&
> > +                           M_PORT(new_conf) == M_PORT(odev->net_conf))
> > +                               retcode = LAAlreadyInUse;
> > +
> > +                       if (O_ADDR(new_conf) == O_ADDR(odev->net_conf) &&
> > +                           O_PORT(new_conf) == O_PORT(odev->net_conf))
> > +                               retcode = OAAlreadyInUse;
> > +
> > +                       dec_net(odev);
> > +                       if (retcode != NoError)
> > +                               goto fail;
> > +               }
> > +       }
> > +#undef M_ADDR
> > +#undef M_PORT
> > +#undef O_ADDR
> > +#undef O_PORT
>
> Ewww....  Either those should be static inlines or you should just
> declare some local variables and reference them instead.

Right. I just cleaned that up.

> > +#if 0
> > +       /* for the connection loss logic in drbd_recv
[...]
> Either fix this code or remove it.

Removed.


As usual I have pushed the changes to git://git.drbd.org/linux-2.6-drbd
I will prepare for a further post to LKML next week.

Thanks for your comments!

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

