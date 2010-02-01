Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0BARj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:39:29 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:36552 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0BARj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:39:28 -0500
Message-ID: <4B6711E2.6010409@xenontk.org>
Date: Mon, 01 Feb 2010 23:09:46 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: Re: [Bug #15127] Bluetooth: sleeping function called from invalid
 context
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>	 <de962C6zBxL.A.lME.FFiZLB@chimera> <1264986406.31341.5.camel@localhost.localdomain>
In-Reply-To: <1264986406.31341.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 06:36 AM, Marcel Holtmann wrote:
> Hi Rafael,
> 
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.31 and 2.6.32.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15127
>> Subject		: Bluetooth: sleeping function called from invalid context
>> Submitter	: David John <davidjon@xenontk.org>
>> Date		: 2010-01-12 9:19 (20 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e726b17422bade75fba94e625cd35fd1353e682
>> References	: http://marc.info/?l=linux-kernel&m=126328727021949&w=4
> 
> you have an outdated email from Luiz and I change it to the right one
> now.
> 
> I looked with him at the patch and I think this will fix it:
> 
> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> index fc5ee32..2b50637 100644
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -252,7 +252,6 @@ static void rfcomm_session_timeout(unsigned long
> arg)
>  	BT_DBG("session %p state %ld", s, s->state);
>  
>  	set_bit(RFCOMM_TIMED_OUT, &s->flags);
> -	rfcomm_session_put(s);
>  	rfcomm_schedule(RFCOMM_SCHED_TIMEO);
>  }
>  
> @@ -1920,6 +1919,7 @@ static inline void rfcomm_process_sessions(void)
>  		if (test_and_clear_bit(RFCOMM_TIMED_OUT, &s->flags)) {
>  			s->state = BT_DISCONN;
>  			rfcomm_send_disc(s, 0);
> +			rfcomm_session_put(s);
>  			continue;
>  		}
>  
> We need some extra testing on this with the actual hardware we did the
> patch for. So this will take at least a few days before we get our hands
> on it.
> 
> Regards
> 
> Marcel
> 
> 
> 

Hi Marcel,

FWIW, your patch fixes the issue.

Regards,
David.
