Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0BGQEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 11:04:38 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:64230 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0BGQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 11:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IikkO+uCGNSsoRmkFMhVbmY09iIgy4VHvfKazEeA1PyiJm7Jcr6nA1hS6oQo7JrzGP
         9RxjKRw604/Yu3Ws+FkCjFAJnlLKymaobvNVZZok3x1IrudUBt5tnEImKnYAq8sqefar
         mVDVEexU3hfSoVGLqrhrf+BZvG7vsfDzhIi6Y=
Date: Mon, 8 Feb 2010 00:06:57 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, gregkh@suse.de,
       taviso@google.com, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       alan@lxorguk.ukuu.org.uk, jdike@addtoit.com, jln@google.com,
       mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency in
	tty_fasync
Message-ID: <20100207160657.GA17447@hack>
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp> <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain> <20100207064643.GA15533@hack> <alpine.LFD.2.00.1002062246390.3829@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1002062246390.3829@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 10:59:56PM -0800, Linus Torvalds wrote:
>
>
>On Sun, 7 Feb 2010, Américo Wang wrote:
>> 
>> We already fixed this, a better fix:
>
>No we didn't.
>
>> http://lkml.org/lkml/2010/1/26/338
>> 
>> I sent a same fix with Greg's.
>
>We already did that. You didn't read Tetsuo's email carefully.
>
>Let's quote the important parts:
>
>  "is not yet fixed as of 2.6.33-rc7."
>
>and also the _second_ lockdep complaint he quotes, which starts out with
>
>  [   81.651199] =========================================================
>  [   81.651199] [ INFO: possible irq lock inversion dependency detected ]
>  [   81.651199] 2.6.33-rc7 #11
>  [   81.651199] ---------------------------------------------------------
>
>(note the -rc7 there).
>


Ah, I was just mislead by the subject... sigh


>The problem? Look at f_getown: it does
>
>	read_lock(&filp->f_owner.lock);
>
>ie it holds f_owner without interrupts disabled. Now an interrupt comes 
>in, and takes 'siglock' because it ends up sending a signal (timer, SIGIO, 
>whatever). So you have a f_owner -> siglock ordering.
>
>But we _also_ have a siglock -> ctrl_lock -> f_owner ordering, in that 
>problematic tty_fasync() thing. So we have a ABBA deadlock situation.
>
>Yes, it's hard (practically impossible) to trigger, because you have to 
>get an interrupt just at the right point with all the right processes, but 
>lockdep seems to be entirely correct. 
>
>So it is simply _wrong_ to take f_owner while we hold ctrl_lock.
>
>Which is why I suggest just reverting both the original problematic commit 
>_and_ the commit you point to, and just fix the race with that pid_get/put 
>pair instead. As per my patch.
>

Good analysis, this seems better for me too.

Thank you!
