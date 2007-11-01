Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbXKAFMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbXKAFMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXKAFL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:11:57 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:24942 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751307AbXKAFL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:11:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fcK1I9IEpEZD5C16Hq8Dt9Qq1PA2OiTlwiqW0fBJu7GB4nQBPA/nqrtsFfx0fo++bNgqYeaXsU0pi5fyLxrTpuYQIz236XPdgco50fhJtmwWFlr6w9HWMAoiSMnNP8NMZtxk2VuxCer6TwEwmPrGRwM5djOl5gf2eVv6I4AAJAg=  ;
X-YMail-OSG: CI2P2P0VM1nyfeZTWS0x8Ju_Tgu30JI5YKoZtsOYxJZu211DCnIlqxqowHeWbOGSUZ8.iyRSgQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "bc Wong (chimwong)" <bcwong@cisco.com>
Subject: Re: filp usage when cpu busy
Date: Thu, 1 Nov 2007 15:05:15 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <47293248.9000906@cisco.com>
In-Reply-To: <47293248.9000906@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011505.15751.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 12:56, bc Wong (chimwong) wrote:
> Hi,
>
> With 2.6.16 x86_64 on a 4 core machine, I noticed
> that the filp usage (according to /proc/slabinfo)
> shoots up and keeps on increasing sharply when one
> of the CPUs is (1) locked up, or (2) very busy
> doing a lot of printk()'s with KERN_EMERG.
>
> In the case of (1), it's permanent until it runs
> out of memory eventually. For (2), it's temporary;
> filp count comes back down when the printk()'s are
> done.
>
> I can't think of any relationship between a busy/
> locked-up CPU and filp count. The system is still
> functional. New short-lived processes kept being
> created, but the overall number of processes is
> stable.
>
> Does anyone know why filp count would go up like
> that?

Yeah, it's probably because filp structures are freed by
RCU, and if you have a locked up CPU then it can't go
through a quiescent state so RCU stops freeing your filps.

If you add some cond_resched()s to your code, you should
find that RCU will force a reschedule and things will work
(actually, for 2.6.16, I'm not sure if RCU had the code to
force a reschedule... it's force_quiescent_state() in
kernel/rcupdate.c upstream).
