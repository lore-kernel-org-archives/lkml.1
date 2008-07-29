Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYG2JmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYG2JmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYG2JmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:42:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:40268 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYG2JmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SwMfQuAmiR9D2R+jAOBHBxofOy9j8OoFlyH2+MJzx+c+0RriLh5OM58Pq2n+SICzm5
         onK3K1B6qV1WJHXfFbanFT/Qi7MFLUlvLnmX34axL7Ls+bQHQpZMvDsIaKNYu2bwH60r
         fXdNTmWiVYX4neKq7DqNViaK3yk//SuZsRr24=
Message-ID: <488EE5F0.7020302@gmail.com>
Date: Tue, 29 Jul 2008 11:42:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Char: ds1286, eliminate busy waiting
References: <1217008198-17143-1-git-send-email-jirislaby@gmail.com> <20080728230533.GB1430@linux-mips.org>
In-Reply-To: <20080728230533.GB1430@linux-mips.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle napsal(a):
> On Fri, Jul 25, 2008 at 07:49:58PM +0200, Jiri Slaby wrote:
> 
>> ds1286_get_time(); is not called from atomic context, sleep for 20 ms is
>> better choice than a (home-made) busy waiting for such a situation.

> Looks ok to me I guess.  Though I don't really think it matters ...

I think RT people has different opinion ;).

> The same condition also appears in drivers/char/rtc.c and maybe a few
> others.  Rtc.c has been copies and modified several times.

In rtc.c there is something completely different:
         while (rtc_is_updating() != 0 &&
                time_before(jiffies, uip_watchdog + 2*HZ/100))
                 cpu_relax();

It's a conditional busy-waiting. It reads the rtc status after each busy 
cycle while in the ds1286 there was
         if (ds1286_is_updating() != 0)
                 while (time_before(jiffies, uip_watchdog + 2*HZ/100))
                         barrier();
