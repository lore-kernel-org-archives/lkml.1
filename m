Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbXIKQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbXIKQUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbXIKQUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:20:25 -0400
Received: from web52002.mail.re2.yahoo.com ([206.190.49.249]:26251 "HELO
	web52002.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753737AbXIKQUZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:20:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=GHreDuzeM5O/8ndvqDNIpAFTy5GE9z3F0fBulJSGO/vlnOjEJnoxqjZDgO24ZT/Pv24tsN4rl6lnPk255bH9V2OOEzpLwUCY5XM1dMZ74r2z9+vnIsCQotlpVBT5FSHwH6HRjCIdUxOt73cxRvqL0C4ulWJ5lPAuWGoaEeEWSeM=;
X-YMail-OSG: kcnUIgcVM1mK90k.mM7Kux9Co41JEmJRKc4_hQV_ZTi_No_9KyDk4KXbgabdt8OXg74K8k2E6oHoEGDyo6VoopKyFWy1Ra.KHooh6ekhb9xetQsAAQr5ooNhEYKBuw--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Tue, 11 Sep 2007 09:20:23 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Do not deprecate binary semaphore or do allow mutex in software interrupt contexts
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <36061.50670.qm@web52002.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Arjan van de Ven:
> what do you do if the trylock fails?

Just do not read the status variable now but modify the timer to run later.

> to be honest, the scenario describe really smells of broken locking, in
> fact it really sounds like it wants to use spinlocks instead 

No, I don't think it is broken.
Spinlocks can be used, but I don't see them being obviously better in all cases.
If access takes a long time, it is better to sleep during it.
And if you sleep, you might just end up creating a new mutex implementation with a spinlock.

Alan Cox:
> For polling and timer based code its often simpler to do
>
>    del_timer_sync(&my_timer);
>    FrobStuff
>    add_timer(&my_timer);
>
> especially if "FrobStuff" is likely to change when you next need to poll.

In the scenario I presented, the timer modifies itself to run later.
Therefore, simply calling del_timer_sync is not enough but you have to set an atomic variable to prevent the timer from adding itself again.
Again, you end up creating a new mutex implementation, which is not good.




       __________________________________ 
Yahoo! Clever - Der einfachste Weg, Fragen zu stellen und Wissenswertes mit Anderen zu teilen. www.yahoo.de/clever

