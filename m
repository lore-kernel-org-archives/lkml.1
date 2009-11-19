Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZKSPmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZKSPmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZKSPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:42:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52264 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZKSPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=e01WtwqL/aosCuVJ5B7nRKLpkh23LitzmdaHsglRN8JhLyBh0zaRxBq0YuX3Qzq0Bl
         mKw2yuxNug/tvE/c9/IJ+o7O6SnWiyitCJXs+uk0iXFYiXoxNeHLeIVASPTsWtjB7H1q
         4uCsmMeJ+lv5XiAqJaIyY1DZ4+PV6aw1YG1zU=
Message-ID: <4B056791.5090002@gmail.com>
Date: Thu, 19 Nov 2009 16:43:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091117 SUSE/3.0.0-2.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com> <4AF84E2F.3010305@gmail.com> <20091109173654.GA8809@redhat.com> <4B040A03.2020508@gmail.com> <20091118231532.GA13039@redhat.com>
In-Reply-To: <20091118231532.GA13039@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 12:15 AM, Oleg Nesterov wrote:
> On 11/18, Jiri Slaby wrote:
>>
>> On the last point: I added explicit ACCESS_ONCE all over there. If you
>> don't like I will trash it.
> 
> Just curious, why?
> 
> I mean, do you have any example of the "bad" behaviour which is
> fixed by ACCESS_ONCE() ?

Hi,

no, I haven't seen any errors caused by that yet. I added those in the
"just in case compiler starts to do weird things" manner.

>> The only remaining weird user is in
>> kernel/acct.c:
>>         /*
>>          * Accounting records are not subject to resource limits.
>>          */
>>         flim = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
>>         current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
>>         file->f_op->write(file, (char *)&ac,
>>                                sizeof(acct_t), &file->f_pos);
>>         current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
>>
>> It means that threads of the process with PACCT caps have unlimited file
>> size for a short while. If there is setrlimit in between, it gets wiped
>> out as well.
> 
> This is called when the whole thread-group exits, there are no
> live threads except current.

Not really, it is called from umount, sys_acct and other paths.

> At least, given that do_acct_process() does override_creds(), an
> ordinary user can't fool the accounting.

Agreed. That path can be executed only by a user with (at least) PACCT
or SYS_ADMIN caps. Hopefully.

Thanks.
