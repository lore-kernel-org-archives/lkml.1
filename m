Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZKIIyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZKIIyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZKIIyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:54:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:22458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbZKIIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:54:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GtT51Hgg1dckNXxC/BjLBKQ/4m7ui6wpOT06DLcOqP+tmN0mX7WEOPbRsjiYNSZLfE
         87x3G9i9amAI2DnttN/sfVxvwnTzviorSOE2DkQqpqYCTGDmhjTHeJSeMQT7N3xYhabS
         Oc9T3BZT/xR+z8uBuBRjU7aj0EObpfJ6owuHQ=
Message-ID: <4AF7D8C2.60807@gmail.com>
Date: Mon, 09 Nov 2009 09:54:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu>
In-Reply-To: <20091106092600.GC22505@elte.hu>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2009 10:26 AM, Ingo Molnar wrote:
> Also, the locking there looks messy:
> 
> +       /* optimization: 'current' doesn't need locking, e.g. setrlimit */
> +       if (tsk != current) {
> +               /* protect tsk->signal and tsk->sighand from disappearing */
> +               read_lock(&tasklist_lock);
> +               if (!tsk->sighand) {
> +                       retval = -ESRCH;
> +                       goto out;
> +               }
>         }
> 
> Neil's splitup into a helper function looks _far_ cleaner.

Oops, I don't understand here. Looking at
http://patchwork.kernel.org/patch/54863/
and
http://decibel.fi.muni.cz/cgi-bin/gitweb.cgi?p=linux.git;a=commitdiff;h=ba9ba971a9241250646091935d77d2f31b7c15af

They are almost identical. That 'if' above is added by:
http://decibel.fi.muni.cz/cgi-bin/gitweb.cgi?p=linux.git;a=commitdiff;h=bab65b1e6c0fd797a1ecdb32911faa82947effd0

The latter commit is to avoid performance penalty introduced for
setrlimit syscall by the added lock (as it's unneeded for 'current'). If
you find that crappy, there is no problem to drop it, indeed.
