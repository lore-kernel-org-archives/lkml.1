Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZKTK1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZKTK1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZKTK1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:27:44 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:51248 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZKTK1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:27:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iNCb37lc06iN+fvVs0edVcRn5DjOnYfWenSyQXf+iuEYoCC9HltzG/XVZzKdbPbgkR
         Jkb5ab6VUlZT6SzS6W59+i8SBKO2SWJTB2INBrLIxRCDamM8oX5iSaNLO71nl5BsssfC
         +HIVSOtUN49cUCNmsa+2svb02Ett80x80KhMI=
Message-ID: <4B066F1F.7090902@gmail.com>
Date: Fri, 20 Nov 2009 11:27:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091117 SUSE/3.0.0-2.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: acct_file_reopen() && do_acct_process() (Was: [PATCH 0/3] extend
 get/setrlimit to support setting rlimits external to a process (v7))
References: <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com> <4AF84E2F.3010305@gmail.com> <20091109173654.GA8809@redhat.com> <4B040A03.2020508@gmail.com> <20091118231532.GA13039@redhat.com> <4B056791.5090002@gmail.com> <20091120021102.GA5603@redhat.com>
In-Reply-To: <20091120021102.GA5603@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2009 03:11 AM, Oleg Nesterov wrote:
> Hmm. you are right. Do you know why acct_file_reopen() does
> 
> 	if (old_acct)
> 		do_acct_process();
> 
> ???
> 
> This looks just strange. What is the point ? If the caller doesn't
> exit, we shouldn't account it?

I have no idea. I just checked free and net bsds and they record only
exiting tasks. Maybe someone added it to record the process which
disabled the acct (last entry). Dunno.

> And this is just wrong, no? Even if we forget about rlim, since
> do_acct_process() does override_creds() + revert_creds(), any
> __task_cred() in between is fooled?
> 
> Probably I greatly misread something in acct.c, otherwise I can't
> see why, say, mntput() should ever record the caller in acct file.

>From how I understand the code, it is the last mntput before the fs gets
unmounted. It's to close the acct file. But I don't understand why it
accounts.

> IOW: could someone explain why the patch below is wrong?

For me, it makes sense. But that's not important ;).

> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -206,7 +206,6 @@ static void acct_file_reopen(struct bsd_
>  	if (old_acct) {
>  		mnt_unpin(old_acct->f_path.mnt);
>  		spin_unlock(&acct_lock);
> -		do_acct_process(acct, old_ns, old_acct);
>  		filp_close(old_acct, NULL);
>  		spin_lock(&acct_lock);

thanks,
-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
