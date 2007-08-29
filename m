Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXH2LzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXH2LzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 07:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbXH2Lyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 07:54:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:56087 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbXH2Lyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 07:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JMWeKgAvvCHOc8KJ48igXd1f5iYBi2Bwz+runPbAftaXiuD8cg4TQcJYugLJHNK5jELU7ac86dg0lWlg+wLDdgVA7lDUg/Y1dlZrR4ceMBmMQd7Wjl/p56GDIEek8us3YxTEjkpUnqdk1RyRE0vlX908qUFqpPaKQ3xijEKe/6o=
Message-ID: <25ae38200708290454r5be02a2ct568260cb429e4f1a@mail.gmail.com>
Date: Wed, 29 Aug 2007 17:24:53 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: Fork Bombing Patch
Cc: "Chris Snook" <csnook@redhat.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <33633.simon.1188386980@5ec7c279.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	 <46C4BC46.7000305@redhat.com>
	 <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
	 <46C9A867.6090509@redhat.com>
	 <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>
	 <m3d4xeii2z.fsf@maximus.localdomain> <46CDD98F.2020208@redhat.com>
	 <25ae38200708290248w2cdd152fpbdaa1b123de0b7ef@mail.gmail.com>
	 <33633.simon.1188386980@5ec7c279.invalid>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
   consider a case:
if non root user request admin for more number of processes than root
user,admin needs to modify settings in /etc/security/limits.conf file
and if that user is not trustworthy and if does fork bombing attack it
will kill the box.
(I have already tried this attack). in that case this loop will work,
but by the time attack might have killed the box (Bcoz so many
processes has already been created at that time) . so in that case
admin wont come to know that what has happened.

Like this there are many cases..(actually these cases has already been
discussed On LKML 2 months before in my thread named "fork bombing
attack").
in all these cases this printk helps adminstrator a lot.


Anand

On 8/29/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> On Wed, August 29, 2007 10:48, Anand Jahagirdar wrote:
> > Hi
> >                 printk_ratelimit function takes care of flooding the
> > syslog. due to printk_ratelimit function syslog will not be flooded
> > anymore. as soon as administrator gets this message, he can take
> > action against that user (may be block user's access on server). i
> > think the my fork patch is very useful and helps administrator lot.
> >                 i would also like to mention that in some of the cases
> > ulimit solution wont work. in that case fork bombing takes the machine
> > and server needs a reboot. i am sure in that situation this printk
> > statement helps administrator to know what has happened.
>
> If ulimit "wont work" in some situations, how is it going to trigger this printk?
> (When doesn't it work?)
>
> > Anand
> >
> > On 8/24/07, Chris Snook <csnook@redhat.com> wrote:
> >> Krzysztof Halasa wrote:
> >> > Hi,
> >> >
> >> > "Anand Jahagirdar" <anandjigar@gmail.com> writes:
> >> >
> >> >>    I am forwarding one more improved patch which i have modified as
> >> >> per your suggestions. Insted of KERN_INFO i have used KERN_NOTICE and
> >> >> i have added one more if block to check hard limit. how good it is?
> >> >
> >> > Not very, still lacks "#ifdef CONFIG_something" and the required
> >> > Kconfig change (or other runtime thing defaulting to "no printk").
> >>
> >> Wrapping a single printk that's unrelated to debugging in an #ifdef
> >> CONFIG_* or a sysctl strikes me as abuse of those configuration
> >> facilities.  Where would we draw the line for other patches wanting to
> >> do similar things?
> >>
> >> I realized that even checking the hard limit it insufficient, because
> >> that can be lowered (but not raised) by unprivileged processes.  If we
> >> can't do this unconditionally (and we can't, because the log pollution
> >> would be intolerable for many people) then we shouldn't do it at all.
> >>
> >> Anand -- I appreciate the effort, but I think you should reconsider
> >> precisely what problem you're trying to solve here.  This approach can't
> >> tell the difference between legitimate self-regulation of resource
> >> utilization and a real attack.  Worse, in the event of a real attack, it
> >> could be used to make it more difficult for the administrator to notice
> >> something much more serious than a forkbomb.
> >>
> >> I suspect that userspace might be a better place to solve this problem.
> >>  You could run your monitoring app with elevated or even realtime
> >> priority to ensure it will still function, and you have much more
> >> freedom in making the reporting configurable.  You can also look at much
> >> more data than we could ever allow in fork.c, and possibly detect
> >> attacks that this patch would miss if a clever attacker stayed just
> >> below the limit.
> >>
> >>        -- Chris
> >>
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
>
> --
> Simon Arlott
>
