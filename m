Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYHKQQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYHKQQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYHKQPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:15:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:16961 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYHKQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oTPjRirbqFyIL5sd0h1YCceXMoGDk1hNw+gTcButSohTtBU9E8+iz3npa4Uu73exip
         Z2ZhBXxZNlxHtNiWHNwUc1NVzAGDdHGB7o++3Je36e+gmh0lN9Xan49A3Y3wx/JVwMvP
         4XPdq2vzBUOu89oMuJWJYuDQvIJ1CqG9Jd54U=
Message-ID: <86802c440808110915j5c6906b1u7b3e337ddd7bb6d1@mail.gmail.com>
Date: Mon, 11 Aug 2008 09:15:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <20080811112545.GE6925@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <859858.77737.qm@web82105.mail.mud.yahoo.com>
	 <20080809135650.GE8125@linux.vnet.ibm.com>
	 <20080811112545.GE6925@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 4:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>
>> > I'm _way_ over my head in this discussion, but here's some more food
>> > for thought.  Last weekend, when I first tried 2.6.26 and discovered
>> > the freeze, I thought an error of my own in .config was causing it.
>> > Before I ever sought help, I made about a dozen experiments with
>> > different .config files.
>> >
>> > One series of those experiments involved turning off most of the
>> > kernel... including CONFIG_INET.  The kernel still froze, but when
>> > entering pci_init().  (This info can be read in my original post to
>> > the Debian BTS, which I have provided links for a couple of times in
>> > this LKML thread.  I even went further and removed enough that the
>> > freeze was avoided, but so much of the kernel was missing that my
>> > init scripts couldn't mount a hard disk any more.  Trying to restore
>> > enough to allow HD mounting just brought back the freeze.)
> [...]
>>
>> RCU doesn't use HPET directly.  Most of its time-dependent behavior
>> comes from its being invoked from the scheduling-clock interrupt.
>
> such freezes frequently occur due to the plain lack of timer interrupts.
>
> As networking's rcu_synchronize() is one of the first calls in the
> kernel that relies on a timer IRQ hitting the CPU, it would be the first
> one that "freezes". It's not a real freeze though: it's the lack of
> timer events breaking RCU completion. (RCU has an implicit and somewhat
> subtle dependency on timer irqs periodically hitting the CPU)
>
> You can probably verify this by adding something like this to
> kernel/timer.c's do_timer() function:
>
>   if (printk_ratelimit())
>        printk("timer irq hit, jiffies: %ld\n", jiffies);
>
> Yinghai, do you have any ideas about this particular problem? One theory
> would be that your e820 changes might have caused a shuffling of
> resources that made the hpet's timer IRQ generation inoperable.

the hpet request_resource() calling fail?

YH
