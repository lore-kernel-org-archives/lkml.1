Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYI3Qb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYI3Qb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYI3Qbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:31:51 -0400
Received: from web35405.mail.mud.yahoo.com ([66.163.179.114]:22855 "HELO
	web35405.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751792AbYI3Qbu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:31:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 12:31:50 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=NdZmslssSge63LjUVKGBfesmx0isjQWDPlwll4e5pT4ZsiZI+nTe5j5vKsiWlSabE6sFF+tF81AedG3Gv5w0aWicMNig4fouem+oGvF1UTnuDBlqZ0dNpE8pa03pW9oOwurWqaGFd4BydqcPj1iOtGx6L4PY95zkJ2wxpbmFSW0=;
X-YMail-OSG: ZUsLFoQVM1lzIdlKiyhNh8Qh.qcMHL3o5jjE_jehCpIr4nmoDohzasq_VmJospwUsqcW5FORLd4zjFQ.ucUGS8GxuTDih7fFxLz.eN5WAyAi32w.vb_ntLLWUmpu0Z0d2SMv8UmcNZfKR2A5oFkrZ5OtUTmSourHbDP4O8G8bZT6htUXTA--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 30 Sep 2008 09:25:09 -0700 (PDT)
From: Krishna Kumar <krikkku@yahoo.com>
Reply-To: krikkku@yahoo.com
Subject: Re: [REV2: PATCH 1/2]: workqueue: Implement the kernel API 
To: linux-kernel@vger.kernel.org
Cc: oleg@tv-sign.ru
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <509896.58523.qm@web35405.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

(sending from a different email address)

> Oleg Nesterov <oleg@tv-sign.ru> wrote on 09/29/2008 07:57:34 PM:
>
> Yes. I must admit, I prefer the simple, non-intrusive code I suggested
> much more.
>
> Once again, the slow path is (at least, supposed to be) unlikely, and
> the difference is not that large. (I mean the slow path is when both
> queue() and update_timer() fail).
>
> Should we complicate the code to add this minor optimization (and
> btw pessimize the "normal" queue_delayed_work) ?
>
> And, once we have the correct and simple code, we can optimize it
> later.
>
> > I will go with the above
> > approach.
>
> No. Please do what _you_ think right ;)

No, you are right - I will go to the simpler (and bug-free?) interface.

> Yes. Please note that queue_delayed_work(work, 0) does not use the timer
> at all. IOW, queue_delayed_work(wq, work, 0) == queue_work(wq, &dwork->work).
> Perhaps (I don't know) update_queue_delayed_work() should do the same.
>
> From the next patch:
>
>       -       cancel_delayed_work(&afs_vlocation_reap);
>       -       schedule_delayed_work(&afs_vlocation_reap, 0);
>       +       schedule_update_delayed_work(&afs_vlocation_reap, 0);
>
> Again, I don't claim this is wrong, but please note that delay == 0.

As you stated in an earlier mail, the following code should handle all cases.
I think delay==0 is fine now, we take the costly (but rare) path.

int queue_update_delayed_work(struct workqueue_struct *wq,
                              struct delayed_work *dwork, unsigned long delay)
{
        int ret = 1;

        while (queue_delayed_work(wq, dwork, delay)) {
                unsigned long when = jiffies + delay;

                ret = 0;
                if (delay && update_timer_expiry(&dwork->timer, when))
                        break;
                cancel_work_sync(&dwork->work);
        }

        return ret;
}

I will run some tests and submit again.

Thanks once more for explaining patiently some very complicated portions :)

- KK


      Unlimited freedom, unlimited storage. Get it now, on http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html/
