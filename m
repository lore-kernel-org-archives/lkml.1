Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYEaLuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYEaLuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 07:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYEaLt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 07:49:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17746 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYEaLt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 07:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cB5y5KU0H/YYLMvFvdDaZyzcLriv31Zb+cY5XZ3yz12koE6u+r5NJXoy6gJNNtfN0jCUiMTFI939g9xAlitajr2eRx+9IihcGLEulDm3fMq/WUEvzVY6wMPy+hpvq/NhDEOXrswYH/lo7ygwQ3UDtqig7boGn2KOC/unJNimF80=
Message-ID: <48413B6E.3050202@gmail.com>
Date: Sat, 31 May 2008 13:50:06 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH 1/1] Char: tty_io, fix closecount counting
References: <1211810923-3122-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1211810923-3122-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> This is probably a fix for an issue first reported in 2.6.18.1:
> http://lkml.org/lkml/2006/10/20/301
> and
> http://marc.info/?l=linux-mips&m=118797256328587

Alan, I know, you already stated some time ago, that you don't have a clue 
what could have caused this. Haven't you found anything since that time as I 
think the hangup path is the only possible cause of this problem?

I've found an other one from 2.6.17-rc4:
http://readlist.com/lists/vger.kernel.org/linux-kernel/44/220050.html
and from 2.6.22+suse_stuff:
http://lists.opensuse.org/opensuse-bugs/2008-04/msg05628.html

It is ever vcs1, which is /dev/console and it is the only treated separately 
(otherwise I think we would have more (and distinct) reports like this). 
When the console is HUPped? And what should happen with openers? The 
2.6.22+suse happened when sulogin /dev/console was invoked. Any ideas how to 
track this down?

> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -1434,9 +1434,9 @@ static void do_tty_hangup(struct work_struct *work)
>  	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
>  		if (filp->f_op->write == redirected_tty_write)
>  			cons_filp = filp;
> +		closecount++;
>  		if (filp->f_op->write != tty_write)
>  			continue;
> -		closecount++;
>  		tty_fasync(-1, filp, 0);	/* can't block */
>  		filp->f_op = &hung_up_tty_fops;
>  	}
