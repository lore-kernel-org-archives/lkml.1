Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYGZUxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYGZUxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYGZUxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:53:37 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:34931 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753732AbYGZUxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:53:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XubLjJs1wbNhXGoW6nB3ABkY0aJj+uJWaxaYkLRQBeAGdsfkXhPR99kkRLkXlCA8tBuQrd6UVe+iwBYFPxxDTt9/74WzJDUmNr/NR6mGdCi+UUMPI+nCcEzDE0bdONmTkRv1a0H2YxyDWaP1tVp6SXSeC90jWudRMLa3kG4aP6U=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Tomas Janousek <tomi@nomi.cz>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Date: Sat, 26 Jul 2008 13:50:55 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20080726154617.GA5613@notes.lisk.in>
In-Reply-To: <20080726154617.GA5613@notes.lisk.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807261350.55524.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2008, Tomas Janousek wrote:
> Solves http://bugzilla.kernel.org/show_bug.cgi?id=11127
> 
> The old rtc.c driver did it, some drivers (like rtc-sh) do it in their release
> function too, but rtc-cmos does not -- because it provides the irq_set_state
> op -- so the rtc framework itself should care about it. This patch makes it do
> so.

I'd say it differently:  hardly any RTC drivers do this correctly.

Maybe only rtc-sh, which tracks whether user or kernel code turned
on the periodic IRQ.

 
> I am aware that some drivers, like rtc-sh, handle userspace PIE sets in their
> ioctl op, exporting the irq_set_state op at the same time. The logic in
> rtc_irq_set_state should make sure it doesn't matter and the driver should not
> need to care stopping periodic interrupts in its release routine any more.
> I did not look at other drivers though.

A quick grep shows that out of 42 (wow!) current RTC drivers:

 - rtc-{bfin,sa1100,sh,test} support ioctl(PIE_ON/PIE_OFF), at least
   before some recent patches fixing that glitch (not in my tree) by
   switching to irq_set_state().

 - rtc-{cmos,s3c,sh,vr41xx} support the more correct irq_set_state()
   requests, which are available for in-kernel use not just through
   ioctl(PIE_ON/PIE_OFF) calls to /dev files.

 - Of those:  rtc-{bfin,s3c,sa1100,sh,vr41xx} all have release()
   methods ... though it looks to me like most of those wrongly
   disable *all* IRQs, even ones in use by something other than
   the /dev client closing that FD.

That suggests there's quite a mess yet to be fixed.  This patch
will ensure that periodic IRQs get properly shut off by close()
or exit() of a task that started them.  Those release() methods
shouldn't then be second-guessing things.

And then there are the other two types of IRQ.  Update IRQs can
only be enabled through ioctl(UIE_ON), so they're fair game to
turn off when closing /dev files.  Alarms seem to be a special
case -- best not touched when closing files.


> Signed-off-by: Tomas Janousek <tomi@nomi.cz>
> Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
> Cc: David Brownell <david-b@pacbell.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... who likes it when bugfixes just take one line of code,
even if they consume many pages of discussion.  ;)


> ---
>  drivers/rtc/rtc-dev.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
> index 90dfa0d..6fafa62 100644
> --- a/drivers/rtc/rtc-dev.c
> +++ b/drivers/rtc/rtc-dev.c
> @@ -408,6 +408,8 @@ static int rtc_dev_release(struct inode *inode, struct file *file)
>  #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
>  	clear_uie(rtc);
>  #endif

Hmm, I'd think that something like an rtc_dev_ioctl(PIE_OFF) would be
preferable here ... so that it's not just UIE_EMUL logic which turns
off the one-per-second update IRQs.

In fact, with a change like that I suspect the release() issues could
best be dealt with by just removing that method and its implementations...


> +	rtc_irq_set_state(rtc, NULL, 0);
> +
>  	if (rtc->ops->release)
>  		rtc->ops->release(rtc->dev.parent);
>  
> -- 
> 1.5.6
> 
> 
> -- 
> Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
> 


