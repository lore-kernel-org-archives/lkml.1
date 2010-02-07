Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0BGHAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 02:00:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab0BGHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 02:00:48 -0500
Date: Sat, 6 Feb 2010 22:59:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, gregkh@suse.de,
       taviso@google.com, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       alan@lxorguk.ukuu.org.uk, jdike@addtoit.com, jln@google.com,
       mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency in
 tty_fasync
In-Reply-To: <20100207064643.GA15533@hack>
Message-ID: <alpine.LFD.2.00.1002062246390.3829@localhost.localdomain>
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp> <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain> <20100207064643.GA15533@hack>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Feb 2010, Américo Wang wrote:
> 
> We already fixed this, a better fix:

No we didn't.

> http://lkml.org/lkml/2010/1/26/338
> 
> I sent a same fix with Greg's.

We already did that. You didn't read Tetsuo's email carefully.

Let's quote the important parts:

  "is not yet fixed as of 2.6.33-rc7."

and also the _second_ lockdep complaint he quotes, which starts out with

  [   81.651199] =========================================================
  [   81.651199] [ INFO: possible irq lock inversion dependency detected ]
  [   81.651199] 2.6.33-rc7 #11
  [   81.651199] ---------------------------------------------------------

(note the -rc7 there).

The problem? Look at f_getown: it does

	read_lock(&filp->f_owner.lock);

ie it holds f_owner without interrupts disabled. Now an interrupt comes 
in, and takes 'siglock' because it ends up sending a signal (timer, SIGIO, 
whatever). So you have a f_owner -> siglock ordering.

But we _also_ have a siglock -> ctrl_lock -> f_owner ordering, in that 
problematic tty_fasync() thing. So we have a ABBA deadlock situation.

Yes, it's hard (practically impossible) to trigger, because you have to 
get an interrupt just at the right point with all the right processes, but 
lockdep seems to be entirely correct. 

So it is simply _wrong_ to take f_owner while we hold ctrl_lock.

Which is why I suggest just reverting both the original problematic commit 
_and_ the commit you point to, and just fix the race with that pid_get/put 
pair instead. As per my patch.

		Linus
