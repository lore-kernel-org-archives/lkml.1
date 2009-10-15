Return-Path: <linux-kernel-owner+w=401wt.eu-S935151AbZJORj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935151AbZJORj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbZJORjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:39:25 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:48437 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025AbZJORjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:39:24 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
       Paul Fulghum <paulkf@microgate.com>, Boyan <btanastasov@yahoo.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	<4AD3F769.5080405@gmail.com>
	<alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>
	<4AD437F9.9020708@yahoo.co.uk>
	<alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
	<4AD4DE4C.4010402@yahoo.co.uk>
	<alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
	<4AD4F548.2030506@microgate.com>
	<alpine.LFD.2.01.0910131514100.3404@localhost.localdomain>
	<1255478932.19056.24.camel@localhost.localdomain>
	<4AD51D6B.7010509@microgate.com>
	<alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
	<20091014125846.1a3c8d40@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0910140804180.6146@localhost.localdomain>
	<alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
Date: Fri, 16 Oct 2009 02:38:38 +0900
In-Reply-To: <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> (Linus
	Torvalds's message of "Wed, 14 Oct 2009 09:38:43 -0700 (PDT)")
Message-ID: <87aazsh80x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus Torvalds <torvalds@linux-foundation.org> writes:

> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> index 0296612..66fa4e1 100644
> --- a/drivers/char/tty_buffer.c
> +++ b/drivers/char/tty_buffer.c
> @@ -468,7 +468,7 @@ static void flush_to_ldisc(struct work_struct *work)
>   */
>  void tty_flush_to_ldisc(struct tty_struct *tty)
>  {
> -	flush_to_ldisc(&tty->buf.work.work);
> +	flush_delayed_work(&tty->buf.work);
>  }

This might wait unnecessary scheduled-work on input_available_p(). This
is nitpick though, we can call tty_flush_to_ldisc() only when data is
unavailable.

I.e. the following or something,

static inline int input_available_p(struct tty_struct *tty, int amt)
{
	int try = 0;

retry:
	if (tty->icanon) {
		if (tty->canon_data)
			return 1;
	} else if (tty->read_cnt >= (amt ? amt : 1))
		return 1;

	if (!checked) {
		tty_flush_to_ldisc(tty);
		try = 1;
		goto retry;
	}

	return 0;
}

> +void flush_delayed_work(struct delayed_work *dwork)
> +{
> +	if (del_timer(&dwork->timer)) {
> +		struct cpu_workqueue_struct *cwq;
> +		cwq = wq_per_cpu(keventd_wq, get_cpu());
> +		__queue_work(cwq, &dwork->work);
> +		put_cpu();
> +	}
> +	flush_work(&dwork->work);
> +}
> +EXPORT_SYMBOL(flush_delayed_work);
> +
> +/**

Sorry if I'm missing the point. Doesn't this have (possible) race with
schedule_delayed_work() (i.e. by tty writer)?

             cpu0                                      cpu1

    if (del_timer(&dwork->timer)) {
                                            // cpu0 doesn't set _PENDING
                                            schedule_delayed_work()
        cwq = wq_per_cpu();
        __queue_work(cwq, &dwork->work);
        put_cpu();
    }
                                            // run timer
                                            delayed_work_timer_fn()
                                                __queue_work()
                                                    list_add_tail()
                                                // re-add without list_del(),
                                                // so this will break the list?
    flush_work(&dwork->work);

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
